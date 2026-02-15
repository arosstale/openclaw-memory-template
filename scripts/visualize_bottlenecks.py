#!/usr/bin/env python3
"""
visualize_bottlenecks.py - Fast ASCII histogram of REFLECTIONS.md patterns
Aggressive approach: Speed-first, minimal validation, just works
"""

import re
import sys
from collections import Counter

def parse_reflections(file_path):
    """Extract patterns from REFLECTIONS.md"""
    with open(file_path, 'r') as f:
        content = f.read()

    # Extract friction_points and types
    friction_ids = re.findall(r'<friction_id>(F\d{3})</friction_id>', content)
    types = re.findall(r'<type>(.*?)</type>', content)
    
    # Extract patterns from reflections
    patterns = []
    for match in re.finditer(r'<reflection>', content):
        section = content[match.end():content.find('</reflection>', match.end())]
        # Extract habit IDs, friction IDs, etc.
        patterns.extend(re.findall(r'<friction_id>(F\d{3})</friction_id>', section))
        patterns.extend(re.findall(r'habit id="(H\d{3})"', section))
        patterns.extend(re.findall(r'<type>(\w+)</type>', section))
    
    return friction_ids, types, patterns

def print_histogram(data, title, top_n=5):
    """Print ASCII bar chart"""
    if not data:
        print(f"\n{title}: No data found")
        return
    
    counter = Counter(data)
    top_items = counter.most_common(top_n)
    
    print(f"\n{title}:")
    max_count = top_items[0][1] if top_items else 0
    
    for item, count in top_items:
        bar_len = int(count / max_count * 30) if max_count > 0 else 0
        bar = '█' * bar_len
        print(f"  {item:15s} {bar} ({count})")

def main():
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
    else:
        file_path = '.openclaw/core/REFLECTIONS.md'
    
    print(f"📊 REFLECTIONS MD BOTTLENECK ANALYZER")
    print(f"   File: {file_path}")
    
    friction_ids, types, patterns = parse_reflections(file_path)
    
    # Print top 5 friction points
    if friction_ids:
        print_histogram(friction_ids, "Top 5 Friction Points")
    
    # Print top 5 types
    if types:
        print_histogram(types, "Top 5 Types")
    
    # Print top 5 patterns
    if patterns:
        print_histogram(patterns, "Top 5 Recurring Patterns")
    
    print(f"\n✓ Done")

if __name__ == '__main__':
    main()
