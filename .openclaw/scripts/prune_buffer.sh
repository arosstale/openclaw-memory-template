#!/bin/bash
# prune_buffer.sh - BUFFER.md evaporation protocol
# Purpose: Automatically remove low-value logs from BUFFER.md after they've been distilled
# Usage: ./prune_buffer.sh [--dry-run] [--min-age-days=7]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default values
MIN_AGE_DAYS=7
DRY_RUN=false
PRUNED_COUNT=0
KEPT_COUNT=0

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --min-age-days=*)
            MIN_AGE_DAYS="${1#*=}"
            shift
            ;;
        *)
            echo "Usage: $0 [--dry-run] [--min-age-days=N]"
            echo "  --dry-run: Show what would be deleted without deleting"
            echo "  --min-age-days: Only prune entries older than N days (default: 7)"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}=== BUFFER.md EVAPORATION PROTOCOL ===${NC}"
echo ""
echo -e "${YELLOW}Configuration:${NC}"
echo "  Minimum age: $MIN_AGE_DAYS days"
echo "  Dry run: $DRY_RUN"
echo ""

BUFFER_FILE=".openclaw/core/BUFFER.md"

if [ ! -f "$BUFFER_FILE" ]; then
    echo -e "${RED}✗ BUFFER.md not found${NC}"
    exit 1
fi

# Extract BUFFER.md entries (assuming markdown with date headers)
# Pattern: ## [YYYY-MM-DD] or ### [HH:MM]
CURRENT_DATE=$(date +%Y-%m-%d)
MIN_DATE=$(date -d "$MIN_AGE_DAYS days ago" +%Y-%m-%d)

echo -e "${YELLOW}Analyzing BUFFER.md...${NC}"
echo ""

# Read BUFFER.md and analyze entries
ENTRY_COUNT=0
OLD_ENTRY_COUNT=0
RECENT_ENTRY_COUNT=0

while IFS= read -r line; do
    # Check for date headers
    if [[ $line =~ ^##\s+\[([0-9]{4}-[0-9]{2}-[0-9]{2})\] ]]; then
        ENTRY_DATE="${BASH_REMATCH[1]}"
        ENTRY_COUNT=$((ENTRY_COUNT + 1))
        
        # Check if entry is old enough to prune
        if [[ "$ENTRY_DATE" < "$MIN_DATE" ]]; then
            OLD_ENTRY_COUNT=$((OLD_ENTRY_COUNT + 1))
            if [ "$DRY_RUN" = false ]; then
                echo -e "${RED}✗ Would prune: [$ENTRY_DATE]${NC}"
            fi
        else
            RECENT_ENTRY_COUNT=$((RECENT_ENTRY_COUNT + 1))
            if [ "$DRY_RUN" = false ]; then
                echo -e "${GREEN}✓ Keeping: [$ENTRY_DATE]${NC}"
            fi
        fi
    fi
done < "$BUFFER_FILE"

echo ""
echo -e "${YELLOW}Summary:${NC}"
echo "  Total entries: $ENTRY_COUNT"
echo "  Old enough to prune: $OLD_ENTRY_COUNT"
echo "  Recent entries (keeping): $RECENT_ENTRY_COUNT"
echo ""

# If not dry run, perform actual pruning
if [ "$DRY_RUN" = false ] && [ $OLD_ENTRY_COUNT -gt 0 ]; then
    echo -e "${YELLOW}Performing evaporation...${NC}"
    
    # Create backup
    BACKUP_FILE="$BUFFER_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$BUFFER_FILE" "$BACKUP_FILE"
    echo -e "${GREEN}✓ Backup created: $BACKUP_FILE${NC}"
    
    # Remove old entries
    TEMP_FILE=$(mktemp)
    awk -v min_date="$MIN_DATE" '
        /^## \[/ && $2 < min_date {
            # Skip this entry
            if (!skip) {
                skip = 1
            }
        }
        skip && /^## \[/ {
            # Start including again
            skip = 0
        }
        !skip { print }
    ' "$BUFFER_FILE" > "$TEMP_FILE"
    
    mv "$TEMP_FILE" "$BUFFER_FILE"
    echo -e "${GREEN}✓ Evaporation complete${NC}"
    echo ""
    echo -e "${BLUE}=== BUFFER.md Evaporated ===${NC}"
    PRUNED_COUNT=$OLD_ENTRY_COUNT
    KEPT_COUNT=$RECENT_ENTRY_COUNT
fi

echo ""
echo -e "${GREEN}✓ Pruning protocol complete${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Review backup: $BACKUP_FILE"
echo "  2. Check if any old entries should be distilled to CONSOLIDATED_WISDOM.md"
echo "  3. Update EVOLUTION.md with patterns from pruned entries"

echo ""
echo -e "${BLUE}Integration with EVOLUTION.md:${NC}"
echo "  Evaporated BUFFER entries should trigger EVOLUTION.md pattern updates:"
echo "  - If multiple similar errors → Create technical truth"
echo "  - If human preference pattern → Create life lesson"
echo "  - If phase-specific pattern → Create temporal insight"
