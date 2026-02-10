"""
OpenClaw Observational Memory - Complete Examples

This file demonstrates various usage patterns for Observational Memory.
"""

import json
from datetime import datetime
from pathlib import Path

# Add .openclaw to path
import sys
sys.path.insert(0, str(Path(__file__).parent / ".openclaw"))

from observational_memory import ObservationalMemory, ObservationConfig


def example_1_basic_usage():
    """Example 1: Basic usage with default configuration."""
    print("\n=== Example 1: Basic Usage ===\n")

    # Initialize with default config
    om = ObservationalMemory()

    # Process messages
    messages = [
        {
            "role": "user",
            "content": "I have 2 kids and work at Google",
            "timestamp": datetime.now(),
        },
        {
            "role": "assistant",
            "content": "That's great! Tell me more about your work.",
            "timestamp": datetime.now(),
        },
        {
            "role": "user",
            "content": "I'm a software engineer working on AI projects",
            "timestamp": datetime.now(),
        },
    ]

    record = om.process_messages("example-1", messages)

    print(f"✅ Processed {len(messages)} messages")
    print(f"📝 Extracted {len(record.observations)} observations")

    # Get context
    context = om.get_context("example-1")
    print(f"\n📄 Context:\n{context}")


def example_2_custom_configuration():
    """Example 2: Using custom configuration."""
    print("\n=== Example 2: Custom Configuration ===\n")

    # Custom configuration
    config = ObservationConfig(
        observation_threshold=100,      # Lower for testing
        reflection_threshold=200,        # Lower for testing
        observer_temperature=0.3,        # More creative
        reflector_temperature=0.0,      # Deterministic
        llm_provider="anthropic",        # Use Anthropic
        use_tiktoken=True,              # Accurate token counting
    )

    om = ObservationalMemory(config)

    print(f"✅ Configured with:")
    print(f"   - Observation threshold: {config.observation_threshold}")
    print(f"   - Reflection threshold: {config.reflection_threshold}")
    print(f"   - LLM provider: {config.llm_provider}")
    print(f"   - Tiktoken enabled: {config.use_tiktoken}")


def example_3_different_providers():
    """Example 3: Using different LLM providers."""
    print("\n=== Example 3: Different LLM Providers ===\n")

    providers = ["anthropic", "openai", "google"]

    for provider in providers:
        try:
            config = ObservationConfig(llm_provider=provider)
            om = ObservationalMemory(config)
            print(f"✅ {provider.capitalize()}: Connected")
        except Exception as e:
            print(f"❌ {provider.capitalize()}: {e}")


def example_4_statistics():
    """Example 4: Getting statistics."""
    print("\n=== Example 4: Statistics ===\n")

    om = ObservationalMemory()

    # Process some messages
    messages = [
        {"role": "user", "content": "I need help", "timestamp": datetime.now()},
    ]
    om.process_messages("example-4", messages)

    # Get stats
    stats = om.get_stats("example-4")

    print("📊 Statistics:")
    print(f"   - Total observations: {stats.get('total_observations', 0)}")
    print(f"   - Has current task: {stats.get('has_current_task', False)}")


def example_5_force_reflection():
    """Example 5: Forcing reflection."""
    print("\n=== Example 5: Force Reflection ===\n")

    om = ObservationalMemory()

    # Process multiple messages
    for i in range(5):
        messages = [
            {"role": "user", "content": f"Message {i}", "timestamp": datetime.now()},
        ]
        om.process_messages("example-5", messages)

    # Force reflection
    result = om.force_reflection("example-5")
    print(f"🔄 {result}")


def example_6_persistence():
    """Example 6: Persistence across instances."""
    print("\n=== Example 6: Persistence ===\n")

    # First instance
    om1 = ObservationalMemory()
    messages = [
        {"role": "user", "content": "Remember this", "timestamp": datetime.now()},
    ]
    om1.process_messages("example-6", messages)
    print("✅ First instance: Observations saved")

    # Second instance
    om2 = ObservationalMemory()
    record = om2.get_observation_record("example-6")
    print(f"✅ Second instance: {len(record.observations)} observations loaded")


def example_7_cli_tool():
    """Example 7: Using CLI tool."""
    print("\n=== Example 7: CLI Tool ===\n")

    import subprocess

    # Create sample messages file
    messages = [
        {"role": "user", "content": "Test message", "timestamp": "2026-02-10T10:00:00Z"},
    ]
    with Path("messages.json").open("w") as f:
        json.dump(messages, f)

    print("✅ Created messages.json")

    # Run CLI commands
    print("\n📋 Running CLI commands...")

    # Observe
    result = subprocess.run(
        ["python3", "scripts/observational-memory-cli.py", "observe", "example-7", "-f", "messages.json"],
        capture_output=True,
        text=True,
    )
    print(f"\nObserve: {result.stdout.strip()}")

    # Stats
    result = subprocess.run(
        ["python3", "scripts/observational-memory-cli.py", "stats", "example-7"],
        capture_output=True,
        text=True,
    )
    print(f"\nStats:\n{result.stdout.strip()}")

    # Clean up
    Path("messages.json").unlink(missing_ok=True)


def example_8_token_counting():
    """Example 8: Token counting."""
    print("\n=== Example 8: Token Counting ===\n")

    try:
        from observational_memory.tiktoken_counter import get_token_counter

        counter = get_token_counter()

        texts = [
            "Hello, world!",
            "This is a longer text with many words.",
            "OpenClaw Observational Memory is a memory system for AI agents.",
        ]

        print("📊 Token counts:")
        for text in texts:
            count = counter.count_tokens(text)
            print(f"   - '{text}': {count} tokens")
    except ImportError:
        print("❌ Tiktoken not installed (pip install tiktoken)")


def example_9_llm_client():
    """Example 9: Using LLM client directly."""
    print("\n=== Example 9: LLM Client ===\n")

    try:
        from observational_memory.llm_client import get_llm_client

        client = get_llm_client("anthropic")
        response = client.generate(
            prompt="Say hello in one word.",
            temperature=0.5,
            max_tokens=10,
        )
        print(f"🤖 LLM response: {response}")
    except Exception as e:
        print(f"❌ LLM client error: {e}")


def example_10_full_workflow():
    """Example 10: Complete workflow."""
    print("\n=== Example 10: Complete Workflow ===\n")

    # Initialize
    config = ObservationConfig(
        observation_threshold=100,
        reflection_threshold=200,
    )
    om = ObservationalMemory(config)

    # Simulate conversation
    conversation = [
        ("user", "Hi, I'm looking for help with my project"),
        ("assistant", "Of course! Tell me about your project."),
        ("user", "It's a trading bot for cryptocurrency"),
        ("assistant", "Interesting! What programming language are you using?"),
        ("user", "Python with Python"),
        ("assistant", "Python is great for trading bots. What exchanges are you targeting?"),
    ]

    print("💬 Processing conversation...")
    for i, (role, content) in enumerate(conversation):
        messages = [
            {"role": role, "content": content, "timestamp": datetime.now()},
        ]
        om.process_messages("example-10", messages)
        print(f"   [{i+1}/{len(conversation)}] {role}: {content[:50]}...")

    # Get final context
    print("\n📄 Final context:")
    context = om.get_context("example-10")
    print(context)

    # Get stats
    stats = om.get_stats("example-10")
    print(f"\n📊 Final stats: {stats}")


def main():
    """Run all examples."""
    print("🐺📿 OpenClaw Observational Memory - Examples")
    print("=" * 50)

    examples = [
        example_1_basic_usage,
        example_2_custom_configuration,
        example_3_different_providers,
        example_4_statistics,
        example_5_force_reflection,
        example_6_persistence,
        example_7_cli_tool,
        example_8_token_counting,
        example_9_llm_client,
        example_10_full_workflow,
    ]

    for i, example in enumerate(examples, 1):
        try:
            example()
        except Exception as e:
            print(f"❌ Example {i} failed: {e}")

    print("\n" + "=" * 50)
    print("✅ All examples completed")


if __name__ == "__main__":
    main()
