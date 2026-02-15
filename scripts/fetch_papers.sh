#!/bin/bash
# fetch_papers.sh - Wrapper for arXiv fetcher
# Part of OpenClaw Memory Template V2
#
# Usage:
#   ./fetch_papers.sh                 # Fetch papers for all domains
#   ./fetch_papers.sh <domain>        # Fetch for specific domain

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check Python and dependencies
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 required but not installed"
    exit 1
fi

# Check if arxiv library is installed
python3 -c "import arxiv" 2>/dev/null
if [[ $? -ne 0 ]]; then
    echo "❌ arxiv library not installed"
    echo ""
    echo "Install with:"
    echo "  pip install arxiv"
    exit 1
fi

# Run the fetcher
python3 "$SCRIPT_DIR/arxiv_fetcher.py" "$@"
