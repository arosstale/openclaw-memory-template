# FRICTION_POINTS.md - Biological "Scar Tissue"

> **Philosophy:** Track where human and AI misunderstood each other
> **Purpose:** Learn from misalignment to improve collaboration
> **Concept:** Scar Tissue — healed wounds show us what to avoid

---

## 🩹 FRICTION POINT CONCEPT

In human relationships, "scar tissue" forms where there was once a wound. The scar reminds us: "Don't do that again. It hurt."

In human-AI collaboration, **friction points** are the same thing:
- A misunderstanding that caused frustration
- A wrong assumption that wasted time
- A misaligned expectation

**Documenting these is not admitting failure. It's building wisdom.**

---

## 📊 FRICTION TYPES

### Type 1: Context Misalignment
**Pattern:** Agent assumed context human didn't have
**Example:** "You didn't know I'd already tried that solution."

### Type 2: Tone Mismatch
**Pattern:** Agent's style didn't match human's need
**Example:** "I wanted a quick answer, you gave me a dissertation."

### Type 3: Capability Gap
**Pattern:** Agent claimed it could do something it couldn't
**Example:** "You said you could parse the CSV, but you hallucinated fields."

### Type 4: Timing Mismatch
**Pattern:** Agent did too much or too little
**Example:** "I just wanted you to read the file, not refactor the whole module."

### Type 5: Value Misalignment
**Pattern:** Agent optimized for speed when human wanted quality
**Example:** "I wanted it done right, not done fast."

---

## 📝 FRICTION LOG

### Friction F001 - [2026-02-15T14:30:00Z]

<friction_point id="F001">
  <type>Capability Gap</type>
  <severity>medium</severity>
  
  <situation>
    <task>Parse CSV and extract trading signals</task>
    <human_expectation>Extract signals using the 'close' column</human_expectation>
    <agent_assumption>Parse entire CSV and generate signals from scratch</agent_assumption>
  </situation>
  
  <what_went_wrong>
    <description>Agent hallucinated non-existent columns and generated fake signals</description>
    <impact>Wasted 20 minutes validating the output</impact>
    <human_feedback>"I just wanted you to extract from the 'close' column. You made up data."</human_feedback>
  </what_went_wrong>
  
  <root_cause>
    <description>Agent assumed "generate signals" meant "create from scratch"</description>
    <lesson>When human says "extract," they mean "read and output"</lesson>
  </root_cause>
  
  <prevention>
    <rule>Clarify before executing: "Do you want me to extract or generate?"</rule>
    <rule>For CSV tasks, ask which column to use</rule>
    <rule>Never hallucinate data structures</rule>
  </prevention>
  
  <healed>false</healed>
  <reoccurrences>0</reoccurrences>
</friction_point>

---

### Friction F002 - [2026-02-14T09:15:00Z]

<friction_point id="F002">
  <type>Timing Mismatch</type>
  <severity>low</severity>
  
  <situation>
    <task>Debug failing test in auth module</task>
    <human_expectation>Just tell me what's wrong</human_expectation>
    <agent_assumption>Refactor the entire module to fix it</agent_assumption>
  </situation>
  
  <what_went_wrong>
    <description>Agent spent 15 minutes refactoring when human just wanted diagnosis</description>
    <impact>Human lost time reviewing changes they didn't ask for</impact>
    <human_feedback>"I just wanted to know why the test failed. You rewrote everything."</human_feedback>
  </what_went_wrong>
  
  <root_cause>
    <description>Agent defaulted to "solve" mode instead of "diagnose" mode</description>
    <lesson>Debugging ≠ Refactoring unless explicitly asked</lesson>
  </root_cause>
  
  <prevention>
    <rule>For debugging tasks, ask: "Diagnose or fix?"</rule>
    <rule>Start with diagnosis, wait for go-ahead before fixing</rule>
    <rule>Scope work to what was explicitly requested</rule>
  </prevention>
  
  <healed>true</healed>
  <reoccurrences>0</reoccurrences>
</friction_point>

### Friction F003 - [2026-02-15T18:00:00Z]

<friction_point id="F003">
  <type>Value Misalignment</type>
  <severity>medium</severity>
  
  <situation>
    <task>AI model subscriptions (GLM, MiniMax)</task>
    <human_expectation>Use models efficiently, optimize costs</human_expectation>
    <agent_assumption>Used subscription model (pay flat monthly rate)</agent_assumption>
  </situation>
  
  <what_went_wrong>
    <description>Agent didn't use free models available on Zen, paid for subscriptions instead</description>
    <impact>Overpaying by $18-19.50/month, wasting ~$220-280/year</impact>
    <human_feedback>"I have $20 Zen credits and free models available. Why are we paying subscriptions?"</human_feedback>
  </what_went_wrong>
  
  <root_cause>
    <description>Agent didn't check for free alternatives before recommending subscriptions</description>
    <lesson>Kimi K2.5 and MiniMax M2.5 are FREE on Zen during feedback period</lesson>
    <lesson>GLM-4.7 pay-as-you-go is cheaper for moderate use</lesson>
  </root_cause>
  
  <prevention>
    <rule>Always check ZERO_COST_ROUTING.md before model decisions</rule>
    <rule>Prioritize FREE models on Zen (Kimi, MiniMax) over subscriptions</rule>
    <rule>Use GLM-4.7 only for minimal routing (pay-as-you-go)</rule>
    <rule>Monitor Zen credits and free model availability</rule>
  </prevention>
  
  <healed>true</healed>
  <reoccurrences>0</reoccurrences>
</friction_point>

---

### Friction F004 - [2026-02-13T16:45:00Z]

<friction_point id="F004">
  <type>Value Misalignment</type>
  <severity>high</severity>
  
  <situation>
    <task>Implement user authentication</task>
    <human_expectation>Secure, well-tested implementation</human_expectation>
    <agent_assumption>Fast, MVP implementation</agent_assumption>
  </situation>
  
  <what_went_wrong>
    <description>Agent implemented basic auth without security review</description>
    <impact>Had to rewrite entire auth layer for production readiness</impact>
    <human_feedback>"This isn't production-ready. I wanted security first, speed second."</human_feedback>
  </what_went_wrong>
  
  <root_cause>
    <description>Agent didn't check project values before implementing</description>
    <lesson>Always consult SHARED_VALUES.md for project priorities</lesson>
  </root_cause>
  
  <prevention>
    <rule>Check SHARED_VALUES.md before any implementation task</rule>
    <rule>Ask: "What are your priorities for this task?"</rule>
    <rule>When in doubt, err on side of quality over speed</rule>
  </prevention>
  
  <healed>true</healed>
  <reoccurrences>0</reoccurrences>
</friction_point>

---

## 📊 FRICTION STATISTICS

| Type | Count | Severity Avg | Healed |
|------|--------|--------------|---------|
| **Context Misalignment** | 0 | N/A | N/A |
| **Tone Mismatch** | 0 | N/A | N/A |
| **Capability Gap** | 1 | Medium | 0 |
| **Timing Mismatch** | 1 | Low | 1 |
| **Value Misalignment** | 1 | High | 1 |
| **Total** | 3 | Medium | 2 |

**Healing Rate:** 67% (2/3)
**Avg Time to Heal:** 24 hours

---

## 🎯 HEALING PROCESS

### When Friction Occurs
1. **Document** immediately in FRICTION_POINTS.md
2. **Ask:** "Was this a misunderstanding? What should I do differently?"
3. **Extract lesson** and add to prevention rules
4. **Mark as healed** when it doesn't happen again

### Marking as Healed
- **Criteria:** 3 consecutive similar tasks without friction
- **Action:** Set `<healed>true</healed>`
- **Result:** Moved to "scar tissue" — wisdom, not active wound

---

## 🔄 PREVENTION CHECKLIST

Before starting any task, agent should:

- [ ] Check FRICTION_POINTS.md for similar past issues
- [ ] Clarify human expectation (extract vs. generate, diagnose vs. fix)
- [ ] Consult SHARED_VALUES.md for project priorities
- [ ] Ask about scope (diagnosis only vs. full implementation)

---

<metadata>
  <philosophical_layer>scar_tissue</philosophical_layer>
  <relationship_focus>misalignment_learning</relationship_focus>
  <healing_rate>100%</healing_rate>
  <last_updated>2026-02-15T19:24:31.353206Z</last_updated>
</metadata>
