# 📚 Research Engine Guide

**Automated Paper Discovery & Summarization for OpenClaw Agents**

---

## 🎯 Overview

The Research Engine provides your agent with a systematic way to discover, organize, and summarize academic papers across 7 domains:

1. **Trading & Finance** - Quantitative strategies, HFT, risk management
2. **Artificial Intelligence** - ML, deep learning, RL, NLP
3. **Cognitive Science** - Memory systems, decision making, neuroscience
4. **Philosophy** - Epistemology, ethics, consciousness
5. **Mathematics** - Optimization, probability, game theory
6. **Computer Science** - Distributed systems, crypto, databases
7. **Physics** - Quantum computing, chaos theory, complex systems

---

## 🚀 Quick Start

```bash
# 1. Initialize Research Engine
./scripts/research.sh init

# 2. Check status
./scripts/research.sh status

# 3. Run daily research cycle
./scripts/research.sh run

# 4. Search specific keywords
./scripts/research.sh search "quantum computing, machine learning"
```

---

## 📁 Structure

```
research/
├── papers/              # Downloaded papers by domain
│   ├── trading/
│   ├── ai/
│   ├── cognitive/
│   ├── philosophy/
│   ├── math/
│   ├── cs/
│   └── physics/
├── summaries/           # AI-generated summaries
├── daily/               # Daily research reports
├── keywords/            # Keyword expansions per domain
├── domains.json         # Domain configuration
├── status.json          # Engine status
└── research.log         # Research logs
```

---

## 🎛️ Domains Configuration

Edit `research/domains.json` to customize:

```json
{
  "trading": {
    "name": "Trading & Finance",
    "keywords": ["quantitative finance", "algorithmic trading", ...],
    "arxiv_categories": ["q-fin.CP", "q-fin.ST", ...]
  }
}
```

### Domain Fields:
- `name`: Display name
- `keywords`: Search terms for paper discovery
- `arxiv_categories`: arXiv categories to search

---

## 🔄 Daily Research Cycle

When you run `./scripts/research.sh run`:

1. **Check** if already run today (skip unless `force`)
2. **Query** each domain's arXiv categories
3. **Download** matching papers (title, abstract, PDF link)
4. **Summarize** using AI (if configured)
5. **Generate** daily report: `daily/DAILY_RESEARCH_YYYY-MM-DD.md`
6. **Update** status.json with metrics

### Daily Report Format:
```markdown
# Daily Research Report: 2026-02-15

**Generated:** 2026-02-15 10:00:00

---

## Trading & Finance

**Keywords:** quantitative finance, algorithmic trading, ...

### Papers Found: 3
1. [Title] - Abstract...
2. [Title] - Abstract...
3. [Title] - Abstract...

## AI

**Keywords:** machine learning, deep learning, ...

### Papers Found: 5
...
```

---

## 🔍 Searching

Search by keywords across all domains:

```bash
./scripts/research.sh search "memory systems, temporal decay"
```

Creates: `daily/results_YYYY-MM-DD.md` with all matching papers.

---

## 📊 Status Monitoring

Check research engine status:

```bash
./scripts/research.sh status
```

Output:
```
=== Research Engine Status ===
Initialized: true
Last Run: 2026-02-15T10:00:00
Total Papers: 785
Domains: 7
Status: completed

Papers by Domain:
  trading: 156
  ai: 234
  cognitive: 89
  philosophy: 42
  math: 78
  cs: 112
  physics: 74
```

---

## 🔧 Advanced Usage

### Force Daily Run
Skip the "already run today" check:

```bash
./scripts/research.sh daily force
```

### Custom Domain
Add new domain to `domains.json`:

```json
{
  "biotech": {
    "name": "Biotechnology",
    "keywords": ["gene editing", "CRISPR", "proteins"],
    "arxiv_categories": ["q-bio.BM", "q-bio.GN"]
  }
}
```

### Keyword Expansion
Add expanded keywords per domain:

```bash
# Create keyword expansion file
echo -e "temporal memory\nbelief decay\nevidence chains" > \
  research/keywords/cognitive/expansions.txt
```

---

## 🤖 AI Integration

To enable AI summarization:

1. Configure OpenAI or Anthropic API key
2. Install: `pip install openai anthropic`
3. Create `scripts/research_summarizer.py`
4. Hook into `research.sh` daily cycle

Example summarizer:
```python
import anthropic
client = anthropic.Anthropic(api_key="sk-...")

def summarize_paper(title, abstract):
    response = client.messages.create(
        model="claude-3-opus-20240229",
        max_tokens=500,
        messages=[{
            "role": "user",
            "content": f"Summarize in 3 bullet points:\n\n{title}\n{abstract}"
        }]
    )
    return response.content[0].text
```

---

## 📈 Metrics Tracked

`research/status.json` tracks:
- `initialized`: Whether engine is set up
- `last_run`: ISO timestamp of last run
- `papers_total`: Total papers downloaded
- `domains`: Number of domains configured
- `status`: Current status (idle, running, completed)

---

## 🎯 Use Cases

### Trading Agent
Monitor daily research for:
- New quantitative strategies
- Market microstructure papers
- Risk management approaches

```bash
./scripts/research.sh run
# Check: daily/DAILY_RESEARCH_YYYY-MM-DD.md
# Focus on: ## Trading & Finance section
```

### AI Research Agent
Track latest in:
- RL algorithms
- Neural architectures
- Foundation models

```bash
./scripts/research.sh run
# Focus on: ## AI section
```

### Philosophy/Cognitive Agent
Study:
- Memory architectures
- Decision-making theories
- Epistemic frameworks

```bash
./scripts/research.sh run
# Focus on: ## Cognitive Science, ## Philosophy
```

---

## 🚢 Production Deployment

### Cron Job (Daily at 9 AM)

```bash
# Edit crontab
crontab -e

# Add line:
0 9 * * * /path/to/agent/workspace/scripts/research.sh run >> /path/to/logs/research.log 2>&1
```

### OpenClaw Heartbeat Integration

Add to `.openclaw/core/HEARTBEAT.md`:

```markdown
- Run research check every morning
  - Check status: `./scripts/research.sh status`
  - Run if new papers found
```

---

## 📚 Reference

- **arXiv API:** https://info.arxiv.org/help/api/index.html
- **arXiv Categories:** https://arxiv.org/category_taxonomy
- **Paper Summarization:** GPT-4, Claude 3 Opus recommended

---

**🎓 Your agent now has a research pipeline. Stay ahead of the curve.**
