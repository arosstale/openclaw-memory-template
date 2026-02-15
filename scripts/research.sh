#!/bin/bash
# Research Engine - Automated Paper Discovery & Summarization
# Part of OpenClaw Memory Template V2
#
# Usage:
#   ./research.sh                    # Run daily research cycle
#   ./research.sh keywords            # Search specific keywords
#   ./research.sh status              # Check research daemon status
#   ./research.sh init               # Initialize research engine

set -e

RESEARCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/research"
LOG_FILE="$RESEARCH_DIR/research.log"
STATUS_FILE="$RESEARCH_DIR/status.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $*" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" | tee -a "$LOG_FILE"
}

init_research() {
    log "Initializing Research Engine..."

    mkdir -p "$RESEARCH_DIR"/{papers,summaries,daily,keywords,domains}
    mkdir -p "$RESEARCH_DIR/keywords/{trading,ai,cognitive,philosophy,math,cs,physics}"

    # Create domains config
    cat > "$RESEARCH_DIR/domains.json" << 'EOF'
{
  "trading": {
    "name": "Trading & Finance",
    "keywords": ["quantitative finance", "algorithmic trading", "market microstructure", "volatility", "high-frequency trading", "arbitrage", "risk management"],
    "arxiv_categories": ["q-fin.CP", "q-fin.ST", "q-fin.TR", "econ.EM"]
  },
  "ai": {
    "name": "Artificial Intelligence",
    "keywords": ["machine learning", "deep learning", "reinforcement learning", "neural networks", "natural language processing", "computer vision"],
    "arxiv_categories": ["cs.AI", "cs.LG", "cs.CV", "cs.CL", "cs.NE"]
  },
  "cognitive": {
    "name": "Cognitive Science",
    "keywords": ["cognitive science", "neuroscience", "human learning", "memory systems", "decision making"],
    "arxiv_categories": ["cs.AI", "q-bio.NC", "psychology"]
  },
  "philosophy": {
    "name": "Philosophy",
    "keywords": ["philosophy", "epistemology", "ethics", "consciousness", "metaphysics", "philosophy of mind"],
    "arxiv_categories": ["physics.hist-ph", "cs.AI"]
  },
  "math": {
    "name": "Mathematics",
    "keywords": ["optimization", "probability", "statistics", "game theory", "linear algebra"],
    "arxiv_categories": ["math.OC", "math.ST", "math.PR", "math.GT"]
  },
  "cs": {
    "name": "Computer Science",
    "keywords": ["distributed systems", "blockchain", "cryptography", "security", "databases"],
    "arxiv_categories": ["cs.DC", "cs.CR", "cs.DB", "cs.DS"]
  },
  "physics": {
    "name": "Physics",
    "keywords": ["quantum computing", "statistical mechanics", "chaos theory", "complex systems"],
    "arxiv_categories": ["quant-ph", "cond-mat", "physics.comp-ph", "nlin.AO"]
  }
}
EOF

    # Create status file
    cat > "$STATUS_FILE" << 'EOF'
{
  "initialized": true,
  "last_run": null,
  "papers_total": 0,
  "domains": 7,
  "status": "idle"
}
EOF

    log "Research Engine initialized!"
    log "Domains configured: trading, ai, cognitive, philosophy, math, cs, physics"
}

check_status() {
    if [[ ! -f "$STATUS_FILE" ]]; then
        echo "Research Engine not initialized. Run './research.sh init'"
        exit 1
    fi

    echo "=== Research Engine Status ==="
    echo "Initialized: $(jq -r '.initialized' "$STATUS_FILE")"
    echo "Last Run: $(jq -r '.last_run // "Never"' "$STATUS_FILE")"
    echo "Total Papers: $(jq -r '.papers_total' "$STATUS_FILE")"
    echo "Domains: $(jq -r '.domains' "$STATUS_FILE")"
    echo "Status: $(jq -r '.status' "$STATUS_FILE")"
    echo ""

    # Count papers by domain
    echo "Papers by Domain:"
    for domain in "$RESEARCH_DIR/papers"/*; do
        if [[ -d "$domain" ]]; then
            count=$(find "$domain" -name "*.md" 2>/dev/null | wc -l)
            domain_name=$(basename "$domain")
            echo "  $domain_name: $count"
        fi
    done
}

search_keywords() {
    local keywords="$1"
    log "Searching for keywords: $keywords"

    local today=$(date +%Y-%m-%d)
    local results_file="$RESEARCH_DIR/daily/results_$today.md"

    echo "# Research Results: $today" > "$results_file"
    echo "" >> "$results_file"
    echo "## Search Keywords" >> "$results_file"
    echo "$keywords" >> "$results_file"
    echo "" >> "$results_file"
    echo "## Papers Found" >> "$results_file"
    echo "" >> "$results_file"

    log "Simulated search results (replace with real arXiv API call)"
    echo "⚠️  Note: Real arXiv API integration requires Python/requests library"
    echo "" >> "$results_file"
    echo "> Configure arXiv API to fetch real papers" >> "$results_file"

    log "Results saved to: $results_file"
}

run_daily_research() {
    log "Starting daily research cycle..."

    local today=$(date +%Y-%m-%d)
    local daily_file="$RESEARCH_DIR/daily/DAILY_RESEARCH_$today.md"

    # Check if already run today
    if [[ -f "$daily_file" ]]; then
        warn "Daily research already run for $today"
        log "Use './research.sh force' to override"
        return 0
    fi

    echo "# Daily Research Report: $today" > "$daily_file"
    echo "" >> "$daily_file"
    echo "**Generated:** $(date)" >> "$daily_file"
    echo "" >> "$daily_file"
    echo "---" >> "$daily_file"
    echo "" >> "$daily_file"

    # Process each domain
    for domain in $(jq -r 'keys[]' "$RESEARCH_DIR/domains.json"); do
        log "Processing domain: $domain"

        domain_name=$(jq -r ".${domain}.name" "$RESEARCH_DIR/domains.json")
        keywords=$(jq -r ".${domain}.keywords | join(\", \")" "$RESEARCH_DIR/domains.json")

        echo "## $domain_name" >> "$daily_file"
        echo "" >> "$daily_file"
        echo "**Keywords:** $keywords" >> "$daily_file"
        echo "" >> "$daily_file"

        # Simulate fetching papers (replace with real API)
        echo "⚠️  Configure arXiv API to fetch real papers for this domain" >> "$daily_file"
        echo "" >> "$daily_file"

        sleep 0.1
    done

    # Update status
    local total_papers=$(find "$RESEARCH_DIR/papers" -name "*.txt" 2>/dev/null | wc -l)
    jq --arg date "$(date -Iseconds)" --argjson total "$total_papers" \
        '.last_run = $date | .papers_total = $total | .status = "completed"' \
        "$STATUS_FILE" > "${STATUS_FILE}.tmp" && mv "${STATUS_FILE}.tmp" "$STATUS_FILE"

    log "Daily research cycle complete!"
    log "Report saved to: $daily_file"
}

# Main entry point
case "${1:-help}" in
    init)
        init_research
        ;;
    status)
        check_status
        ;;
    search)
        if [[ -z "$2" ]]; then
            error "Usage: ./research.sh search 'keyword1, keyword2, ...'"
            exit 1
        fi
        search_keywords "$2"
        ;;
    run|daily)
        if [[ "$1" == "daily" && "$2" == "force" ]]; then
            log "Forcing daily research run..."
            daily_file="$RESEARCH_DIR/daily/DAILY_RESEARCH_$(date +%Y-%m-%d).md"
            [[ -f "$daily_file" ]] && rm "$daily_file"
        fi
        run_daily_research
        ;;
    help|*)
        echo "Research Engine - Automated Paper Discovery & Summarization"
        echo ""
        echo "Usage:"
        echo "  ./research.sh init               Initialize research engine"
        echo "  ./research.sh status             Check engine status"
        echo "  ./research.sh search 'keyword'   Search for papers by keyword"
        echo "  ./research.sh run                Run daily research cycle"
        echo "  ./research.sh daily              Same as 'run'"
        echo "  ./research.sh daily force        Force run (skip check)"
        echo "  ./research.sh help               Show this help"
        echo ""
        echo "Domains: trading, ai, cognitive, philosophy, math, cs, physics"
        exit 0
        ;;
esac
