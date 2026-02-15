#!/bin/bash
# summarize_papers.sh - Wrapper for AI summarizer
# Part of OpenClaw Memory Template V2
#
# Usage:
#   ./summarize_papers.sh                 # Summarize 5 recent papers
#   ./summarize_papers.sh <count>         # Summarize N recent papers

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check Python and dependencies
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 required but not installed"
    exit 1
fi

# Check if any AI library is installed
python3 -c "import anthropic" 2>/dev/null
HAS_ANTHROPIC=$?

python3 -c "import openai" 2>/dev/null
HAS_OPENAI=$?

if [[ $HAS_ANTHROPIC -ne 0 && $HAS_OPENAI -ne 0 ]]; then
    echo "❌ No AI library installed"
    echo ""
    echo "Install one of:"
    echo "  pip install anthropic"
    echo "  pip install openai"
    exit 1
fi

# Check API keys
if [[ -z "$ANTHROPIC_API_KEY" && -z "$OPENAI_API_KEY" ]]; then
    echo "❌ No API key configured"
    echo ""
    echo "Set one of:"
    echo "  export ANTHROPIC_API_KEY='sk-ant-...'"
    echo "  export OPENAI_API_KEY='sk-...'"
    exit 1
fi

# Run the summarizer
python3 "$SCRIPT_DIR/research_summarizer.py" "$@"
