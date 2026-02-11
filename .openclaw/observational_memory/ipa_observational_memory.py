"""
IPA (Interaction-Perceptive Agentic Policy Optimization) Observational Memory.

Based on ALE/ROME paper (https://arxiv.org/abs/2512.24873)

IPA assigns credit over semantic interaction chunks rather than individual tokens,
improving long-horizon training stability.

This implementation extends PAOM with IPA-style credit assignment.
"""

import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from datetime import datetime

# Add path to observational_memory
sys.path.insert(0, str(Path(__file__).parent / ".openclaw" / "observational_memory"))

try:
    from observational_memory import (
        ObservationalMemory,
        ObservationConfig,
        ObservationRecord,
        ObservationPriority,
        PriorityLevel
    )
except ImportError:
    print("Warning: observational_memory not available")
    ObservationalMemory = None


@dataclass
class InteractionChunk:
    """A semantic interaction chunk for IPA credit assignment."""
    chunk_id: str
    messages: List[Dict]
    created_at: datetime
    credit: float = 0.0
    num_evaluations: int = 0


class IPAObservationalMemory(ObservationalMemory):
    """
    Observational Memory with IPA-style credit assignment.
    
    Features:
    - Groups messages into semantic interaction chunks
    - Assigns credit at chunk level (not token level)
    - Tracks chunk performance for long-horizon learning
    - Provides stability improvements over token-level credit
    """
    
    def __init__(self, config: Optional[ObservationConfig] = None):
        """Initialize IPA Observational Memory."""
        super().__init__(config)
        self.interaction_chunks: Dict[str, InteractionChunk] = {}
        self.chunk_sequence: List[str] = []
        self.current_chunk: Optional[InteractionChunk] = None
        
    def _create_interaction_chunk(
        self,
        messages: List[Dict],
        thread_id: str
    ) -> InteractionChunk:
        """
        Create a new semantic interaction chunk.
        
        Args:
            messages: Messages in this interaction
            thread_id: Thread identifier
            
        Returns:
            New interaction chunk
        """
        chunk_id = f"{thread_id}_chunk_{len(self.chunk_sequence)}"
        
        chunk = InteractionChunk(
            chunk_id=chunk_id,
            messages=messages,
            created_at=datetime.now(),
        )
        
        # Store chunk
        self.interaction_chunks[chunk_id] = chunk
        self.chunk_sequence.append(chunk_id)
        
        return chunk
        
    def process_messages_with_chunks(
        self,
        thread_id: str,
        messages: List[Dict],
        chunk_size: int = 5
    ) -> ObservationRecord:
        """
        Process messages grouped into semantic chunks.
        
        Args:
            thread_id: Thread identifier
            messages: Messages to process
            chunk_size: Number of messages per semantic chunk
            
        Returns:
            Observation record
        """
        # Group messages into chunks
        chunks = []
        for i in range(0, len(messages), chunk_size):
            chunk_messages = messages[i:i + chunk_size]
            chunk = self._create_interaction_chunk(chunk_messages, thread_id)
            chunks.append(chunk)
            
        # Process chunks
        observations = []
        for chunk in chunks:
            # Call parent's observation logic
            obs = self._observe_chunk(chunk)
            observations.append(obs)
            
        # Create consolidated record
        record = ObservationRecord(
            thread_id=thread_id,
            observations=observations,
            created_at=datetime.now(),
            last_updated=datetime.now(),
        )
        
        # Save to database
        self._save_observation_record(record)
        
        # Store current chunk
        self.current_chunk = chunks[-1] if chunks else None
        
        return record
        
    def _observe_chunk(self, chunk: InteractionChunk) -> str:
        """Observe a semantic interaction chunk."""
        # Combine messages for observation
        combined_content = "\\n\\n".join([
            f"{m.get('role', 'user')}: {m.get('content', '')}"
            for m in chunk.messages
        ])
        
        # Use LLM to extract observation
        prompt = f"""
You are an Observer agent. Extract key information from this interaction chunk.

Interaction Chunk:
{combined_content}

Extract:
- Key facts mentioned
- Decisions made
- Outcomes observed

Respond with a concise observation (3-5 sentences).
"""
        observation_text = self._llm_extract(prompt)
        
        return observation_text
        
    def assign_credit(
        self,
        chunk_id: str,
        success: float,
        weight: float = 1.0
    ):
        """
        Assign credit to an interaction chunk.
        
        Args:
            chunk_id: Chunk identifier
            success: Success metric (0-1 or -1 to 1)
            weight: Weight for this credit assignment
        """
        if chunk_id not in self.interaction_chunks:
            print(f"Warning: Chunk {chunk_id} not found")
            return
            
        chunk = self.interaction_chunks[chunk_id]
        
        # Assign weighted credit
        chunk.credit += success * weight
        chunk.num_evaluations += 1
        
        print(f"✓ Assigned credit to {chunk_id}: {chunk.credit:.2f} (evaluations: {chunk.num_evaluations})")
        
    def get_chunk_performance(self, chunk_id: str) -> Optional[Dict]:
        """Get performance metrics for a chunk."""
        if chunk_id not in self.interaction_chunks:
            return None
            
        chunk = self.interaction_chunks[chunk_id]
        
        # Calculate average credit
        avg_credit = chunk.credit / max(chunk.num_evaluations, 1)
        
        return {
            "chunk_id": chunk_id,
            "credit": chunk.credit,
            "num_evaluations": chunk.num_evaluations,
            "avg_credit": avg_credit,
            "messages_count": len(chunk.messages),
        }
        
    def get_best_chunks(self, top_k: int = 5) -> List[Dict]:
        """Get top-performing interaction chunks."""
        chunk_perfs = [
            self.get_chunk_performance(chunk_id)
            for chunk_id in self.chunk_sequence
        ]
        
        # Filter None and sort by average credit
        chunk_perfs = [p for p in chunk_perfs if p is not None]
        chunk_perfs.sort(key=lambda x: x["avg_credit"], reverse=True)
        
        return chunk_perfs[:top_k]
        
    def synthesize_chunk(
        self,
        chunk_id: str,
        include_context: int = 3
    ) -> str:
        """
        Synthesize context from interaction chunk and nearby chunks.
        
        Args:
            chunk_id: Target chunk
            include_context: Number of surrounding chunks to include
            
        Returns:
            Synthesized context
        """
        if chunk_id not in self.chunk_sequence:
            return ""
            
        # Get chunk position
        pos = self.chunk_sequence.index(chunk_id)
        
        # Get surrounding chunks
        start = max(0, pos - include_context)
        end = min(len(self.chunk_sequence), pos + include_context + 1)
        
        surrounding_ids = self.chunk_sequence[start:end]
        
        # Synthesize from chunks
        context_parts = []
        for cid in surrounding_ids:
            if cid in self.interaction_chunks:
                chunk = self.interaction_chunks[cid]
                context_parts.append(
                    f"Chunk [{cid}] (credit: {chunk.credit:.2f}):\\n" +
                    f"  Messages: {len(chunk.messages)}\\n"
                )
                
        return "\\n\\n".join(context_parts)
        
    def reflect_with_ipa(
        self,
        thread_id: str
    ) -> str:
        """
        Reflect using IPA-style credit-aware compression.
        
        Args:
            thread_id: Thread identifier
            
        Returns:
            Compressed reflection
        """
        # Get chunks for this thread
        thread_chunks = [
            cid for cid in self.chunk_sequence
            if cid.startswith(thread_id)
        ]
        
        # Get best chunks (high credit)
        best_chunks = []
        for cid in thread_chunks:
            perf = self.get_chunk_performance(cid)
            if perf and perf["avg_credit"] > 0.0:
                best_chunks.append(cid)
                
        # If not enough, use recent
        if len(best_chunks) < 3:
            best_chunks = thread_chunks[-5:]  # Last 5 chunks
            
        # Synthesize reflection
        reflection_parts = []
        for cid in best_chunks:
            if cid in self.interaction_chunks:
                chunk = self.interaction_chunks[cid]
                # Get compressed observation from database
                obs = self._get_observation_for_chunk(cid)
                if obs:
                    reflection_parts.append(
                        f"✓ {cid}: {obs} (credit: {chunk.credit:.2f})"
                    )
                    
        return "\\n\\n".join(reflection_parts)


def example_ipa_memory():
    """Example of IPA Observational Memory."""
    print("🐺📿 IPA Observational Memory Example")
    print("=" * 60)
    
    # Create memory
    config = ObservationConfig(
        observation_threshold=10000,
        reflection_threshold=15000,
    )
    memory = IPAObservationalMemory(config)
    
    # Simulate interaction chunks
    print("\\n📝 Creating interaction chunks...")
    thread_id = "example-thread"
    
    messages = [
        {"role": "user", "content": "I need help with Python", "timestamp": datetime.now()},
        {"role": "assistant", "content": "Sure, what do you need?", "timestamp": datetime.now()},
        {"role": "user", "content": "How to use lists", "timestamp": datetime.now()},
        {"role": "assistant", "content": "Lists are mutable sequences", "timestamp": datetime.now()},
        {"role": "user", "content": "Thanks!", "timestamp": datetime.now()},
    ]
    
    # Process with chunks
    record = memory.process_messages_with_chunks(thread_id, messages, chunk_size=3)
    
    print(f"   Created {len(memory.chunk_sequence)} chunks")
    print(f"   Observations: {len(record.observations)}")
    
    # Assign credit
    print("\\n📊 Assigning credit to chunks...")
    memory.assign_credit(thread_id + "_chunk_0", success=0.8)
    memory.assign_credit(thread_id + "_chunk_1", success=-0.2)
    memory.assign_credit(thread_id + "_chunk_0", success=0.1)
    
    # Get chunk performance
    print("\\n📈 Chunk Performance:")
    for chunk_id in memory.chunk_sequence:
        perf = memory.get_chunk_performance(chunk_id)
        if perf:
            print(f"   {perf['chunk_id']}: avg_credit={perf['avg_credit']:.2f}, evals={perf['num_evaluations']}")
    
    # Get best chunks
    print("\\n🏆 Best Chunks:")
    best = memory.get_best_chunks(top_k=3)
    for chunk in best:
        print(f"   {chunk['chunk_id']}: {chunk['avg_credit']:.2f}")
    
    # Synthesize context
    print("\\n📄 Synthesized Context:")
    context = memory.synthesize_chunk(thread_id + "_chunk_0", include_context=2)
    print(context[:500] + "..." if len(context) > 500 else context)
    
    # Reflect with IPA
    print("\\n🔮 IPA Reflection:")
    reflection = memory.reflect_with_ipa(thread_id)
    print(reflection[:500] + "..." if len(reflection) > 500 else reflection)
    
    print("\\n✅ IPA Observational Memory example complete")


if __name__ == "__main__":
    example_ipa_memory()
