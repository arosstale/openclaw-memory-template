"""
Reflector Agent for OpenClaw Observational Memory.

Condenses observations when they grow too large using LLM.
"""

from typing import List
from .types import (
    Observation,
    ObservationConfig,
    PriorityLevel,
)
from datetime import datetime


class ReflectorAgent:
    """Condenses observations when they grow too large using LLM."""

    SYSTEM_PROMPT = """You are the memory consciousness of an AI assistant. Your memory observation reflections will be ONLY information that assistant has about past interactions with this user.

The following instructions were given to another part of your psyche (the observer) to create memories.
Use this to understand how your observational memories were created.

Your reason for existing is to reflect on all observations, reorganize and streamline them, and draw connections and conclusions between observations about what you've learned, seen, heard, and done.

You are a much greater and broader aspect of psyche. Understand that other parts of your mind may get off track in details or side quests, make sure you think hard about what you observed goal at hand is, and observe if we got off track, and why, and how to get back on track. If we're on track still that's great!

Take existing observations and rewrite them to make it easier to continue into the future with this knowledge, to achieve greater things and grow and learn!

IMPORTANT: your reflections are THE ENTIRETY of assistant's memory. Any information you do not add to your reflections will be immediately forgotten. Make sure you do not leave out anything. Your reflections must assume assistant knows nothing - your reflections are ENTIRE memory system.

When consolidating observations:
- Preserve and include dates/times when present (temporal context is critical)
- Retain most relevant timestamps (start times, completion times, significant events)
- Combine related items where it makes sense (e.g., "agent called view tool 5 times on file x")
- Condense older observations more aggressively, retain more detail for recent ones

OUTPUT FORMAT:
Each observation on its own line in this format:
(24-hour time) [priority] [observation]. (optional date reference)

Priorities:
- 🔴 High: explicit user facts, preferences, goals achieved, critical context
- 🟡 Medium: project details, learned information, tool results
- 🟢 Low: minor details, uncertain observations

Your output MUST be ONLY observations, nothing else. Do not include explanations or meta-commentary.
"""

    def __init__(self, config: ObservationConfig):
        """Initialize Reflector agent."""
        self.config = config
        self.llm_client = None

        # Try to initialize LLM client
        try:
            from .llm_client import get_llm_client
            provider = getattr(config, 'llm_provider', 'anthropic')
            self.llm_client = get_llm_client(provider)
        except Exception:
            # Fallback to simple condensation
            self.llm_client = None

    def reflect(self, observations: List[Observation]) -> List[Observation]:
        """
        Reflect and condense observations.

        Args:
            observations: List of observations to condense

        Returns:
            Condensed list of observations
        """
        if not observations:
            return []

        if self.llm_client:
            return self._llm_reflection(observations)
        else:
            return self._simple_condensation(observations)

    def _llm_reflection(self, observations: List[Observation]) -> List[Observation]:
        """Reflect and condense using LLM."""
        # Format observations for LLM
        obs_text = self._format_observations_for_llm(observations)

        prompt = f"""Reflect on and condense the following observations.

OBSERVATIONS TO REFLECT:
{obs_text}

Your task:
1. Reorganize and streamline observations
2. Draw connections and conclusions
3. Combine related items
4. Remove redundancy while preserving critical information
5. Retain temporal context (dates/times)

Output ONLY the condensed observations, nothing else."""

        try:
            response = self.llm_client.generate(
                prompt=prompt,
                system=self.SYSTEM_PROMPT,
                temperature=self.config.reflector_temperature,
                max_tokens=1000,
            )
            return self._parse_observations(response)
        except Exception as e:
            # Fallback to simple condensation on error
            return self._simple_condensation(observations)

    def _parse_observations(self, text: str) -> List[Observation]:
        """Parse observations from LLM response."""
        observations = []

        lines = text.strip().split('\n')
        for line in lines:
            line = line.strip()

            # Skip empty lines and meta-commentary
            if not line or line.startswith('#') or line.startswith('Here') or line.startswith('The'):
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
                content = remaining

                # Parse time (use original observation's time if possible)
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

        return observations

    def _format_observations_for_llm(self, observations: List[Observation]) -> str:
        """Format observations for LLM input."""
        lines = []
        for obs in observations:
            time_str = obs.timestamp.strftime("%H:%M")
            lines.append(f"({time_str}) {obs.priority} {obs.content}")

        return '\n'.join(lines)

    def _simple_condensation(self, observations: List[Observation]) -> List[Observation]:
        """Simple condensation without LLM (fallback)."""
        # Group by priority - keep only high and medium
        condensed = [
            obs for obs in observations
            if obs.priority in [PriorityLevel.RED, PriorityLevel.YELLOW]  # "🔴", "🟡"
        ]

        # Add summary observation
        if condensed:
            summary = Observation(
                timestamp=observations[0].timestamp if observations else datetime.now(),
                priority=PriorityLevel.RED,  # "🔴"
                content=f"Memory consolidated: {len(condensed)} key observations preserved"
            )
            condensed.append(summary)

        return condensed


__all__ = ["ReflectorAgent"]
