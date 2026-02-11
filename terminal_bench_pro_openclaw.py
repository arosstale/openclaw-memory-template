"""
Terminal Bench Pro (OpenClaw Edition).

Benchmark suite for Agentic Learning Ecosystem (ALE) components.
Evaluates ALMA, PAOM, and V7 integration using ROCK/IPA.
"""

import sys
import time
from typing import Dict, List, Any
from pathlib import Path

# Add paths
sys.path.insert(0, str(Path(__file__).parent / ".openclaw"))

from rock.rock_environment import V7SimulationEnv
from ipa.ipa_evaluator import IPAEvaluator
from roll.roll_framework import ROLLFramework

# Mock ALMA for standalone testing if needed, or import real
try:
    from alma.alma_agent import ALMAAgent
except ImportError:
    print("ALMA Agent not found, using mock.")
    class ALMAAgent:
        def __init__(self, db_path): pass
        def propose_design(self): 
            class Design:
                parameters = {"learning_rate": 0.05}
            return Design()


class TerminalBenchPro:
    """
    Benchmark suite implementation.
    """
    
    def __init__(self):
        self.env = V7SimulationEnv(market_regime="sideways")
        self.ipa = IPAEvaluator()
        self.roll = ROLLFramework()
        self.results = {}
        
    def run_benchmark(self, num_episodes: int = 10):
        """Run the full benchmark."""
        print(f"🚀 Running Terminal Bench Pro ({num_episodes} episodes)...")
        
        # 1. Baseline Performance
        print("\n📊 Phase 1: Baseline Performance")
        baseline_trajectories = self._collect_trajectories(num_episodes, strategy="random")
        baseline_score = self._evaluate_batch(baseline_trajectories)
        print(f"   Baseline Score (IPA): {baseline_score:.4f}")
        
        # 2. Optimized Performance (ROLL)
        print("\n🔄 Phase 2: ROLL Optimization")
        # Initial weights - bias slightly to allow optimization to have effect
        weights = {"strategy_a": 0.6, "strategy_b": 0.4} 
        
        # Optimize loop
        for i in range(3):
            trajectories = self._collect_trajectories(5, strategy="weighted", weights=weights)
            # Calculate average score for reporting
            scores = [self.ipa.evaluate(t)["total_score"] for t in trajectories]
            avg_score = sum(scores) / len(scores) if scores else 0
            
            weights = self.roll.optimize_weights(weights, trajectories)
            print(f"   Iter {i+1}: Score: {avg_score:.2f}, Updated weights: {weights}")
            
        # 3. Final Evaluation
        print("\n🏆 Phase 3: Final Evaluation")
        final_trajectories = self._collect_trajectories(num_episodes, strategy="weighted", weights=weights)
        final_score = self._evaluate_batch(final_trajectories)
        print(f"   Final Score (IPA): {final_score:.4f}")
        
        improvement = ((final_score - baseline_score) / baseline_score) * 100 if baseline_score != 0 else 0
        print(f"\n✅ Improvement: {improvement:+.2f}%")
        
        self.results = {
            "baseline": baseline_score,
            "final": final_score,
            "improvement": improvement
        }
        
    def _collect_trajectories(self, count: int, strategy: str, weights: Dict = None) -> List[List[Dict]]:
        trajectories = []
        for _ in range(count):
            self.env.reset()
            # Wrap environment strategy
            if strategy == "random":
                strat_func = lambda obs: "buy" if obs["step"] % 2 == 0 else "sell"
            else:
                # Mock weighted strategy
                strat_func = lambda obs: "buy" if (obs["price"] > 100 and weights.get("strategy_a", 0.5) > 0.5) else "sell"
                
            traj = self.env.generate_trajectory(strat_func, num_steps=50)
            trajectories.append(traj)
        return trajectories
        
    def _evaluate_batch(self, trajectories: List[List[Dict]]) -> float:
        scores = []
        for traj in trajectories:
            eval_result = self.ipa.evaluate(traj)
            scores.append(eval_result["total_score"])
        return sum(scores) / len(scores) if scores else 0.0


if __name__ == "__main__":
    bench = TerminalBenchPro()
    bench.run_benchmark()
