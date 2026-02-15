#!/bin/bash
# validate_xml.sh - Automated ID uniqueness and XML validation
# G006 IMPLEMENTED: Metadata validation for FOR_THE_FUTURE.md

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
    FILES=$(find . -name "*.md" -type f | grep -E "(MEMORY|CONSOLIDATED_WISDOM|FRICTION_POINTS|EVOLUTION|REFLECTIONS|SHARED_VALUES|FOR_THE_FUTURE)" | sort)
fi

echo -e "${GREEN}=== OpenClaw XML Validation ===${NC}"
echo ""

for file in $FILES; do
    echo -e "${YELLOW}Validating: $file${NC}"
    
    # Extract all IDs from: file (before duplicate check)
    WISDOM_IDS=$(grep -oE 'id="W[0-9]{3}"' "$file" | sed 's/id="//g' || true)
    FRICTION_IDS=$(grep -oE 'id="F[0-9]{3}"' "$file" | sed 's/id="//g' || true)
    # Extract goal IDs specifically for this file
    if [[ "$file" == *"FOR_THE_FUTURE.md"* ]]; then
        mapfile -t GOAL_IDS < <(grep -oE 'id="G[0-9]{3}"' "$file" | sed 's/id="//g')
    else
        GOAL_IDS=""
    fi
    REFLECTION_IDS=$(grep -oE 'id="R[0-9]{3}"' "$file" | sed 's/id="//g' || true)
    
    # Check for duplicates within each type
    for prefix in "W" "F" "G" "R"; do
        case $prefix in
            W)
                IDS=("${WISDOM_IDS[@]}")
                TYPE="wisdom"
                ;;
            F)
                IDS=("${FRICTION_IDS[@]}")
                TYPE="friction"
                ;;
            G)
                IDS=("${GOAL_IDS[@]}")
                TYPE="goal"
                ;;
            R)
                IDS=("${REFLECTION_IDS[@]}")
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
    
    # G006: Metadata validation for FOR_THE_FUTURE.md
    # Check if actual goal count matches metadata active_goals count
    if [[ "$file" == *"FOR_THE_FUTURE.md"* ]]; then
        # Count only ACTIVE goals (state="active"), not all goals
        GOAL_COUNT=$(grep -c '<state>active</state>' "$file")
        # Extract active_goals count from metadata section (opening tag only)
        METADATA_GOALS=$(grep -oE '<active_goals>[0-9]+' "$file" | head -1 | grep -oE '[0-9]+' | head -1)
        
        if [ "$GOAL_COUNT" != "$METADATA_GOALS" ]; then
            ERRORS_FOUND=$((ERRORS_FOUND + 1))
            METADATA_LINE=$(grep -n '<active_goals>' "$file" | cut -d: -f1)
            ERROR_DETAILS+=("$file: Metadata drift - Found $GOAL_COUNT active goals but active_goals=$METADATA_GOALS at line $METADATA_LINE")
            echo -e "  ${RED}✗ Metadata drift in $file${NC}"
            echo -e "    Actual goals: $GOAL_COUNT, Metadata says: $METADATA_GOALS"
        fi
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
