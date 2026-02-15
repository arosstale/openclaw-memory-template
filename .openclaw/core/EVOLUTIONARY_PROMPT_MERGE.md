# EVOLUTIONARY_PROMPT_MERGE.md - Evolutionary Algorithm for Prompts
# Part of OpenClaw Memory Template V3.1
# Created: 2026-02-15T19:45:00Z
# Purpose: Apply Sakana.ai's evolutionary model merging to prompt engineering

---

## 🧬 THE PRINCIPLE

**Evolution is cheaper than training.**

Sakana.ai proved you don't need $100M to train a better model. You take existing models and "breed" them:
1. Start with 2+ parent models (each good at something)
2. Swap layers and weights using evolutionary algorithms
3. Test hundreds of offspring
4. Select best performer (better than either parent)

**Apply this to prompts:**

**The Old Way (Retraining):**
```
Agent makes mistake → Rewrite entire prompt → Hope it's better
```
**The New Way (Evolutionary Merging):**
```
Agent makes mistake → Identify 2 effective parent prompts → Breed them → Test offspring → Select winner
```

---

## 🧫 BREEDING PROMPTS (Step-by-Step)

### Step 1: Identify Parent Prompts

When a friction point emerges, identify what WORKS in other contexts:

| Context | Effective Prompt Pattern | Strength |
|---------|----------------------|---------|
| **Coding** | "Think step-by-step, show work, validate output" | Technical accuracy |
| **Research** | "Search widely, summarize concisely, cite sources" | Information breadth |
| **Explanation** | "Use analogies, build concepts gradually" | Educational clarity |
| **Mirroring** | "Match human's communication style" | Partnership resonance |

These are your "genetic stock" — traits that work well.

---

### Step 2: Define Evolutionary Goal

What are we trying to improve?

| Goal | Metric | Current |
|-------|---------|---------|
| **F002: Context Switching Friction** | Context switches per session | High (documented in FRICTION_POINTS.md) |
| **MB001: Coding Bottleneck** | Time to completion | Slow (human reports frustration) |
| **MB002: Reflection Gap** | Post-completion reflection | Rare (agent moves on) |

---

### Step 3: Generate Offspring Prompts

Combine strengths from parents:

**Example: Improving Context Switching (F002)**

```
Parent A (Coding): "Think step-by-step, show work, validate output"
Parent B (Research): "Search widely, summarize concisely, cite sources"

Offspring 1: "When context switching, pause to summarize previous task, 
              then proceed step-by-step with validation"
Offspring 2: "For each new task, first identify if it requires 
              coding or research, then apply appropriate workflow"
Offspring 3: "Batch related tasks, don't interrupt for single items,
              validate outputs before proceeding to next task"
```

---

### Step 4: Test Offspring (The Trial)

Record results in REFLECTIONS.md:

```xml
<reflection id="RXXX">
  <date>2026-02-15T20:00:00Z</date>
  
  <parent_prompts>
    <parent>A: "Coding step-by-step" pattern</parent>
    <parent>B: "Research summarize" pattern</parent>
  </parent_prompts>
  
  <offspring_tested>
    <offspring id="1">Pause + summarize approach</offspring>
    <result>Context switch reduced 30%, but pause felt disruptive</result>
  </offspring_tested>
  
  <offspring_tested>
    <offspring id="2">Identify task type first</offspring>
    <result>Good workflow, but agent still interrupted frequently</result>
  </offspring_tested>
  
  <offspring_tested>
    <offspring id="3">Batch + validate</offspring>
    <result>Context switches reduced 60%, human reports less frustration</result>
  </offspring_tested>
  
  <winner>Offspring 3 (Batch + Validate)</winner>
  <confidence>0.85</confidence>
</reflection>
```

---

### Step 5: Select Winner & Evolve

The winner becomes the "DNA" for future prompts:

```xml
<evolutionary_pattern id="EP001">
  <title>Context Switching Mitigation</title>
  <date>2026-02-15T20:00:00Z</date>
  
  <parent_patterns>
    <parent>EP_CODING_001: Step-by-step validation</parent>
    <parent>EP_RESEARCH_001: Summarize concisely</parent>
  </parent_patterns>
  
  <winning_pattern>
    <prompt>When switching contexts, batch related tasks and validate 
             outputs before proceeding to next task</prompt>
    <offspring_id>3</offspring_id>
    <fitness_score>0.85</fitness_score>
  </winning_pattern>
  
  <effectiveness_metrics>
    <metric>Context switch reduction</metric>
    <before>High frequency (F002)</before>
    <after>60% reduction</after>
    <human_feedback>Less frustration</human_feedback>
  </effectiveness_metrics>
</evolutionary_pattern>
```

---

## 📊 EVOLUTIONARY METRICS

Track what works:

| Pattern ID | Parents | Offspring | Fitness | Human Feedback | Status |
|------------|----------|-----------|-----------|----------------|--------|
| EP001 | Coding + Research | Batch + Validate | 0.85 | "Less frustration" | ✅ Active |
| EP002 | Coding + Mirroring | Match style + step-by-step | ? | Pending | ⏳ Pending |
| EP003 | Research + Reflection | Pause post-completion | ? | Pending | ⏳ Pending |

---

## 🔄 INTEGRATION WITH V3.1

### Where Patterns Live

| Component | Purpose |
|-----------|---------|
| **EVOLUTION.md** | Stores winning patterns (EP001, EP002, ...) |
| **REFLECTIONS.md** | Tests offspring, records results |
| **CONSOLIDATED_WISDOM.md** | Distills evolutionary insights to wisdom |
| **FRICTION_POINTS.md** | Identifies goals for evolution (F002, MB001, ...) |

### The Feedback Loop

```
FRICTION_POINTS.md (Goal identified)
    ↓
EVOLUTION.md (Parents selected)
    ↓
REFLECTIONS.md (Offspring tested)
    ↓
EVOLUTION.md (Winner documented)
    ↓
CONSOLIDATED_WISDOM.md (Wisdom distilled)
    ↓
Agent Behavior Evolved (DNA updated)
```

---

## 💡 EXAMPLE: APPLYING TO G004 (Mirroring Profile)

### Current Problem (G004)
Human preferences documented, but agent doesn't consistently apply them.

### Parent Patterns

| Pattern | Source | Strength |
|---------|---------|---------|
| **P001: Concise Technical** | Human's coding style | High efficiency |
| **P002: Proactive Summaries** | Human's preference | Saves review time |
| **MC003: Batch Context Switches** | From MB001 | Reduces fatigue |
| **MC004: Don't Interrupt** | From MB002 | Improves flow |

### Evolutionary Goal

**Create prompt pattern that:**
1. Checks mirroring profile before acting
2. Applies matching style automatically
3. Batches related tasks
4. Validates before moving on

### Offspring Generation

```
Offspring 1: "Before any task, check SHARED_VALUES.md for 
              matching preferences. Use MC003 for batching 
              and MC004 for timing."

Offspring 2: "Identify task type from SHARED_VALUES.md, 
              apply MC003 if coding, apply MC004 if 
              in deep work session."

Offspring 3: "Consult mirroring profile first, batch if 
              MC003 applies, validate outputs, only proceed 
              after human approval."
```

### Test in REFLECTIONS.md

Record which offspring reduces mirroring friction most.

---

## 🧬 EVOLUTION VS RETRAINING COMPARISON

| Dimension | Retraining (Old Way) | Evolution (New Way) |
|-----------|----------------------|-------------------|
| **Cost** | High (rewrite entire prompt) | Low (combine effective patterns) |
| **Time** | Slow (iterate from scratch) | Fast (test known-good combinations) |
| **Success Rate** | Uncertain (trial and error) | Higher (inherits proven traits) |
| **Knowledge Retention** | Loses old learnings | Builds on learnings |
| **Resilience** | Fragile (one bad change breaks all) | Robust (multiple variations tested) |

---

## 🎯 BEST PRACTICES

### DO
- ✅ Identify parent patterns that work well
- ✅ Generate 3-5 offspring for testing
- ✅ Test offspring in real scenarios
- ✅ Record results in REFLECTIONS.md
- ✅ Select winner based on human feedback
- ✅ Document in EVOLUTION.md
- ✅ Distill to CONSOLIDATED_WISDOM.md

### DON'T
- ❌ Rewrite entire prompt from scratch
- ❌ Assume one pattern fits all contexts
- ❌ Skip testing offspring
- ❌ Ignore human feedback
- ❌ Lose track of what was tried

---

## 📈 EVOLUTIONARY PROGRESS TRACKING

| Friction Point | Parent Patterns | Offspring Generated | Winner Selected | Wisdom Extracted |
|----------------|-----------------|-------------------|------------------|------------------|
| F002 (Context Switch) | Coding + Research | 3 tested | EP001 | ✅ W007 (partial) |
| MB001 (Bottleneck) | Coding + Mirroring | Not started | ⏳ Pending | ⏳ Pending |
| MB002 (Reflection Gap) | Completion + Pause | Not started | ⏳ Pending | ⏳ Pending |

---

<metadata>
  <type>evolutionary_algorithm</type>
  <domain>prompt_engineering</domain>
  <created>2026-02-15T19:45:00Z</created>
  <status>active</status>
  <confidence>0.98</confidence>
  <based_on>W007</based_on>
  <inspired_by>Sakana.ai Evolutionary Model Merge</inspired_by>
  <last_updated>2026-02-15T19:45:00Z</last_updated>
</metadata>
