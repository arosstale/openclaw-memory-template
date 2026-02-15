# BUFFER.md - Short-Term Synapse (Working Memory)

> **Bio-Inspired Function:** Short-term memory synapses
> **Decay Policy:** Delete entries older than 7 days unless elevated to MEMORY.md
> **Purpose:** Raw, append-only stream of agent activity

---

## ⚡ BUFFER RULES

### What Goes Here
- Every action the agent takes (executed commands, file edits, tasks)
- Temporary thoughts and observations
- Low-frequency, low-importance activities
- Raw logs before consolidation

### Decay Policy
```
Age: 1-2 days    → Full retention
Age: 3-5 days    → High decay risk
Age: 6-7 days    → Automatic pruning
Age: >7 days      → Deleted (unless elevated)
```

### Elevation Criteria
- **High Entropy Events:** Changes project state (new files, major refactors)
- **Novel Observations:** New patterns, unexpected behaviors
- **User-Flagged:** User explicitly says "remember this"
- **Frequently Referenced:** Accessed by other agents multiple times

---

## 📝 BUFFER STREAM (Append-Only)

<buffer_entry>
  <timestamp>2026-02-15T16:50:00Z</timestamp>
  <agent>main</agent>
  <activity>terminal_exec</activity>
  <command>git status</command>
  <result>clean</result>
  <entropy>low</entropy>
  <decay_timer>48h</decay_timer>
  <referenced_count>0</referenced_count>
  <status>raw</status>
</buffer_entry>

---

## 🧠 CONSOLIDATION LOG

Last consolidation: [ISO-8601]
Next consolidation due: [ISO-8601]
Consolidation interval: Every 24 hours

<consolidation_rule>
  "Review BUFFER.md entries. If entropy is LOW and age > 48h, prune.
  If entropy is HIGH or user-flagged, elevate to MEMORY.md.
  If novel pattern discovered, add to EVOLUTION.md."
</consolidation_rule>

---

<metadata>
  <bio_layer>working_memory</bio_layer>
  <decay_policy>7_days</decay_policy>
  <consolidation_interval>24h</consolidation_interval>
  <last_purged>[ISO-8601]</last_purged>
</metadata>
