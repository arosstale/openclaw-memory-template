#!/bin/bash

# OpenClaw Memory Status Script
# Shows memory statistics and recent logs

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$SCRIPT_DIR")"
MEMORY_DIR="$WORKSPACE/memory"

echo "🧠 OpenClaw Memory Status"
echo "======================================"
echo ""

# Git status
if [ -d "$MEMORY_DIR/.git" ]; then
    cd "$MEMORY_DIR"
    GIT_STATUS=$(git status --short)
    REMOTE=$(git remote get-url origin 2>/dev/null || echo "none")
    
    echo "📊 Git Repository"
    echo "Remote: $REMOTE"
    echo "Status: $GIT_STATUS"
    echo ""
    
    # Recent commits
    echo "📜 Recent Commits (last 5):"
    git log --oneline -5 --graph --all
else
    echo "📊 Git Repository: Not initialized"
fi

echo ""

# Log statistics
echo "📝 Daily Logs:"
if [ -d "$MEMORY_DIR/daily" ]; then
    LOG_COUNT=$(ls -1 "$MEMORY_DIR/daily/"*.md 2>/dev/null | wc -l)
    TOTAL_WORDS=$(wc -w "$MEMORY_DIR/daily/"*.md 2>/dev/null | tail -1)
    LATEST_LOG=$(ls -t "$MEMORY_DIR/daily/"*.md 2>/dev/null | head -1 | xargs basename)
    
    echo "Total logs: $LOG_COUNT"
    echo "Latest: $LATEST_LOG"
    echo "Total words: $TOTAL_WORDS"
else
    echo "No daily logs found"
fi

echo ""

# Memory index
echo "📚 Memory Files:"
if [ -f "$MEMORY_DIR/index.md" ]; then
    FILES_COUNT=$(grep -c "^#" "$MEMORY_DIR/index.md" 2>/dev/null || echo "0")
    echo "Index entries: $FILES_COUNT"
else
    echo "No index found"
fi

echo ""

# Usage tip
echo "💡 Usage:"
echo "  Run log script:  .openclaw/scripts/log.sh"
echo "  Sync with remote:  .openclaw/scripts/sync.sh"
echo "  Status: .openclaw/scripts/status.sh"
