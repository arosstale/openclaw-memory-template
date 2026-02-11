"""
Advanced mutation strategies for ALMA meta-learning.

Provides sophisticated mutation operators for evolving memory designs.
"""

import random
import math
from typing import Dict, List, Optional, Callable
from datetime import datetime


class MutationStrategy:
    """Base mutation strategy."""

    def mutate(self, params: Dict) -> Dict:
        """Mutate parameters."""
        raise NotImplementedError


class GaussianMutation(MutationStrategy):
    """Gaussian mutation with adaptive sigma."""

    def __init__(self, sigma: float = 0.1, adaptive: bool = True):
        """
        Initialize Gaussian mutation.

        Args:
            sigma: Standard deviation for mutation
            adaptive: Adapt sigma based on success rate
        """
        self.sigma = sigma
        self.adaptive = adaptive
        self.success_count = 0
        self.total_count = 0
        self.min_sigma = 0.01
        self.max_sigma = 0.5

    def mutate(self, params: Dict) -> Dict:
        """Apply Gaussian mutation."""
        result = params.copy()

        for key, value in result.items():
            if isinstance(value, (int, float)):
                # Apply Gaussian noise
                noise = random.gauss(0, self.sigma * abs(value))
                result[key] = value + noise

                # Ensure numeric bounds
                if isinstance(value, int):
                    result[key] = int(result[key])
                else:
                    result[key] = round(result[key], 2)

                # Keep positive
                if result[key] < 0:
                    result[key] = abs(value) * 0.1

        return result

    def update_success(self, success: bool):
        """Update success rate and adapt sigma."""
        if not self.adaptive:
            return

        self.success_count += 1 if success else 0
        self.total_count += 1

        if self.total_count >= 10:
            # Calculate success rate
            success_rate = self.success_count / self.total_count

            # Adapt sigma: higher success -> smaller sigma (fine-tune)
            # lower success -> larger sigma (explore)
            if success_rate > 0.5:
                self.sigma = max(self.min_sigma, self.sigma * 0.9)
            else:
                self.sigma = min(self.max_sigma, self.sigma * 1.1)

            # Reset counters
            self.success_count = 0
            self.total_count = 0


class SimulatedAnnealingMutation(MutationStrategy):
    """Simulated annealing mutation with temperature decay."""

    def __init__(
        self,
        initial_temp: float = 1.0,
        decay_rate: float = 0.95,
        min_temp: float = 0.01
    ):
        """
        Initialize simulated annealing mutation.

        Args:
            initial_temp: Starting temperature
            decay_rate: Temperature decay per iteration
            min_temp: Minimum temperature
        """
        self.temperature = initial_temp
        self.decay_rate = decay_rate
        self.min_temp = min_temp

    def mutate(self, params: Dict) -> Dict:
        """Apply simulated annealing mutation."""
        result = params.copy()

        # Acceptance probability increases with temperature
        accept_large = random.random() < self.temperature

        for key, value in result.items():
            if isinstance(value, (int, float)):
                if accept_large:
                    # Large mutation
                    mutation = random.uniform(-0.5, 0.5) * value
                else:
                    # Small mutation
                    mutation = random.uniform(-0.1, 0.1) * value

                result[key] = value + mutation

                if isinstance(value, int):
                    result[key] = int(result[key])
                else:
                    result[key] = round(result[key], 2)

                if result[key] < 0:
                    result[key] = abs(value) * 0.1

        # Decay temperature
        self.temperature = max(self.min_temp, self.temperature * self.decay_rate)

        return result


class CrossoverMutation(MutationStrategy):
    """Crossover-based mutation for parameter exploration."""

    def __init__(self, crossover_rate: float = 0.5):
        """
        Initialize crossover mutation.

        Args:
            crossover_rate: Probability of crossover
        """
        self.crossover_rate = crossover_rate
        self.other_params = None

    def set_other_params(self, params: Dict):
        """Set other parameters for crossover."""
        self.other_params = params

    def mutate(self, params: Dict) -> Dict:
        """Apply crossover mutation."""
        result = params.copy()

        if self.other_params is None:
            return result

        # Crossover with probability
        for key in result:
            if key in self.other_params:
                if random.random() < self.crossover_rate:
                    # Blend crossover (alpha)
                    alpha = random.random()
                    if isinstance(result[key], (int, float)):
                        result[key] = alpha * result[key] + (1 - alpha) * self.other_params[key]

                        if isinstance(result[key], int):
                            result[key] = int(result[key])
                        else:
                            result[key] = round(result[key], 2)
                    elif isinstance(result[key], bool):
                        # Random crossover for booleans
                        result[key] = result[key] if random.random() < 0.5 else self.other_params[key]

        return result


class AdaptiveMutation(MutationStrategy):
    """Adaptive mutation that combines multiple strategies."""

    def __init__(self):
        """Initialize adaptive mutation."""
        self.strategies = [
            GaussianMutation(sigma=0.05, adaptive=False),
            GaussianMutation(sigma=0.15, adaptive=False),
            SimulatedAnnealingMutation(initial_temp=0.8),
            CrossoverMutation(crossover_rate=0.3),
        ]
        self.performance = [0.0] * len(self.strategies)
        self.usage = [0] * len(self.strategies)

    def mutate(self, params: Dict) -> Dict:
        """Apply adaptive mutation."""
        # Select strategy based on performance
        strategy = self._select_strategy()

        # Apply mutation
        result = strategy.mutate(params)

        # Track usage
        strategy_idx = self.strategies.index(strategy)
        self.usage[strategy_idx] += 1

        return result

    def update_performance(self, strategy_idx: int, score: float):
        """Update performance of a strategy."""
        self.performance[strategy_idx] = (
            self.performance[strategy_idx] * 0.9 + score * 0.1
        )

    def _select_strategy(self) -> MutationStrategy:
        """Select strategy based on performance (softmax)."""
        # Softmax selection
        exp_scores = [math.exp(p / 10.0) for p in self.performance]
        total = sum(exp_scores)

        probs = [s / total for s in exp_scores]

        # Roulette wheel selection
        r = random.random()
        cumulative = 0.0
        for i, prob in enumerate(probs):
            cumulative += prob
            if r <= cumulative:
                return self.strategies[i]

        return self.strategies[-1]


class ParameterConstraints:
    """Enforce constraints on parameters."""

    # Valid parameter ranges
    RANGES = {
        "observation_threshold": (10000, 50000),
        "reflection_threshold": (15000, 100000),
        "observer_temperature": (0.0, 1.0),
        "reflector_temperature": (0.0, 0.5),
        "compression_ratio": (0.5, 1.0),
    }

    # Valid parameter values (for categorical)
    VALID_VALUES = {
        "llm_provider": ["anthropic", "openai", "google"],
        "use_tiktoken": [True, False],
        "context_window": [4000, 8000, 32000, 100000],
    }

    @classmethod
    def enforce(cls, params: Dict) -> Dict:
        """Enforce constraints on parameters."""
        result = params.copy()

        for key, value in result.items():
            # Enforce ranges
            if key in cls.RANGES:
                min_val, max_val = cls.RANGES[key]
                value = max(min_val, min(value, max_val))

                # Round to nearest 1000 for thresholds
                if "threshold" in key:
                    value = int(round(value / 1000.0) * 1000)
                elif isinstance(value, float):
                    value = round(value, 2)

            # Enforce valid values
            elif key in cls.VALID_VALUES and value not in cls.VALID_VALUES[key]:
                # Pick random valid value
                value = random.choice(cls.VALID_VALUES[key])

            result[key] = value

        return result

    @classmethod
    def generate_random(cls) -> Dict:
        """Generate random valid parameters."""
        params = {}

        # Generate random values within ranges
        for key, (min_val, max_val) in cls.RANGES.items():
            if "threshold" in key:
                params[key] = random.randint(min_val, max_val // 1000 * 1000)
            else:
                params[key] = round(random.uniform(min_val, max_val), 2)

        # Generate random values from valid values
        for key, valid in cls.VALID_VALUES.items():
            params[key] = random.choice(valid)

        return params


def mutate_design(
    base_params: Dict,
    strategy: str = "gaussian",
    constraints: bool = True
) -> Dict:
    """
    Mutate a memory design.

    Args:
        base_params: Base parameters to mutate
        strategy: Mutation strategy ("gaussian", "annealing", "crossover", "adaptive")
        constraints: Whether to enforce parameter constraints

    Returns:
        Mutated parameters
    """
    # Select strategy
    if strategy == "gaussian":
        mutation = GaussianMutation(sigma=0.1, adaptive=True)
    elif strategy == "annealing":
        mutation = SimulatedAnnealingMutation(initial_temp=1.0)
    elif strategy == "crossover":
        mutation = CrossoverMutation(crossover_rate=0.5)
        mutation.set_other_params(ParameterConstraints.generate_random())
    elif strategy == "adaptive":
        mutation = AdaptiveMutation()
    else:
        mutation = GaussianMutation(sigma=0.1)

    # Apply mutation
    result = mutation.mutate(base_params)

    # Enforce constraints
    if constraints:
        result = ParameterConstraints.enforce(result)

    return result


def evolve_designs(
    base_designs: List[Dict],
    num_generations: int = 10,
    population_size: int = 20,
    strategy: str = "adaptive"
) -> List[Dict]:
    """
    Evolve a population of designs.

    Args:
        base_designs: Initial designs
        num_generations: Number of generations
        population_size: Population size
        strategy: Mutation strategy

    Returns:
        Final evolved designs
    """
    population = base_designs.copy()

    # Pad population if needed
    while len(population) < population_size:
        population.append(ParameterConstraints.generate_random())

    for generation in range(num_generations):
        # Create next generation
        next_gen = []

        # Keep top performers (elitism)
        next_gen.extend(population[:2])

        # Mutate rest
        while len(next_gen) < population_size:
            # Select parent (tournament)
            parent = random.choice(population[:len(population) // 2])

            # Mutate
            child = mutate_design(parent, strategy=strategy)
            next_gen.append(child)

        # Replace population
        population = next_gen

    return population


if __name__ == "__main__":
    print("🐺📿 Advanced Mutation Strategies Test")
    print("=" * 60)

    # Test mutation
    base_params = {
        "observation_threshold": 30000,
        "reflection_threshold": 40000,
        "observer_temperature": 0.3,
        "reflector_temperature": 0.1,
        "llm_provider": "anthropic",
        "use_tiktoken": True,
        "compression_ratio": 0.8,
    }

    print("\nOriginal Parameters:")
    for key, value in base_params.items():
        print(f"  {key}: {value}")

    strategies = ["gaussian", "annealing", "crossover", "adaptive"]

    for strategy in strategies:
        mutated = mutate_design(base_params, strategy=strategy)
        print(f"\n{strategy.capitalize()} Mutation:")
        for key, value in mutated.items():
            changed = "✓" if value != base_params[key] else " "
            print(f"  {changed} {key}: {value}")

    print("\n✅ Mutation strategies test complete")
