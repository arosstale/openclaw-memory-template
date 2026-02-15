# LEARNINGS.md - Soft Learnings & Observations

> **Format:** Append-Only with Weekly Summarization
> **Purpose:** Observations, patterns, behavioral notes
> **Constraint:** Never edit existing entries. Append only.
> **Maintenance:** Summarize weekly, move old entries to ARCHIVE_LEARNINGS.md

---

## How to Add New Learnings

**Format:**
```xml
<learning>
<timestamp>[ISO-8601 Date]</timestamp>
<observation>What happened</observation>
<context>Additional context</context>
<confidence>high|medium|low</confidence>
</learning>
```

---

## Recent Learnings (Last 7 Days)

<learning>
<timestamp>[YYYY-MM-DD]</timestamp>
<observation>INSERT_LEARNING_HERE</observation>
<context>INSERT_CONTEXT_HERE</context>
<confidence>medium</confidence>
</learning>

<!-- Add new learnings above this line -->

---

## Weekly Summary (Last Summary: [YYYY-MM-DD])

**Summary of Key Patterns:**

- [Pattern 1]
- [Pattern 2]
- [Pattern 3]

**Archived Entries:** [Count]

---

## Guidelines for Adding Learnings

### What Goes Here:
- User preferences observed over time
- Communication patterns
- Working style observations
- Decision-making tendencies
- Reaction patterns
- Habitual requests

### What Goes in MEMORY.md:
- Hard facts (name, contact info)
- Static preferences (always, never)
- System configurations
- API keys and credentials structure
- File paths and aliases

### Confidence Levels:
- **High**: Observed 5+ times consistently
- **Medium**: Observed 2-4 times
- **Low**: Observed once, pattern unclear

---

## Weekly Maintenance Task

**Frequency:** Weekly (e.g., every Sunday)

**Process:**
1. Review learnings older than 7 days
2. Identify patterns and consolidate
3. If high confidence → Move to MEMORY.md as fact
4. Summarize remaining in Weekly Summary
5. Archive old entries to `memory/ARCHIVE_LEARNINGS.md`

**Compression Prompt:**
```
Review LEARNINGS.md entries older than 7 days.
Identify:
1. Patterns appearing 5+ times → Move to MEMORY.md
2. Repeated themes → Consolidate into single summary
3. Low-confidence entries → Flag for review
4. Move processed entries to memory/ARCHIVE_LEARNINGS.md
Update Weekly Summary with consolidated insights.
```

---

## Example Learnings

<learning>
<timestamp>2026-02-15T14:30:00Z</timestamp>
<observation>User prefers concise responses when on mobile (Telegram)</observation>
<context>Detected from message length complaints on Telegram vs desktop</context>
<confidence>high</confidence>
</learning>

<learning>
<timestamp>2026-02-14T09:15:00Z</timestamp>
<observation>User runs security checks before deploying code</observation>
<context>Consistent pattern in last 3 deployments</context>
<confidence>high</confidence>
</learning>

<learning>
<timestamp>2026-02-13T16:45:00Z</timestamp>
<observation>User appreciates emoji reactions on completed tasks</observation>
<context>Positive feedback received after adding 🎉 reactions</context>
<confidence>medium</confidence>
</learning>

---

## Metadata

<stats>
<total_learnings>3</total_learnings>
<high_confidence>2</high_confidence>
<medium_confidence>1</medium_confidence>
<low_confidence>0</low_confidence>
<last_summary>[YYYY-MM-DD]</last_summary>
<next_summary>[YYYY-MM-DD]</next_summary>
</stats>
