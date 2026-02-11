"""
ALMA Integration for V7 Trading System.

Applies ALMA meta-learning to optimize V7 strategy weights and parameters.
"""

import sys
import json
import sqlite3
from pathlib import Path
from typing import Dict, List, Optional
from datetime import datetime

# Add path to .openclaw
sys.path.insert(0, str(Path(__file__).parent / ".openclaw"))

try:
    from alma.alma_agent import ALMAAgent
except ImportError:
    # Fallback for when running from different directories
    sys.path.insert(0, str(Path(__file__).parent))
    from .openclaw.alma.alma_agent import ALMAAgent


class TradingMemory:
    """Simple trading memory for tracking strategy performance."""
    
    def __init__(self, db_path: str = ".openclaw/trading_memory.db"):
        self.db_path = db_path
        self._init_db()
        
    def _init_db(self):
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS trade_results (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                strategy TEXT,
                win_rate REAL,
                avg_return REAL,
                num_trades INTEGER,
                market_regime TEXT,
                timestamp TEXT
            )
        """)
        conn.commit()
        conn.close()
        
    def record_trade_result(self, strategy, win_rate, avg_return, num_trades, market_regime):
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO trade_results (strategy, win_rate, avg_return, num_trades, market_regime, timestamp)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (strategy, win_rate, avg_return, num_trades, market_regime, datetime.now().isoformat()))
        conn.commit()
        conn.close()
        
    def get_record_count(self):
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM trade_results")
        count = cursor.fetchone()[0]
        conn.close()
        return count


class V7ALMAIntegration:
    """
    Integrate ALMA meta-learning with V7 trading system.

    Features:
    1. Dynamic strategy weight optimization
    2. Market regime-aware parameter tuning
    3. Performance-based strategy selection
    4. Continuous learning from trades
    """

    def __init__(
        self,
        v7_script_path: str = "hl-trading-agent/launch_paper_trading_v7.py",
        alma_db_path: str = ".openclaw/alma_v7_designs.db"
    ):
        """
        Initialize V7 ALMA integration.

        Args:
            v7_script_path: Path to V7 trading script
            alma_db_path: Path to ALMA designs database
        """
        self.v7_script_path = v7_script_path
        self.alma_db_path = alma_db_path

        # Initialize ALMA meta-agent
        self.alma = ALMAAgent(db_path=alma_db_path)

        # Initialize trading memory
        self.trading_memory = TradingMemory()

        # V7 strategies
        self.v7_strategies = [
            "trend_capture_pro",
            "supertrend_nova_cloud",
            "volatility_breakout_system",
            "selective_momentum_swing",
            "divergence_volatility_enhanced",
            "momentum_convergence_strategy",
            "adaptive_range_strategy",
            "multi_timeframe_rsi",
            "bollinger_breakout_strategy",
            "tvscreener",
            "liquidator_indicator",
            "renaissance_ai",
        ]

    def get_optimal_weights(
        self,
        market_regime: Optional[str] = None,
        lookback_days: int = 30
    ) -> Dict[str, float]:
        """
        Get optimal strategy weights using ALMA.

        Args:
            market_regime: Current market regime (bull/bear/sideways)
            lookback_days: Number of days to look back

        Returns:
            Dictionary of strategy weights
        """
        # In a real implementation, this would query ALMA for the best design
        # For now, we simulate ALMA providing weights based on its 'parameters'
        best_design = self.alma.get_best_design()
        
        if best_design and "strategy_weights" in best_design.parameters:
             weights = best_design.parameters["strategy_weights"]
        else:
            # Fallback/Initial: Equal weights
            weights = {s: 1.0 / len(self.v7_strategies) for s in self.v7_strategies}

        # Adjust for market regime
        if market_regime:
            weights = self._adjust_weights_for_regime(weights, market_regime)

        return weights

    def update_strategy_performance(
        self,
        strategy_name: str,
        win_rate: float,
        avg_return: float,
        num_trades: int,
        market_regime: str
    ):
        """
        Update strategy performance in ALMA memory.

        Args:
            strategy_name: Strategy name
            win_rate: Win rate (0-1)
            avg_return: Average return per trade
            num_trades: Number of trades
            market_regime: Market regime during trades
        """
        # Store in trading memory
        self.trading_memory.record_trade_result(
            strategy=strategy_name,
            win_rate=win_rate,
            avg_return=avg_return,
            num_trades=num_trades,
            market_regime=market_regime
        )

        # Trigger ALMA meta-learning cycle (simplified)
        # In a full system, this would calculate a new score and update the design
        pass

    def suggest_strategy(
        self,
        current_market_data: Dict,
        market_regime: str
    ) -> str:
        """
        Suggest best strategy for current conditions.

        Args:
            current_market_data: Current market indicators
            market_regime: Current market regime

        Returns:
            Best strategy name
        """
        # Get optimal weights
        weights = self.get_optimal_weights(market_regime=market_regime)

        # Get best strategy
        best_strategy = max(weights, key=weights.get)

        return best_strategy

    def generate_v7_config_patch(
        self,
        market_regime: str = "sideways"
    ) -> str:
        """
        Generate a config patch for V7.

        Args:
            market_regime: Current market regime

        Returns:
            Python code patch for V7
        """
        # Get optimal weights
        weights = self.get_optimal_weights(market_regime=market_regime)

        # Generate patch code
        patch_lines = [
            "# ALMA-Generated Strategy Weights",
            "# Generated by V7 ALMA Integration",
            f"# Market Regime: {market_regime}",
            f"# Generated: {datetime.now().isoformat()}",
            "",
            "# Replace strategy_weights in V7 with:",
            "ALMA_STRATEGY_WEIGHTS = {",
        ]

        for strategy, weight in weights.items():
            patch_lines.append(f'    "{strategy}": {weight:.4f},')

        patch_lines.extend([
            "}",
            "",
            "# Apply to consensus calculation:",
            "strategy_weights.update(ALMA_STRATEGY_WEIGHTS)",
            "",
            f"# Consensus threshold: {self._calculate_consensus_threshold(market_regime)}",
        ])

        return "\n".join(patch_lines)

    def _adjust_weights_for_regime(
        self,
        weights: Dict[str, float],
        regime: str
    ) -> Dict[str, float]:
        """Adjust weights based on market regime."""
        adjusted = weights.copy()

        # Regime-specific adjustments
        if regime == "bull":
            # Boost momentum and trend strategies
            boost_strategies = [
                "trend_capture_pro",
                "selective_momentum_swing",
                "momentum_convergence_strategy",
            ]
            for s in boost_strategies:
                if s in adjusted:
                    adjusted[s] *= 1.3

        elif regime == "bear":
            # Boost volatility and breakout strategies
            boost_strategies = [
                "volatility_breakout_system",
                "bollinger_breakout_strategy",
                "divergence_volatility_enhanced",
            ]
            for s in boost_strategies:
                if s in adjusted:
                    adjusted[s] *= 1.3

        elif regime == "sideways":
            # Boost range-based strategies
            boost_strategies = [
                "adaptive_range_strategy",
                "multi_timeframe_rsi",
            ]
            for s in boost_strategies:
                if s in adjusted:
                    adjusted[s] *= 1.3

        # Normalize
        total = sum(adjusted.values())
        if total > 0:
            for s in adjusted:
                adjusted[s] /= total

        return adjusted

    def _calculate_consensus_threshold(self, regime: str) -> int:
        """Calculate consensus threshold based on regime."""
        if regime == "bull":
            return 2  # More aggressive in bull markets
        elif regime == "bear":
            return 3  # More conservative in bear markets
        else:
            return 2  # Base threshold

    def export_alma_design(
        self,
        output_path: str = "alma_v7_design.json"
    ):
        """Export current ALMA design to JSON."""
        # Get best design
        # This is a simulation since we don't have real ALMA data yet
        design = {
            "generated_at": datetime.now().isoformat(),
            "market_regime": "sideways",  # TODO: Get from V7
            "strategy_weights": self.get_optimal_weights(),
            "best_strategy": max(
                self.get_optimal_weights(),
                key=self.get_optimal_weights().get
            ),
        }

        # Write to file
        with open(output_path, 'w') as f:
            json.dump(design, f, indent=2)

        print(f"✅ Exported ALMA design to {output_path}")

    def get_stats(self) -> Dict:
        """Get V7 ALMA integration statistics."""
        # In this simulation, we check for 'get_num_designs' if it exists, otherwise 0
        alma_designs = getattr(self.alma, "get_num_designs", lambda: 0)()
        
        return {
            "num_strategies": len(self.v7_strategies),
            "alma_designs": alma_designs,
            "trading_memory_records": self.trading_memory.get_record_count(),
        }


def example_v7_integration():
    """Example V7 ALMA integration."""
    print("🐺📿 V7 ALMA Integration Example")
    print("=" * 60)

    # Initialize
    integration = V7ALMAIntegration()

    # Get optimal weights
    print("\\n🔢 Optimal Strategy Weights:")
    weights = integration.get_optimal_weights(market_regime="sideways")

    # Sort by weight
    sorted_weights = sorted(weights.items(), key=lambda x: x[1], reverse=True)

    for strategy, weight in sorted_weights[:5]:
        print(f"  {strategy}: {weight:.4f}")

    # Generate config patch
    print("\\n📝 V7 Config Patch:")
    patch = integration.generate_v7_config_patch(market_regime="sideways")
    print(patch)

    # Suggest strategy
    print("\\n🎯 Suggested Strategy:")
    best = integration.suggest_strategy(
        current_market_data={},
        market_regime="sideways"
    )
    print(f"  {best}")

    # Export design
    integration.export_alma_design()

    # Stats
    stats = integration.get_stats()
    print(f"\\n📊 Stats:")
    print(f"  Strategies: {stats['num_strategies']}")
    print(f"  ALMA Designs: {stats['alma_designs']}")

    print("\\n✅ V7 ALMA integration example complete")


if __name__ == "__main__":
    example_v7_integration()
