"""
Configuration for OpenClaw Observational Memory.
"""

from dataclasses import dataclass, field
from typing import Literal, Optional
from datetime import datetime


class PriorityLevel:
    """Priority levels for observations."""
    RED = "🔴"
    YELLOW = "🟡"
    GREEN = "🟢"


@dataclass
class Observation:
    """A single observation with temporal context."""
    timestamp: datetime
    priority: str  # PriorityLevel.RED, YELLOW, or GREEN
    content: str
    referenced_date: Optional[datetime] = None  # Estimated/actual referenced date


@dataclass
class ObservationalMemoryRecord:
    """Complete observational memory for a thread."""
    observations: list[Observation]
    current_task: str = ""
    suggested_response: str = ""
    last_observed_at: Optional[datetime] = None


@dataclass
class ObservationConfig:
    """Configuration for Observational Memory."""
    # Thresholds (in tokens)
    observation_threshold: int = 30000      # When to trigger Observer
    reflection_threshold: int = 40000      # When to trigger Reflector

    # Model settings
    observer_temperature: float = 0.3
    reflector_temperature: float = 0.0
    llm_provider: str = "anthropic"  # "anthropic", "openai", "google"

    # Token counting
    use_tiktoken: bool = True          # Use Tiktoken for accurate counting

    # Storage
    db_path: str = ".openclaw/observational_memory.db"


@dataclass
class ModelConfig:
    """LLM model configuration."""
    provider: "Literal['anthropic', 'openai', 'google']" = "anthropic"
    model: str = "claude-sonnet-4-20250214"
    max_tokens: int = 100000
    temperature: float = 0.3


def default_config() -> ObservationConfig:
    """Get default configuration."""
    return ObservationConfig()


__all__ = [
    "PriorityLevel",
    "Observation",
    "ObservationalMemoryRecord",
    "ObservationConfig",
    "ModelConfig",
    "default_config",
]
