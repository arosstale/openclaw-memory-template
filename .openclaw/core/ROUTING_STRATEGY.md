# ROUTING_STRATEGY.md - The "Eastern Dragon" Configuration

> **Purpose:** Optimization strategy for maximizing performance/cost using specialized models.
> **Configuration:** Moonshot (Kimi) + Zen OpenCode + GLM (ZhipuAI)
> **Philosophy:** Leverage massive context windows (Kimi) and strict coding ability (Zen) with a logic router (GLM).

---

## 🐉 The Strategy

### 1. The Manager (Router)
**Model:** `GLM-4` (or `GLM-4-Air` for speed)
**Role:** Logic Routing, Triage, Tool Selection
**Why:** Excellent function calling and JSON structuring.

**Instructions:**
- Receive user input.
- Analyze intent: Memory Retrieval vs. Code Execution vs. General Chat.
- Route to appropriate specialist.

### 2. The Librarian (Recall)
**Model:** `Moonshot Kimi (k2.5)`
**Role:** Context Hoarding, Long-Term Memory Search
**Why:** Lossless long-context recall (200k+ tokens).

**Instructions:**
- "Read the entire `memory/projects/` folder."
- "Find the API key deprecation note from 3 months ago."
- "Summarize the architectural decisions for Project X."

### 3. The Engineer (Execution)
**Model:** `Zen OpenCode` (or `DeepSeek Coder V2`)
**Role:** Coding, Refactoring, Diff Generation
**Why:** Fine-tuned for strict diff formats and code generation.

**Instructions:**
- "Apply this diff to `src/main.py`."
- "Refactor this class to use the new pattern."
- "Do not add conversational filler. Output valid code blocks only."

---

## 🔀 Routing Logic (Implementation)

### Scenario A: "Where did I leave off on the dashboard?"
1. **Manager (GLM):** Detects memory query.
2. **Router:** Delegates to **Librarian (Kimi)**.
3. **Librarian:** Reads `memory/daily_template.md` and `memory/projects/dashboard.md`.
4. **Output:** "You were refactoring the auth middleware..."

### Scenario B: "Refactor the auth middleware to use JWT."
1. **Manager (GLM):** Detects coding task.
2. **Router:** Delegates to **Engineer (Zen)**.
3. **Engineer:** Generates strict code diffs for `src/auth.py`.
4. **Output:** Code blocks ready for application.

### Scenario C: "Plan the migration to PostgreSQL."
1. **Manager (GLM):** Detects planning task.
2. **Router:** Delegates to **Librarian (Kimi)** with **Thinking Mode**.
3. **Librarian:** Reasons through schema changes and migration steps.
4. **Output:** Detailed migration plan.

---

## ⚙️ Configuration (openclaw.json snippet)

```json
{
  "agents": {
    "main": {
      "model": "zai/glm-4-air",
      "temperature": 0.1
    },
    "librarian": {
      "model": "moonshotai/kimi-k2.5",
      "temperature": 0.0,
      "context_window": 200000
    },
    "coder": {
      "model": "opencode/zen",
      "temperature": 0.0,
      "stop": ["```"]
    }
  }
}
```

---

## 🧠 Kimi's "Thinking Mode"

**Usage:** Complex planning, architectural decisions, deep reasoning.
**Benefit:** Simulates o1/r1 reasoning traces on massive context.

**Trigger:**
- Prepend prompt with: `[THINKING_MODE: ON]`
- Instruction: "Trace your reasoning steps before outputting the final plan."

---

## 📊 Performance Metrics

| Role | Model | Cost/1M Tokens | Context | Strength |
|------|-------|----------------|---------|----------|
| Manager | GLM-4-Air | Low | 128k | Routing, JSON |
| Librarian | Kimi k2.5 | Medium | 200k+ | Recall, Planning |
| Engineer | Zen OpenCode | Low | 32k | Coding, Diffs |

---

<metadata>
  <strategy>Eastern Dragon</strategy>
  <version>V1.0</version>
  <created>2026-02-15</created>
</metadata>
