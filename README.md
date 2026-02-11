# OpenClaw Memory Template

> Community template for OpenClaw agent memory systems with ALMA self-improving capabilities

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

# 3. Initialize Observational Memory
bash scripts/init-observational-memory.sh

# 4. Run ALMA+PAOM self-improving demo
python3 alma_paom_integration.py

# 5. Start PostgreSQL sidecar (optional)
docker-compose -f docker-compose.postgres.yml up -d

# 6. Run tests
python3 test_observational_memory.py
```

---

## V2.5 Features

### 🆕 ALMA Self-Improving Systems

Based on the ALMA research paper (https://arxiv.org/pdf/2602.07755):

> "Agentic systems that learn to improve all aspects of their agentic system, including their memory, learning to continually learn while solving problems in ever-changing real-world environments!"

**Key Innovation**: AI systems should learn **HOW to optimize**, not just **WHAT to execute**.

### Core Components

| Feature | Description |
|----------|-------------|
| **ALMA Meta-Learning** | Automatic design discovery and optimization |
| **Observational Memory (PAOM)** | Context compression + temporal tracking |
| **Knowledge System** | Semantic codebase search and indexing |
| **ALMA+PAOM Integration** | Self-improving memory system |
| **LLM Integration** | Anthropic, OpenAI, Google support |
| **Tiktoken** | 100% accurate token counting |
| **CLI Tool** | Full command-line interface |

### Core Features

| Feature | Description |
|----------|-------------|
| **Zero-Knowledge Proofs** | Cryptographic task verification |
| **Proof-Based Reputation** | Mathematically verified proofs |
| **Swarm Protocol** | Multi-agent coordination |
| **Dual-Core Memory** | PostgreSQL (structured) + QMD (semantic) |
| **Hardware-Aware** | Thermal monitoring and adaptive compute |
| **GEPA** | Self-correcting mutation engine |
| **ALMA Self-Improvement** | Meta-learning for automatic optimization |

---

## Architecture

```
┌────────────────────────────────────────────────────────────┐
│          OpenClaw Self-Improving Memory Template        │
├────────────────────────────────────────────────────────────┤
│                                                        │
│  ┌──────────────────┐  ┌──────────────┐       │
│  │      ALMA        │  │   PAOM       │       │
│  │  Meta-Learning  │  │  Memory       │       │
│  │                  │  │              │       │
│  └──────────────────┘  └──────────────┘       │
│           │                      │               │
│           └─────────────┬─────────┘               │
│                         ↓                        │
│            Self-Improving System                 │
│                         ↓                        │
│              Actor (Main Agent)                 │
└────────────────────────────────────────────────────────────┘
```

---

## Documentation

| Document | Purpose |
|----------|----------|
| **README.md** | Main documentation |
| **V2.5_RELEASE_NOTES.md** | V2.5 changelog |
| **V2.4_RELEASE_NOTES.md** | V2.4 changelog |
| **MIGRATION_V24.md** | Migration guide from V2.3 |
| **SELF_IMPROVING_ROADMAP.md** | 5-phase roadmap |
| **DASHBOARD.md** | System architecture |
| **PROTOCOL.md** | Swarm protocol |
| **CONTRIBUTING.md** | Contribution guidelines |
| **CHANGELOG.md** | Version history |

### Component Documentation

| Component | Location |
|-----------|----------|
| **Observational Memory** | `.openclaw/observational_memory/` |
| **PAOM Docs** | `.openclaw/docs/OBSERVATIONAL_MEMORY.md` |
| **PAOM API** | `.openclaw/docs/OBSERVATIONAL_MEMORY_API.md` |
| **ALMA Agent** | `.openclaw/alma/alma_agent.py` |
| **Unified Memory** | `.openclaw/memory/` |
| **Zero-Knowledge Proofs** | `.openclaw/zkp/` |
| **GEPA Evolution** | `.openclaw/evolution/` |

---

## ALMA+PAOM Self-Improving

### Quick Start

```python
from alma_paom_integration import ALMAPAOSystem

# Initialize self-improving system
system = ALMAPAOSystem()

# Run meta-learning cycle
designs = system.run_meta_learning_cycle(
    num_iterations=5,
    num_designs_per_iteration=3,
)

# Best design is automatically applied
best_design = system.alma.get_best_design()
print(f"Best design: {best_design.design_id} (score: {best_design.performance_score:.2f})")
```

### Command-Line Demo

```bash
python3 alma_paom_integration.py
```

**Output**:
```
🐺📿 Self-Improving Memory System Example
============================================================

🚀 Initial optimization...

🔄 Iteration 1/3
🔧 Applied design parameters:
   observation_threshold: 30000
   reflection_threshold: 50000
   llm_provider: google
✅ Applied design: cd6c0e53 (score: 88.20)

...

🏆 Best design: cd6c0e53
   Score: 88.20

✅ Self-improving system example complete
```

---

## Observational Memory Usage

```python
from .openclaw.observational_memory import ObservationalMemory, ObservationConfig

# Initialize
config = ObservationConfig(
    observation_threshold=30000,
    reflection_threshold=40000,
)
om = ObservationalMemory(config)

# Process messages
messages = [
    {"role": "user", "content": "I have 2 kids", "timestamp": datetime.now()},
]
record = om.process_messages("thread-123", messages)

# Get context
context = om.get_context("thread-123")
```

---

## CLI Tools

### Observational Memory CLI

```bash
# Observe messages
python scripts/observational-memory-cli.py observe <thread> -f messages.json

# Get context
python scripts/observational-memory-cli.py context <thread>

# Get stats
python scripts/observational-memory-cli.py stats <thread>

# Force reflection
python scripts/observational-memory-cli.py reflect <thread>

# List threads
python scripts/observational-memory-cli.py list
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
from .openclaw.observational_memory import ObservationConfig

config = ObservationConfig(
    observation_threshold=30000,  # 30k tokens
    reflection_threshold=40000,   # 40k tokens
    observer_temperature=0.3,      # LLM temperature
    reflector_temperature=0.0,      # LLM temperature
    llm_provider="anthropic",        # LLM provider
    use_tiktoken=True,              # Tiktoken
    db_path=".openclaw/observational_memory.db",
)
```

### ALMA

```python
from .openclaw.alma.alma_agent import ALMAAgent

alma = ALMAAgent(db_path=".openclaw/alma_designs.db")
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

## Research Foundation

### ALMA Paper

- **Title**: Algorithm Learning via Meta-learning Agents
- **Authors**: Xiong, Hu, and Clune
- **arXiv**: https://arxiv.org/pdf/2602.07755
- **Code**: https://github.com/zksha/alma
- **Website**: https://yimingxiong.me/alma

### Key Insight

> "Agentic systems that learn to improve all aspects of their agentic system, including their memory, learning to continually learn while solving problems in ever-changing real-world environments!"

### Connections to Our Systems

**V7 Trading System**
- ✅ ALMA enables meta-learning of strategy weights
- System learns HOW to optimize, not just WHAT to execute

**Tick Orchestrator**
- ✅ ALMA enables continual learning of agent routing
- Self-improving multi-agent coordination

**RBI Research Engine**
- ✅ ALMA-enhanced research engine
- Continual improvement in paper discovery

---

## Support

- **Community**: https://discord.com/invite/clawd
- **Documentation**: See individual `.md` files
- **Source**: https://github.com/openclaw/openclaw

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| **V2.5** | 2026-02-10 | ALMA meta-learning, self-improving systems |
| **V2.4** | 2026-02-10 | Mastra Observational Memory, test suite |
| **V2.3** | 2026-02-01 | Zero-Knowledge Proofs, Swarm protocol |
| **V2.2** | 2026-01-20 | Swarm Intelligence, cross-agent knowledge transfer |
| **V1.2** | 2026-01-15 | Enhanced security, encryption, auth |

---

**Version**: 2.5 ALMA Self-Improving | **Status**: 🟢 Production Ready | **Last Updated**: 2026-02-10
