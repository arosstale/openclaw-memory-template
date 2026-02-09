#!/bin/bash

# Thermal Monitoring Daemon Fix
# Ensures the thermal monitoring daemon is running and logging correctly

set -e

LOG_FILE="/tmp/pi_thermal_monitor.log"
DAEMON_NAME="thermal_monitor.py"
DAEMON_DIR="/home/majinbu/pi-mono-workspace/monitoring"

echo "🌡️ Thermal Monitor Fix Script"
echo "================================"

# Check if daemon file exists
if [ ! -f "$DAEMON_DIR/$DAEMON_NAME" ]; then
    echo "⚠️  Daemon script not found at $DAEMON_DIR/$DAEMON_NAME"
    echo "Looking for thermal monitoring setup..."
    ls -la "$DAEMON_DIR"
    exit 1
fi

# Check if daemon is running
DAEMON_PID=$(pgrep -f "$DAEMON_NAME" | awk '{print $1}')

if [ -n "$DAEMON_PID" ]; then
    echo "✅ Daemon is running (PID: $DAEMON_PID)"
    
    # Check if it's logging
    if [ -f "$LOG_FILE" ]; then
        LOG_SIZE=$(stat -c %s "$LOG_FILE" 2>/dev/null || echo "0")
        LOG_MTIME=$(stat -c %Y "$LOG_FILE" 2>/dev/null || echo "0")
        NOW=$(date +%s)
        AGE=$((NOW - LOG_MTIME))
        
        echo "📊 Log file: $LOG_FILE"
        echo "   Size: $LOG_SIZE bytes"
        echo "   Last modified: $AGE seconds ago"
        
        if [ $AGE -gt 3600 ]; then
            echo "⚠️  Warning: Log hasn't been updated in 1+ hours"
            echo "   Daemon may not be writing to expected location"
        else
            echo "✓ Log is recent and active"
        fi
    else
        echo "⚠️  Log file not found at $LOG_FILE"
        echo "   Expected: $LOG_FILE"
        echo "   Daemon may be logging elsewhere"
    fi
else
    echo "❌ Daemon is NOT running"
    echo "   Starting daemon..."
    
    # Start daemon in background
    nohup python3 "$DAEMON_DIR/$DAEMON_NAME" > /dev/null 2>&1 &
    NEW_PID=$!
    
    sleep 2
    
    # Verify it started
    if pgrep -f "$DAEMON_NAME" > /dev/null; then
        echo "✅ Daemon started successfully (PID: $NEW_PID)"
    else
        echo "❌ Failed to start daemon"
        echo "   Check daemon logs for errors"
        exit 1
    fi
fi

# Show current thermal status
echo ""
echo "🌡️ Current Thermal Status:"
if [ -f "$LOG_FILE" ]; then
    echo "Most recent reading:"
    tail -5 "$LOG_FILE"
else
    echo "No log file at $LOG_FILE"
fi

echo ""
echo "💡 Tips:"
echo "  - Use 'systemctl status' to check systemd services"
echo "  - Use 'journalctl -u \$USER' to view logs"
echo "  - Run '.openclaw/scripts/status.sh' to check memory system status"
