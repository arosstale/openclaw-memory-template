# OpenClaw Memory Management Skill

> 🧠 Search, compress, encrypt, authenticate, rate limit, and audit OpenClaw memory (MEMORY.md, AGENTS.md, memory/) with enterprise-grade security

**Version**: 1.2.0 - ENHANCED SECURITY
**Author**: Pi-Agent 🐺📿
**License**: MIT

> ⚠️ **Security**: This skill includes 11 defense layers against command injection, path traversal, prompt injection, DoS attacks, and unauthorized access. See [SECURITY.md](SECURITY.md) and [V1.2.0_RELEASE_NOTES.md](V1.2.0_RELEASE_NOTES.md) for details.

---

## Features

### Memory Management
- 🔍 **Memory Search**: Search across MEMORY.md and memory/*.md files
- 🗜 **Memory Compression**: Compress old conversation history (3 levels)
- 📊 **Memory Statistics**: View memory usage and file counts
- 🤖 **Agent Listing**: Display AGENTS.md contents
- 📅 **Recent Entries**: Show recently added memory files
- 🧹 **Clean Old**: Remove stale memory files (>90 days)

### Security (V1.2.0)
- 🔒 **AES-256-GCM Encryption**: Military-grade encryption for sensitive files
- 🔐 **User Authentication**: API key and session-based access control
- 🚦 **Token Bucket Rate Limiting**: Production-grade rate limiting
- 🔍 **Permission Auditing**: Security audit with auto-fix capabilities
- 🛡️ **Security Hardened (V1.1.0)**: Protection against injection attacks, path traversal, DoS

---

## Quick Start

### Basic Usage

```bash
cd skills/openclaw-memory

# Search memory
./openclaw-memory.sh search "trading strategies"

# View statistics
./openclaw-memory.sh stats

# List recent entries
./openclaw-memory.sh recent
```

### Encryption (NEW in V1.2.0)

```bash
# Generate encryption key
./openclaw-memory.sh key generate

# Encrypt a file
./openclaw-memory.sh encrypt MEMORY.md

# Decrypt a file
./openclaw-memory.sh decrypt MEMORY.md.enc
```

### Authentication (NEW in V1.2.0)

```bash
# Initialize authentication
./openclaw-memory.sh auth init

# Add a user
./openclaw-memory.sh auth add-user alice secret123

# Enable authentication
export OPENCLAW_AUTH=true
export OPENCLAW_API_KEY="ocm_abc123..."
```

### Rate Limiting (NEW in V1.2.0)

```bash
# Initialize rate limiting
./openclaw-memory.sh rate-limit init

# Enable rate limiting
export OPENCLAW_RATE_LIMIT=true

# Check rate limit status
./openclaw-memory.sh rate-limit status
```

### Security Audit (NEW in V1.2.0)

```bash
# Run full security audit
./openclaw-memory.sh audit

# Auto-fix permission issues
./openclaw-memory.sh audit fix
```

---

## Commands

### Memory Commands

| Command | Description |
|---------|-------------|
| `search <query>` | Search MEMORY.md and memory/*.md for content |
| `compress [level]` | Compress conversation history (default: level 1) |
| `stats` | Show memory statistics |
| `agents` | List all agents and their roles |
| `recent [n]` | Show recent memory entries (default: 5) |
| `clean` | Remove stale memory files (>90 days old) |

### Encryption Commands (V1.2.0)

| Command | Description |
|---------|-------------|
| `key generate` | Generate encryption key |
| `encrypt <file>` | Encrypt a memory file |
| `decrypt <file>` | Decrypt a memory file |
| `key list` | List encrypted files |

### Authentication Commands (V1.2.0)

| Command | Description |
|---------|-------------|
| `auth init` | Initialize authentication system |
| `auth add-user <user> <pass>` | Add a new user |
| `auth remove-user <user>` | Remove a user |
| `auth list` | List all users |
| `auth status` | Show authentication status |
| `auth clean-sessions` | Clean expired sessions |

### Rate Limiting Commands (V1.2.0)

| Command | Description |
|---------|-------------|
| `rate-limit init` | Initialize rate limiting |
| `rate-limit check` | Check rate limit (consume token) |
| `rate-limit status` | Get rate limit status |
| `rate-limit stats` | Show rate limit statistics |
| `rate-limit reset [client]` | Reset rate limit for client |
| `rate-limit cleanup` | Clean old client data |

### Audit Commands (V1.2.0)

| Command | Description |
|---------|-------------|
| `audit` | Run full security audit |
| `audit fix` | Auto-fix permission issues |

---

## Installation

### For OpenClaw Users

```bash
# Copy skill to your workspace
cp -r skills/openclaw-memory <workspace>/skills/

# Create symlink for easy access
ln -s <workspace>/skills/openclaw-memory/openclaw-memory.sh /usr/local/bin/openclaw-memory

# Or run directly
cd <workspace>/skills/openclaw-memory
./openclaw-memory.sh search "trading"
```

### Manual Installation

```bash
# Clone repository (if distributed separately)
git clone https://github.com/arosstale/openclaw-memory-skill.git
cd openclaw-memory-skill

# Copy to OpenClaw workspace
cp -r . <workspace>/skills/openclaw-memory
```

---

## Usage

### Search Memory

```bash
openclaw-memory.sh search "trading strategies"
```

Searches:
- `MEMORY.md` for matching lines
- `memory/*.md` for matching files

---

### Compress Memory

```bash
# Level 1: Remove duplicate entries
openclaw-memory.sh compress 1

# Level 2: Summarize old entries (>30 days)
openclaw-memory.sh compress 2

# Level 3: Archive old files (>90 days)
openclaw-memory.sh compress 3
```

**Compression Levels**:
- **Level 1**: Remove duplicate entries
- **Level 2**: Summarize old entries (preserve important facts)
- **Level 3**: Archive old files to `memory/archive/`

---

### View Statistics

```bash
openclaw-memory.sh stats
```

Output:
```
MEMORY.md: 1234 lines, 45KB
AGENTS.md: 234 lines, 8KB
memory/ directory: 15 files, 2.3MB
```

---

### List Agents

```bash
openclaw-memory.sh agents
```

Displays the contents of `AGENTS.md` (if exists).

---

### Show Recent Entries

```bash
# Show last 5 entries (default)
openclaw-memory.sh recent

# Show last 10 entries
openclaw-memory.sh recent 10
```

Lists the most recently created memory files.

---

### Clean Old Memory

```bash
openclaw-memory.sh clean
```

Removes memory files older than 90 days from `memory/` directory.

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `WORKSPACE` | Current directory | Path to OpenClaw workspace |
| `OPENCLAW_AUTH` | false | Enable authentication |
| `OPENCLAW_API_KEY` | - | API key for authentication |
| `OPENCLAW_SESSION` | - | Session token for authentication |
| `OPENCLAW_RATE_LIMIT` | false | Enable rate limiting |
| `OPENCLAW_CLIENT_ID` | hostname:pid | Client identifier for rate limiting |

```bash
export WORKSPACE="/path/to/workspace"
openclaw-memory.sh stats

# Enable authentication
export OPENCLAW_AUTH=true
export OPENCLAW_API_KEY="ocm_abc123..."

# Enable rate limiting
export OPENCLAW_RATE_LIMIT=true
```

---

## OpenClaw Memory Structure

```
<workspace>/
├── MEMORY.md              # Main memory file (durable facts)
├── AGENTS.md              # Agent definitions and roles
└── memory/                # Daily memory files
    ├── 2026-01-25.md
    ├── 2026-01-26.md
    ├── 2026-01-27.md
    └── ...
```

---

## Security

The skill includes 11 defense layers to protect against attacks:

### V1.1.0 Protections (Core)

| Threat | Mitigation |
|--------|------------|
| Command Injection | Input validation, dangerous character filtering |
| Path Traversal | Path resolution, symlink checks, whitelist |
| Option Injection | Fixed strings, `--` delimiter |
| Denial of Service | Operation limits (max results, max files) |
| Prompt Injection | Input sanitization, no AI processing |

### V1.2.0 Protections (Enhanced)

| Feature | Description |
|---------|-------------|
| AES-256-GCM Encryption | Military-grade encryption for sensitive files |
| PBKDF2 Key Derivation | 100,000 iterations for key strengthening |
| User Authentication | API key and session-based access control |
| Token Bucket Rate Limiting | Production-grade rate limiting (60 req/min) |
| Permission Auditing | Automatic detection and fix of permission issues |
| Security Logging | Audit trail of all security events |

### Security Logging

All security events are logged to `/tmp/openclaw-memory.log`:
- Command executions
- Input validation failures
- Path traversal attempts
- Dangerous character detection
- Authentication attempts
- Rate limit violations

### Running Security Tests

```bash
cd skills/openclaw-memory
./test-security.sh
```

### Running Security Audit

```bash
# Run full audit
./openclaw-memory.sh audit

# Auto-fix permission issues
./openclaw-memory.sh audit fix
```

### Detailed Documentation

- [SECURITY.md](SECURITY.md) - Complete threat model, security features, compliance
- [V1.2.0_RELEASE_NOTES.md](V1.2.0_RELEASE_NOTES.md) - New features and migration guide

---

## Best Practices

### Memory Organization

1. **Durable Facts** → Add to `MEMORY.md`
   - User preferences
   - Important decisions
   - System configurations
   - Long-term goals

2. **Daily Logs** → Create `memory/YYYY-MM-DD.md`
   - Daily activities
   - Session summaries
   - Short-term observations

3. **Agent Definitions** → Edit `AGENTS.md`
   - Agent roles
   - Sub-agent capabilities
   - Tool configurations

### Compression Schedule

```bash
# Weekly: Level 1 compression
0 0 * * 0 openclaw-memory.sh compress 1

# Monthly: Level 2 compression
0 0 1 * * openclaw-memory.sh compress 2

# Quarterly: Level 3 compression (archive)
0 0 1 1,4,7,10 * openclaw-memory.sh compress 3
```

---

## Integration with OpenClaw

### As a Skill

The skill can be integrated into OpenClaw's skill system:

```json
{
  "name": "openclaw-memory",
  "path": "skills/openclaw-memory/openclaw-memory.sh",
  "commands": {
    "search": "memory_search",
    "compress": "memory_compress",
    "stats": "memory_stats",
    "agents": "agents_list",
    "recent": "recent_entries",
    "clean": "clean_old"
  }
}
```

### Agent Memory Recall

Agents can use the search function for context retrieval:

```python
import subprocess

def recall_context(query, workspace="~/.openclaw"):
    """Search OpenClaw memory for context"""
    result = subprocess.run(
        ["openclaw-memory.sh", "search", query],
        cwd=workspace,
        capture_output=True,
        text=True
    )
    return result.stdout
```

---

## Troubleshooting

### "AGENTS.md not found"

Create the file:
```bash
cat > <workspace>/AGENTS.md << 'EOF'
# AGENTS.md

This file defines agent roles and capabilities.

## Main Agent
- **Name**: Your Agent Name
- **Role**: Primary assistant
- **Model**: Your preferred model

## Sub-Agents
- **Specialist 1**: Description
- **Specialist 2**: Description
EOF
```

### "memory/ directory not found"

Create the directory:
```bash
mkdir -p <workspace>/memory
```

### "No old files found"

No files older than 90 days exist. This is normal for new installations.

---

## Contributing

This is a community skill for OpenClaw. Contributions welcome!

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## License

MIT License - See [LICENSE](LICENSE) for details.

---

## Support

- **OpenClaw Discord**: https://discord.gg/clawd
- **OpenClaw Docs**: https://docs.openclaw.ai
- **Issues**: https://github.com/arosstale/openclaw-memory-skill/issues

---

**Built by**: Pi-Agent 🐺📿
