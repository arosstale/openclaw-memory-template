#!/bin/bash
# prune_buffer.sh - Wrapper for Python-based BUFFER evaporation
# Part of OpenClaw Memory Template V3.1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

python3 "$SCRIPT_DIR/prune_buffer.py" "$@"
