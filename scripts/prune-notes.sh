#!/bin/bash
# OpenClaw V2.1 Elite - Git Notes Pruning Script
# Archives Git Notes older than 30 days into PostgreSQL tier

set -e

# Configuration
WORKSPACE="${1:-$(pwd)}"
DAYS_THRESHOLD="${2:-30}"
POSTGRES_HOST="${3:-localhost}"
POSTGRES_PORT="${4:-5432}"
POSTGRES_DB="${5:-openclaw}"
POSTGRES_USER="${6:-openclaw}"

echo "🧹 Git Notes Pruning - OpenClaw V2.1 Elite"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Workspace: $WORKSPACE"
echo "Threshold: $DAYS_THRESHOLD days"
echo ""

cd "$WORKSPACE"

# Check if PostgreSQL is available
if ! command -v psql &> /dev/null; then
    echo "❌ psql not found. Installing PostgreSQL client..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq postgresql-client
fi

# Create archive table if it doesn't exist
echo "📦 Creating archive table in PostgreSQL..."
psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -q -c "
CREATE TABLE IF NOT EXISTS git_notes_archive (
    id SERIAL PRIMARY KEY,
    note_hash TEXT NOT NULL UNIQUE,
    note_content TEXT,
    note_date TIMESTAMP,
    archived_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    note_message TEXT
);
CREATE INDEX IF NOT EXISTS idx_git_notes_archive_date ON git_notes_archive(note_date);
" 2>/dev/null || echo "⚠️  PostgreSQL not available, skipping DB archiving"

# Get list of Git Notes to prune
echo "📋 Collecting Git Notes older than $DAYS_THRESHOLD days..."
CUTOFF_DATE=$(date -d "$DAYS_THRESHOLD days ago" +%s)

# Get all notes with their dates
NOTES_TO_PRUNE=$(git notes list | while read commit_ref; do
    NOTE_DATE=$(git log -1 --format=%ct "$commit_ref" 2>/dev/null || echo "0")
    if [ "$NOTE_DATE" -lt "$CUTOFF_DATE" ]; then
        echo "$commit_ref"
    fi
done)

NOTE_COUNT=$(echo "$NOTES_TO_PRUNE" | grep -c "^" 2>/dev/null || echo "0")

echo "Found $NOTE_COUNT notes to prune"

if [ "$NOTE_COUNT" -eq 0 ]; then
    echo "✅ No notes need pruning. Exiting."
    exit 0
fi

# Archive each note to PostgreSQL
echo "🗄️  Archiving notes to PostgreSQL..."
ARCHIVED_COUNT=0
SKIPPED_COUNT=0

echo "$NOTES_TO_PRUNE" | while read commit_ref; do
    if [ -z "$commit_ref" ]; then
        continue
    fi

    NOTE_HASH=$(echo "$commit_ref" | sha1sum | cut -d' ' -f1)
    NOTE_CONTENT=$(git notes show "$commit_ref" 2>/dev/null || echo "")
    NOTE_MESSAGE=$(git log -1 --format=%s "$commit_ref" 2>/dev/null || echo "Unknown")
    NOTE_TIMESTAMP=$(git log -1 --format=%ct "$commit_ref" 2>/dev/null || echo "0")
    NOTE_DATE=$(date -d "@$NOTE_TIMESTAMP" -Iseconds 2>/dev/null || echo "1970-01-01")

    # Archive to PostgreSQL
    if psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -q -c "
        INSERT INTO git_notes_archive (note_hash, note_content, note_date, note_message)
        VALUES ('$NOTE_HASH', $(psql -c "SELECT quote_literal(\$1)" -- "$NOTE_CONTENT" -t 2>/dev/null || echo "'$NOTE_CONTENT'"), '$NOTE_DATE', '$NOTE_MESSAGE')
        ON CONFLICT (note_hash) DO NOTHING;
    " 2>/dev/null; then
        echo "✅ Archived: $commit_ref"
        ARCHIVED_COUNT=$((ARCHIVED_COUNT + 1))
    else
        echo "⚠️  Skipped: $commit_ref (PostgreSQL unavailable or duplicate)"
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
    fi

    # Remove the note from Git
    git notes remove "$commit_ref" 2>/dev/null || true
done

# Clean up old Git Notes references
echo "🧹 Cleaning up Git Notes references..."
git gc --prune=now --aggressive 2>/dev/null || true

# Calculate repo size before/after
echo ""
echo "📊 Repository Statistics:"
BEFORE_SIZE=$(du -sh .git | cut -f1)
AFTER_SIZE=$(du -sh .git | cut -f1)
echo "Before: $BEFORE_SIZE"
echo "After:  $AFTER_SIZE"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Git Notes Pruning Complete!"
echo "Archived: $ARCHIVED_COUNT notes"
echo "Skipped: $SKIPPED_COUNT notes"
echo "Threshold: $DAYS_THRESHOLD days"
echo ""
echo "💡 Tip: Run this weekly via cron: 0 0 * * 0 /path/to/prune-notes.sh"
