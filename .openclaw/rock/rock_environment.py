"""
ROCK: Sandbox Environment Manager.

Part of the Agentic Learning Ecosystem (ALE).
Provides environments for trajectory generation and agent training.
"""

from typing import Dict, List, Any, Tuple, Optional
import random
from datetime import datetime, timedelta
from abc import ABC, abstractmethod


class ROCKEnvironment(ABC):
    """Abstract base class for ROCK environments."""
    
    @abstractmethod
    def reset(self) -> Dict[str, Any]:
        """Reset the environment to initial state."""
        pass
        
    @abstractmethod
    def step(self, action: Any) -> Tuple[Dict[str, Any], float, bool, Dict[str, Any]]:
        """
        Execute an action in the environment.
        
        Returns:
            observation: New state
            reward: Reward for the action
            done: Whether the episode is finished
            info: Additional information
        """
        pass
        
    @abstractmethod
    def render(self):
        """Render the environment state."""
        pass


class V7SimulationEnv(ROCKEnvironment):
    """
    Simulated environment for V7 Trading System strategies.
    Generates market data and evaluates strategy performance.
    """
    
    def __init__(self, market_regime: str = "sideways", initial_balance: float = 10000.0):
        self.market_regime = market_regime
        self.initial_balance = initial_balance
        self.balance = initial_balance
        self.position = None
        self.market_price = 100.0
        self.step_count = 0
        self.max_steps = 100
        self.history = []
        
    def reset(self) -> Dict[str, Any]:
        self.balance = self.initial_balance
        self.position = None
        self.market_price = 100.0
        self.step_count = 0
        self.history = []
        
        return self._get_observation()
        
    def step(self, action: str) -> Tuple[Dict[str, Any], float, bool, Dict[str, Any]]:
        """
        Execute trading action.
        
        Actions:
        - "buy": Enter long position
        - "sell": Exit position
        - "hold": Do nothing
        """
        self.step_count += 1
        prev_balance = self.balance
        
        # Simulate market movement based on regime
        change = 0.0
        if self.market_regime == "bull":
            change = random.normalvariate(0.001, 0.01)  # Upward drift
        elif self.market_regime == "bear":
            change = random.normalvariate(-0.001, 0.01) # Downward drift
        else:
            change = random.normalvariate(0.0, 0.005)   # Random walk
            
        self.market_price *= (1.0 + change)
        
        # Execute action
        reward = 0.0
        
        if action == "buy" and self.position is None:
            self.position = self.market_price
        elif action == "sell" and self.position is not None:
            profit = (self.market_price - self.position) / self.position
            self.balance *= (1.0 + profit)
            reward = profit * 100  # Scaled reward
            self.position = None
            
        # Holding cost or opportunity cost could be added here
        
        # Check if done
        done = self.step_count >= self.max_steps or self.balance <= 0
        
        observation = self._get_observation()
        info = {
            "balance": self.balance,
            "market_price": self.market_price,
            "regime": self.market_regime
        }
        
        self.history.append((observation, action, reward, done, info))
        
        return observation, reward, done, info
        
    def _get_observation(self) -> Dict[str, Any]:
        return {
            "price": self.market_price,
            "balance": self.balance,
            "has_position": self.position is not None,
            "step": self.step_count
        }
        
    def render(self):
        print(f"Step {self.step_count}: Price {self.market_price:.2f}, Balance {self.balance:.2f}, Pos: {self.position}")
        
    def generate_trajectory(self, strategy_func, num_steps: int = 100) -> List[Tuple]:
        """Generate a full trajectory using a strategy function."""
        obs = self.reset()
        trajectory = []
        
        for _ in range(num_steps):
            action = strategy_func(obs)
            next_obs, reward, done, info = self.step(action)
            trajectory.append({
                "observation": obs,
                "action": action,
                "reward": reward,
                "next_observation": next_obs,
                "done": done,
                "info": info
            })
            obs = next_obs
            if done:
                break
                
        return trajectory
