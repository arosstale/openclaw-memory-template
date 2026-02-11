"""
IPA: Interaction-Perceptive Agentic Policy Optimization.

Part of the Agentic Learning Ecosystem (ALE).
Provides credit assignment over semantic interaction chunks rather than individual tokens.
"""

from typing import List, Dict, Any
import math

class InteractionChunk:
    """A semantic chunk of interaction."""
    
    def __init__(self, chunk_id: str, content: List[Any], metadata: Dict[str, Any] = None):
        self.id = chunk_id
        self.content = content
        self.metadata = metadata or {}
        self.score = 0.0
        
    def __repr__(self):
        return f"Chunk(id={self.id}, items={len(self.content)}, score={self.score:.2f})"


class IPAEvaluator:
    """
    Evaluator implementing IPA credit assignment logic.
    """
    
    def __init__(self, gamma: float = 0.99):
        self.gamma = gamma  # Discount factor for credit assignment
        
    def chunk_trajectory(self, trajectory: List[Dict[str, Any]]) -> List[InteractionChunk]:
        """
        Break a trajectory into semantic chunks.
        
        In a full implementation, this would use an LLM or specific rules 
        to identify semantic boundaries. Here, we use a simple sliding window 
        or task-based chunking.
        """
        chunks = []
        current_chunk_content = []
        chunk_index = 0
        
        # Simple heuristic: Chunk by every 5 steps or when a significant reward occurs
        for i, step in enumerate(trajectory):
            current_chunk_content.append(step)
            
            # End chunk conditions:
            # 1. Significant reward (positive or negative)
            # 2. Fixed size reached
            # 3. Episode end
            is_significant = abs(step.get("reward", 0)) > 0.1
            is_full = len(current_chunk_content) >= 5
            is_last = (i == len(trajectory) - 1)
            
            if is_significant or is_full or is_last:
                chunk = InteractionChunk(
                    chunk_id=f"chunk_{chunk_index}",
                    content=current_chunk_content,
                    metadata={"step_start": i - len(current_chunk_content) + 1, "step_end": i}
                )
                chunks.append(chunk)
                current_chunk_content = []
                chunk_index += 1
                
        return chunks
        
    def assign_credit(self, chunks: List[InteractionChunk]) -> List[InteractionChunk]:
        """
        Assign credit to chunks based on rewards.
        
        Uses a discount mechanism to propagate rewards backwards to causal chunks.
        """
        # Calculate raw rewards for each chunk
        for chunk in chunks:
            # Sum rewards within the chunk
            chunk_reward = sum(step.get("reward", 0.0) for step in chunk.content)
            chunk.score = chunk_reward
            
        # Propagate credit backwards (Time-based credit assignment)
        # IPA extends this by considering semantic dependencies, but we start with temporal.
        # Ideally, we would build a dependency graph between chunks.
        
        running_return = 0.0
        for chunk in reversed(chunks):
            running_return = chunk.score + self.gamma * running_return
            chunk.score = running_return
            
        return chunks
        
    def evaluate(self, trajectory: List[Dict[str, Any]]) -> Dict[str, Any]:
        """
        Full evaluation pipeline: Chunk -> Assign Credit -> Aggregate.
        """
        chunks = self.chunk_trajectory(trajectory)
        scored_chunks = self.assign_credit(chunks)
        
        total_score = sum(c.score for c in scored_chunks)
        avg_score = total_score / len(scored_chunks) if scored_chunks else 0
        
        return {
            "chunks": scored_chunks,
            "total_score": total_score,
            "avg_chunk_score": avg_score,
            "num_chunks": len(scored_chunks)
        }
