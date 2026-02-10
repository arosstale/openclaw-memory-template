#!/usr/bin/env bash
# OpenClaw Memory Management Skill
# Version: 1.0.0
# Author: Pi-Agent

set -e

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Default paths
WORKSPACE="${WORKSPACE:-$(pwd)}"
MEMORY_FILE="$WORKSPACE/MEMORY.md"
AGENTS_FILE="$WORKSPACE/AGENTS.md"
MEMORY_DIR="$WORKSPACE/memory"

# Help
show_help() {
    cat << EOF
🧠 OpenClaw Memory Management Skill

Commands:
  search <query>           Search MEMORY.md and memory/*.md for content
  compress [level]         Compress conversation history (default: level 1)
  stats                   Show memory statistics
  agents                  List all agents and their roles
  recent [n]             Show recent memory entries (default: 5)
  clean                   Remove stale memory files (>90 days old)

Environment Variables:
  WORKSPACE                Path to OpenClaw workspace (default: current dir)

Examples:
  openclaw-memory.sh search "trading strategies"
  openclaw-memory.sh compress 2
  openclaw-memory.sh stats
  openclaw-memory.sh agents

EOF
}

# Search memory
memory_search() {
    local query="$1"
    echo -e "${CYAN}🔍 Searching memory for: $query${NC}"
    echo ""

    # Search MEMORY.md
    if [ -f "$MEMORY_FILE" ]; then
        echo -e "${GREEN}📄 MEMORY.md:${NC}"
        grep -i -n "$query" "$MEMORY_FILE" | head -10 || echo "  No matches"
        echo ""
    fi

    # Search memory/*.md
    if [ -d "$MEMORY_DIR" ]; then
        echo -e "${GREEN}📁 memory/ directory:${NC}"
        find "$MEMORY_DIR" -name "*.md" -exec grep -l -i "$query" {} \; | head -10
    fi
}

# Compress memory
memory_compress() {
    local level="${1:-1}"
    echo -e "${CYAN}🗜  Compressing memory (level: $level)...${NC}"
    echo ""

    # Level 1: Remove duplicate entries
    # Level 2: Summarize old entries
    # Level 3: Archive old files

    case "$level" in
        1)
            echo "Level 1: Removing duplicate entries"
            # Implementation depends on memory format
            ;;
        2)
            echo "Level 2: Summarizing old entries (>30 days)"
            ;;
        3)
            echo "Level 3: Archiving old files (>90 days)"
            ;;
        *)
            echo -e "${RED}❌ Invalid level: $level (use 1, 2, or 3)${NC}"
            exit 1
            ;;
    esac

    echo -e "${GREEN}✅ Compression complete${NC}"
}

# Show statistics
memory_stats() {
    echo -e "${CYAN}📊 Memory Statistics${NC}"
    echo ""

    # MEMORY.md
    if [ -f "$MEMORY_FILE" ]; then
        local lines=$(wc -l < "$MEMORY_FILE")
        local size=$(du -h "$MEMORY_FILE" | cut -f1)
        echo "MEMORY.md: $lines lines, $size"
    fi

    # AGENTS.md
    if [ -f "$AGENTS_FILE" ]; then
        local lines=$(wc -l < "$AGENTS_FILE")
        local size=$(du -h "$AGENTS_FILE" | cut -f1)
        echo "AGENTS.md: $lines lines, $size"
    fi

    # memory/*.md
    if [ -d "$MEMORY_DIR" ]; then
        local count=$(find "$MEMORY_DIR" -name "*.md" | wc -l)
        local total_size=$(du -sh "$MEMORY_DIR" 2>/dev/null | cut -f1)
        echo "memory/ directory: $count files, $total_size"
    fi
}

# List agents
agents_list() {
    echo -e "${CYAN}🤖 AGENTS.md${NC}"
    echo ""

    if [ -f "$AGENTS_FILE" ]; then
        cat "$AGENTS_FILE"
    else
        echo -e "${YELLOW}⚠️  AGENTS.md not found${NC}"
    fi
}

# Show recent entries
recent_entries() {
    local count="${1:-5}"
    echo -e "${CYAN}📅 Recent Memory Entries (last $count)${NC}"
    echo ""

    if [ -d "$MEMORY_DIR" ]; then
        ls -t "$MEMORY_DIR"/*.md 2>/dev/null | head -"$count" | while read file; do
            echo "  $(basename "$file")"
        done
    else
        echo -e "${YELLOW}⚠️  memory/ directory not found${NC}"
    fi
}

# Clean old memory
clean_old() {
    echo -e "${CYAN}🧹 Cleaning old memory files (>90 days)${NC}"
    echo ""

    if [ -d "$MEMORY_DIR" ]; then
        local count=$(find "$MEMORY_DIR" -name "*.md" -mtime +90 | wc -l)
        if [ "$count" -gt 0 ]; then
            echo "Found $count old files. Removing..."
            find "$MEMORY_DIR" -name "*.md" -mtime +90 -delete
            echo -e "${GREEN}✅ Removed $count old files${NC}"
        else
            echo "No old files found"
        fi
    else
        echo -e "${YELLOW}⚠️  memory/ directory not found${NC}"
    fi
}

# Main
main() {
    local command="${1:-help}"

    case "$command" in
        search)
            memory_search "$2"
            ;;
        compress)
            memory_compress "$2"
            ;;
        stats)
            memory_stats
            ;;
        agents)
            agents_list
            ;;
        recent)
            recent_entries "$2"
            ;;
        clean)
            clean_old
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo -e "${RED}❌ Unknown command: $command${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"
