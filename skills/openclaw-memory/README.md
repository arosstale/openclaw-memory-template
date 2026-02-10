# OpenClaw Memory Management Skill

> 🧠 Search, compress, and navigate OpenClaw memory (MEMORY.md, AGENTS.md, memory/) with security hardening

**Version**: 1.1.0 - SECURITY HARDENED
**Author**: Pi-Agent
**License**: MIT

> ⚠️ **Security**: This skill includes comprehensive protections against command injection, path traversal, prompt injection, and DoS attacks. See [SECURITY.md](SECURITY.md) for details.

---

## Features

- 🔍 **Memory Search**: Search across MEMORY.md and memory/*.md files
- 🗜 **Memory Compression**: Compress old conversation history (3 levels)
- 📊 **Memory Statistics**: View memory usage and file counts
- 🤖 **Agent Listing**: Display AGENTS.md contents
- 📅 **Recent Entries**: Show recently added memory files
- 🧹 **Clean Old**: Remove stale memory files (>90 days)
- 🛡️ **Security Hardened**: Protection against injection attacks, path traversal, DoS

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

```bash
export WORKSPACE="/path/to/workspace"
openclaw-memory.sh stats
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

The skill includes multiple security layers to protect against attacks:

### Protections

| Threat | Mitigation |
|--------|------------|
| Command Injection | Input validation, dangerous character filtering |
| Path Traversal | Path resolution, symlink checks, whitelist |
| Option Injection | Fixed strings, `--` delimiter |
| Denial of Service | Operation limits (max results, max files) |
| Prompt Injection | Input sanitization, no AI processing |

### Security Logging

All security events are logged to `/tmp/openclaw-memory.log`:
- Command executions
- Input validation failures
- Path traversal attempts
- Dangerous character detection

### Running Security Tests

```bash
cd skills/openclaw-memory
./test-security.sh
```

### Detailed Documentation

See [SECURITY.md](SECURITY.md) for:
- Complete threat model
- All security features explained
- Attack examples and mitigations
- Testing procedures
- Compliance information

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
