#!/bin/bash
# validate_xml.sh - Automated ID uniqueness and XML validation
# Purpose: Prevent duplicate IDs and malformed XML in memory files
# Usage: ./validate_xml.sh [file_path] or runs on all XML files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track errors
ERRORS_FOUND=0
ERROR_DETAILS=()

# Files to validate
if [ -n "$1" ]; then
    FILES="$1"
else
    FILES=$(find . -name "*.md" -type f | grep -E "(MEMORY|CONSOLIDATED_WISDOM|FRICTION_POINTS|EVOLUTION|REFLECTIONS|SHARED_VALUES)" | sort)
fi

echo -e "${GREEN}=== OpenClaw XML Validation ===${NC}"
echo ""

for file in $FILES; do
    echo -e "${YELLOW}Validating: $file${NC}"
    
    # Extract all IDs from the file
    WISDOM_IDS=$(grep -oE 'id="W[0-9]{3}"' "$file" | sed 's/id="//g' || true)
    FRICTION_IDS=$(grep -oE 'id="F[0-9]{3}"' "$file" | sed 's/id="//g' || true)
    GOAL_IDS=$(grep -oE 'id="G[0-9]{3}"' "$file" | sed 's/id="//g' || true)
    REFLECTION_IDS=$(grep -oE 'id="R[0-9]{3}"' "$file" | sed 's/id="//g' || true)
    
    # Check for duplicates within each type
    for prefix in "W" "F" "G" "R"; do
        case $prefix in
            W)
                IDS=($WISDOM_IDS)
                TYPE="wisdom"
                ;;
            F)
                IDS=($FRICTION_IDS)
                TYPE="friction"
                ;;
            G)
                IDS=($GOAL_IDS)
                TYPE="goal"
                ;;
            R)
                IDS=($REFLECTION_IDS)
                TYPE="reflection"
                ;;
        esac
        
        if [ ${#IDS[@]} -gt 0 ]; then
            # Check for duplicates
            UNIQUE_IDS=$(printf "%s\n" "${IDS[@]}" | sort -u)
            DUPLICATE_COUNT=$((${#IDS[@]} - $(echo "$UNIQUE_IDS" | wc -l)))
            
            if [ $DUPLICATE_COUNT -gt 0 ]; then
                ERRORS_FOUND=$((ERRORS_FOUND + 1))
                echo -e "  ${RED}✗ Duplicate $TYPE IDs found in $file${NC}"
                
                # Find and report duplicates with line numbers
                DUPLICATES=$(printf "%s\n" "${IDS[@]}" | sort | uniq -d)
                for dup in $DUPLICATES; do
                    LINE_NUM=$(grep -n "id=\"$dup\"" "$file" | cut -d: -f1 | head -1)
                    ERROR_DETAILS+=("$file: Duplicate $type ID $dup at line $LINE_NUM")
                done
            fi
        fi
    done
    
    # Check for unclosed tags (basic validation)
    # Count opening and closing tags for major XML elements
    # Pattern: <tag followed by space or > (to avoid matching <tag> in <tag_name>)
    OPEN_TAGS=$(grep -cE '<(wisdom|friction_point|evolutionary_goal|memory_entry|reflection)[ >]' "$file" || true)
    CLOSE_TAGS=$(grep -cE '</(wisdom|friction_point|evolutionary_goal|memory_entry|reflection)>' "$file" || true)
    
    if [ "$OPEN_TAGS" != "$CLOSE_TAGS" ]; then
        ERRORS_FOUND=$((ERRORS_FOUND + 1))
        LINE_NUM=$(grep -nE '<(wisdom|friction_point|evolutionary_goal|memory_entry|reflection)' "$file" | tail -1 | cut -d: -f1)
        ERROR_DETAILS+=("$file: Unclosed XML tags (opening: $OPEN_TAGS, closing: $CLOSE_TAGS), check around line $LINE_NUM")
        echo -e "  ${RED}✗ Unclosed XML tags in $file${NC}"
        echo -e "    Opening tags: $OPEN_TAGS, Closing tags: $CLOSE_TAGS"
    fi
done

echo ""

# Summary
if [ $ERRORS_FOUND -eq 0 ]; then
    echo -e "${GREEN}✓ All validations passed!${NC}"
    echo -e "${GREEN}✓ No duplicate IDs found${NC}"
    echo -e "${GREEN}✓ XML structure is valid${NC}"
    exit 0
else
    echo -e "${RED}✗ Validation failed with $ERRORS_FOUND error(s)${NC}"
    echo ""
    echo -e "${YELLOW}Error Details:${NC}"
    for error in "${ERROR_DETAILS[@]}"; do
        echo -e "  ${RED}• $error${NC}"
    done
    echo ""
    echo -e "${YELLOW}Please fix the above errors before committing.${NC}"
    exit 1
fi
