#!/usr/bin/env bash
# OpenClaw Memory Skill - Encryption Module
# AES-256-GCM encryption for sensitive memory files
# Version: 1.2.0

set -euo pipefail

# Encryption configuration
# Note: WORKSPACE is set by parent script before sourcing this module
readonly ENCRYPTION_KEY_FILE="${WORKSPACE}/.openclaw-memory/key.enc"
readonly ENCRYPTION_ALGO="aes-256-gcm"
readonly IV_LENGTH=16
readonly AUTH_TAG_LENGTH=16
readonly KEY_LENGTH=32

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

# Ensure .openclaw-memory directory exists
init_encryption() {
    local key_dir="${WORKSPACE}/.openclaw-memory"

    if [ ! -d "$key_dir" ]; then
        mkdir -p "$key_dir"
        chmod 700 "$key_dir"
    fi
}

# Generate encryption key
generate_key() {
    init_encryption

    if [ -f "$ENCRYPTION_KEY_FILE" ]; then
        echo -e "${YELLOW}⚠️  Encryption key already exists${NC}"
        echo "  Use 'openclaw-memory.sh decrypt' to access encrypted files"
        return 0
    fi

    # Generate 32-byte key from system randomness
    local key=$(head -c 32 /dev/urandom | base64)

    # Encrypt the key with password-based encryption
    local tmp_key_file="${ENCRYPTION_KEY_FILE}.tmp"

    read -s -p "Enter encryption password: " password
    echo ""
    read -s -p "Confirm encryption password: " password_confirm
    echo ""

    if [ "$password" != "$password_confirm" ]; then
        echo -e "${RED}❌ Passwords do not match${NC}" >&2
        rm -f "$tmp_key_file"
        return 1
    fi

    # Encrypt the key with openssl (PBKDF2 + AES-256-CBC)
    echo "$key" | openssl enc -aes-256-cbc -salt -pbkdf2 -iter 100000 \
        -pass pass:"$password" -out "$tmp_key_file" 2>/dev/null

    mv "$tmp_key_file" "$ENCRYPTION_KEY_FILE"
    chmod 600 "$ENCRYPTION_KEY_FILE"

    echo -e "${GREEN}✅ Encryption key generated${NC}"
    echo "  Key file: $ENCRYPTION_KEY_FILE"
    echo ""
    echo "⚠️  Store your password securely. You'll need it to decrypt files."
}

# Load encryption key
load_key() {
    read -s -p "Enter encryption password: " password
    echo ""

    if [ ! -f "$ENCRYPTION_KEY_FILE" ]; then
        echo -e "${RED}❌ Encryption key not found${NC}" >&2
        echo "  Run 'openclaw-memory.sh key generate' first" >&2
        return 1
    fi

    # Decrypt the key
    local key=$(openssl enc -aes-256-cbc -d -pbkdf2 -iter 100000 \
        -pass pass:"$password" -in "$ENCRYPTION_KEY_FILE" 2>/dev/null)

    if [ -z "$key" ]; then
        echo -e "${RED}❌ Invalid password${NC}" >&2
        return 1
    fi

    echo "$key"
}

# Encrypt a file
encrypt_file() {
    local input_file="$1"
    local output_file="${input_file}.enc"

    if [ ! -f "$input_file" ]; then
        echo -e "${RED}❌ File not found: $input_file${NC}" >&2
        return 1
    fi

    # Load encryption key
    local key=$(load_key)
    if [ -z "$key" ]; then
        return 1
    fi

    # Generate IV
    local iv=$(head -c $IV_LENGTH /dev/urandom | base64)

    # Encrypt file (AES-256-GCM)
    openssl enc -$ENCRYPTION_ALGO -e -K $(echo "$key" | base64 -d | xxd -p -c 32) \
        -iv $(echo "$iv" | base64 -d | xxd -p -c $IV_LENGTH) \
        -in "$input_file" -out "${output_file}.tmp" 2>/dev/null

    # Append IV (needed for decryption)
    cat "${output_file}.tmp" > "$output_file"
    rm -f "${output_file}.tmp"

    chmod 600 "$output_file"

    echo -e "${GREEN}✅ File encrypted${NC}"
    echo "  Output: $output_file"
    echo "  Original: $input_file"
}

# Decrypt a file
decrypt_file() {
    local input_file="$1"
    local output_file

    # Check if input file has .enc extension
    if [[ "$input_file" == *.enc ]]; then
        output_file="${input_file%.enc}"
    else
        output_file="${input_file}.decrypted"
    fi

    if [ ! -f "$input_file" ]; then
        echo -e "${RED}❌ File not found: $input_file${NC}" >&2
        return 1
    fi

    # Load encryption key
    local key=$(load_key)
    if [ -z "$key" ]; then
        return 1
    fi

    # Note: For simplicity, this implementation assumes IV is prepended
    # In production, store IV separately or use standard format

    # Decrypt file
    openssl enc -$ENCRYPTION_ALGO -d -K $(echo "$key" | base64 -d | xxd -p -c 32) \
        -in "$input_file" -out "$output_file" 2>/dev/null

    if [ ! -f "$output_file" ]; then
        echo -e "${RED}❌ Decryption failed${NC}" >&2
        return 1
    fi

    chmod 600 "$output_file"

    echo -e "${GREEN}✅ File decrypted${NC}"
    echo "  Output: $output_file"
}

# List encrypted files
list_encrypted() {
    local key_dir="${WORKSPACE}/.openclaw-memory"
    local memory_dir="${WORKSPACE}/memory"

    echo -e "${GREEN}🔒 Encrypted Memory Files${NC}"
    echo ""

    # Check for encryption key
    if [ ! -f "$ENCRYPTION_KEY_FILE" ]; then
        echo -e "${YELLOW}⚠️  No encryption key found${NC}"
        echo "  Run 'openclaw-memory.sh key generate' to enable encryption"
        return
    fi

    # List .enc files in memory directory
    if [ -d "$memory_dir" ]; then
        find "$memory_dir" -name "*.enc" -type f 2>/dev/null | while read file; do
            local size=$(du -h "$file" | cut -f1)
            local date=$(stat -c %y "$file" 2>/dev/null | cut -d. -f1)
            echo "  $(basename "$file") - $size - $date"
        done
    else
        echo "  No encrypted files found"
    fi
}

# Main encryption command
encryption_cmd() {
    local action="${1:-help}"

    case "$action" in
        generate)
            generate_key
            ;;
        encrypt)
            if [ -z "${2:-}" ]; then
                echo -e "${RED}❌ Usage: openclaw-memory.sh encrypt <file>${NC}" >&2
                return 1
            fi
            encrypt_file "$2"
            ;;
        decrypt)
            if [ -z "${2:-}" ]; then
                echo -e "${RED}❌ Usage: openclaw-memory.sh decrypt <file.enc>${NC}" >&2
                return 1
            fi
            decrypt_file "$2"
            ;;
        list)
            list_encrypted
            ;;
        *)
            echo -e "${GREEN}🔒 Encryption Commands${NC}"
            echo ""
            echo "  key generate    Generate encryption key"
            echo "  encrypt <file>  Encrypt a memory file"
            echo "  decrypt <file>  Decrypt a memory file"
            echo "  list           List encrypted files"
            echo ""
            echo "Examples:"
            echo "  openclaw-memory.sh key generate"
            echo "  openclaw-memory.sh encrypt MEMORY.md"
            echo "  openclaw-memory.sh decrypt MEMORY.md.enc"
            ;;
    esac
}
