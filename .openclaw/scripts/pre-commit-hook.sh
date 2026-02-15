#!/bin/bash
# Pre-commit hook for OpenClaw Memory Template
# Runs XML validation before allowing commits
# To install: ln -s .git/hooks/pre-commit .openclaw/scripts/pre-commit-hook.sh

# Get list of files being committed
FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.md$' || true)

# Validate specific core files + any modified .md files
if [ -f ".openclaw/scripts/validate_xml.sh" ]; then
    echo -e "\033[0;36mRunning XML validation on committed files...\033[0m"
    
    # Always validate core files
    ./.openclaw/scripts/validate_xml.sh > /dev/null
    CORE_RESULT=$?
    
    # Validate any modified .md files for XML structure
    XML_VALIDATION_PASSED=true
    for file in $FILES; do
        if grep -qE '<(wisdom|friction_point|evolutionary_goal|memory_entry|reflection)[ >]' "$file" 2>/dev/null; then
            echo "  Validating: $file"
            OPEN_TAGS=$(grep -cE '<(wisdom|friction_point|evolutionary_goal|memory_entry|reflection)[ >]' "$file" || true)
            CLOSE_TAGS=$(grep -cE '</(wisdom|friction_point|evolutionary_goal|memory_entry|reflection)>' "$file" || true)
            
            if [ "$OPEN_TAGS" != "$CLOSE_TAGS" ]; then
                echo -e "    \033[0;31m✗ Unclosed XML tags in $file\033[0m"
                XML_VALIDATION_PASSED=false
            fi
        fi
    done
    
    if [ $CORE_RESULT -ne 0 ] || [ "$XML_VALIDATION_PASSED" = false ]; then
        echo ""
        echo -e "\033[0;31m✗ Commit aborted due to validation errors\033[0m"
        echo -e "\033[1;33mPlease fix the errors above before committing again.\033[0m"
        exit 1
    fi
    
    echo -e "\033[0;32m✓ Validation passed\033[0m"
else
    echo -e "\033[1;33m⚠ Warning: validate_xml.sh not found in .openclaw/scripts/\033[0m"
    echo "Skipping XML validation..."
fi

exit 0
