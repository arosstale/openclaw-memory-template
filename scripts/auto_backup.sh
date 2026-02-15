#!/bin/bash
# auto_backup.sh - Aggressive approach: Fast backup script
# Backs up core .md files with timestamp

BACKUP_DIR="backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/memory_backup_$DATE.tar.gz"

echo "📦 Quick Backup: $BACKUP_FILE"

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_FILE" .openclaw/core/*.md .openclaw/scripts/*.sh 2>/dev/null

ls -lh "$BACKUP_FILE" | awk '{print "✓ Size: " $5}'

echo "✓ Done"
