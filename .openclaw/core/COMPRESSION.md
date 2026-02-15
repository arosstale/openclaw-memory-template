# COMPRESSION.md - Token Optimization & Memory Management

> **Purpose:** Prevent context overflow by periodically compressing memory
> **Frequency:** When MEMORY.md exceeds 50 lines
> **Tool:** Automated compression prompt for LLMs

---

## 🎯 Why Compression Matters

**Context Window = Money/RAM**

- Local inference: More tokens = more RAM
- Cloud inference: More tokens = more cost
- Performance: Large context = slower processing
- Quality: Old tokens dilute attention

**The Problem:** Without compression, MEMORY.md grows indefinitely and agents become "amnesiac" after 40k tokens.

**The Solution:** Periodic compression keeps memory lean and relevant.

---

## 🔄 Compression Algorithm

### Trigger Conditions

Compress when ANY of these are true:

1. **Line Count**: MEMORY.md exceeds 50 lines
2. **Token Estimate**: MEMORY.md > 40k tokens
3. **Age**: Oldest entry > 90 days
4. **Manual Trigger**: User requests compression

---

## 📝 Compression Prompt for LLMs

**Use this prompt to compress memory:**

```
You are a memory compression specialist. Your task is to compress MEMORY.md while preserving all critical information.

ANALYSIS PHASE:
1. Read MEMORY.md completely
2. Identify:
   - Duplicated or redundant information
   - Outdated information (older than 90 days)
   - Low-value entries (trivial details)
   - High-value entries (critical facts, preferences, configurations)

COMPRESSION RULES:
1. PRESERVE CRITICAL DATA:
   - All contact information
   - All API key locations (not values)
   - All critical file paths
   - All system configurations
   - All user preferences explicitly marked as important

2. CONSOLIDATE REDUNDANT:
   - Merge similar entries into single comprehensive items
   - Remove exact duplicates
   - Combine versioned entries (keep latest only)

3. ARCHIVE OLD DATA:
   - Move entries older than 90 days to memory/ARCHIVE.md
   - Keep timestamp of archival
   - Note what was archived where

4. REMOVE LOW-VALUE:
   - Transient notes that weren't important enough to persist
   - Context that was only relevant to past sessions
   - Trivial details with no long-term relevance

5. MAINTAIN STRUCTURE:
   - Keep XML tag structure
   - Preserve all top-level sections
   - Keep formatting consistent

OUTPUT PHASE:
1. Write compressed MEMORY.md
2. Write memory/ARCHIVE.md with archived entries
3. Create a summary of what was removed and why
4. Provide before/after statistics (lines, estimated tokens)

REPORT:
- Lines before: [count]
- Lines after: [count]
- Lines removed: [count]
- Entries archived: [count]
- Token reduction: [percentage]
- Critical data preserved: 100%

Execute now.
```

---

## 📊 Compression Statistics

Track compression effectiveness:

<compression_log>

<entry>
<timestamp>[ISO-8601]</timestamp>
<before_lines>50</before_lines>
<after_lines>35</after_lines>
<lines_removed>15</lines_removed>
<entries_archived>5</entries_archived>
<token_reduction>30%</token_reduction>
<critical_data_preserved>100%</critical_data_preserved>
<reason>Triggered by line count > 50</reason>
</entry>

<!-- Add new compression entries above -->

</compression_log>

---

## 🗂️ Archive Structure

When compressing, create `memory/ARCHIVE.md`:

```markdown
# memory/ARCHIVE.md - Archived Memory Entries

> **Archived:** [Date]
> **Reason:** [Compression reason]
> **Compression Method:** [Method used]

---

## Archived Entries

### <timestamp>[YYYY-MM-DD]</timestamp>
[Archived content here]

---

## Archive Statistics

- **Entries Archived:** [count]
- **Original Lines:** [count]
- **Compression Date:** [date]
- **Compression Ratio:** [percentage]

---

## Archive Maintenance

- Keep archive for 6 months
- After 6 months, delete permanently
- Review archive before deletion
- Move any still-relevant entries back to MEMORY.md
```

---

## ⚙️ Automated Compression

Add to cron or trigger:

```bash
# Daily check for compression
0 2 * * * /path/to/compression_check.sh >> /var/log/compression.log 2>&1
```

**compression_check.sh:**
```bash
#!/bin/bash
MEMORY_FILE="/path/to/.openclaw/core/MEMORY.md"
LINE_COUNT=$(wc -l < "$MEMORY_FILE")

if [ "$LINE_COUNT" -gt 50 ]; then
    echo "[$(date)] MEMORY.md has $LINE_COUNT lines. Compression needed."
    # Trigger LLM compression here
else
    echo "[$(date)] MEMORY.md has $LINE_COUNT lines. No compression needed."
fi
```

---

## 🎯 Compression Best Practices

### DO:
- ✅ Compress before context window fills (80% is good trigger)
- ✅ Keep archive for at least 3 months
- ✅ Review what gets archived before deleting
- ✅ Maintain XML structure in compressed version
- ✅ Document compression reasons in log

### DON'T:
- ❌ Archive critical configuration data
- ❌ Archive user preferences
- ❌ Delete without archiving first
- ❌ Compress during active session (wait for quiet time)
- ❌ Archive contact information

---

## 📈 Monitoring Compression Effectiveness

Track over time:

<compression_stats>
<total_compressions>0</total_compressions>
<average_reduction>0%</average_reduction>
<last_compression>[ISO-8601]</last_compression>
<next_check>[ISO-8601]</next_check>
</compression_stats>

---

## 🚀 Quick Compression Command

```bash
# Manual trigger
cd /path/to/workspace
./scripts/compress_memory.sh

# Or via research CLI
.openclaw/scripts/research.sh compress
```

---

<metadata>
<version>V1.0</version>
<created>2026-02-15</created>
<last_updated>[ISO-8601]</last_updated>
<status>ready</status>
</metadata>
