#!/usr/bin/env python3
"""
validate_friction_stats.py - Defensive approach to validate FRICTION_POINTS.md
Checks friction counts, validates metadata, ensures statistics are accurate
"""

import re
import sys
from datetime import datetime
from collections import Counter, defaultdict

def parse_friction_points(file_path):
    """
    Parse FRICTION_POINTS.md and extract all friction points
    Returns: list of dicts with friction point data
    """
    with open(file_path, 'r') as f:
        content = f.read()

    friction_points = []
    for match in re.finditer(r'<friction_point id="(F\d{3})">', content):
        friction_id = match.group(1)
        # Extract section for this friction point
        section_start = match.start()
        section_end = content.find('</friction_point>', section_start)
        if section_end == -1:
            print(f"⚠ Warning: Unclosed friction point {friction_id}")
            continue

        section = content[section_start:section_end]

        # Extract type
        type_match = re.search(r'<type>(.*?)</type>', section)
        friction_type = type_match.group(1) if type_match else "Unknown"

        # Extract severity
        severity_match = re.search(r'<severity>(.*?)</severity>', section)
        severity = severity_match.group(1) if severity_match else "Unknown"

        # Extract healed status
        healed_match = re.search(r'<healed>(.*?)</healed>', section)
        healed = healed_match.group(1).lower() == 'true' if healed_match else False

        friction_points.append({
            'id': friction_id,
            'type': friction_type,
            'severity': severity,
            'healed': healed
        })

    return friction_points

def validate_statistics(friction_points, content):
    """
    Validate the statistics table in FRICTION_POINTS.md
    Returns: list of discrepancies found
    """
    discrepancies = []

    # Count by type
    type_counts = defaultdict(int)
    healed_counts = defaultdict(int)
    severity_by_type = defaultdict(list)

    for fp in friction_points:
        type_counts[fp['type']] += 1
        if fp['healed']:
            healed_counts[fp['type']] += 1
        severity_by_type[fp['type']].append(fp['severity'])

    # Extract statistics table from content
    stats_match = re.search(r'\|\s*\*\*Total\*\*\s*\|\s*(\d+)\s*\|', content)
    if not stats_match:
        discrepancies.append("Could not find Total in statistics table")
    else:
        reported_total = int(stats_match.group(1))
        actual_total = len(friction_points)
        if reported_total != actual_total:
            discrepancies.append(
                f"Total count mismatch: Reported {reported_total}, Actual {actual_total}"
            )

    # Check individual type counts
    for friction_type in type_counts:
        type_match = re.search(
            rf'\|\s*\*\*{friction_type}\*\*\s*\|\s*(\d+)\s*\|',
            content
        )
        if type_match:
            reported = int(type_match.group(1))
            actual = type_counts[friction_type]
            if reported != actual:
                discrepancies.append(
                    f"{friction_type} count mismatch: Reported {reported}, Actual {actual}"
                )
        else:
            discrepancies.append(f"{friction_type} not found in statistics table")

    return discrepancies, type_counts, healed_counts, severity_by_type

def generate_corrected_stats(type_counts, healed_counts, severity_by_type):
    """
    Generate corrected statistics table
    """
    lines = []
    lines.append("| Type | Count | Severity Avg | Healed |")
    lines.append("|------|--------|--------------|---------|")

    all_types = list(type_counts.keys())
    all_types.sort()

    total_count = 0
    total_healed = 0
    all_severities = []

    for friction_type in all_types:
        count = type_counts[friction_type]
        healed = healed_counts[friction_type]
        severities = severity_by_type[friction_type]

        total_count += count
        total_healed += healed
        all_severities.extend(severities)

        # Calculate avg severity
        severity_map = {'low': 1, 'medium': 2, 'high': 3}
        severity_nums = [severity_map.get(s, 2) for s in severities]
        avg_severity_num = sum(severity_nums) / len(severity_nums) if severity_nums else 2

        if avg_severity_num <= 1.5:
            avg_severity = 'Low'
        elif avg_severity_num <= 2.5:
            avg_severity = 'Medium'
        else:
            avg_severity = 'High'

        lines.append(f"| **{friction_type}** | {count} | {avg_severity} | {healed} |")

    # Total row
    total_healing_rate = (total_healed / total_count * 100) if total_count > 0 else 0
    total_severity_nums = []
    severity_map = {'low': 1, 'medium': 2, 'high': 3, 'Low': 1, 'Medium': 2, 'High': 3}
    for severities in severity_by_type.values():
        total_severity_nums.extend([severity_map.get(s, 2) for s in severities])

    if total_severity_nums:
        total_avg_severity_num = sum(total_severity_nums) / len(total_severity_nums)
        if total_avg_severity_num <= 1.5:
            total_avg_severity = 'Low'
        elif total_avg_severity_num <= 2.5:
            total_avg_severity = 'Medium'
        else:
            total_avg_severity = 'High'
    else:
        total_avg_severity = 'N/A'

    lines.append(f"| **Total** | {total_count} | {total_avg_severity} | {total_healed} |")
    lines.append("")
    lines.append(f"**Healing Rate:** {total_healing_rate:.0f}% ({total_healed}/{total_count})")

    return '\n'.join(lines)

def update_metadata(content, total_count):
    """
    Update metadata section with correct values
    """
    # Update healing_rate
    healing_rate_match = re.search(r'<healing_rate>(\d+)%</healing_rate>', content)
    if healing_rate_match:
        # Recalculate healing rate
        healed_count = len(re.findall(r'<healed>true</healed>', content))
        new_rate = int(healed_count / total_count * 100) if total_count > 0 else 0
        content = re.sub(
            r'<healing_rate>\d+%</healing_rate>',
            f'<healing_rate>{new_rate}%</healing_rate>',
            content
        )

    # Update last_updated
    content = re.sub(
        r'<last_updated>\[ISO-8601\]</last_updated>',
        f'<last_updated>{datetime.now().isoformat()}Z</last_updated>',
        content
    )

    return content

def main():
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
    else:
        file_path = '.openclaw/core/FRICTION_POINTS.md'

    print(f"🔍 FRICTION POINTS VALIDATOR (Defensive)")
    print(f"   File: {file_path}\n")

    # Parse friction points
    friction_points = parse_friction_points(file_path)
    print(f"✓ Found {len(friction_points)} friction points")

    with open(file_path, 'r') as f:
        content = f.read()

    # Validate statistics
    discrepancies, type_counts, healed_counts, severity_by_type = validate_statistics(
        friction_points, content
    )

    if discrepancies:
        print(f"\n⚠ Found {len(discrepancies)} discrepancies:")
        for d in discrepancies:
            print(f"   - {d}")
    else:
        print("\n✓ All statistics are correct")

    # Generate corrected stats table
    print(f"\n📊 Corrected Statistics Table:")
    corrected_stats = generate_corrected_stats(type_counts, healed_counts, severity_by_type)
    print(corrected_stats)

    # Update metadata
    updated_content = update_metadata(content, len(friction_points))

    if updated_content != content:
        print(f"\n✓ Metadata updated")
        # Write back to file
        with open(file_path, 'w') as f:
            f.write(updated_content)
        print(f"✓ File updated: {file_path}")
    else:
        print(f"\n✓ Metadata already up to date")

    print(f"\n✓ Done")

if __name__ == '__main__':
    main()
