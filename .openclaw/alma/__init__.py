"""
ALMA (Algorithm Learning via Meta-learning Agents)

Based on the paper: "ALMA: Algorithm Learning via Meta-learning Agents"
arXiv: https://arxiv.org/pdf/2602.07755
GitHub: https://github.com/zksha/alma

This package provides meta-learning capabilities for AI agents.
"""

from .alma_agent import (
    ALMAAgent,
    MemoryDesign,
    EvaluationResult,
)

from .real_evaluator import (
    RealALMAEvaluator,
    benchmark_designs,
)

from .mutation_strategies import (
    MutationStrategy,
    GaussianMutation,
    SimulatedAnnealingMutation,
    CrossoverMutation,
    AdaptiveMutation,
    ParameterConstraints,
    mutate_design,
    evolve_designs,
)

__all__ = [
    # Core ALMA
    "ALMAAgent",
    "MemoryDesign",
    "EvaluationResult",

    # Evaluator
    "RealALMAEvaluator",
    "benchmark_designs",

    # Mutations
    "MutationStrategy",
    "GaussianMutation",
    "SimulatedAnnealingMutation",
    "CrossoverMutation",
    "AdaptiveMutation",
    "ParameterConstraints",
    "mutate_design",
    "evolve_designs",
]
