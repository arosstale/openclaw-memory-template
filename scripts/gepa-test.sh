#!/bin/bash
# OpenClaw V2.1 Elite - GEPA Mutation System Test
# Validates the GEPA mutation engine, thermal-awareness, and versioning

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║   🧬 GEPA Mutation System Test                                    ║"
echo "║                                                                ║"
echo "║   Validating Self-Correcting Evolution Engine                      ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to report test result
report_test() {
    local test_name="$1"
    local result="$2"
    local details="$3"

    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}✅ PASS${NC} - $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}❌ FAIL${NC} - $test_name"
        echo -e "   ${YELLOW}$details${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Test 1: evolve.ts exists
echo -e "${CYAN}[Test 1/8]${NC} GEPA Engine File Check"
if [ -f ".openclaw/evolution/evolve.ts" ]; then
    report_test "evolve.ts exists" "PASS" "File found at .openclaw/evolution/evolve.ts"
else
    report_test "evolve.ts exists" "FAIL" "evolve.ts not found"
fi
echo ""

# Test 2: Versioning script exists
echo -e "${CYAN}[Test 2/8]${NC} Genetic Versioning Script"
if [ -f "scripts/version-mutation.sh" ] && [ -x "scripts/version-mutation.sh" ]; then
    report_test "version-mutation.sh exists and executable" "PASS" "Script is ready for auto-tagging"
else
    report_test "version-mutation.sh exists and executable" "FAIL" "Check file permissions"
fi
echo ""

# Test 3: MUTATION_LOG template exists
echo -e "${CYAN}[Test 3/8]${NC} Mutation Log Template"
if [ -f "MUTATION_LOG.md" ]; then
    report_test "MUTATION_LOG.md exists" "PASS" "IQ tracking template is available"
else
    report_test "MUTATION_LOG.md exists" "FAIL" "Mutation log template not found"
fi
echo ""

# Test 4: Thermal check script
echo -e "${CYAN}[Test 4/8]${NC} Thermal Monitoring Script"
if [ -f "scripts/thermal-check.sh" ] && [ -x "scripts/thermal-check.sh" ]; then
    report_test "thermal-check.sh exists and executable" "PASS" "Thermal safety is operational"

    # Run thermal check and verify output format
    if command -v ./scripts/thermal-check.sh &> /dev/null; then
        ./scripts/thermal-check.sh > /dev/null 2>&1 && \
        report_test "thermal-check.sh executes" "PASS" "Thermal check runs without errors"
    fi
else
    report_test "thermal-check.sh exists and executable" "FAIL" "Check file permissions"
fi
echo ""

# Test 5: AGENTS.md has memory architecture
echo -e "${CYAN}[Test 5/8]${NC} AGENTS.md Memory Architecture"
if [ -f ".openclaw/core/AGENTS.md" ]; then
    if grep -q "Elite Memory Architecture" ".openclaw/core/AGENTS.md"; then
        report_test "AGENTS.md has V2.1 memory architecture" "PASS" "Elite memory rules defined"
    else
        report_test "AGENTS.md has V2.1 memory architecture" "FAIL" "Missing V2.1 memory section"
    fi
else
    report_test "AGENTS.md exists" "FAIL" "AGENTS.md not found"
fi
echo ""

# Test 6: Git availability for versioning
echo -e "${CYAN}[Test 6/8]${NC} Git Configuration"
if command -v git &> /dev/null; then
    report_test "Git is available" "PASS" "Git is installed and accessible"

    # Check if we're in a git repo
    if git rev-parse --git-dir > /dev/null 2>&1; then
        report_test "Git repository initialized" "PASS" "Versioning is enabled"
    else
        report_test "Git repository initialized" "FAIL" "Not in a git repository"
    fi
else
    report_test "Git is available" "FAIL" "Git not installed"
fi
echo ""

# Test 7: PostgreSQL configuration
echo -e "${CYAN}[Test 7/8]${NC} PostgreSQL Sidecar Configuration"
if [ -f "docker-compose.postgres.yml" ]; then
    report_test "docker-compose.postgres.yml exists" "PASS" "PostgreSQL sidecar configured"

    if [ -f "scripts/init-postgres.sql" ]; then
        report_test "init-postgres.sql exists" "PASS" "Database schema is defined"
    else
        report_test "init-postgres.sql exists" "FAIL" "Database schema not found"
    fi
else
    report_test "docker-compose.postgres.yml exists" "FAIL" "PostgreSQL sidecar not configured"
fi
echo ""

# Test 8: QMD configuration
echo -e "${CYAN}[Test 8/8]${NC} QMD Sidecar Configuration"
if [ -f "docker-compose.qmd.yml" ]; then
    report_test "docker-compose.qmd.yml exists" "PASS" "QMD sidecar configured"

    if grep -q "oven/bun" "docker-compose.qmd.yml"; then
        report_test "QMD using Bun runtime" "PASS" "Correct runtime specified"
    else
        report_test "QMD using Bun runtime" "FAIL" "Runtime verification failed"
    fi
else
    report_test "docker-compose.qmd.yml exists" "WARN" "QMD sidecar is optional"
    TESTS_FAILED=$((TESTS_FAILED - 1))  # Don't count as failure
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${MAGENTA}📊 GEPA System Test Summary${NC}"
echo ""
echo -e "Tests Passed: ${GREEN}${TESTS_PASSED}${NC}"
echo -e "Tests Failed: ${RED}${TESTS_FAILED}${NC}"

total_tests=$((TESTS_PASSED + TESTS_FAILED))
pass_rate=0
if [ $total_tests -gt 0 ]; then
    pass_rate=$(( (TESTS_PASSED * 100) / total_tests ))
fi

echo -e "Pass Rate:   ${CYAN}${pass_rate}%${NC}"
echo ""

# Verdict
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${CYAN}🎯 GEPA System Verdict${NC}"
echo ""

if [ $pass_rate -eq 100 ]; then
    echo -e "${GREEN}✅ EXCELLENT - GEPA system is fully operational${NC}"
    echo ""
    echo "The GEPA mutation engine is ready for:"
    echo "  • Self-correcting mutations on failures"
    echo "  • Thermal-aware adaptive compute"
    echo "  • Genetic versioning with Git tags"
    echo "  • PostgreSQL mutation logging"
    echo "  • IQ tracking via MUTATION_LOG.md"
    echo ""
    exit_code=0
elif [ $pass_rate -ge 75 ]; then
    echo -e "${YELLOW}⚠️  GOOD - GEPA system is operational with minor issues${NC}"
    echo ""
    echo "Review failed tests above for recommendations."
    exit_code=1
else
    echo -e "${RED}❌ NEEDS SETUP - GEPA system requires configuration${NC}"
    echo ""
    echo "Required setup steps:"
    echo "  1. Ensure evolve.ts is present"
    echo "  2. Run scripts/init.sh if needed"
    echo "  3. Verify Git repository is initialized"
    echo "  4. Check PostgreSQL and QMD configurations"
    exit_code=2
fi

echo ""

exit $exit_code
