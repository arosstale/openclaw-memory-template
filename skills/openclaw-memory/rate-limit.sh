#!/usr/bin/env bash
# OpenClaw Memory Skill - Rate Limiting Module
# Token bucket algorithm for production use
# Version: 1.2.0

set -euo pipefail

# Rate limiting configuration
# Note: WORKSPACE is set by parent script before sourcing this module
readonly RATE_LIMIT_DIR="${WORKSPACE}/.openclaw-rate-limit"
readonly RATE_LIMIT_FILE="${RATE_LIMIT_DIR}/limits.json"
readonly DEFAULT_RATE=60          # requests per minute
readonly DEFAULT_BURST=10          # burst capacity
readonly CLEANUP_INTERVAL=3600     # 1 hour

# Check if colors are defined by parent script
if [ -z "${GREEN+x}" ]; then
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly RED='\033[0;31m'
    readonly NC='\033[0m'
fi

# Ensure WORKSPACE is set
if [ -z "${WORKSPACE:-}" ]; then
    export WORKSPACE="$(pwd)"
fi

# Initialize rate limiting
init_rate_limit() {
    if [ ! -d "$RATE_LIMIT_DIR" ]; then
        mkdir -p "$RATE_LIMIT_DIR"
        chmod 700 "$RATE_LIMIT_DIR"

        echo '{"clients": {}}' > "$RATE_LIMIT_FILE"

        echo -e "${GREEN}✅ Rate limiting initialized${NC}"
        echo "  Rate limit: $DEFAULT_RATE requests/minute"
        echo "  Burst capacity: $DEFAULT_BURST"
    fi
}

# Get client identifier
get_client_id() {
    # Try to get from environment
    local client_id="${OPENCLAW_CLIENT_ID:-}"

    if [ -n "$client_id" ]; then
        echo "$client_id"
        return
    fi

    # Fall back to IP or hostname
    local hostname=$(hostname 2>/dev/null || echo "unknown")
    local pid=$$

    echo "${hostname}:${pid}"
}

# Get current timestamp in seconds
get_timestamp() {
    date +%s
}

# Initialize client bucket
init_client_bucket() {
    local client_id="$1"
    local timestamp=$(get_timestamp)

    # Create bucket entry
    echo "{
  \"client_id\": \"$client_id\",
  \"tokens\": $DEFAULT_BURST,
  \"last_refill\": $timestamp,
  \"rate\": $DEFAULT_RATE,
  \"burst\": $DEFAULT_BURST,
  \"requests\": []
}" >> "${RATE_LIMIT_DIR}/clients/${client_id}.json"

    chmod 600 "${RATE_LIMIT_DIR}/clients/${client_id}.json"
}

# Refill tokens
refill_tokens() {
    local client_id="$1"
    local client_file="${RATE_LIMIT_DIR}/clients/${client_id}.json"

    if [ ! -f "$client_file" ]; then
        init_client_bucket "$client_id"
        return 0
    fi

    local current_time=$(get_timestamp)
    local last_refill=$(grep '"last_refill":' "$client_file" | grep -o '[0-9]*' | head -1)
    local current_tokens=$(grep '"tokens":' "$client_file" | grep -o '[0-9]*' | head -1)
    local rate=$(grep '"rate":' "$client_file" | grep -o '[0-9]*' | head -1)
    local burst=$(grep '"burst":' "$client_file" | grep -o '[0-9]*' | head -2 | tail -1)

    # Calculate time elapsed in seconds
    local time_elapsed=$((current_time - last_refill))

    # Calculate tokens to add (rate per minute = rate/60 per second)
    local tokens_to_add=$((time_elapsed * rate / 60))

    # Refill tokens
    local new_tokens=$((current_tokens + tokens_to_add))

    # Cap at burst capacity
    if [ $new_tokens -gt $burst ]; then
        new_tokens=$burst
    fi

    # Update client file
    sed -i "s/\"tokens\": [0-9]*/\"tokens\": $new_tokens/" "$client_file"
    sed -i "s/\"last_refill\": [0-9]*/\"last_refill\": $current_time/" "$client_file"

    echo $new_tokens
}

# Consume token
consume_token() {
    local client_id="$1"

    # Ensure clients directory exists
    mkdir -p "${RATE_LIMIT_DIR}/clients"

    # Refill tokens first
    local tokens=$(refill_tokens "$client_id")

    # Check if we have tokens
    if [ "$tokens" -gt 0 ]; then
        # Consume one token
        local new_tokens=$((tokens - 1))
        local client_file="${RATE_LIMIT_DIR}/clients/${client_id}.json"
        sed -i "s/\"tokens\": [0-9]*/\"tokens\": $new_tokens/" "$client_file"

        # Log request
        log_request "$client_id"

        return 0
    else
        return 1
    fi
}

# Log request
log_request() {
    local client_id="$1"
    local client_file="${RATE_LIMIT_DIR}/clients/${client_id}.json"
    local timestamp=$(get_timestamp)

    # Add to requests array (simplified)
    local timestamp_iso=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "    {\"timestamp\": $timestamp, \"iso\": \"$timestamp_iso\"}," >> "$client_file"
}

# Check rate limit
check_rate_limit() {
    local client_id="${1:-$(get_client_id)}"

    init_rate_limit

    # Try to consume token
    if consume_token "$client_id"; then
        return 0
    else
        echo -e "${RED}❌ Rate limit exceeded${NC}" >&2
        echo "  Client: $client_id" >&2
        echo "  Rate: $DEFAULT_RATE requests/minute" >&2
        echo "  Burst: $DEFAULT_BURST" >&2
        return 1
    fi
}

# Get rate limit status
get_rate_limit_status() {
    local client_id="${1:-$(get_client_id)}"
    local client_file="${RATE_LIMIT_DIR}/clients/${client_id}.json"

    if [ ! -f "$client_file" ]; then
        echo "Tokens: $DEFAULT_BURST/$DEFAULT_BURST"
        return 0
    fi

    local tokens=$(grep '"tokens":' "$client_file" | grep -o '[0-9]*' | head -1)
    local burst=$(grep '"burst":' "$client_file" | grep -o '[0-9]*' | head -2 | tail -1)

    echo "Tokens: $tokens/$burst"
}

# Clean up old client data
cleanup_old_clients() {
    local current_time=$(get_timestamp)
    local cutoff_time=$((current_time - CLEANUP_INTERVAL))

    if [ ! -d "${RATE_LIMIT_DIR}/clients" ]; then
        return
    fi

    find "${RATE_LIMIT_DIR}/clients" -name "*.json" -mtime +1 -delete 2>/dev/null || true

    echo -e "${GREEN}✅ Old client data cleaned${NC}"
}

# Reset rate limit (admin function)
reset_rate_limit() {
    local client_id="${1:-$(get_client_id)}"
    local client_file="${RATE_LIMIT_DIR}/clients/${client_id}.json"

    if [ -f "$client_file" ]; then
        local burst=$(grep '"burst":' "$client_file" | grep -o '[0-9]*' | head -2 | tail -1)
        sed -i "s/\"tokens\": [0-9]*/\"tokens\": $burst/" "$client_file"
        echo -e "${GREEN}✅ Rate limit reset for $client_id${NC}"
    else
        echo -e "${YELLOW}⚠️  No rate limit data found for $client_id${NC}"
    fi
}

# Show rate limit statistics
rate_limit_stats() {
    echo -e "${GREEN}📊 Rate Limit Statistics${NC}"
    echo ""

    if [ ! -d "$RATE_LIMIT_DIR" ]; then
        echo -e "${YELLOW}⚠️  Rate limiting not initialized${NC}"
        return
    fi

    # Count active clients
    local client_count=0
    if [ -d "${RATE_LIMIT_DIR}/clients" ]; then
        client_count=$(find "${RATE_LIMIT_DIR}/clients" -name "*.json" 2>/dev/null | wc -l)
    fi

    echo "  Active clients: $client_count"
    echo "  Rate limit: $DEFAULT_RATE requests/minute"
    echo "  Burst capacity: $DEFAULT_BURST"
    echo ""

    if [ "$client_count" -gt 0 ]; then
        echo "  Client status:"
        find "${RATE_LIMIT_DIR}/clients" -name "*.json" 2>/dev/null | while read file; do
            local client=$(basename "$file" .json)
            local tokens=$(grep '"tokens":' "$file" | grep -o '[0-9]*' | head -1)
            local burst=$(grep '"burst":' "$file" | grep -o '[0-9]*' | head -2 | tail -1)
            echo "    $client: $tokens/$burst tokens"
        done
    fi
}

# Main rate limit command
rate_limit_cmd() {
    local action="${1:-help}"

    case "$action" in
        init)
            init_rate_limit
            ;;
        check)
            check_rate_limit "${2:-}"
            ;;
        status)
            get_rate_limit_status "${2:-}"
            ;;
        stats)
            rate_limit_stats
            ;;
        reset)
            reset_rate_limit "${2:-}"
            ;;
        cleanup)
            cleanup_old_clients
            ;;
        *)
            echo -e "${GREEN}🚦 Rate Limiting Commands${NC}"
            echo ""
            echo "  init              Initialize rate limiting"
            echo "  check [client]    Check rate limit (consume token)"
            echo "  status [client]   Get rate limit status"
            echo "  stats             Show rate limit statistics"
            echo "  reset [client]    Reset rate limit for client"
            echo "  cleanup           Clean old client data"
            echo ""
            echo "Environment Variables:"
            echo "  OPENCLAW_CLIENT_ID  Client identifier (default: hostname:pid)"
            echo ""
            echo "Configuration:"
            echo "  Rate limit: $DEFAULT_RATE requests/minute"
            echo "  Burst capacity: $DEFAULT_BURST"
            echo ""
            echo "Examples:"
            echo "  openclaw-memory.sh rate-limit init"
            echo "  openclaw-memory.sh rate-limit check"
            echo "  openclaw-memory.sh rate-limit stats"
            ;;
    esac
}
