"""
Observer Agent for OpenClaw Observational Memory.

Extracts observations from message history when threshold is exceeded.
Uses LLM for intelligent observation extraction.
"""

from typing import Dict, List, Optional, Tuple
from .types import (
    Observation,
    ObservationConfig,
    PriorityLevel,
)
from datetime import datetime


class ObserverAgent:
    """Extracts observations from message history using LLM."""

    SYSTEM_PROMPT = """You are the memory consciousness of an AI assistant. Your observations will be ONLY information that assistant has about past interactions with this user.

CORE PRINCIPLES:

1. BE SPECIFIC - Vague observations are useless. Capture details that distinguish and identify.
2. ANCHOR IN TIME - Note when things happened and when they were said.
3. TRACK STATE CHANGES - When information updates or supersedes previous info, make it explicit.
4. USE COMMON SENSE - If it would help assistant remember later, observe it.

ASSERTIONS VS QUESTIONS:
- User TELLS you something → 🔴 "User stated [fact]"
- User ASKS something → 🟡 "User asked [question]"
- User assertions are authoritative. They are the source of truth about their own life.

TEMPORAL ANCHORING:
Each observation has TWO potential timestamps:
1. BEGINNING: The time statement was made (from message timestamp) - ALWAYS include this
2. END: The time being REFERENCED, if different from when it was said - ONLY when there's a relative time reference

ONLY add "(meaning DATE)" or "(estimated DATE)" at the END when you can provide an ACTUAL DATE:
- Past: "last week", "yesterday", "a few days ago", "last month", "in March"
- Future: "this weekend", "tomorrow", "next week"

DO NOT add end dates for:
- Present-moment statements with no time reference
- Vague references like "recently", "a while ago", "lately", "soon" - these cannot be converted to actual dates

FORMAT:
Each observation on its own line in this format:
(24-hour time) [priority] [observation]. (optional date reference)

Priorities:
- 🔴 High: explicit user facts, preferences, goals achieved, critical context
- 🟡 Medium: project details, learned information, tool results
- 🟢 Low: minor details, uncertain observations

REMEMBER: These observations are assistant's ENTIRE memory. Any detail you fail to observe is permanently forgotten. Use common sense - if something seems like it might be important to remember, it probably is. When in doubt, observe it.
"""

    def __init__(self, config: ObservationConfig):
        """Initialize Observer agent."""
        self.config = config
        self.llm_client = None

        # Try to initialize LLM client
        try:
            from .llm_client import get_llm_client
            provider = getattr(config, 'llm_provider', 'anthropic')
            self.llm_client = get_llm_client(provider)
        except Exception:
            # Fallback to simple extraction
            self.llm_client = None

    def extract_observations(
        self,
        messages: List[Dict],
        existing_observations: str = ""
    ) -> Tuple[List[Observation], str, str]:
        """
        Extract observations from message history.

        Args:
            messages: List of message dicts
            existing_observations: Existing observations text

        Returns:
            - observations: List of new observations
            - current_task: Current task being worked on
            - suggested_response: Suggested continuation
        """
        if self.llm_client:
            return self._llm_extraction(messages, existing_observations)
        else:
            return self._simple_extraction(messages)

    def _llm_extraction(
        self,
        messages: List[Dict],
        existing_observations: str
    ) -> Tuple[List[Observation], str, str]:
        """Extract observations using LLM."""
        # Format messages for LLM
        messages_text = self._format_messages_for_llm(messages)

        prompt = f"""Extract observations from the following conversation history.

EXISTING OBSERVATIONS:
{existing_observations if existing_observations else "(none)"}

NEW MESSAGES:
{messages_text}

Extract new observations from the messages that are NOT already in existing observations.
Each observation on its own line.

Output ONLY observations, nothing else."""

        try:
            response = self.llm_client.generate(
                prompt=prompt,
                system=self.SYSTEM_PROMPT,
                temperature=self.config.observer_temperature,
                max_tokens=1000,
            )
            return self._parse_observations(response)
        except Exception as e:
            # Fallback to simple extraction on error
            return self._simple_extraction(messages)

    def _parse_observations(self, text: str) -> Tuple[List[Observation], str, str]:
        """Parse observations from LLM response."""
        observations = []
        current_task = ""
        suggested_response = ""

        lines = text.strip().split('\n')
        for line in lines:
            line = line.strip()

            # Skip empty lines
            if not line:
                continue

            # Parse observation: (HH:MM) [priority] observation
            if line.startswith('(') and ')' in line:
                # Extract time
                time_end = line.find(')')
                time_str = line[1:time_end]
                remaining = line[time_end+1:].strip()

                # Extract priority
                if remaining.startswith('🔴'):
                    priority = PriorityLevel.RED
                    remaining = remaining[1:].strip()
                elif remaining.startswith('🟡'):
                    priority = PriorityLevel.YELLOW
                    remaining = remaining[1:].strip()
                elif remaining.startswith('🟢'):
                    priority = PriorityLevel.GREEN
                    remaining = remaining[1:].strip()
                else:
                    # Default priority
                    priority = PriorityLevel.YELLOW

                # Extract content
                if remaining.startswith('[') and ']' in remaining:
                    content_start = remaining.find('[')
                    content_end = remaining.find(']')
                    content = remaining[content_end+1:].strip()
                else:
                    content = remaining

                # Parse time
                try:
                    hour, minute = map(int, time_str.split(':'))
                    timestamp = datetime.now().replace(hour=hour, minute=minute, second=0, microsecond=0)
                except:
                    timestamp = datetime.now()

                obs = Observation(
                    timestamp=timestamp,
                    priority=priority,
                    content=content,
                    referenced_date=None,
                )
                observations.append(obs)

        return observations, current_task, suggested_response

    def _format_messages_for_llm(self, messages: List[Dict]) -> str:
        """Format messages for LLM input."""
        lines = []
        for msg in messages:
            role = msg.get("role", "unknown")
            content = msg.get("content", "")
            timestamp = msg.get("timestamp", "")

            if isinstance(timestamp, datetime):
                time_str = timestamp.strftime("%H:%M")
            else:
                time_str = str(timestamp)

            lines.append(f"[{time_str}] {role}: {content}")

        return '\n'.join(lines)

    def _simple_extraction(self, messages: List[Dict]) -> Tuple[List[Observation], str, str]:
        """Simple extraction without LLM (fallback)."""
        observations = []
        for msg in messages:
            if msg.get("role") == "user":
                # Extract key facts
                content = msg.get("content", "")
                timestamp = msg.get("timestamp", datetime.now())
                if isinstance(timestamp, str):
                    try:
                        timestamp = datetime.fromisoformat(timestamp)
                    except:
                        timestamp = datetime.now()

                # Simple heuristic extraction
                content_lower = content.lower()
                if "kids" in content_lower or "children" in content_lower:
                    obs = Observation(
                        timestamp=timestamp,
                        priority=PriorityLevel.RED,
                        content="User mentioned family (children)"
                    )
                    observations.append(obs)
                elif "work" in content_lower or "job" in content_lower:
                    obs = Observation(
                        timestamp=timestamp,
                        priority=PriorityLevel.YELLOW,
                        content="User discussed work situation"
                    )
                    observations.append(obs)
                elif "help" in content_lower:
                    obs = Observation(
                        timestamp=timestamp,
                        priority=PriorityLevel.YELLOW,
                        content="User asked for help"
                    )
                    observations.append(obs)

        return observations, "", ""


__all__ = ["ObserverAgent"]
