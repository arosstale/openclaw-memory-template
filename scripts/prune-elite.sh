#!/bin/bash
# OpenClaw V2.1 Elite - Archive Old Episodic Logs
# Archives memory/ logs older than 30 days into PostgreSQL cold-storage tier

set -e

# Configuration
POSTGRES_HOST="${1:-localhost}"
POSTGRES_PORT="${2:-5432}"
POSTGRES_DB="${3:-openclaw_elite}"
POSTGRES_USER="${4:-openclaw}"
POSTGRES_PASSWORD="${5:-changeme_in_production}"
MEMORY_DIR="${6:-./memory}"
DAYS_OLD="${7:-30}"

echo "🗄️  Elite Memory Archive - OpenClaw V2.1"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Archive logs older than: $DAYS_OLD days"
echo "Memory directory:       $MEMORY_DIR"
echo "PostgreSQL:             $POSTGRES_HOST:$POSTGRES_PORT"
echo ""

# Check if memory directory exists
if [ ! -d "$MEMORY_DIR" ]; then
    echo "❌ Memory directory not found: $MEMORY_DIR"
    exit 1
fi

# Set PGPASSWORD for psql
export PGPASSWORD="$POSTGRES_PASSWORD"

# Ensure the archived_logs table exists
echo "📋 Ensuring archived_logs table exists..."
psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -q -c "
CREATE TABLE IF NOT EXISTS archived_logs (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(255) NOT NULL UNIQUE,
    date DATE NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_archived_logs_date ON archived_logs(date);
" 2>&1

# Find and archive old logs
echo "🔍 Finding logs older than $DAYS_OLD days..."
echo ""

ARCHIVED_COUNT=0
TOTAL_SIZE=0

# Find all .md files in memory directory older than DAYS_OLD
while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    file_date=$(echo "$filename" | sed 's/memory-\(.*\)\.md/\1/')

    # Validate date format (YYYY-MM-DD)
    if ! date -d "$file_date" >/dev/null 2>&1; then
        echo "⚠️  Skipping invalid date format: $filename"
        continue
    fi

    echo "📦 Archiving: $filename"

    # Read file content
    content=$(cat "$file")

    # Insert into PostgreSQL (or update if exists)
    RESULT=$(psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -t -c "
    INSERT INTO archived_logs (filename, date, content)
    VALUES ('$filename', '$file_date', \$\$${content//$$/\\$$}\$\$)
    ON CONFLICT (filename) DO UPDATE SET
        content = EXCLUDED.content
    RETURNING 'success';
    " 2>&1)

    if [ "$RESULT" = " success" ]; then
        # Move to archived subdirectory
        mkdir -p "$MEMORY_DIR/archived"
        mv "$file" "$MEMORY_DIR/archived/$filename"

        # Calculate size
        size=$(wc -c < "$MEMORY_DIR/archived/$filename")
        TOTAL_SIZE=$((TOTAL_SIZE + size))

        ARCHIVED_COUNT=$((ARCHIVED_COUNT + 1))
        echo "   ✅ Archived to PostgreSQL"
    else
        echo "   ❌ Failed: $RESULT"
    fi

done < <(find "$MEMORY_DIR" -maxdepth 1 -name "memory-*.md" -mtime +$DAYS_OLD -print0)

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Archive Summary"
echo ""
echo "Files archived: $ARCHIVED_COUNT"
echo "Total size:     $(numfmt --to=iec $TOTAL_SIZE 2>/dev/null || echo "${TOTAL_SIZE} bytes")"
echo "Location:       PostgreSQL.archived_logs table"
echo ""

# Query archived statistics
echo "📈 Archived Statistics"
ARCHIVE_STATS=$(psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -t -c "
SELECT
    COUNT(*) as total_archives,
    MIN(date) as oldest_date,
    MAX(date) as newest_date
FROM archived_logs;
" 2>/dev/null)

if [ -n "$ARCHIVE_STATS" ]; then
    echo "$ARCHIVE_STATS"
fi

echo ""
echo "✅ Elite memory archive complete!"
echo ""
echo "💡 Notes:"
echo "  - Archived files moved to: $MEMORY_DIR/archived/"
echo "  - All content remains searchable via PostgreSQL"
echo "  - Use QMD for current (last 30 days) logs"
echo "  - Use PostgreSQL for historical logs"

# Unset password
unset PGPASSWORD
