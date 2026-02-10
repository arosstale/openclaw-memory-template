"""
OpenClaw Observational Memory (PAOM)
Based on Mastra's Observational Memory

A text-based memory system that compresses context into observations
with emoji prioritization and multi-date temporal tracking.

Inspired by Mastra: https://mastra.ai/blog/observational-memory
"""

import sqlite3
from pathlib import Path
from datetime import datetime
from .observer_agent import ObserverAgent
from .reflector_agent import ReflectorAgent
from .types import (
    ObservationConfig,
    Observation,
    ObservationalMemoryRecord,
    PriorityLevel,
)
from typing import Dict, List, Optional, Tuple
import json


def get_token_counter(config: ObservationConfig):
    """Get token counter based on configuration."""
    if config.use_tiktoken:
        try:
            from .tiktoken_counter import get_token_counter
            return get_token_counter()
        except ImportError:
            # Fallback to simple counter
            pass

    # Simple fallback
    from .token_counter import TokenCounter
    return TokenCounter()


class ObservationalMemory:
    """
    Main Observational Memory system.

    Components:
    - Observer: Extracts observations when messages exceed threshold
    - Reflector: Condenses observations when they exceed threshold
    - Actor: Sees observations + recent messages
    """

    def __init__(self, config: Optional[ObservationConfig] = None):
        """Initialize Observational Memory system."""
        from .types import default_config

        self.config = config or default_config()
        self.token_counter = get_token_counter(self.config)
        self.observer = ObserverAgent(self.config)
        self.reflector = ReflectorAgent(self.config)

        # Initialize SQLite storage
        self._init_database()

    def _init_database(self):
        """Initialize SQLite database for observations."""
        db_path = Path(self.config.db_path)
        db_path.parent.mkdir(parents=True, exist_ok=True)

        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()

        # Create observations table
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS observations (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                thread_id TEXT NOT NULL,
                timestamp TEXT NOT NULL,
                priority TEXT NOT NULL,
                content TEXT NOT NULL,
                referenced_date TEXT,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
        """)

        # Create memory_records table
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS memory_records (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                thread_id TEXT UNIQUE NOT NULL,
                current_task TEXT,
                suggested_response TEXT,
                last_observed_at TEXT,
                updated_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
        """)

        # Create index on thread_id
        cursor.execute("""
            CREATE INDEX IF NOT EXISTS idx_thread_id ON observations(thread_id)
        """)

        conn.commit()
        conn.close()

    def get_observation_record(self, thread_id: str) -> Optional[ObservationalMemoryRecord]:
        """Get memory record for a thread from SQLite database."""
        db_path = Path(self.config.db_path)
        if not db_path.exists():
            return None

        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()

        # Get memory record
        cursor.execute("""
            SELECT current_task, suggested_response, last_observed_at
            FROM memory_records
            WHERE thread_id = ?
        """, (thread_id,))
        record_data = cursor.fetchone()

        if not record_data:
            conn.close()
            return None

        # Get observations
        cursor.execute("""
            SELECT timestamp, priority, content, referenced_date
            FROM observations
            WHERE thread_id = ?
            ORDER BY created_at ASC
        """, (thread_id,))
        obs_data = cursor.fetchall()

        conn.close()

        # Build observations list
        observations = []
        for row in obs_data:
            obs = Observation(
                timestamp=datetime.fromisoformat(row[0]),
                priority=row[1],
                content=row[2],
                referenced_date=datetime.fromisoformat(row[3]) if row[3] else None
            )
            observations.append(obs)

        return ObservationalMemoryRecord(
            observations=observations,
            current_task=record_data[0] or "",
            suggested_response=record_data[1] or "",
            last_observed_at=datetime.fromisoformat(record_data[2]) if record_data[2] else None
        )

    def _save_observation_record(self, thread_id: str, record: ObservationalMemoryRecord):
        """Save memory record to SQLite database."""
        db_path = Path(self.config.db_path)
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()

        # Update memory record
        cursor.execute("""
            INSERT OR REPLACE INTO memory_records
            (thread_id, current_task, suggested_response, last_observed_at, updated_at)
            VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
        """, (
            thread_id,
            record.current_task,
            record.suggested_response,
            record.last_observed_at.isoformat() if record.last_observed_at else None
        ))

        # Clear old observations for this thread (they're being replaced)
        cursor.execute("""
            DELETE FROM observations WHERE thread_id = ?
        """, (thread_id,))

        # Insert observations
        for obs in record.observations:
            cursor.execute("""
                INSERT INTO observations
                (thread_id, timestamp, priority, content, referenced_date)
                VALUES (?, ?, ?, ?, ?)
            """, (
                thread_id,
                obs.timestamp.isoformat(),
                obs.priority,
                obs.content,
                obs.referenced_date.isoformat() if obs.referenced_date else None
            ))

        conn.commit()
        conn.close()

    def process_messages(
        self,
        thread_id: str,
        messages: List[Dict],
        existing_observations: str = ""
    ) -> ObservationalMemoryRecord:
        """
        Process new messages through observational memory pipeline.

        Pipeline:
        1. Get existing memory
        2. Extract new observations
        3. Check thresholds
        4. Trigger Observer or Reflector if needed
        5. Return updated memory
        """
        # Get existing memory
        record = self.get_observation_record(thread_id)
        if record is None:
            record = ObservationalMemoryRecord(observations=[])

        # Get existing observations as text
        existing_obs_text = self._format_observations(record.observations)

        # Extract new observations
        new_observations, current_task, suggested = self.observer.extract_observations(
            messages,
            existing_obs_text
        )

        # Combine observations
        combined = record.observations + new_observations

        # Check if reflection needed
        observation_count = self.token_counter.count_observations(combined)
        if observation_count > self.config.reflection_threshold:
            # Trigger Reflector
            combined = self.reflector.reflect(combined)

        # Update record
        record.observations = combined
        record.current_task = current_task or record.current_task
        record.suggested_response = suggested or record.suggested_response
        record.last_observed_at = datetime.now()

        # Save to database
        self._save_observation_record(thread_id, record)

        return record

    def get_context(self, thread_id: str) -> str:
        """
        Get formatted context for actor (main agent).

        Returns:
        - Observations (compressed history)
        - Current task (if available)
        - Suggested response (if available)
        """
        record = self.get_observation_record(thread_id)
        if record is None:
            return "No observations yet."

        # Format for actor
        context = self._format_observations(record.observations)

        # Add suggested response
        if record.suggested_response:
            context += f"\n\n<Suggested Response>\n{record.suggested_response}\n"

        # Add current task
        if record.current_task:
            context += f"\n\n<Current Task>\n{record.current_task}\n"

        return context

    def _format_observations(self, observations: List[Observation]) -> str:
        """Format observations for context."""
        if not observations:
            return ""

        # Group by date
        grouped: Dict[str, List[Observation]] = {}
        for obs in observations:
            date_key = obs.timestamp.date().isoformat()
            if date_key not in grouped:
                grouped[date_key] = []
            grouped[date_key].append(obs)

        # Format output
        lines = []
        for date_key in sorted(grouped.keys()):
            lines.append(f"Date: {date_key}")
            for obs in grouped[date_key]:
                time_str = obs.timestamp.strftime("%H:%M")
                emoji = obs.priority  # Now a string: "🔴", "🟡", "🟢"
                lines.append(f"* {emoji} ({time_str}) {obs.content}")

        return "\n".join(lines)

    def get_stats(self, thread_id: str) -> Dict:
        """Get statistics about observational memory."""
        record = self.get_observation_record(thread_id)
        if record is None:
            return {"total_observations": 0}

        return {
            "total_observations": len(record.observations),
            "last_observed_at": None,
            "has_current_task": bool(record.current_task),
        }

    def force_reflection(self, thread_id: str) -> str:
        """Force reflection on a thread."""
        record = self.get_observation_record(thread_id)
        if record is None:
            return "No observations to reflect."

        # Trigger Reflector
        reflected = self.reflector.reflect(record.observations)

        # Update record
        record.observations = reflected
        return f"✅ Reflection complete. {len(record.observations)} observations"


# Export for easy importing
__all__ = [
    "ObservationalMemory",
    "ObservationConfig",
    "Observation",
    "ObservationalMemoryRecord",
    "PriorityLevel",
]
