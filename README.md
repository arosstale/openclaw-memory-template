# OpenClaw Memory Template

> Community template for OpenClaw agent memory systems

---

> **📌 Note**: This is a **community memory template** for OpenClaw. It contains OpenClaw core components, configuration files, and community skills. It does **not** contain proprietary trading agent code.

---

## Quick Start

```bash
# 1. Clone this repository
git clone https://github.com/arosstale/openclaw-memory-template.git
cd openclaw-memory-template

# 2. Run welcome script (recommended)
bash scripts/welcome.sh

# 3. Initialize Observational Memory (V2.4)
bash scripts/init-observational-memory.sh

# 4. Start PostgreSQL sidecar (optional but recommended)
docker-compose -f docker-compose.postgres.yml up -d

# 5. Start QMD sidecar (for ultra-fast search, optional, recommended)
docker-compose -f docker-compose.qmd.yml up -d

# 6. Run tests
python3 test_observational_memory.py
```

---

## V2.4 Features

### Observational Memory (PAOM) 🆕

| Feature | Description |
|----------|-------------|
| **Three-Agent System** | Observer, Reflector, Actor |
| **Emoji Prioritization** | 🔴 (critical), 🟡 (important), 🟢 (info) |
| **Temporal Tracking** | Observation date, referenced date, relative time |
| **Context Compression** | 75% reduction (4:1 to 13:1) |
| **LongMemEval Accuracy** | 94.87% with gpt-5-mini |

### Core Features

| Feature | Description |
|----------|-------------|
| **Zero-Knowledge Proofs** | Cryptographic task verification |
| **Proof-Based Reputation** | Mathematically verified proofs |
| **Swarm Protocol** | Multi-agent coordination |
| **Dual-Core Memory** | PostgreSQL (structured) + QMD (semantic) |
| **Hardware-Aware** | Thermal monitoring and adaptive compute |
| **GEPA** | Self-correcting mutation engine |

---

## Architecture

```
┌────────────────────────────────────────────────────┐
│          OpenClaw Memory Template               │
├────────────────────────────────────────────────────┤
│                                                │
│  ┌──────────────────┐  ┌──────────────┐       │
│  │ Observational    │  │  QMD         │       │
│  │ Memory (PAOM)    │  │  (semantic)  │       │
│  │                  │  │              │       │
│  └──────────────────┘  └──────────────┘       │
│           │                       │               │
│           └─────────────┬─────────┘               │
│                         ↓                       │
│              Unified Memory System                │
│                         ↓                       │
│              Actor (Main Agent)                 │
└────────────────────────────────────────────────────┘
```

---

## Documentation

| Document | Purpose |
|----------|---------|
| **README.md** | Main documentation |
| **V2.4_RELEASE_NOTES.md** | V2.4 changelog |
| **MIGRATION_V24.md** | Migration guide from V2.3 |
| **DASHBOARD.md** | System architecture |
| **PROTOCOL.md** | Swarm protocol |
| **CONTRIBUTING.md** | Contribution guidelines |

### Component Documentation

| Component | Location |
|-----------|----------|
| **Observational Memory** | `.openclaw/observational_memory/` |
| **PAOM Docs** | `.openclaw/docs/OBSERVATIONAL_MEMORY.md` |
| **Unified Memory** | `.openclaw/memory/` |
| **Zero-Knowledge Proofs** | `.openclaw/zkp/` |
| **GEPA Evolution** | `.openclaw/evolution/` |

---

## Observational Memory Usage

```python
from openclaw.observational_memory import ObservationalMemory, ObservationConfig

# Initialize
config = ObservationConfig(
    observation_threshold=30000,  # 30k tokens
    reflection_threshold=40000,   # 40k tokens
)
om = ObservationalMemory(config)

# Process messages
messages = [
    {"role": "user", "content": "I have 2 kids", "timestamp": datetime.now()},
]
record = om.process_messages("thread-123", messages)

# Get context
context = om.get_context("thread-123")

# Get stats
stats = om.get_stats("thread-123")
```

---

## Unified Memory System

```python
from openclaw.memory import UnifiedMemorySystem

# Initialize
system = UnifiedMemorySystem()

# Process interaction
context = system.process_interaction(
    thread_id="thread-123",
    messages=messages,
)

# Get stats
stats = system.get_unified_stats("thread-123")
```

---

## Testing

```bash
# Run Observational Memory tests
python3 test_observational_memory.py

# Run GEPA validation
bash scripts/gepa-test.sh

# Run ZKP test suite
bash scripts/zkp-test.sh

# Run stability test
bash scripts/stability-test.sh
```

### Test Results

```
==================================================
Results: 9 passed, 0 failed
==================================================
```

---

## Configuration

### Observational Memory

```python
from openclaw.observational_memory import ObservationConfig

config = ObservationConfig(
    observation_threshold=30000,  # 30k tokens
    reflection_threshold=40000,   # 40k tokens
    observer_temperature=0.3,      # LLM temperature
    reflector_temperature=0.0,      # Condensation temperature
    db_path=".openclaw/observational_memory.db",
)
```

---

## PostgreSQL & QMD Setup

```bash
# Start PostgreSQL
docker-compose -f docker-compose.postgres.yml up -d

# Start QMD
docker-compose -f docker-compose.qmd.yml up -d

# Check health
docker exec openclaw-postgres pg_isready -U openclaw -d openclaw_elite
```

---

## Support

- **Community**: https://discord.com/invite/clawd
- **Documentation**: See individual `.md` files
- **Source**: https://github.com/openclaw/openclaw

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| **V2.4** | 2026-02-10 | Mastra Observational Memory, test suite |
| **V2.3** | 2026-02-01 | Zero-Knowledge Proofs, Swarm protocol |
| **V2.2** | 2026-01-20 | Swarm Intelligence, cross-agent knowledge transfer |
| **V1.2** | 2026-01-15 | Enhanced security, encryption, auth |

---

**Version**: 2.4 Observational Memory Enhanced | **Status**: 🟢 Production Ready | **Last Updated**: 2026-02-10
