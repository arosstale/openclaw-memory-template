# EVOLUTION.md - Neuroplasticity (Learned Patterns)

> **Bio-Inspired Function:** Neuroplastic adaptation
> **Purpose:** "How we work" vs. "What we did"
> **A-Mem Pattern:** Memory as an updated instruction set

---

## 🧬 EVOLUTIONARY RULES

### Self-Reflective Memory Update
> "Whenever a task takes more than 3 attempts, identify the friction point.
> Update EVOLUTION.md to prevent this mistake globally.
> Memory is not just history; it is an updated instruction set."

### Pattern Classification
- **Procedural:** "Always use X before doing Y"
- **Cognitive:** "User prefers concise responses"
- **Environmental:** "This project uses Python 3.11 only"
- **Anti-Patterns:** "Never use rm -rf without confirmation"

---

## 📊 LEARNED PATTERNS

<pattern id="E001">
  <discovered>2026-02-15T16:00:00Z</discovered>
  <friction_point>
    <context>Package installation failing repeatedly</context>
    <attempts>5</attempts>
    <root_cause>Global permissions required</root_cause>
  </friction_point>
  
  <evolution>
    <type>procedural</type>
    <rule>Always check for global install requirements before pip install</rule>
    <implementation>Use `pip show` to check, then `sudo pip install` if needed</implementation>
    <prevention>Check ERRORS.md for "permissions" before attempting install</prevention>
  </evolution>
  
  <confidence_score>0.95</confidence_score>
  <entropy>high</entropy>
  <reference_count>12</reference_count>
</pattern>

<pattern id="E002">
  <discovered>2026-02-14T10:30:00Z</discovered>
  <friction_point>
    <context>User annoyed by emoji usage in error logs</context>
    <attempts>2</attempts>
    <root_cause>Inappropriate tone for error reporting</root_cause>
  </friction_point>
  
  <evolution>
    <type>cognitive</type>
    <rule>Never use emojis in error messages or critical logs</rule>
    <implementation>Plain text, professional tone for errors</implementation>
    <prevention>Review tone before sending error reports</prevention>
  </evolution>
  
  <confidence_score>0.90</confidence_score>
  <entropy>medium</entropy>
  <reference_count>8</reference_count>
</pattern>

<pattern id="E003">
  <discovered>2026-02-13T14:20:00Z</discovered>
  <friction_point>
    <context>Git commits failing with "nothing to commit"</context>
    <attempts>4</attempts>
    <root_cause>Not checking git status before commit</root_cause>
  </friction_point>
  
  <evolution>
    <type>procedural</type>
    <rule>Always run `git status` before `git commit`</rule>
    <implementation>Add pre-commit check in all git workflows</implementation>
    <prevention>Check working tree status first</prevention>
  </evolution>
  
  <confidence_score>0.85</confidence_score>
  <entropy>medium</entropy>
  <reference_count>15</reference_count>
</pattern>

---

## 🎯 ANTI-PATTERNS (Never Do These)

<anti_pattern id="A001">
  <discovered>2026-02-10T09:00:00Z</discovered>
  <severity>critical</severity>
  <rule>NEVER run `rm -rf` without explicit confirmation</rule>
  <consequence>Data loss</consequence>
  <alternative>Use `trash` command or move to `/tmp`</alternative>
  <reference_count>23</reference_count>
</anti_pattern>

<anti_pattern id="A002">
  <discovered>2026-02-08T16:45:00Z</discovered>
  <severity>high</severity>
  <rule>NEVER assume file paths without checking first</rule>
  <consequence>File not found errors, broken scripts</consequence>
  <alternative>Always use `ls -la` to verify paths</alternative>
  <reference_count>18</reference_count>
</anti_pattern>

---

## 🔄 EVOLUTION TRIGGERS

### Automatic Pattern Detection
- Task takes >3 attempts → Auto-create pattern entry
- User expresses frustration → Cognitive pattern trigger
- Same error repeated 2+ times → Procedural pattern trigger
- Critical failure → Anti-pattern trigger

### Manual Pattern Creation
- User says "Remember this for next time"
- User asks "Why does this keep happening?"
- Agent identifies improvement opportunity

---

## 📈 EVOLUTION METRICS

| Pattern Type | Count | Avg Confidence | Avg References |
|--------------|--------|----------------|----------------|
| Procedural   | 3      | 0.87           | 12.3           |
| Cognitive    | 1      | 0.90           | 8.0            |
| Environmental| 0      | 0.00           | 0.0            |
| Anti-Patterns| 2      | 1.00           | 20.5           |

**Total Evolution Points:** 6
**Last Updated:** [ISO-8601]

---

<metadata>
  <bio_layer>neuroplasticity</bio_layer>
  <a_mem_pattern>true</a_mem_pattern>
  <evolution_trigger>3_attempts</evolution_trigger>
  <last_updated>[ISO-8601]</last_updated>
</metadata>
