#!/usr/bin/env python3
"""
ALMA Enhanced Test Suite

Tests for ALMA meta-learning, real evaluator, and mutation strategies.
"""

import sys
from pathlib import Path
import os

# Add paths
repo_root = Path(__file__).parent
sys.path.insert(0, str(repo_root))
sys.path.insert(0, str(repo_root / ".openclaw"))

from alma.alma_agent import ALMAAgent
from alma.real_evaluator import RealALMAEvaluator, benchmark_designs
from alma.mutation_strategies import (
    mutate_design,
    evolve_designs,
    ParameterConstraints,
    GaussianMutation,
    SimulatedAnnealingMutation,
    AdaptiveMutation,
)

# Test results
TEST_RESULTS = []


def test_alma_agent():
    """Test ALMA agent functionality."""
    print("\n🧪 Test 1: ALMA Agent")

    try:
        # Initialize (use temp file for persistence)
        import tempfile
        temp_db = tempfile.NamedTemporaryFile(delete=False, suffix=".db").name
        alma = ALMAAgent(db_path=temp_db)

        # Propose design
        design = alma.propose_design()

        assert design is not None, "Design is None"
        assert design.design_id is not None, "Design ID is None"
        assert len(design.parameters) > 0, "No parameters in design"

        # Evaluate design
        result = alma.evaluate_design(design.design_id, {
            "accuracy": 90.0,
            "efficiency": 85.0,
            "compression": 80.0,
        })

        assert result.score > 0, "Score should be > 0"

        # Update best flag (needed after manual evaluation)
        alma._update_best_flag()

        # Get best design
        best = alma.get_best_design()
        assert best is not None, "Best design is None"
        assert best.design_id == design.design_id, "Best design ID mismatch"

        print("  ✅ PASS")
        TEST_RESULTS.append(("ALMA Agent", "PASS"))
        return True

    except Exception as e:
        print(f"  ❌ FAIL: {e}")
        import traceback
        traceback.print_exc()
        TEST_RESULTS.append(("ALMA Agent", "FAIL"))
        return False


def test_real_evaluator():
    """Test real evaluator."""
    print("\n🧪 Test 2: Real Evaluator")

    try:
        # Initialize
        evaluator = RealALMAEvaluator()

        # Create test designs
        designs = [
            {
                "observation_threshold": 20000,
                "reflection_threshold": 30000,
                "use_tiktoken": True,
            },
            {
                "observation_threshold": 30000,
                "reflection_threshold": 40000,
                "use_tiktoken": False,
            },
        ]

        # Benchmark
        results = benchmark_designs(designs, evaluator)

        assert len(results) == 2
        assert all("composite_score" in r for r in results)

        print("  ✅ PASS")
        TEST_RESULTS.append(("Real Evaluator", "PASS"))
        return True

    except Exception as e:
        print(f"  ❌ FAIL: {e}")
        TEST_RESULTS.append(("Real Evaluator", "FAIL"))
        return False


def test_mutation_strategies():
    """Test mutation strategies."""
    print("\n🧪 Test 3: Mutation Strategies")

    try:
        # Base params
        base = {
            "observation_threshold": 30000,
            "reflection_threshold": 40000,
            "use_tiktoken": True,
        }

        # Test all strategies
        strategies = ["gaussian", "annealing", "crossover", "adaptive"]

        for strategy in strategies:
            mutated = mutate_design(base, strategy=strategy)

            assert mutated is not None
            assert len(mutated) == len(base)

            # Check constraints enforced
            assert "observation_threshold" in mutated
            assert "reflection_threshold" in mutated

        print("  ✅ PASS")
        TEST_RESULTS.append(("Mutation Strategies", "PASS"))
        return True

    except Exception as e:
        print(f"  ❌ FAIL: {e}")
        TEST_RESULTS.append(("Mutation Strategies", "FAIL"))
        return False


def test_parameter_constraints():
    """Test parameter constraints."""
    print("\n🧪 Test 4: Parameter Constraints")

    try:
        # Generate random params
        params = ParameterConstraints.generate_random()

        assert len(params) > 0

        # Enforce constraints
        constrained = ParameterConstraints.enforce(params)

        # Check thresholds are multiples of 1000
        if "observation_threshold" in constrained:
            assert constrained["observation_threshold"] % 1000 == 0

        print("  ✅ PASS")
        TEST_RESULTS.append(("Parameter Constraints", "PASS"))
        return True

    except Exception as e:
        print(f"  ❌ FAIL: {e}")
        TEST_RESULTS.append(("Parameter Constraints", "FAIL"))
        return False


def test_evolution():
    """Test design evolution."""
    print("\n🧪 Test 5: Design Evolution")

    try:
        # Base designs
        base = [ParameterConstraints.generate_random() for _ in range(3)]

        # Evolve
        evolved = evolve_designs(
            base,
            num_generations=5,
            population_size=10,
            strategy="adaptive"
        )

        assert len(evolved) == 10

        print("  ✅ PASS")
        TEST_RESULTS.append(("Evolution", "PASS"))
        return True

    except Exception as e:
        print(f"  ❌ FAIL: {e}")
        TEST_RESULTS.append(("Evolution", "FAIL"))
        return False


def test_alma_meta_learning_cycle():
    """Test ALMA meta-learning cycle."""
    print("\n🧪 Test 6: ALMA Meta-Learning Cycle")

    try:
        # Initialize (use temp file for persistence)
        import tempfile
        temp_db = tempfile.NamedTemporaryFile(delete=False, suffix=".db").name
        alma = ALMAAgent(db_path=temp_db)
        evaluator = RealALMAEvaluator()

        # Run meta-learning cycle
        best, results = alma.run_meta_learning_iteration(
            num_designs=5,
            evaluator=lambda d: evaluator.evaluate_design(d.parameters, num_iterations=1)
        )

        assert best is not None
        assert len(results) == 5

        print("  ✅ PASS")
        TEST_RESULTS.append(("Meta-Learning Cycle", "PASS"))
        return True

    except Exception as e:
        print(f"  ❌ FAIL: {e}")
        import traceback
        traceback.print_exc()
        TEST_RESULTS.append(("Meta-Learning Cycle", "FAIL"))
        return False


def test_alma_stats():
    """Test ALMA statistics."""
    print("\n🧪 Test 7: ALMA Statistics")

    try:
        # Initialize (use temp file for persistence)
        import tempfile
        temp_db = tempfile.NamedTemporaryFile(delete=False, suffix=".db").name
        alma = ALMAAgent(db_path=temp_db)

        # Propose and evaluate designs
        for _ in range(3):
            design = alma.propose_design()
            alma.evaluate_design(design.design_id, {
                "accuracy": 90.0,
                "efficiency": 85.0,
                "compression": 80.0,
            })

        # Get stats
        stats = alma.get_stats()

        assert stats["num_designs"] == 3
        assert stats["num_evaluations"] == 3

        print("  ✅ PASS")
        TEST_RESULTS.append(("ALMA Stats", "PASS"))
        return True

    except Exception as e:
        print(f"  ❌ FAIL: {e}")
        TEST_RESULTS.append(("ALMA Stats", "FAIL"))
        return False


def run_all_tests():
    """Run all ALMA tests."""
    print("🐺📿 ALMA Enhanced Test Suite")
    print("=" * 60)

    tests = [
        test_alma_agent,
        test_real_evaluator,
        test_mutation_strategies,
        test_parameter_constraints,
        test_evolution,
        test_alma_meta_learning_cycle,
        test_alma_stats,
    ]

    for test in tests:
        test()

    # Print summary
    print("\n" + "=" * 60)
    print("📊 Test Summary:")
    print("=" * 60)

    passed = sum(1 for _, status in TEST_RESULTS if status == "PASS")
    failed = sum(1 for _, status in TEST_RESULTS if status == "FAIL")

    for name, status in TEST_RESULTS:
        emoji = "✅" if status == "PASS" else "❌"
        print(f"  {emoji} {name}")

    print("=" * 60)
    print(f"Results: {passed} passed, {failed} failed")
    print("=" * 60)

    return failed == 0


if __name__ == "__main__":
    success = run_all_tests()
    sys.exit(0 if success else 1)
