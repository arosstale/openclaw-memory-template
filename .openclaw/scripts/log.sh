#!/bin/bash

# OpenClaw Daily Logging Script
# Creates or appends to daily log entries

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$SCRIPT_DIR")"
MEMORY_DIR="$WORKSPACE/memory"
TODAY=$(date +%Y-%m-%d)
DAILY_LOG="$MEMORY_DIR/daily/$TODAY.md"
TEMPLATE="$WORKSPACE/templates/daily-log.md"

# Check if templates exist
if [ ! -f "$TEMPLATE" ]; then
    echo "⚠️  Template not found at $TEMPLATE"
    echo "Creating minimal template..."
    mkdir -p "$(dirname "$TEMPLATE")"
    cat > "$TEMPLATE" << 'EOF'
---
date: {{DATE}}
session_start: {{SESSION_START}}
session_end: {{SESSION_END}}
projects: []

# Session
## Active Projects
- 
## Tasks Completed
- 
## Blockers
-

## Learnings
- 

## Decisions
- 

## Next Steps
-
EOF
fi

# Check if daily log exists
if [ ! -f "$DAILY_LOG" ]; then
    echo "📝 Creating new daily log: $TODAY"
    mkdir -p "$(dirname "$DAILY_LOG")"
    
    # Create from template
    sed -e "s/{{DATE}}/$TODAY/" \
        -e "s/{{SESSION_START}}/$(date +%H:%M:%S)/" \
        -e "s/{{SESSION_END}}//" \
        "$TEMPLATE" > "$DAILY_LOG"
    
    echo "✓ Created daily log at $DAILY_LOG"
else
    echo "📝 Appending to existing daily log: $TODAY"
    
    # Add session marker
    echo -e "\n---\n## Session ($(date +%H:%M:%S))\n" >> "$DAILY_LOG"
    echo "## Active Projects" >> "$DAILY_LOG"
    echo "- (Active projects will be logged here)" >> "$DAILY_LOG"
    echo "" >> "$DAILY_LOG"
fi

echo "✓ Daily log ready at $DAILY_LOG"
