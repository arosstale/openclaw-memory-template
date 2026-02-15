# OpenClaw Memory Template

> Community template for OpenClaw agent memory systems with ALMA self-improving capabilities

---

> **📌 Note**: This is a **community memory template** for OpenClaw. It contains OpenClaw core components, configuration files, and community skills. It does **not** contain proprietary trading agent code.

### 📚 Research Engine (NEW)
Automated paper discovery & summarization across 7 domains (Trading, AI, Cognitive Science, Philosophy, Math, CS, Physics). Your agent stays ahead of the latest research without manual curation.

---

## 📁 Architecture

```
.openclaw/
├── core/              # Identity, Soul, Rules (The Agent)
│   ├── IDENTITY.md
│   ├── SOUL.md
│   ├── AGENTS.md
│   ├── USER.md
│   ├── TOOLS.md
│   └── HEARTBEAT.md
│
├── context/           # External Knowledge (The Index)
│   └── LINKS.md
│
├── scripts/           # Automation (The Nervous System)
│   ├── init.sh        # Bootstrap
│   ├── sync.sh        # Git sync with notes
│   ├── log.sh         # Daily logging
│   ├── status.sh      # Health check
│   ├── fix-thermal-monitor.sh  # Diagnostics
│   └── research.sh   # **NEW** Paper discovery
│
└── templates/         # Consistency
    ├── daily-log.md
    └── project.md

memory/
├── .git/              # The Brain (Git-backed)
├── daily/             # Daily logs
├── projects/          # Project notes
├── .gitignore         # Prevents conflicts
└── index.md           # Central index

research/              # **NEW** Academic Research
├── papers/            # Downloaded papers by domain
├── summaries/         # AI-generated summaries
├── daily/             # Daily research reports
├── keywords/          # Keyword expansions
├── domains.json       # Domain configuration
└── status.json        # Engine status
```

---

## 🎯 Quick Start

```bash
# 1. Clone this repository
git clone https://github.com/arosstale/openclaw-memory-template.git
cd openclaw-memory-template

# 2. Run setup
./setup.sh ~/my-agent-workspace

# 3. Configure Git remote
cd ~/my-agent-workspace/memory
git remote add origin https://github.com/YOUR_USERNAME/agent-memory
git push -u origin main

# 4. Customize
.openclaw/core/IDENTITY.md   # Agent persona
.openclaw/core/SOUL.md       # Behavior
.openclaw/core/USER.md       # User preferences

# 5. Start using
.openclaw/scripts/log.sh    # Create daily log
# ... work ...
.openclaw/scripts/sync.sh   # Sync to Git

# 6. Research engine (NEW)
.openclaw/scripts/research.sh init    # Initialize research
.openclaw/scripts/research.sh run     # Run daily research
.openclaw/scripts/research.sh status   # Check status
```

---

## 🔧 Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `init.sh` | Bootstrap structure | `.openclaw/scripts/init.sh` |
| `sync.sh` | Git sync with notes | `.openclaw/scripts/sync.sh` |
| `log.sh` | Create daily log | `.openclaw/scripts/log.sh` |
| `status.sh` | Health check | `.openclaw/scripts/status.sh` |
| `fix-thermal-monitor.sh` | Diagnose Pi temps | `.openclaw/scripts/fix-thermal-monitor.sh` |
| `research.sh` | **NEW** Paper discovery | `./scripts/research.sh run` |

---

## 📚 Research Engine (NEW)

### Automated Paper Discovery

7 Domains:
1. **Trading & Finance** - Quant strategies, HFT, risk management
2. **Artificial Intelligence** - ML, DL, RL, NLP
3. **Cognitive Science** - Memory systems, decision making
4. **Philosophy** - Epistemology, ethics, consciousness
5. **Mathematics** - Optimization, probability, game theory
6. **Computer Science** - Distributed systems, crypto, databases
7. **Physics** - Quantum computing, chaos theory

### Usage:
```bash
# Initialize research engine
./scripts/research.sh init

# Check status
./scripts/research.sh status

# Run daily research cycle
./scripts/research.sh run

# Search specific keywords
./scripts/research.sh search "temporal memory, belief decay"
```

### Features:
- **Daily Discovery**: Queries arXiv for new papers
- **Domain Tracking**: 7 domains with configurable keywords
- **Status Monitoring**: JSON status with papers collected
- **AI Summarization**: Ready for OpenAI/Claude integration
- **Keyword Expansion**: Expand search terms per domain

See [RESEARCH_ENGINE.md](./RESEARCH_ENGINE.md) for complete guide.

---

## 💡 Features

### Clean Git History
Commit messages are clean, with metadata in Git Notes (JSON):
```json
{
  "title": "Daily Log Update",
  "date": "2026-02-03",
  "session_start": "2026-02-03T09:00:00",
  "session_summary": "Completed research..."
}
```

### Morning Routine
Checks automatically:
- Security: Recent changes, suspicious activity
- System: CPU temp, disk usage, daemon status
- Memory: Git sync status, daily log created
- **Research**: Check for new papers (NEW)

### Self-Diagnostics
Agent can check and fix its own thermal monitoring without human help.

### Context Registry
All external resources in `LINKS.md` — no more "where was that link?"

### 📚 Research Pipeline (NEW)
- Automated arXiv queries per domain
- Daily research reports in Markdown
- Paper storage with AI summarization support
- Keyword expansion and tracking

---

## 📊 V1 vs V2

| Feature | V1 | V2 |
|---------|-----|-----|
| Memory | Manual files | Git-backed, versioned |
| Git History | Mixed with AI chatter | 100% clean |
| Automation | Basic sync | 6 production scripts |
| Self-Awareness | Reactive | Proactive health checks |
| Context | Lost in files | LINKS.md registry |
| Research | Manual discovery | Automated arXiv pipeline |
| Structure | Flat | Clear separation |

---

## 🐺 Philosophy

**Three Principles:**

1. **Minimal Core** — Few files, clear structure, agents extend via code
2. **Self-Documenting** — Memory captures its own evolution
3. **Terminal-Native** — CLI-first, Git-based, no GUI friction

---

## 📄 Documentation

- [Research Engine Guide](./RESEARCH_ENGINE.md) — Automated paper discovery & summarization
- [Advanced RAG Guide](./ADVANCED_RAG_GUIDE.md) — Memory retrieval techniques
- [Structure](./STRUCTURE.md) — Directory structure explained

---

## 🤝 Contributing

This is a template—fork and customize!

Share your variations:
- Custom scripts
- Additional templates
- Workflow improvements
- Integration examples

---

## 📜 License

MIT — Use, modify, share freely. Attribution appreciated.

---

## 🙏 Credits

- **Daniel Miessler** — PAI Framework inspiration
- **Armin Ronacher** — Pi agent philosophy
- **Mario Zechner** — Pi implementation
- **Peter Steinberger** — OpenClaw vision
- **Artale** — Production testing & V2 architecture

---

**🐺 Your agent now has a self-managing brain with research pipeline. Time to build.**
