#!/bin/bash
# Pi-Agent Health Check
# Analyzes Mutation Drift, Subconscious Bloat, and System Health
# Not just "is it alive?" - "is it improving?"

set -euo pipefail

# ========================================
# Configuration
# ========================================
WORKSPACE="${WORKSPACE:-/home/majinbu/pi-mono-workspace}"
MEMORY_DIR="$WORKSPACE/memory"
HEALTH_LOG="$WORKSPACE/health/health_check_$(date +%Y%m%d_%H%M%S).log"
HEALTH_DB="$WORKSPACE/health/health.db"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ========================================
# Setup
# ========================================
mkdir -p "$(dirname "$HEALTH_LOG")"
mkdir -p "$WORKSPACE/health"

echo "🐺📿 Pi-Agent Health Check" | tee -a "$HEALTH_LOG"
echo "========================================" | tee -a "$HEALTH_LOG"
echo "Date: $(date)" | tee -a "$HEALTH_LOG"
echo "" | tee -a "$HEALTH_LOG"

# ========================================
# 1. Mutation Drift Analysis
# ========================================
analyze_mutation_drift() {
    echo -e "${BLUE}🧬 Mutation Drift Analysis${NC}" | tee -a "$HEALTH_LOG"
    echo "------------------------------" | tee -a "$HEALTH_LOG"
    
    # Check for ALMA/Mutation logs
    local mutation_log="$WORKSPACE/memory/MUTATION_LOG.md"
    
    if [ ! -f "$mutation_log" ]; then
        echo -e "${YELLOW}⚠️  No mutation log found. System is cold.${NC}" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Initialize GEPA mutation tracking" | tee -a "$HEALTH_LOG"
        return 1
    fi
    
    # Count mutations
    local total_mutations=$(grep -c "^## Mutation" "$mutation_log" 2>/dev/null || echo "0")
    local recent_mutations=$(tail -50 "$mutation_log" | grep -c "^## Mutation" 2>/dev/null || echo "0")
    
    echo "Total Mutations: $total_mutations" | tee -a "$HEALTH_LOG"
    echo "Recent (last 50): $recent_mutations" | tee -a "$HEALTH_LOG"
    
    # Check for human-in-the-loop checkpoints
    local checkpoint_count=$(grep -c "✅ Human Approved" "$mutation_log" 2>/dev/null || echo "0")
    local checkpoint_ratio=$(echo "scale=2; $checkpoint_count / $total_mutations" | bc 2>/dev/null || echo "0")
    
    echo -e "Human Checkpoints: $checkpoint_count (${GREEN}$(echo "$checkpoint_ratio * 100" | bc)%${NC})" | tee -a "$HEALTH_LOG"
    
    # Risk assessment
    if [ "$checkpoint_ratio" = "0" ] && [ "$total_mutations" -gt 20 ]; then
        echo -e "${RED}🚨 HIGH RISK: Unsupervised evolution!${NC}" | tee -a "$HEALTH_LOG"
        echo "   ⚠️  System may have drifted from original design goals" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Implement Human-in-the-Loop checkpoints" | tee -a "$HEALTH_LOG"
    elif [ "$checkpoint_ratio" \< "0.1" ] && [ "$total_mutations" -gt 50 ]; then
        echo -e "${YELLOW}⚠️  MEDIUM RISK: Low supervision${NC}" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Increase human checkpoint frequency" | tee -a "$HEALTH_LOG"
    else
        echo -e "${GREEN}✅ Mutation drift is within acceptable bounds${NC}" | tee -a "$HEALTH_LOG"
    fi
    
    echo "" | tee -a "$HEALTH_LOG"
}

# ========================================
# 2. Subconscious Bloat Analysis
# ========================================
analyze_storage_bloat() {
    echo -e "${BLUE}💾 Subconscious Bloat Analysis${NC}" | tee -a "$HEALTH_LOG"
    echo "------------------------------" | tee -a "$HEALTH_LOG"
    
    # Git folder size
    local git_size=$(du -sk "$WORKSPACE/.git" 2>/dev/null || echo "0")
    local git_size_mb=$(echo "scale=2; $git_size / 1048576" | bc 2>/dev/null || echo "0")
    
    # Memory folder size
    local mem_size=$(du -sk "$MEMORY_DIR" 2>/dev/null || echo "0")
    local mem_size_mb=$(echo "scale=2; $mem_size / 1048576" | bc 2>/dev/null || echo "0")
    
    # SQLite databases
    local db_size=$(find "$WORKSPACE" -name "*.db" -exec du -ch {} + 2>/dev/null | tail -1 || echo "0")
    local db_size_mb=$(echo "scale=2; $db_size / 1048576" | bc 2>/dev/null || echo "N/A")
    
    echo "Git (.git): ${git_size_mb} MB" | tee -a "$HEALTH_LOG"
    echo "Memory: ${mem_size_mb} MB" | tee -a "$HEALTH_LOG"
    echo "Databases: ${db_size_mb} MB" | tee -a "$HEALTH_LOG"
    echo "Total: ${git_size_mb} MB + ${mem_size_mb} MB + ${db_size_mb} MB = $(echo "scale=2; $git_size_mb + $mem_size_mb + $db_size_mb" | bc) MB" | tee -a "$HEALTH_LOG"
    
    # Bloat assessment
    if [ ! -z "$git_size_mb" ] && [ "$(echo "$git_size_mb > 500" | bc)" = "1" ]; then
        echo -e "${RED}🚨 HIGH RISK: Git folder is bloated${NC}" | tee -a "$HEALTH_LOG"
        echo "   ⚠️  Over 500MB - sync times will be slow" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Run aggressive git gc" | tee -a "$HEALTH_LOG"
    elif [ ! -z "$git_size_mb" ] && [ "$(echo "$git_size_mb > 200" | bc)" = "1" ]; then
        echo -e "${YELLOW}⚠️  MEDIUM RISK: Git folder growing${NC}" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Monitor growth rate" | tee -a "$HEALTH_LOG"
    else
        echo -e "${GREEN}✅ Storage is within acceptable bounds${NC}" | tee -a "$HEALTH_LOG"
    fi
    
    # Pruning recommendations
    echo -e "\n📋 Pruning Recommendations:" | tee -a "$HEALTH_LOG"
    
    # Check for old memory files (> 30 days)
    local old_memories=$(find "$MEMORY_DIR" -name "*.md" -mtime +30 | wc -l)
    if [ "$old_memories" -gt 5 ]; then
        echo "   - Archive memories older than 30 days" | tee -a "$HEALTH_LOG"
        echo "     Count: $old_memories files" | tee -a "$HEALTH_LOG"
    fi
    
    # Check for large SQLite files (> 100MB)
    local large_dbs=$(find "$WORKSPACE" -name "*.db" -size +100M)
    if [ -n "$large_dbs" ]; then
        echo "   - Vacuum large SQLite databases" | tee -a "$HEALTH_LOG"
        echo "$large_dbs" | while read db; do
            echo "     $db"
        done
    fi
    
    # Check for duplicate/cascaded memory
    if [ -d "$MEMORY_DIR/templates" ]; then
        local template_count=$(find "$MEMORY_DIR/templates" -name "*.md" | wc -l)
        if [ "$template_count" -gt 20 ]; then
            echo "   - Consolidate memory templates (count: $template_count)" | tee -a "$HEALTH_LOG"
        fi
    fi
    
    echo "" | tee -a "$HEALTH_LOG"
}

# ========================================
# 3. Thermal Stuttering Analysis
# ========================================
analyze_thermal_patterns() {
    echo -e "${BLUE}🌡️  Thermal Stuttering Analysis${NC}" | tee -a "$HEALTH_LOG"
    echo "------------------------------" | tee -a "$HEALTH_LOG"
    
    # Check for thermal logs
    local thermal_log="$WORKSPACE/monitoring/thermal_log.txt"
    
    if [ ! -f "$thermal_log" ]; then
        echo -e "${YELLOW}⚠️  No thermal log found${NC}" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Enable temperature monitoring" | tee -a "$HEALTH_LOG"
        return 1
    fi
    
    # Count throttle events
    local throttle_up=$(grep -c "throttle enabled" "$thermal_log" 2>/dev/null || echo "0")
    local throttle_down=$(grep -c "throttle disabled" "$thermal_log" 2>/dev/null || echo "0")
    local total_cycles=$(echo "$throttle_up + $throttle_down" | bc)
    
    echo "Throttle Up: $throttle_up" | tee -a "$HEALTH_LOG"
    echo "Throttle Down: $throttle_down" | tee -a "$HEALTH_LOG"
    echo "Total Cycles: $total_cycles" | tee -a "$HEALTH_LOG"
    
    # Stuttering assessment
    if [ -n "$total_cycles" ] && [ "$total_cycles" -gt 20 ]; then
        local avg_cycle_rate=$(echo "scale=1; $total_cycles / 10" | bc 2>/dev/null) # Assuming 10 min window
        echo -e "${RED}🚨 HIGH RISK: Excessive throttling${NC}" | tee -a "$HEALTH_LOG"
        echo "   ⚠️  Average: ${avg_cycle_rate} cycles/10min" | tee -a "$HEALTH_LOG"
        echo "   This causes poor user experience" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Implement task prioritization instead of binary gating" | tee -a "$HEALTH_LOG"
    elif [ -n "$total_cycles" ] && [ "$total_cycles" -gt 10 ]; then
        echo -e "${YELLOW}⚠️  MEDIUM RISK: Frequent throttling${NC}" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Review thermal thresholds" | tee -a "$HEALTH_LOG"
    else
        echo -e "${GREEN}✅ Thermal patterns are stable${NC}" | tee -a "$HEALTH_LOG"
    fi
    
    echo "" | tee -a "$HEALTH_LOG"
}

# ========================================
# 4. Configuration Debt Analysis
# ========================================
analyze_configuration_debt() {
    echo -e "${BLUE}⚙️  Configuration Debt Analysis${NC}" | tee -a "$HEALTH_LOG"
    echo "------------------------------" | tee -a "$HEALTH_LOG"
    
    # Check Docker status
    if command -v docker &> /dev/null; then
        local docker_running=$(docker ps --format "{{.Names}}" | grep -c "openclaw\|clawdbot" 2>/dev/null || echo "0")
        if [ "$docker_running" -gt 0 ]; then
            echo -e "${GREEN}✅ Docker is running ($docker_running containers)${NC}" | tee -a "$HEALTH_LOG"
        else
            echo -e "${YELLOW}⚠️  Docker may not be running${NC}" | tee -a "$HEALTH_LOG"
        fi
    else
        echo -e "${YELLOW}⚠️  Docker not available${NC}" | tee -a "$HEALTH_LOG"
    fi
    
    # Check PostgreSQL
    local postgres_running=$(pg_isready 2>/dev/null && echo "1" || echo "0")
    if [ "$postgres_running" = "1" ]; then
        echo -e "${GREEN}✅ PostgreSQL is running${NC}" | tee -a "$HEALTH_LOG"
    else
        echo -e "${YELLOW}⚠️  PostgreSQL may not be running${NC}" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Check if system can fallback to SQLite" | tee -a "$HEALTH_LOG"
    fi
    
    # Check for Fallback Mode indicators
    local fallback_needed=false
    
    # Check if OpenClaw can work without QMD
    if ! command -v qmd &> /dev/null; then
        echo -e "${GREEN}✅ System can work without QMD${NC}" | tee -a "$HEALTH_LOG"
    else
        echo -e "${YELLOW}⚠️  QMD dependency detected${NC}" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Verify fallback to built-in search" | tee -a "$HEALTH_LOG"
        fallback_needed=true
    fi
    
    # Check if system works without PostgreSQL
    if [ "$postgres_running" != "1" ]; then
        echo -e "${GREEN}✅ System can work without PostgreSQL${NC}" | tee -a "$HEALTH_LOG"
    fi
    
    # Fragility score
    local dependency_count=0
    command -v docker &> /dev/null && dependency_count=$((dependency_count + 1))
    [ "$postgres_running" = "1" ] && dependency_count=$((dependency_count + 1))
    command -v qmd &> /dev/null && dependency_count=$((dependency_count + 1))
    
    echo "Active Dependencies: $dependency_count" | tee -a "$HEALTH_LOG"
    
    if [ "$dependency_count" -ge 3 ]; then
        echo -e "${RED}🚨 HIGH RISK: High dependency count${NC}" | tee -a "$HEALTH_LOG"
        echo "   ⚠️  System is fragile - more points of failure" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Implement graceful degradation" | tee -a "$HEALTH_LOG"
    elif [ "$fallback_needed" = true ]; then
        echo -e "${YELLOW}⚠️  MEDIUM RISK: Missing fallback${NC}" | tee -a "$HEALTH_LOG"
    else
        echo -e "${GREEN}✅ Configuration is resilient${NC}" | tee -a "$HEALTH_LOG"
    fi
    
    echo "" | tee -a "$HEALTH_LOG"
}

# ========================================
# 5. Intelligence Assessment
# ========================================
assess_intelligence_growth() {
    echo -e "${BLUE}🧠 Intelligence Growth Assessment${NC}" | tee -a "$HEALTH_LOG"
    echo "------------------------------" | tee -a "$HEALTH_LOG"
    
    # Compare memory growth vs. learning growth
    local current_memory_files=$(find "$MEMORY_DIR" -name "*.md" -type f | wc -l)
    local current_mem_size=$(du -sh "$MEMORY_DIR" 2>/dev/null || echo "0")
    
    # Check for ALMA score trends (if available)
    local alma_db="$WORKSPACE/monitoring/alma_designs.db"
    local design_count=0
    local avg_score=0
    
    if [ -f "$alma_db" ]; then
        # Extract scores from SQLite (simplified)
        design_count=$(sqlite3 "$alma_db" "SELECT COUNT(*) FROM designs" 2>/dev/null || echo "0")
        avg_score=$(sqlite3 "$alma_db" "SELECT AVG(score) FROM designs" 2>/dev/null || echo "0")
    fi
    
    echo "Memory Files: $current_memory_files" | tee -a "$HEALTH_LOG"
    echo "Memory Size: $current_mem_size" | tee -a "$HEALTH_LOG"
    echo "ALMA Designs: $design_count" | tee -a "$HEALTH_LOG"
    echo "Avg ALMA Score: ${avg_score:-N/A}" | tee -a "$HEALTH_LOG"
    
    # Assess: Getting smarter or heavier?
    local smarter=false
    local heavier=false
    
    # Smarter indicators
    if [ ! -z "$avg_score" ] && [ "$(echo "$avg_score > 0.5" | bc)" = "1" ]; then
        smarter=true
        echo -e "${GREEN}✅ ALMA scores improving${NC}" | tee -a "$HEALTH_LOG"
    fi
    
    if [ "$current_memory_files" -gt 50 ] && [ ! -z "$design_count" ] && [ "$design_count" -gt 10 ]; then
        smarter=true
        echo -e "${GREEN}✅ System is learning and retaining${NC}" | tee -a "$HEALTH_LOG"
    fi
    
    # Heavier indicators (mem_size is in KB, convert to MB)
    local mem_size_mb=$(echo "scale=2; $current_mem_size / 1048576" | bc 2>/dev/null || echo "0")
    
    if [ "$mem_size_mb" -gt 500 ]; then  # > 500MB
        heavier=true
        echo -e "${YELLOW}⚠️  Memory size is large (${mem_size_mb}MB)${NC}" | tee -a "$HEALTH_LOG"
    fi
    
    if [ "$current_memory_files" -gt 100 ] && [ -z "$design_count" ]; then
        heavier=true
        echo -e "${YELLOW}⚠️  Storing more than processing${NC}" | tee -a "$HEALTH_LOG"
    fi
    
    # Verdict
    if [ "$smarter" = true ] && [ "$heavier" = false ]; then
        echo -e "${GREEN}🎯 Verdict: Getting SMARTER${NC}" | tee -a "$HEALTH_LOG"
        echo "   System is improving intelligence without excessive bloat" | tee -a "$HEALTH_LOG"
    elif [ "$smarter" = true ] && [ "$heavier" = true ]; then
        echo -e "${YELLOW}⚠️  Verdict: Getting HEAVIER (but also smarter)${NC}" | tee -a "$HEALTH_LOG"
        echo "   Intelligence is improving, but storage needs pruning" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Implement aggressive pruning policy" | tee -a "$HEALTH_LOG"
    elif [ "$smarter" = false ] && [ "$heavier" = true ]; then
        echo -e "${RED}🚨 Verdict: Getting HEAVIER (not smarter)${NC}" | tee -a "$HEALTH_LOG"
        echo "   ⚠️  System is accumulating data without improvement" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Review mutation logic, pause new features" | tee -a "$HEALTH_LOG"
    else
        echo -e "${YELLOW}⚠️  Verdict: Inconclusive (insufficient data)${NC}" | tee -a "$HEALTH_LOG"
        echo "   Recommendation: Run more ALMA iterations to establish baseline" | tee -a "$HEALTH_LOG"
    fi
    
    echo "" | tee -a "$HEALTH_LOG"
}

# ========================================
# 6. Recommendations Generation
# ========================================
generate_recommendations() {
    echo -e "${BLUE}💡 Recommendations${NC}" | tee -a "$HEALTH_LOG"
    echo "------------------------------" | tee -a "$HEALTH_LOG"
    
    # Priority 1: Human-in-the-Loop Checkpoints
    echo "Priority 1: Implement Human-in-the-Loop Checkpoints" | tee -a "$HEALTH_LOG"
    echo "   - Add approval step to MUTATION_LOG.md every 10 mutations" | tee -a "$HEALTH_LOG"
    echo "   - Require manual Y/N for major parameter changes" | tee -a "$HEALTH_LOG"
    
    # Priority 2: Fallback Mode
    echo "Priority 2: Implement Fallback Mode" | tee -a "$HEALTH_LOG"
    echo "   - If PostgreSQL fails, degrade to SQLite" | tee -a "$HEALTH_LOG"
    echo "   - If QMD fails, use built-in search" | tee -a "$HEALTH_LOG"
    echo "   - System should remain functional with any single component down" | tee -a "$HEALTH_LOG"
    
    # Priority 3: Task Prioritization
    echo "Priority 3: Implement Task Prioritization" | tee -a "$HEALTH_LOG"
    echo "   - Stop high-compute tasks (Reflect, Optimize) when hot" | tee -a "$HEALTH_LOG"
    echo "   - Keep low-compute tasks (Respond, Read) active" | tee -a "$HEALTH_LOG"
    echo "   - Replace binary thermal gating with task queues" | tee -a "$HEALTH_LOG"
    
    # Priority 4: Aggressive Pruning
    echo "Priority 4: Implement Aggressive Pruning Policy" | tee -a "$HEALTH_LOG"
    echo "   - Keep only wisdom weights, not raw traces" | tee -a "$HEALTH_LOG"
    echo "   - Archive old memories (>30 days) to separate storage" | tee -a "$HEALTH_LOG"
    echo "   - Vacuum SQLite databases weekly" | tee -a "$HEALTH_LOG"
    
    # Priority 5: Dependency Reduction
    echo "Priority 5: Reduce Configuration Debt" | tee -a "$HEALTH_LOG"
    echo "   - Minimize required components" | tee -a "$HEALTH_LOG"
    echo "   - Test system with each component disabled" | tee -a "$HEALTH_LOG"
    echo "   - Document graceful degradation paths" | tee -a "$HEALTH_LOG"
    
    echo "" | tee -a "$HEALTH_LOG"
}

# ========================================
# Main Execution
# ========================================
main() {
    echo "" | tee -a "$HEALTH_LOG"
    echo "Starting comprehensive health check..." | tee -a "$HEALTH_LOG"
    echo "" | tee -a "$HEALTH_LOG"
    
    # Run all analyses
    analyze_mutation_drift || true
    analyze_storage_bloat || true
    analyze_thermal_patterns || true
    analyze_configuration_debt || true
    assess_intelligence_growth || true
    generate_recommendations
    
    # Summary
    echo -e "${GREEN}========================================${NC}" | tee -a "$HEALTH_LOG"
    echo -e "${GREEN}Health Check Complete${NC}" | tee -a "$HEALTH_LOG"
    echo -e "${GREEN}========================================${NC}" | tee -a "$HEALTH_LOG"
    echo "Log saved to: $HEALTH_LOG" | tee -a "$HEALTH_LOG"
}

# Run main function
main
