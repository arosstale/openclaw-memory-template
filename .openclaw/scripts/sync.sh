#!/bin/bash

# OpenClaw Memory Synchronization Script (Enhanced)
# Syncs local memory with remote Git repository using git-notes
# Commits: "Update daily log [YYYY-MM-DD]" + Git Notes metadata for clean history

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$SCRIPT_DIR")"
MEMORY_DIR="$WORKSPACE/memory"
GIT_REMOTE="${GIT_REMOTE:-origin/main}"

echo "🔄 Memory Sync: Starting..."

# Check if memory is a Git repo
if [ ! -d "$MEMORY_DIR/.git" ]; then
    echo "⚠️  Memory is not a Git repo. Initialize..."
    cd "$MEMORY_DIR" || exit 1
    git init
    git remote add origin "$GIT_REMOTE" 2>/dev/null
    echo "✓ Git repo initialized"
fi

# Pull latest changes
cd "$MEMORY_DIR" || exit 1
echo "📥 Pulling latest from remote..."
git pull --rebase "$GIT_REMOTE" 2>/dev/null

# Stage all changes
echo "📝 Staging changes..."
git add .

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "✓ No changes to commit"
    exit 0
fi

# Daily log path
DAILY_LOG="$MEMORY_DIR/daily/$(date +%Y-%m-%d).md"

# Extract session summary from daily log (for commit message)
SESSION_SUMMARY=$(cat "$DAILY_LOG" 2>/dev/null | grep -A 10 "## Session" | head -20 | sed 's/^## Session//' | sed 's/^#.*//' | head -1)

# Build commit message
COMMIT_MSG="Update daily log $(date +%Y-%m-%d)"

# Get current session info
CURRENT_SESSION_START=$(date +%Y-%m-%dT%H:%M:%S)
SESSION_HEADER="Session: $CURRENT_SESSION_START"

echo "📊 Session Info:"
echo "   Daily Log: $DAILY_LOG"
echo "   Session Start: $CURRENT_SESSION_START"

# Prepare git-notes metadata
METADATA_JSON=$(cat << 'EOF'
{
  "title": "$COMMIT_MSG",
  "description": "$SESSION_HEADER",
  "type": "daily-log",
  "date": "$(date +%Y-%m-%d)",
  "session_start": "$CURRENT_SESSION_START",
  "project_context": "OpenClaw V2 Self-Evolution",
  "source": "Pi-Agent",
  "session_summary": "$SESSION_SUMMARY"
}
EOF
)

# Commit with git-notes metadata
echo "💾 Committing with git-notes metadata..."
git commit -m "$COMMIT_MSG" -m "metadata_json=$METADATA_JSON"

# Push changes
echo "📤 Pushing to remote..."
git push "$GIT_REMOTE" 2>/dev/null

echo "✅ Memory sync complete!"
echo ""
echo "💡 Tip: Use 'git log --notes' to see all stored metadata"
