#!/usr/bin/env python3
"""
CLI tool for OpenClaw Observational Memory.

Provides command-line interface for managing observations.
"""

import argparse
import json
import sys
from pathlib import Path

# Add .openclaw to path
sys.path.insert(0, str(Path(__file__).parent / ".openclaw"))

from observational_memory import ObservationalMemory, ObservationConfig
from datetime import datetime


def cmd_observe(args):
    """Observe messages from file or stdin."""
    om = ObservationalMemory()

    # Load messages
    if args.file:
        with open(args.file, 'r') as f:
            messages = json.load(f)
    else:
        print("Reading messages from stdin (Ctrl+D to finish)...")
        messages_text = sys.stdin.read()
        messages = json.loads(messages_text)

    # Process messages
    record = om.process_messages(args.thread, messages)

    print(f"✅ Processed {len(messages)} messages")
    print(f"📝 {len(record.observations)} observations extracted")


def cmd_context(args):
    """Get context for a thread."""
    om = ObservationalMemory()

    context = om.get_context(args.thread)
    print(context)


def cmd_stats(args):
    """Get statistics for a thread."""
    om = ObservationalMemory()

    stats = om.get_stats(args.thread)

    print("📊 Observational Memory Statistics")
    print(f"Thread: {args.thread}")
    print(f"Total observations: {stats.get('total_observations', 0)}")
    print(f"Has current task: {stats.get('has_current_task', False)}")


def cmd_reflect(args):
    """Force reflection on a thread."""
    om = ObservationalMemory()

    result = om.force_reflection(args.thread)
    print(result)


def cmd_list(args):
    """List all threads."""
    import sqlite3
    from pathlib import Path

    config = ObservationConfig()
    db_path = Path(config.db_path)

    if not db_path.exists():
        print("No database found.")
        return

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    cursor.execute("SELECT DISTINCT thread_id FROM observations ORDER BY thread_id")
    threads = cursor.fetchall()

    conn.close()

    print("📋 Threads:")
    for thread in threads:
        print(f"  - {thread[0]}")


def main():
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        prog="observational-memory",
        description="OpenClaw Observational Memory CLI",
    )

    subparsers = parser.add_subparsers(dest='command', help='Available commands')

    # Observe command
    observe_parser = subparsers.add_parser('observe', help='Observe messages')
    observe_parser.add_argument('thread', help='Thread ID')
    observe_parser.add_argument('-f', '--file', help='Messages JSON file')
    observe_parser.set_defaults(func=cmd_observe)

    # Context command
    context_parser = subparsers.add_parser('context', help='Get context for thread')
    context_parser.add_argument('thread', help='Thread ID')
    context_parser.set_defaults(func=cmd_context)

    # Stats command
    stats_parser = subparsers.add_parser('stats', help='Get statistics')
    stats_parser.add_argument('thread', help='Thread ID')
    stats_parser.set_defaults(func=cmd_stats)

    # Reflect command
    reflect_parser = subparsers.add_parser('reflect', help='Force reflection')
    reflect_parser.add_argument('thread', help='Thread ID')
    reflect_parser.set_defaults(func=cmd_reflect)

    # List command
    list_parser = subparsers.add_parser('list', help='List all threads')
    list_parser.set_defaults(func=cmd_list)

    # Parse arguments
    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        sys.exit(1)

    # Execute command
    args.func(args)


if __name__ == "__main__":
    main()
