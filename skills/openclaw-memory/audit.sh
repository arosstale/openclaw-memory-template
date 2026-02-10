#!/usr/bin/env bash
# OpenClaw Memory Skill - Permission Audit Module
# Security audit for workspace permissions
# Version: 1.2.0

set -euo pipefail

# Check if colors are defined by parent script
if [ -z "${GREEN+x}" ]; then
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly RED='\033[0;31m'
    readonly CYAN='\033[0;36m'
    readonly NC='\033[0m'
fi

# Audit results
ISSUES_FOUND=0
WARNINGS_FOUND=0
PASSED_CHECKS=0

# Log issue
log_issue() {
    local severity="$1"
    local message="$2"
    local suggestion="${3:-}"

    case "$severity" in
        "critical")
            echo -e "${RED}❌ CRITICAL: $message${NC}"
            ((ISSUES_FOUND++))
            ;;
        "warning")
            echo -e "${YELLOW}⚠️  WARNING: $message${NC}"
            ((WARNINGS_FOUND++))
            ;;
        "pass")
            echo -e "${GREEN}✓ PASS: $message${NC}"
            ((PASSED_CHECKS++))
            ;;
    esac

    if [ -n "$suggestion" ]; then
        echo "   💡 $suggestion"
    fi

    echo ""
}

# Check file permissions
check_file_permissions() {
    local file="$1"
    local expected_perms="$2"

    if [ ! -f "$file" ]; then
        return
    fi

    local actual_perms=$(stat -c "%a" "$file" 2>/dev/null || echo "000")

    if [ "$actual_perms" != "$expected_perms" ]; then
        log_issue "warning" "$file has permissions $actual_perms (expected $expected_perms)" \
                   "Run: chmod $expected_perms $file"
    else
        log_issue "pass" "$file has correct permissions ($actual_perms)"
    fi
}

# Check directory permissions
check_dir_permissions() {
    local dir="$1"
    local expected_perms="$2"

    if [ ! -d "$dir" ]; then
        return
    fi

    local actual_perms=$(stat -c "%a" "$dir" 2>/dev/null || echo "000")

    if [ "$actual_perms" != "$expected_perms" ]; then
        log_issue "warning" "$dir has permissions $actual_perms (expected $expected_perms)" \
                   "Run: chmod $expected_perms $dir"
    else
        log_issue "pass" "$dir has correct permissions ($actual_perms)"
    fi
}

# Check if file is world-readable
check_world_readable() {
    local file="$1"

    if [ ! -f "$file" ]; then
        return
    fi

    local perms=$(stat -c "%a" "$file" 2>/dev/null || echo "000")

    # Check if last digit has read bit (4)
    local last_digit=${perms: -1}
    if [ $((last_digit & 4)) -ne 0 ]; then
        log_issue "critical" "$file is world-readable (other can read)" \
                   "Run: chmod o-r $file"
    fi
}

# Check if file is world-writable
check_world_writable() {
    local file="$1"

    if [ ! -f "$file" ]; then
        return
    fi

    local perms=$(stat -c "%a" "$file" 2>/dev/null || echo "000")

    # Check if last digit has write bit (2)
    local last_digit=${perms: -1}
    if [ $((last_digit & 2)) -ne 0 ]; then
        log_issue "critical" "$file is world-writable (other can write)" \
                   "Run: chmod o-w $file"
    fi
}

# Check if file is group-writable
check_group_writable() {
    local file="$1"

    if [ ! -f "$file" ]; then
        return
    fi

    local perms=$(stat -c "%a" "$file" 2>/dev/null || echo "000")

    # Check if middle digit has write bit (2)
    local middle_digit=${perms: -2:1}
    if [ $((middle_digit & 2)) -ne 0 ]; then
        log_issue "warning" "$file is group-writable (group can write)" \
                   "Run: chmod g-w $file"
    fi
}

# Check for sensitive files with bad permissions
check_sensitive_files() {
    echo -e "${CYAN}🔍 Checking sensitive files...${NC}"
    echo ""

    # Check encryption key
    check_file_permissions "${WORKSPACE}/.openclaw-memory/key.enc" "600"

    # Check authentication files
    check_file_permissions "${WORKSPACE}/.openclaw-auth/users.json" "600"
    check_file_permissions "${WORKSPACE}/.openclaw-auth/api_keys.json" "600"
    check_file_permissions "${WORKSPACE}/.openclaw-auth/sessions.json" "600"

    # Check rate limit files
    find "${WORKSPACE}/.openclaw-rate-limit" -name "*.json" 2>/dev/null | while read file; do
        check_file_permissions "$file" "600"
    done

    # Check MEMORY.md for world-readable
    check_world_readable "${WORKSPACE}/MEMORY.md"

    # Check memory files for world-writable
    find "${WORKSPACE}/memory" -name "*.md" 2>/dev/null | while read file; do
        check_world_writable "$file"
    done
}

# Check directory permissions
check_directories() {
    echo -e "${CYAN}🔍 Checking directory permissions...${NC}"
    echo ""

    check_dir_permissions "${WORKSPACE}/.openclaw-memory" "700"
    check_dir_permissions "${WORKSPACE}/.openclaw-auth" "700"
    check_dir_permissions "${WORKSPACE}/.openclaw-rate-limit" "700"

    # Check if .openclaw-rate-limit/clients is 700
    check_dir_permissions "${WORKSPACE}/.openclaw-rate-limit/clients" "700"
}

# Check for leaked secrets in git
check_git_secrets() {
    echo -e "${CYAN}🔍 Checking for leaked secrets in git...${NC}"
    echo ""

    if ! git -C "$WORKSPACE" rev-parse --git-dir >/dev/null 2>&1; then
        log_issue "warning" "Not a git repository (can't check for leaked secrets)"
        return
    fi

    # Check for .enc files in git
    local enc_files=$(git -C "$WORKSPACE" ls-files | grep "\.enc$" || true)

    if [ -n "$enc_files" ]; then
        log_issue "critical" "Encrypted files tracked in git: $enc_files" \
                   "Add *.enc to .gitignore"
    else
        log_issue "pass" "No encrypted files tracked in git"
    fi

    # Check for key files in git
    local key_files=$(git -C "$WORKSPACE" ls-files | grep -E "(key|api_key|secret|password)" || true)

    if [ -n "$key_files" ]; then
        log_issue "critical" "Potential key/secret files tracked in git: $key_files" \
                   "Remove sensitive files from git history"
    else
        log_issue "pass" "No obvious key/secret files tracked in git"
    fi

    # Check .gitignore
    if [ -f "${WORKSPACE}/.gitignore" ]; then
        if ! grep -q "\.enc$" "${WORKSPACE}/.gitignore"; then
            log_issue "warning" ".gitignore missing *.enc pattern"
        else
            log_issue "pass" ".gitignore includes *.enc pattern"
        fi
    fi
}

# Check for symlinks to sensitive paths
check_symlinks() {
    echo -e "${CYAN}🔍 Checking for symlinks to sensitive paths...${NC}"
    echo ""

    # Check for symlinks in workspace
    find "$WORKSPACE" -type l 2>/dev/null | while read symlink; do
        local target=$(readlink -f "$symlink" 2>/dev/null || echo "")

        # Check if target is in sensitive directory
        case "$target" in
            /etc/*|/proc/*|/sys/*|/dev/*)
                log_issue "critical" "Symlink to sensitive path: $symlink -> $target"
                ;;
        esac
    done

    log_issue "pass" "No symlinks to sensitive paths found"
}

# Check file ownership
check_ownership() {
    echo -e "${CYAN}🔍 Checking file ownership...${NC}"
    echo ""

    local current_user=$(whoami)
    local current_group=$(id -gn)

    # Check sensitive directories
    local sensitive_dirs=(
        "${WORKSPACE}/.openclaw-memory"
        "${WORKSPACE}/.openclaw-auth"
        "${WORKSPACE}/.openclaw-rate-limit"
    )

    for dir in "${sensitive_dirs[@]}"; do
        if [ -d "$dir" ]; then
            local owner=$(stat -c "%U:%G" "$dir" 2>/dev/null || echo "unknown")

            if [ "$owner" != "${current_user}:${current_group}" ]; then
                log_issue "warning" "$dir owned by $owner (expected ${current_user}:${current_group})" \
                           "Run: sudo chown ${current_user}:${current_group} $dir"
            else
                log_issue "pass" "$dir has correct ownership"
            fi
        fi
    done
}

# Check for world-readable memory files
check_memory_visibility() {
    echo -e "${CYAN}🔍 Checking memory file visibility...${NC}"
    echo ""

    if [ ! -d "${WORKSPACE}/memory" ]; then
        return
    fi

    # Check for world-readable memory files
    local world_readable=$(find "${WORKSPACE}/memory" -name "*.md" -perm -o+r 2>/dev/null || true)

    if [ -n "$world_readable" ]; then
        log_issue "warning" "World-readable memory files found" \
                   "Run: chmod o-r ${WORKSPACE}/memory/*.md"
    else
        log_issue "pass" "No world-readable memory files"
    fi
}

# Run full audit
run_audit() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════╗"
    echo "║                                                  ║"
    echo "║    OpenClaw Memory Skill - Security Audit         ║"
    echo "║                                                  ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo "${NC}"
    echo ""

    # Reset counters
    ISSUES_FOUND=0
    WARNINGS_FOUND=0
    PASSED_CHECKS=0

    # Run all checks
    check_sensitive_files
    check_directories
    check_git_secrets
    check_symlinks
    check_ownership
    check_memory_visibility

    # Print summary
    echo -e "${CYAN}══════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}Audit Summary${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${GREEN}✓ Passed: $PASSED_CHECKS${NC}"
    echo -e "${YELLOW}⚠️  Warnings: $WARNINGS_FOUND${NC}"
    echo -e "${RED}❌ Critical Issues: $ISSUES_FOUND${NC}"
    echo ""

    if [ $ISSUES_FOUND -eq 0 ] && [ $WARNINGS_FOUND -eq 0 ]; then
        echo -e "${GREEN}🎉 All checks passed!${NC}"
        return 0
    elif [ $ISSUES_FOUND -gt 0 ]; then
        echo -e "${RED}⚠️  Critical issues found. Please address them.${NC}"
        return 1
    else
        echo -e "${YELLOW}⚠️  Warnings found. Review and fix if needed.${NC}"
        return 0
    fi
}

# Auto-fix issues
auto_fix() {
    echo -e "${CYAN}🔧 Auto-fixing permission issues...${NC}"
    echo ""

    local fixed=0

    # Fix .openclaw-memory directory
    if [ -d "${WORKSPACE}/.openclaw-memory" ]; then
        chmod 700 "${WORKSPACE}/.openclaw-memory" && ((fixed++))
    fi

    # Fix .openclaw-auth directory
    if [ -d "${WORKSPACE}/.openclaw-auth" ]; then
        chmod 700 "${WORKSPACE}/.openclaw-auth" && ((fixed++))
    fi

    # Fix .openclaw-rate-limit directory
    if [ -d "${WORKSPACE}/.openclaw-rate-limit" ]; then
        chmod 700 "${WORKSPACE}/.openclaw-rate-limit" && ((fixed++))
        chmod 700 "${WORKSPACE}/.openclaw-rate-limit/clients" 2>/dev/null && ((fixed++))
    fi

    # Fix sensitive files
    find "${WORKSPACE}/.openclaw-memory" -type f -exec chmod 600 {} \; 2>/dev/null && ((fixed++))
    find "${WORKSPACE}/.openclaw-auth" -type f -exec chmod 600 {} \; 2>/dev/null && ((fixed++))
    find "${WORKSPACE}/.openclaw-rate-limit" -type f -exec chmod 600 {} \; 2>/dev/null && ((fixed++))

    echo -e "${GREEN}✅ Fixed $fixed permission issues${NC}"
}

# Main audit command
audit_cmd() {
    local action="${1:-audit}"

    case "$action" in
        audit)
            run_audit
            ;;
        fix)
            auto_fix
            ;;
        *)
            echo -e "${CYAN}🔍 Permission Audit Commands${NC}"
            echo ""
            echo "  audit      Run full security audit"
            echo "  fix        Auto-fix common permission issues"
            echo ""
            echo "Examples:"
            echo "  openclaw-memory.sh audit"
            echo "  openclaw-memory.sh audit fix"
            ;;
    esac
}
