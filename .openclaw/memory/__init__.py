"""
Unified Memory System for OpenClaw V2.4

Combines Observational Memory (PAOM) with optional QMD semantic search.

Note: ALMA integration is experimental and will be added in future updates.
See: .openclaw/alma/README.md
"""

from typing import Dict, List, Optional
from datetime import datetime

from ..observational_memory import ObservationalMemory, ObservationConfig


class UnifiedMemorySystem:
    """
    Unified memory system combining Observational Memory with optional components.

    Architecture:
    - Observational Memory: Context compression + temporal tracking
    - QMD (optional): Semantic search (not yet integrated)
    - ALMA (experimental): Strategy performance + dynamic weights
    """

    def __init__(self, config: Optional[ObservationConfig] = None):
        """
        Initialize unified memory system.

        Args:
            config: Optional configuration for Observational Memory
        """
        # Observational Memory for context compression
        self.obs_config = config or ObservationConfig()
        self.obs_memory = ObservationalMemory(self.obs_config)

    def process_interaction(
        self,
        thread_id: str,
        messages: List[Dict],
        **kwargs
    ) -> str:
        """
        Process an interaction through the memory system.

        Args:
            thread_id: Thread identifier
            messages: List of message dictionaries
            **kwargs: Additional parameters for future integrations (ALMA, QMD)

        Returns:
            Formatted context string for the main agent
        """
        # Process messages through Observational Memory
        self.obs_memory.process_messages(thread_id, messages)

        # Get context from Observational Memory
        obs_context = self.obs_memory.get_context(thread_id)

        # Build unified context
        unified_context = self._build_unified_context(obs_context, **kwargs)

        return unified_context

    def _build_unified_context(self, obs_context: str, **kwargs) -> str:
        """
        Build unified context from all memory systems.

        Args:
            obs_context: Context from Observational Memory
            **kwargs: Additional context from other systems

        Returns:
            Formatted unified context string
        """
        context_lines = []

        # Observational Memory context
        if obs_context and obs_context != "No observations yet.":
            context_lines.append("## Conversation Memory")
            context_lines.append(obs_context)

        # Add additional context from kwargs (for future QMD/ALMA integration)
        for key, value in kwargs.items():
            if value and isinstance(value, str):
                context_lines.append(f"## {key.replace('_', ' ').title()}")
                context_lines.append(value)

        return "\n\n".join(context_lines) if context_lines else "No memory available."

    def get_unified_stats(self, thread_id: str) -> Dict:
        """
        Get combined statistics from all memory systems.

        Args:
            thread_id: Thread identifier

        Returns:
            Dictionary containing statistics from all systems
        """
        # Observational Memory stats
        obs_stats = self.obs_memory.get_stats(thread_id)

        return {
            "observational_memory": obs_stats,
            "timestamp": datetime.now().isoformat(),
        }

    def get_context(self, thread_id: str) -> str:
        """
        Get formatted context for the main agent (Actor).

        Args:
            thread_id: Thread identifier

        Returns:
            Formatted context string
        """
        return self.obs_memory.get_context(thread_id)

    def get_stats(self, thread_id: str) -> Dict:
        """
        Get statistics about memory systems.

        Args:
            thread_id: Thread identifier

        Returns:
            Dictionary containing memory statistics
        """
        return self.get_unified_stats(thread_id)

    def force_reflection(self, thread_id: str) -> str:
        """
        Force reflection on a thread.

        Args:
            thread_id: Thread identifier

        Returns:
            Result message
        """
        return self.obs_memory.force_reflection(thread_id)


__all__ = ["UnifiedMemorySystem"]
