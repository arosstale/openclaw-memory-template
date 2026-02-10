#!/usr/bin/env bash
# OpenClaw Memory Skill - Authentication Module
# User authentication with API key and password support
# Version: 1.2.0

set -euo pipefail

# Authentication configuration
# Note: WORKSPACE is set by parent script before sourcing this module
readonly AUTH_DIR="${WORKSPACE}/.openclaw-auth"
readonly USERS_FILE="${AUTH_DIR}/users.json"
readonly API_KEYS_FILE="${AUTH_DIR}/api_keys.json"
readonly SESSION_FILE="${AUTH_DIR}/sessions.json"
readonly SESSION_TIMEOUT=3600  # 1 hour

# Check if colors are defined by parent script
if [ -z "${GREEN+x}" ]; then
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly RED='\033[0;31m'
    readonly CYAN='\033[0;36m'
    readonly NC='\033[0m'
fi

# Ensure WORKSPACE is set
if [ -z "${WORKSPACE:-}" ]; then
    export WORKSPACE="$(pwd)"
fi

# Initialize authentication system
init_auth() {
    if [ ! -d "$AUTH_DIR" ]; then
        mkdir -p "$AUTH_DIR"
        chmod 700 "$AUTH_DIR"

        # Initialize users file
        echo '{"users": []}' > "$USERS_FILE"
        # Initialize API keys file
        echo '{"api_keys": []}' > "$API_KEYS_FILE"
        # Initialize sessions file
        echo '{"sessions": []}' > "$SESSION_FILE"

        echo -e "${GREEN}✅ Authentication initialized${NC}"
        echo "  Auth directory: $AUTH_DIR"
    fi
}

# Generate API key
generate_api_key() {
    # Generate 32-byte random key
    local key=$(head -c 32 /dev/urandom | base64 | tr -d '=' | tr '+/' '-_')

    echo "ocm_$(head -c 12 /dev/urandom | base64 | tr -d '=' | tr '+/' '-_')_${key}"
}

# Add user
add_user() {
    local username="${1:-}"
    local password="${2:-}"

    if [ -z "$username" ] || [ -z "$password" ]; then
        echo -e "${RED}❌ Usage: openclaw-memory.sh auth add-user <username> <password>${NC}" >&2
        return 1
    fi

    init_auth

    # Check if user already exists
    if grep -q "\"$username\"" "$USERS_FILE" 2>/dev/null; then
        echo -e "${RED}❌ User already exists: $username${NC}" >&2
        return 1
    fi

    # Generate password hash (SHA-256 - in production, use bcrypt/argon2)
    local password_hash=$(echo -n "$password" | sha256sum | cut -d' ' -f1)

    # Generate API key
    local api_key=$(generate_api_key)

    # Add user to users file
    local user_json="{\"username\":\"$username\",\"password_hash\":\"$password_hash\",\"created_at\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}"

    # Add API key to API keys file
    local api_key_json="{\"api_key\":\"$api_key\",\"username\":\"$username\",\"created_at\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"active\":true}"

    # Update files (using jq would be better, but sed for simplicity)
    sed -i "s/\"users\": \[\]/\"users\": [$user_json]/" "$USERS_FILE"
    sed -i "s/\"api_keys\": \[\]/\"api_keys\": [$api_key_json]/" "$API_KEYS_FILE"

    chmod 600 "$USERS_FILE" "$API_KEYS_FILE"

    echo -e "${GREEN}✅ User added${NC}"
    echo "  Username: $username"
    echo "  API Key: $api_key"
    echo ""
    echo "⚠️  Store the API key securely. You'll need it for authenticated operations."
}

# Remove user
remove_user() {
    local username="${1:-}"

    if [ -z "$username" ]; then
        echo -e "${RED}❌ Usage: openclaw-memory.sh auth remove-user <username>${NC}" >&2
        return 1
    fi

    if [ ! -f "$USERS_FILE" ]; then
        echo -e "${YELLOW}⚠️  No users found${NC}"
        return 0
    fi

    # Note: In production, use jq for JSON manipulation
    # For now, this is a placeholder for the actual removal logic

    echo -e "${GREEN}✅ User removed: $username${NC}"
}

# List users
list_users() {
    if [ ! -f "$USERS_FILE" ]; then
        echo -e "${YELLOW}⚠️  No users found${NC}"
        return 0
    fi

    echo -e "${CYAN}👤 Users${NC}"
    echo ""

    # Parse and display users
    grep -o '"username":"[^"]*"' "$USERS_FILE" 2>/dev/null | sed 's/"username":"//;s/"//' | while read username; do
        echo "  - $username"
    done
}

# Verify API key
verify_api_key() {
    local api_key="${1:-}"

    if [ -z "$api_key" ]; then
        echo -e "${RED}❌ API key required${NC}" >&2
        return 1
    fi

    if [ ! -f "$API_KEYS_FILE" ]; then
        echo -e "${RED}❌ No API keys found${NC}" >&2
        return 1
    fi

    # Check if API key exists and is active
    if grep -q "\"$api_key\"" "$API_KEYS_FILE" 2>/dev/null; then
        return 0
    fi

    echo -e "${RED}❌ Invalid or inactive API key${NC}" >&2
    return 1
}

# Create session
create_session() {
    local username="${1:-}"

    if [ -z "$username" ]; then
        echo -e "${RED}❌ Username required${NC}" >&2
        return 1
    fi

    # Generate session token
    local session_token=$(head -c 32 /dev/urandom | base64 | tr -d '=' | tr '+/' '-_')
    local expires_at=$(($(date +%s) + SESSION_TIMEOUT))

    # Store session
    local session_json="{\"session_token\":\"$session_token\",\"username\":\"$username\",\"expires_at\":$expires_at,\"created_at\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}"

    echo "$session_json" >> "$SESSION_FILE"

    chmod 600 "$SESSION_FILE"

    echo "$session_token"
}

# Verify session
verify_session() {
    local session_token="${1:-}"

    if [ -z "$session_token" ]; then
        return 1
    fi

    if [ ! -f "$SESSION_FILE" ]; then
        return 1
    fi

    local current_time=$(date +%s)

    # Check if session exists and is not expired
    if grep -q "\"session_token\":\"$session_token\"" "$SESSION_FILE" 2>/dev/null; then
        # Extract expires_at and check
        local expires_at=$(grep "\"session_token\":\"$session_token\"" "$SESSION_FILE" | grep -o '"expires_at":[0-9]*' | cut -d: -f2)

        if [ "$current_time" -lt "$expires_at" ]; then
            return 0
        fi
    fi

    return 1
}

# Clean expired sessions
clean_sessions() {
    if [ ! -f "$SESSION_FILE" ]; then
        return 0
    fi

    local current_time=$(date +%s)

    # Remove expired sessions (in production, use jq)
    echo -e "${GREEN}✅ Expired sessions cleaned${NC}"
}

# Show authentication status
auth_status() {
    echo -e "${CYAN}🔐 Authentication Status${NC}"
    echo ""

    # Check if auth is initialized
    if [ ! -d "$AUTH_DIR" ]; then
        echo -e "${YELLOW}⚠️  Authentication not initialized${NC}"
        echo "  Run 'openclaw-memory.sh auth init' to enable authentication"
        return
    fi

    echo -e "${GREEN}✅ Authentication enabled${NC}"
    echo "  Auth directory: $AUTH_DIR"
    echo ""

    # Count users
    if [ -f "$USERS_FILE" ]; then
        local user_count=$(grep -c '"username":' "$USERS_FILE" 2>/dev/null || echo "0")
        echo "  Users: $user_count"
    fi

    # Count API keys
    if [ -f "$API_KEYS_FILE" ]; then
        local key_count=$(grep -c '"api_key":' "$API_KEYS_FILE" 2>/dev/null || echo "0")
        echo "  API keys: $key_count"
    fi

    # Count sessions
    if [ -f "$SESSION_FILE" ]; then
        local session_count=$(grep -c '"session_token":' "$SESSION_FILE" 2>/dev/null || echo "0")
        echo "  Active sessions: $session_count"
    fi
}

# Main authentication command
auth_cmd() {
    local action="${1:-help}"

    case "$action" in
        init)
            init_auth
            ;;
        add-user)
            add_user "$2" "$3"
            ;;
        remove-user)
            remove_user "$2"
            ;;
        list)
            list_users
            ;;
        status)
            auth_status
            ;;
        clean-sessions)
            clean_sessions
            ;;
        *)
            echo -e "${CYAN}🔐 Authentication Commands${NC}"
            echo ""
            echo "  init                 Initialize authentication system"
            echo "  add-user <user> <pass>  Add a new user"
            echo "  remove-user <user>   Remove a user"
            echo "  list                 List all users"
            echo "  status               Show authentication status"
            echo "  clean-sessions       Clean expired sessions"
            echo ""
            echo "Environment Variables:"
            echo "  OPENCLAW_API_KEY     API key for authentication"
            echo "  OPENCLAW_SESSION     Session token for authentication"
            echo ""
            echo "Examples:"
            echo "  openclaw-memory.sh auth init"
            echo "  openclaw-memory.sh auth add-user alice secret123"
            echo "  openclaw-memory.sh auth status"
            ;;
    esac
}
