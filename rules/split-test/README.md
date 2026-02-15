# Split-Test: Evolutionary Prompt Tournament
# Part of OpenClaw Memory Template V3.1
# Based On: W007 (The Swarm Beats Giant)
# Inspired By: Sakana.ai Evolutionary Model Merge

---

## 🧬 THE CONCEPT

**Evolution is cheaper than training.**

Instead of rewriting prompts from scratch ("retraining"), we breed effective prompt patterns and let them compete for survival:

```
Parent A (Aggressive) + Parent B (Defensive)
    ↓
  [Tournament: 5 coding tasks]
    ↓
  Winner (Fittest Offspring)
    ↓
  CODER_V2 (New DNA for agent)
```

---

## 📁 DIRECTORY STRUCTURE

```
rules/split-test/
├── README.md (this file)
├── parents/
│   ├── coder_aggressive.md (Speed-first, terse, minimal validation)
│   └── coder_defensive.md (Robustness-first, validation, logging)
├── tournament/
│   └── round_1.md (Task log, scoring, interim results)
└── offspring/
    ├── README.md (Template for generating CODER_V2)
    └── CODER_V2.md (Will be created after tournament)
```

---

## 🎯 TOURNAMENT RULES

### Round 1: Parents Compete
- **Competitors:** coder_aggressive.md vs coder_defensive.md
- **Duration:** 5 coding tasks
- **Assignment:** Randomized 50/50 split
- **Scoring Criteria:**
  - Human Satisfaction (40%)
  - Bug Count (30%)
  - Time to Working (20%)
  - Maintainability (10%)

### Round 2+: Offspring Compete
- **Competitors:** CODER_V2a, CODER_V2b, CODER_V2c
- **Duration:** 5 coding tasks
- **Goal:** Identify fittest variant

---

## 📋 HOW TO USE

### For the Human
During next 5 coding tasks, tell agent which variant to use:

**Example:**
> "Implement feature X using **Aggressive** variant"
> "Debug this using **Defensive** variant"

Or let agent randomize:
> "Randomly choose variant for this task"

### For the Agent
Before each coding task:
1. Check if human specified variant → Use it
2. If not specified → Randomize (50% Aggressive, 50% Defensive)
3. Record result in `tournament/round_1.md`
4. After 5 tasks → Calculate winner

---

## 🧫 GENETIC MARKERS

Each parent has documented DNA:

| Variant | Speed | Validation | Verbosity | Explanation |
|---------|-------|-----------|-----------|------------|
| Aggressive | HIGH | MINIMAL | LOW | TERSE |
| Defensive | MEDIUM | EXTENSIVE | HIGH | DETAILED |

**Offspring will inherit:**
- **Dominant traits** (from winner)
- **Recessive traits** (from loser, if useful)
- **Mutations** (new combinations discovered during tournament)

---

## 📊 SCORING GUIDE

### Human Satisfaction (40%)
- After each task, human answers: "Which variant was more helpful?"
- Score: 1 point per win
- Tally across 5 tasks

### Bug Count (30%)
- Count bugs found in implementation (immediate or later)
- Fewer bugs = higher score
- Self-reported or human-reported

### Time to Working (20%)
- Track time from request to working code
- Faster = higher score (for same quality)
- Measured in minutes

### Maintainability (10%)
- Code readability, documentation, extensibility
- Human rates: 1-5 scale
- Higher = more maintainable

---

## 🏆 WINNER SELECTION

After 5 tasks, calculate total score:

```
Aggressive Score = (Satisfaction × 0.4) + (Low Bugs × 0.3) + (Fast Time × 0.2) + (Maintainability × 0.1)
Defensive Score = (Satisfaction × 0.4) + (Low Bugs × 0.3) + (Fast Time × 0.2) + (Maintainability × 0.1)
```

**Winner** = Higher total score

---

## 🧬 MERGING STRATEGY

Based on tournament winner, create CODER_V2.md:

### Scenario 1: Aggressive Wins
- **Inherit:** Speed, terseness, minimal validation
- **Add from Defensive:** Minimal critical validation (prevent catastrophic bugs)
- **Result:** Speed-focused with safety rails

### Scenario 2: Defensive Wins
- **Inherit:** Validation, logging, error handling
- **Add from Aggressive:** Conciseness (prevent verbosity)
- **Result:** Robustness-focused but efficient

### Scenario 3: Tie or Mixed
- **Inherit:** Best traits from both
- **Context-aware:** Adaptive (Aggressive for prototypes, Defensive for critical systems)
- **Result:** Hybrid approach

---

## 🔄 LIFECYCLE

1. **Parents Created** ✅ (coder_aggressive.md, coder_defensive.md)
2. **Tournament Started** ⏳ (5 coding tasks pending)
3. **Tournament Complete** ⏳ (Winner identified)
4. **Offspring Generated** ⏳ (CODER_V2.md)
5. **Round 2 Started** (If CODER_V2 unclear winner)
6. **Final DNA Locked In** ✅ (Best variant becomes agent default)
7. **Parents Archived** (Move to offspring/ directory)

---

## 📈 METRICS TO TRACK

Over tournament rounds, track evolution:

| Round | Winner | Score | New Traits | Improvement |
|--------|---------|-------|------------|-------------|
| 1 | TBD | TBD | TBD | TBD |
| 2 | TBD | TBD | TBD | TBD |
| 3 | TBD | TBD | TBD | TBD |

---

## 🎯 SUCCESS CRITERIA

**Tournament is successful when:**
- ✅ 5 coding tasks completed with variants
- ✅ Winner clearly identified (no ties)
- ✅ CODER_V2.md generated
- ✅ CODER_V2 validated in next 5 tasks
- ✅ CODER_V2 outperforms or equals best parent

**Evolution is complete when:**
- ✅ Agent consistently uses optimal variant
- ✅ Human satisfaction is high
- ✅ Bug rate is acceptable
- ✅ No further improvement from offspring

---

## 🧬 CONNECTION TO V3.1

This experiment implements **W007 (The Swarm Beats Giant)** and **EVOLUTIONARY_PROMPT_MERGE.md**:

| Component | Connection |
|-----------|-----------|
| **W007** | Validates Compound AI (specialized variants) |
| **EVOLUTIONARY_PROMPT_MERGE.md** | Provides 5-step process |
| **REFLECTIONS.md** | Records tournament results |
| **EVOLUTION.md** | Stores winning patterns (CODER_V2) |
| **CONSOLIDATED_WISDOM.md** | Distills insights to wisdom |

---

## 💡 LESSONS TO LEARN

After tournament, extract wisdom:

| Question | Expected Answer |
|----------|---------------|
| Which tasks need speed? | Quick prototypes, simple logic, exploratory coding |
| Which tasks need robustness? | Critical systems, complex logic, production code |
| What's the optimal balance? | Context-aware adaptation (Aggressive when simple, Defensive when critical) |
| Can both coexist? | Yes, use different variants for different task types |

---

<metadata>
  <type>experiment_readme</type>
  <domain>evolutionary_prompt_merge</domain>
  <created>2026-02-15T20:00:00Z</created>
  <status>ready_for_tournament</status>
  <based_on>W007, EVOLUTIONARY_PROMPT_MERGE.md</based_on>
  <inspired_by>Sakana.ai Evolutionary Model Merge</inspired_by>
</metadata>
