#!/usr/bin/env python3
"""
buffer_decay.py - Defensive approach: Robust BUFFER.md decay algorithm
Handles XML parsing, timestamp validation, age calculations, and safe pruning
"""

import re
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path

def validate_iso8601(timestamp_str):
    """
    Validate and parse ISO-8601 timestamp
    Returns: datetime object or None if invalid
    """
    if not timestamp_str or timestamp_str == "[ISO-8601]":
        return None

    try:
        # Handle 'Z' suffix (replace with +00:00 for Python < 3.11)
        normalized = timestamp_str.replace('Z', '+00:00')

        # Parse with timezone awareness
        dt = datetime.fromisoformat(normalized)

        # Make timezone-aware if naive
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)

        return dt
    except (ValueError, AttributeError) as e:
        print(f"⚠ Invalid timestamp format: {timestamp_str}")
        return None

def calculate_entry_age(timestamp_str):
    """
    Calculate age of buffer entry in days
    Returns: age in days (float), or None if invalid
    """
    dt = validate_iso8601(timestamp_str)
    if dt is None:
        return None

    now = datetime.now(timezone.utc)
    age_delta = now - dt
    age_days = age_delta.total_seconds() / 8640.0  # Convert to days

    return age_days

def evaluate_decay_risk(age_days, entropy, referenced_count):
    """
    Evaluate decay risk for a buffer entry
    Returns: risk level (none, low, high, critical)
    """
    if age_days is None:
        return "error"

    if age_days > 7:
        return "critical"
    elif age_days >= 6:
        return "critical"
    elif age_days >= 3:
        if entropy.lower() == "low" and referenced_count < 2:
            return "high"
        else:
            return "low"
    elif age_days >= 2:
        return "low"
    else:
        return "none"

def should_prune_entry(entry_data, max_age_days=7):
    """
    Determine if buffer entry should be pruned
    Returns: (should_prune, reason)
    """
    age_days = calculate_entry_age(entry_data['timestamp'])

    if age_days is None:
        return (False, "Invalid timestamp")

    if age_days > max_age_days:
        return (True, f"Older than {max_age_days} days ({age_days:.1f} days)")

    # Don't prune if recently referenced
    if entry_data.get('referenced_count', 0) >= 2:
        return (False, "Recently referenced")

    # Don't prune if high entropy
    if entry_data.get('entropy', '').lower() == 'high':
        if age_days < 5:
            return (False, "High entropy, recent")

    # Prune if old and low entropy
    if age_days >= 6 and entry_data.get('entropy', '').lower() == 'low':
        return (True, f"Old ({age_days:.1f} days) + low entropy")

    return (False, "Meets retention criteria")

def parse_buffer_entries(content):
    """
    Parse all buffer entries from BUFFER.md
    Returns: list of dicts with entry data
    """
    entries = []
    for match in re.finditer(r'<buffer_entry>(.*?)</buffer_entry>', content, re.DOTALL):
        section = match.group(1)

        # Extract fields
        timestamp_match = re.search(r'<timestamp>(.*?)</timestamp>', section)
        entropy_match = re.search(r'<entropy>(.*?)</entropy>', section)
        referenced_match = re.search(r'<referenced_count>(.*?)</referenced_count>', section)

        entry = {
            'timestamp': timestamp_match.group(1) if timestamp_match else None,
            'entropy': entropy_match.group(1) if entropy_match else 'unknown',
            'referenced_count': int(referenced_match.group(1)) if referenced_match else 0,
            'raw_section': match.group(0)
        }

        age = calculate_entry_age(entry['timestamp'])
        entry['age_days'] = age

        entries.append(entry)

    return entries

def generate_decay_report(entries):
    """
    Generate decay risk report
    """
    print(f"\n📊 BUFFER DECAY RISK REPORT")
    print(f"{'=' * 60}")

    if not entries:
        print("No buffer entries found")
        return

    # Count by risk level
    risk_counts = {'none': 0, 'low': 0, 'high': 0, 'critical': 0, 'error': 0}

    for entry in entries:
        risk = evaluate_decay_risk(
            entry['age_days'],
            entry['entropy'],
            entry['referenced_count']
        )
        risk_counts[risk] += 1

    # Print summary
    print(f"\nRisk Distribution:")
    for risk, count in sorted(risk_counts.items()):
        if count > 0:
            print(f"  {risk.upper():12s} {count:3d} entries")

    # Print entries at risk
    high_risk = [e for e in entries if evaluate_decay_risk(
        e['age_days'], e['entropy'], e['referenced_count']
    ) in ['high', 'critical']]

    if high_risk:
        print(f"\n⚠ High-Risk Entries (may be pruned):")
        for entry in high_risk[:10]:  # Show top 10
            risk = evaluate_decay_risk(
                entry['age_days'], entry['entropy'], entry['referenced_count']
            )
            age_str = f"{entry['age_days']:.1f}d" if entry['age_days'] else "?"
            print(f"  - Age {age_str:6s} | Entropy: {entry['entropy']:6s} | Refs: {entry['referenced_count']} | Risk: {risk.upper()}")

def main():
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
    else:
        file_path = '.openclaw/core/BUFFER.md'

    print(f"🧠 BUFFER DECAY ANALYZER (Defensive)")
    print(f"   File: {file_path}")

    path = Path(file_path)
    if not path.exists():
        print(f"⚠ File not found: {file_path}")
        return

    with open(file_path, 'r') as f:
        content = f.read()

    # Parse entries
    entries = parse_buffer_entries(content)
    print(f"✓ Found {len(entries)} buffer entries")

    if not entries:
        print("\n✓ Nothing to analyze")
        return

    # Generate report
    generate_decay_report(entries)

    # Calculate pruning candidates
    pruning_candidates = []
    for entry in entries:
        should_prune, reason = should_prune_entry(entry)
        if should_prune:
            pruning_candidates.append((entry, reason))

    if pruning_candidates:
        print(f"\n✂ Pruning Candidates: {len(pruning_candidates)} entries")
        for entry, reason in pruning_candidates[:5]:
            print(f"   - {reason}")

        # Update metadata
        updated_content = re.sub(
            r'<last_purged>\[ISO-8601\]</last_purged>',
            f'<last_purged>{datetime.now().isoformat()}Z</last_purged>',
            content
        )

        if updated_content != content:
            with open(file_path, 'w') as f:
                f.write(updated_content)
            print(f"\n✓ Metadata updated: last_purged = {datetime.now().isoformat()}Z")
    else:
        print(f"\n✓ No entries need pruning")

    print(f"\n✓ Done")

if __name__ == '__main__':
    main()
