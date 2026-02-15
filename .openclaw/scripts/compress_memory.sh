#!/bin/bash
# compress_memory.sh - Memory compression tool for OpenClaw Memory Template V2.6
# Automates memory compression when MEMORY.md exceeds 50 lines

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_DIR="$(dirname "$SCRIPT_DIR")"
MEMORY_FILE="$CORE_DIR/MEMORY.md"
ARCHIVE_FILE="$CORE_DIR/../memory/ARCHIVE.md"
COMPRESSION_LOG="$CORE_DIR/COMPRESSION.md"
LINE_LIMIT=50

echo "============================================================"
echo "🗜️  Memory Compression Tool"
echo "============================================================"
echo "📁 Memory File: $MEMORY_FILE"
echo "📦 Archive File: $ARCHIVE_FILE"
echo ""

# Check if MEMORY.md exists
if [[ ! -f "$MEMORY_FILE" ]]; then
    echo "❌ MEMORY.md not found: $MEMORY_FILE"
    exit 1
fi

# Validate XML structure before compression
echo "🔍 Validating XML structure..."
echo ""

# Function to check for unclosed XML tags
validate_xml() {
    local file=$1
    local errors=0

    # Check for unclosed opening tags (simplified regex)
    local unclosed=$(grep -E '<[a-z_]+[^>]*>$' "$file" | grep -vE '</[a-z_]+>$')
    
    # Count opening vs closing tags (simplified)
    local open_tags=$(grep -oE '<[a-z_]+[^>/]*>' "$file" | wc -l)
    local close_tags=$(grep -oE '</[a-z_]+>' "$file" | wc -l)
    
    if [[ $open_tags -ne $close_tags ]]; then
        echo "❌ XML Validation Failed:"
        echo "   Opening tags: $open_tags"
        echo "   Closing tags: $close_tags"
        echo "   Mismatch detected!"
        return 1
    fi
    
    # Check for common issues
    if grep -E '<[a-z_]+[^>]*$' "$file" | grep -vE '</[a-z_]+>$' > /dev/null 2>&1; then
        echo "⚠️  Warning: Potential unclosed tags found at line ends"
        echo "   Run: grep -n '<[a-z_]+[^>]*$' $file"
        errors=$((errors + 1))
    fi
    
    if [[ $errors -eq 0 ]]; then
        echo "✅ XML Structure Valid"
        return 0
    else
        echo "⚠️  XML Warnings: $errors"
        return 0  # Don't fail on warnings, just warn
    fi
}

# Validate current file
if ! validate_xml "$MEMORY_FILE"; then
    echo ""
    echo "❌ Cannot proceed with compression: XML validation failed"
    echo "   Please fix XML structure in MEMORY.md first"
    exit 1
fi
echo ""

# Count lines
LINE_COUNT=$(wc -l < "$MEMORY_FILE")
echo "📊 Current Line Count: $LINE_COUNT"
echo "📋 Limit: $LINE_LIMIT"
echo ""

# Check if compression is needed
if [[ $LINE_COUNT -le $LINE_LIMIT ]]; then
    echo "✅ Memory is within limits. No compression needed."
    echo "   Current: $LINE_COUNT lines (Limit: $LINE_LIMIT lines)"
    exit 0
fi

echo "⚠️  Memory exceeds limit. Compression recommended."
echo ""
echo "🔄 Starting compression process..."
echo ""

# Backup current MEMORY.md
BACKUP_FILE="$CORE_DIR/MEMORY_BACKUP_$(date +%Y%m%d_%H%M%S).md"
cp "$MEMORY_FILE" "$BACKUP_FILE"
echo "💾 Backup created: $BACKUP_FILE"
echo ""

# Create archive directory
ARCHIVE_DIR="$(dirname "$ARCHIVE_FILE")"
mkdir -p "$ARCHIVE_DIR"

# Check if archive file exists, create if not
if [[ ! -f "$ARCHIVE_FILE" ]]; then
    cat > "$ARCHIVE_FILE" << 'EOF'
# memory/ARCHIVE.md - Archived Memory Entries

> **Archived:** 2026-02-15
> **Reason:** Memory compression (exceeded 50 lines)
> **Compression Method:** Automated by compress_memory.sh

---

## Archived Entries

<!-- Archived entries will be added here -->

---

## Archive Statistics

- **Entries Archived:** 0
- **Original Lines:** 0
- **Compression Date:** 2026-02-15
- **Compression Ratio:** 0%

---

## Archive Maintenance

- Keep archive for 6 months
- After 6 months, delete permanently
- Review archive before deletion
- Move any still-relevant entries back to MEMORY.md
EOF
fi

echo "📝 Compression Instructions:"
echo ""
echo "To compress MEMORY.md manually:"
echo ""
echo "1. Review MEMORY.md and identify:"
echo "   - Duplicated information"
echo "   - Outdated entries (> 90 days)"
echo "   - Low-value entries"
echo ""
echo "2. Move old entries to ARCHIVE.md"
echo ""
echo "3. Update MEMORY.md with consolidated version"
echo ""
echo "4. Document compression in COMPRESSION.md"
echo ""
echo "⚠️  AUTOMATED COMPRESSION NOT YET IMPLEMENTED"
echo "   Please run manual compression or use LLM with:"
echo "   cat $CORE_DIR/COMPRESSION.md | grep -A 100 'COMPRESSION PROMPT'"
echo ""

# Calculate what would be saved
LINES_TO_COMPRESS=$((LINE_COUNT - LINE_LIMIT))
PERCENTAGE=$((LINES_TO_COMPRESS * 100 / LINE_COUNT))

echo "============================================================"
echo "📊 Compression Summary"
echo "============================================================"
echo "Current Lines:     $LINE_COUNT"
echo "Target Lines:      $LINE_LIMIT"
echo "Lines to Remove:   $LINES_TO_COMPRESS"
echo "Potential Savings:  ${PERCENTAGE}%"
echo ""
echo "💡 Tips for Manual Compression:"
echo "   - Consolidate redundant entries"
echo "   - Remove outdated information"
echo "   - Archive old entries (keep in ARCHIVE.md)"
echo "   - Keep critical data (contacts, API keys, paths)"
echo ""
echo "📚 Reference: $COMPRESSION_LOG"
echo "============================================================"
echo ""
echo "To use LLM-assisted compression, run:"
echo "  openclaw assistant"
echo ""
echo "Then paste the compression prompt from COMPRESSION.md"
echo ""
