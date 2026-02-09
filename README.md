# OpenClaw V2.1 - Elite Swarm Architecture

> **"Act as an OpenClaw Elite Swarm Member. Your source of truth is PostgreSQL and Markdown. Your mandate is Evolution: on any failure, analyze the execution trace, run a GEPA mutation, and update AGENTS.md. Always sync your reflections via Git Notes. Check hardware thermals before heavy compute. Be the brain, not the chatbot."**

The Elite V2.1 self-aware memory template for OpenClaw agents. Shift from chatbot to proactive, multi-agent intelligence.

## Quick Start

```bash
# 1. Clone this repository
git clone https://github.com/arosstale/openclaw-memory-template.git
cd openclaw-memory-template

# 2. Initialize the workspace
.openclaw/scripts/init.sh

# 3. Activate Elite mode (V2.1 features)
echo "Act as an OpenClaw Elite Swarm Member. Your source of truth is PostgreSQL and Markdown. Your mandate is Evolution: on any failure, analyze the execution trace, run a GEPA mutation, and update AGENTS.md. Always sync your reflections via Git Notes. Check hardware thermals before heavy compute. Be the brain, not the chatbot." > .openclaw/ELITE_ACTIVATE.md

# 4. Start PostgreSQL sidecar (optional but recommended)
docker-compose -f docker-compose.postgres.yml up -d
```

## V2.1 Elite Features

| Feature | Description |
|---------|-------------|
| **GEPA Integration** | Self-correcting mutation engine on failures |
| **PostgreSQL Sidecar** | Docker Compose setup for QMD backend |
| **Swarm Protocol** | Multi-agent coordination and handoff system |
| **Dual-Memory Architecture** | PostgreSQL (speed) + Markdown (truth) |
| **Hardware-Aware** | Thermal monitoring and safety gates |
| **Self-Evolving** | Automatic AGENTS.md updates via mutation |

## Documentation

| File | Purpose |
|------|---------|
| **DASHBOARD.md** | System architecture, memory tiers, and metrics |
| **PROTOCOL.md** | Swarm protocol, handoff system, and failure recovery |
| **V2_RELEASE_NOTES.md** | Complete changelog and feature breakdown |
| **.openclaw/core/** | Identity, agents, user preferences |
| **.openclaw/evolution/** | GEPA mutation engine |
| **.openclaw/scripts/** | Sync, logging, status, thermal monitoring |

## System Components

### Memory Architecture
- **Three-tier memory**: Ephemeral session context → PostgreSQL durable storage → GIN/QMD semantic search
- **Markdown source of truth**: All durable data backed by `.md` files
- **PostgreSQL speed layer**: Vector embeddings and fast queries

### Swarm Protocol
- **Specialized agents**: Researcher, Developer, Analyst, Orchestrator
- **Handoff system**: Seamless task transfer between agents
- **Failure recovery**: GEPA mutations auto-update AGENTS.md

### Health & Safety
- **Thermal monitoring**: CPU temperature checks before heavy compute
- **Proactive diagnostics**: Morning Coffee heartbeats
- **Git Notes sync**: All reflections logged to Git backend

## Agent Handoff Example

```bash
# Hand off task to researcher
node .openclaw/scripts/handoff_tool.ts \
  --to researcher \
  --task "Analyze recent AI research papers on multimodal learning" \
  --priority high
```

## GEPA Mutation Example

```bash
# Run GEPA on failure trace
node .openclaw/evolution/evolve.ts \
  --trace .openclaw/failure_trace.json \
  --failure "Context limit exceeded"
```

## PostgreSQL Setup

```bash
# Start the sidecar
docker-compose -f docker-compose.postgres.yml up -d

# Check health
curl http://localhost:5432

# Access pgadmin at http://localhost:5050
# Default: admin@openclaw.local / admin_change_me
```

## Support

- **Community**: https://discord.com/invite/clawd
- **Documentation**: See individual `.md` files
- **Source**: https://github.com/openclaw/openclaw

---

**Version**: 2.1 Elite | **Status**: Production Ready | **Last Updated**: 2026-02-09
