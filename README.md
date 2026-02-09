# OpenClaw V2.1 - Elite Swarm Architecture

> **Pi** 🐺 - Self-evolving, hardware-aware, swarm-ready agent.

The Elite V2.1 self-aware memory template for OpenClaw agents. Shift from chatbot to proactive, multi-agent intelligence.

## Quick Start

```bash
# 1. Clone this repository
git clone https://github.com/arosstale/openclaw-memory-template.git
cd openclaw-memory-template

# 2. Run the welcome script (recommended)
bash scripts/welcome.sh

# Or, manual setup:
# 3. Start PostgreSQL sidecar (optional but recommended)
docker-compose -f docker-compose.postgres.yml up -d

# 4. Start QMD sidecar for ultra-fast search (optional, recommended)
docker-compose -f docker-compose.qmd.yml up -d
```

## V2.1 Elite Features

| Feature | Description |
|---------|-------------|
| **GEPA Integration** | Self-correcting mutation engine on failures |
| **PostgreSQL Sidecar** | Docker Compose setup for structured data |
| **QMD Sidecar** | Hybrid BM25+Vector search for ultra-fast retrieval |
| **Swarm Protocol** | Multi-agent coordination and handoff system |
| **Dual-Core Memory** | PostgreSQL (structured) + QMD (semantic) + Markdown (truth) |
| **Hardware-Aware** | Thermal monitoring and adaptive compute scaling |
| **Genetic Versioning** | Git-tagged mutations for easy rollback |
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
- **Three-tier memory**: Ephemeral session context → PostgreSQL durable storage → QMD semantic search
- **Dual-Core Search**: QMD (BM25 + Vector) for current logs, PostgreSQL for historical queries
- **Markdown source of truth**: All durable data backed by `.md` files
- **Pre-Compaction Flush**: Auto-archive to MEMORY.md at 80% context capacity

### QMD Integration (Optional, Recommended)
- **Local-first search**: Zero cloud dependency with Bun + node-llama-cpp
- **Hybrid search**: Vector (70%) + BM25 (30%) for precision
- **Auto-indexing**: Real-time indexing of `memory/` folder
- **Context prevention**: Offloads search to prevent context choke on Pi hardware

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

## PostgreSQL & QMD Setup

```bash
# Start PostgreSQL sidecar
docker-compose -f docker-compose.postgres.yml up -d

# Start QMD sidecar (for ultra-fast search)
docker-compose -f docker-compose.qmd.yml up -d

# Check PostgreSQL health
docker exec openclaw-postgres pg_isready -U openclaw -d openclaw_elite

# Access Qdrant vector DB at http://localhost:6333
# Access pgadmin at http://localhost:5050
# Default pgadmin: admin@openclaw.local / admin_change_me
```

## Maintenance Scripts

```bash
# Weekly PostgreSQL maintenance (vacuum & indexing)
bash scripts/postgres-maintenance.sh

# Monthly full vacuum (run on 1st of month)
bash scripts/postgres-maintenance.sh --vacuum-full

# Archive logs older than 30 days to PostgreSQL
bash scripts/prune-elite.sh

# Check Pi thermal status before heavy compute
bash scripts/thermal-check.sh

# Prune old Git Notes to keep repo lean
bash scripts/prune-notes.sh
```

## Support

- **Community**: https://discord.com/invite/clawd
- **Documentation**: See individual `.md` files
- **Source**: https://github.com/openclaw/openclaw

---

**Version**: 2.1 Elite | **Status**: Production Ready | **Last Updated**: 2026-02-09
