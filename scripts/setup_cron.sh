#!/bin/bash
# setup_cron.sh - Setup daily automation for research engine
# Part of OpenClaw Memory Template V2

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
FETCH_SCRIPT="$SCRIPT_DIR/fetch_papers.sh"
LOG_FILE="$REPO_DIR/research/research.log"

echo "============================================================"
echo "📅 Setup Cron Job for Research Engine"
echo "============================================================"
echo "📁 Repository: $REPO_DIR"
echo "📜 Fetch Script: $FETCH_SCRIPT"
echo "📋 Log File: $LOG_FILE"
echo ""

# Check if fetch script exists
if [[ ! -f "$FETCH_SCRIPT" ]]; then
    echo "❌ Fetch script not found: $FETCH_SCRIPT"
    exit 1
fi

# Check if script is executable
if [[ ! -x "$FETCH_SCRIPT" ]]; then
    echo "🔧 Making fetch script executable..."
    chmod +x "$FETCH_SCRIPT"
fi

# Create log directory
LOG_DIR="$(dirname "$LOG_FILE")"
mkdir -p "$LOG_DIR"

# Create cron entry
CRON_ENTRY="0 9 * * * $FETCH_SCRIPT >> $LOG_FILE 2>&1"

echo "Cron Entry to Add:"
echo "  $CRON_ENTRY"
echo ""

# Check if crontab exists
CURRENT_CRON=$(crontab -l 2>/dev/null || echo "")

# Check if cron entry already exists
if echo "$CURRENT_CRON" | grep -q "fetch_papers.sh"; then
    echo "⚠️  Cron entry already exists"
    echo ""
    echo "Current crontab:"
    echo "$CURRENT_CRON" | grep "fetch_papers.sh"
    echo ""
    echo "To remove old entry, run:"
    echo "  crontab -e"
    echo ""
    echo "Then delete the line containing 'fetch_papers.sh'"
    exit 0
fi

# Add cron entry
echo "Adding cron entry..."
(crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -

echo "✅ Cron entry added successfully!"
echo ""
echo "New crontab:"
crontab -l
echo ""
echo "============================================================"
echo "✅ Complete!"
echo "============================================================"
echo ""
echo "Next run: Tomorrow at 9:00 AM UTC"
echo "To test immediately:"
echo "  $FETCH_SCRIPT"
echo ""
echo "To edit cron:"
echo "  crontab -e"
