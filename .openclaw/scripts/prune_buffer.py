#!/usr/bin/env python3
"""
prune_buffer.py - BUFFER.md evaporation protocol (Python implementation)
Part of OpenClaw Memory Template V3.1

Purpose:
  - Automatically remove low-value logs from BUFFER.md after they've been distilled
  - Age-based pruning (default: 7 days)
  - Backup before pruning
  - Integration with EVOLUTION.md pattern updates

Usage:
  python3 prune_buffer.py [--dry-run] [--min-age-days=N]
"""

import sys
import re
import argparse
from datetime import datetime, timedelta
from pathlib import Path
import shutil

# ANSI colors
RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
BLUE = '\033[0;34m'
NC = '\033[0m'

def parse_args():
    parser = argparse.ArgumentParser(description='BUFFER.md Evaporation Protocol')
    parser.add_argument('--dry-run', action='store_true',
                       help='Run in dry-run mode (no changes)')
    parser.add_argument('--min-age-days', type=int, default=7,
                       help='Minimum age in days for pruning (default: 7)')
    return parser.parse_args()

def load_buffer(buffer_path):
    """Load BUFFER.md content."""
    with open(buffer_path, 'r') as f:
        return f.read()

def extract_entries(content):
    """Extract buffer entries from BUFFER.md."""
    pattern = r'<buffer_entry>.*?<timestamp>(.*?)</timestamp>.*?</buffer_entry>'
    entries = list(re.finditer(pattern, content, re.DOTALL))
    return entries

def analyze_entries(entries, min_age_days, dry_run):
    """Analyze entries and count what would be pruned."""
    now = datetime.utcnow()
    min_age = timedelta(days=min_age_days)

    total_entries = len(entries)
    old_entries = 0
    recent_entries = 0

    print(f"{BLUE}=== BUFFER.md EVAPORATION PROTOCOL ==={NC}")
    print("")
    print(f"{YELLOW}Configuration:{NC}")
    print(f"  Minimum age: {min_age_days} days")
    print(f"  Dry run: {dry_run}")
    print("")
    print(f"{YELLOW}Analyzing BUFFER.md...{NC}")
    print("")

    for match in entries:
        timestamp_str = match.group(1)
        try:
            entry_time = datetime.strptime(timestamp_str, '%Y-%m-%dT%H:%M:%SZ')
            age = now - entry_time

            if age >= min_age:
                old_entries += 1
                if not dry_run:
                    print(f"{RED}✗ Would prune: [{timestamp_str}]{NC}")
            else:
                recent_entries += 1
                if not dry_run:
                    print(f"{GREEN}✓ Keeping: [{timestamp_str}]{NC}")
        except ValueError:
            # Invalid timestamp, count as recent
            recent_entries += 1

    print("")
    print(f"{YELLOW}Summary:{NC}")
    print(f"  Total entries: {total_entries}")
    print(f"  Old enough to prune: {old_entries}")
    print(f"  Recent entries (keeping): {recent_entries}")
    print("")

    return {
        'total': total_entries,
        'old': old_entries,
        'recent': recent_entries
    }

def prune_entries(content, entries, min_age_days):
    """Remove old entries from content."""
    now = datetime.utcnow()
    min_age = timedelta(days=min_age_days)

    # Process in reverse order to preserve positions
    new_content = content
    for match in reversed(entries):
        timestamp_str = match.group(1)
        try:
            entry_time = datetime.strptime(timestamp_str, '%Y-%m-%dT%H:%M:%SZ')
            age = now - entry_time

            if age >= min_age:
                # Remove this entry
                start = match.start()
                end = match.end()
                new_content = new_content[:start] + new_content[end:]
        except ValueError:
            pass

    return new_content

def main():
    args = parse_args()

    # Buffer path is relative to workspace root
    workspace_root = Path(__file__).parent.parent.parent
    buffer_path = workspace_root / '.openclaw' / 'core' / 'BUFFER.md'

    if not buffer_path.exists():
        print(f"{RED}✗ BUFFER.md not found{NC}")
        sys.exit(1)

    # Load content
    content = load_buffer(buffer_path)

    # Extract entries
    entries = extract_entries(content)

    # Analyze
    stats = analyze_entries(entries, args.min_age_days, args.dry_run)

    if args.dry_run:
        print(f"{GREEN}✓ Pruning protocol complete (dry run){NC}")
        sys.exit(0)

    # Prune if there are old entries
    if stats['old'] > 0:
        print(f"{YELLOW}Performing evaporation...{NC}")

        # Create backup
        backup_path = buffer_path.with_suffix(f'.backup.{datetime.now().strftime("%Y%m%d_%H%M%S")}')
        shutil.copy(buffer_path, backup_path)
        print(f"{GREEN}✓ Backup created: {backup_path}{NC}")

        # Prune entries
        new_content = prune_entries(content, entries, args.min_age_days)

        # Write back
        with open(buffer_path, 'w') as f:
            f.write(new_content)

        print(f"{GREEN}✓ Evaporation complete{NC}")
        print("")
        print(f"{BLUE}=== BUFFER.md Evaporated ==={NC}")
    else:
        print(f"{GREEN}✓ No entries to prune{NC}")

    print("")
    print(f"{BLUE}Next steps:{NC}")
    print(f"  1. Review backup: {backup_path}")
    print(f"  2. Check if any old entries should be distilled to CONSOLIDATED_WISDOM.md")
    print(f"  3. Update EVOLUTION.md with patterns from pruned entries")

    print("")
    print(f"{BLUE}Integration with EVOLUTION.md:{NC}")
    print(f"  Evaporated BUFFER entries should trigger EVOLUTION.md pattern updates:")
    print(f"    - If multiple similar errors → Create technical truth")
    print(f"    - If human preference pattern → Create life lesson")
    print(f"    - If phase-specific pattern → Create temporal insight")

    print("")
    print(f"{GREEN}✓ Pruning protocol complete{NC}")

if __name__ == "__main__":
    main()
