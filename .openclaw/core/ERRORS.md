# ERRORS.md - Self-Correction & Error Log

> **Purpose:** Record failures for learning and future avoidance
> **Pattern:** Error → Root Cause → Fix → Prevention
> **Value:** Before running commands, check this log to avoid repeating mistakes

---

## 🎯 Why This Matters

**The "Learning Loop":**

1. **Error Occurs** → Document in ERRORS.md
2. **Root Cause** → Analyze what happened
3. **Fix Applied** → How it was resolved
4. **Prevention** → How to avoid next time
5. **Pre-Flight Check** → Before running similar commands

This creates a truly learning agent that doesn't repeat mistakes.

---

## 📝 Error Entry Format

```xml
<error_entry>
<timestamp>[ISO-8601]</timestamp>
<command>THE_COMMAND_THAT_FAILED</command>
<error_message>ERROR_OUTPUT_OR_DESCRIPTION</error_message>

<root_cause>
WHY_IT_FAILED
</root_cause>

<fix_applied>
HOW_IT_WAS_FIXED
</fix_applied>

<prevention>
HOW_TO_AVOID_NEXT_TIME
</prevention>

<tags>
<tag>category1</tag>
<tag>category2</tag>
</tags>

<resolved>true|false</resolved>
</error_entry>
```

---

## 📊 Error Categories

| Category | Tags | Examples |
|----------|------|----------|
| **Dependency** | `pip`, `npm`, `apt` | Package install failures |
| **Permission** | `chmod`, `sudo`, `chown` | Access denied errors |
| **Path** | `path`, `directory`, `file` | File not found, wrong directory |
| **Syntax** | `bash`, `python`, `json` | Syntax errors in scripts |
| **Network** | `curl`, `git`, `ssh` | Connection, timeout errors |
| **API** | `anthropic`, `openai`, `arxiv` | API call failures |
| **Memory** | `context`, `token` | Context overflow, truncation |
| **Git** | `git` | Push failures, merge conflicts |
| **System** | `systemd`, `cron` | Service failures |

---

## 📋 Recent Errors (Last 30 Days)

<error_entry>
<timestamp>2026-02-15T14:20:00Z</timestamp>
<command>pip install openclaw</command>
<error_message>ERROR: Could not find a version that satisfies the requirement openclaw</error_message>

<root_cause>
Tried to install OpenClaw via pip, but it's not available in PyPI. OpenClaw is distributed via npm.
</root_cause>

<fix_applied>
Used correct installation method:
npm install -g @openclaw/cli
</fix_applied>

<prevention>
Always check package manager before install:
- Python packages → pip
- Node packages → npm
- System packages → apt
</prevention>

<tags>
<tag>dependency</tag>
<tag>package-manager</tag>
<tag>installation</tag>
</tags>

<resolved>true</resolved>
</error_entry>

<error_entry>
<timestamp>2026-02-15T13:45:00Z</timestamp>
<command>./scripts/setup_cron.sh</command>
<error_message>syntax error: unexpected end of file</error_message>

<root_cause>
Bash script had unclosed quote: missing closing ) in SCRIPT_DIR variable
</root_cause>

<fix_applied>
Fixed quoting:
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
</fix_applied>

<prevention>
Always test bash scripts with:
bash -n script.sh  (syntax check)
bash -x script.sh  (debug mode)
</prevention>

<tags>
<tag>bash</tag>
<tag>syntax</tag>
<tag>script</tag>
</tags>

<resolved>true</resolved>
</error_entry>

<error_entry>
<timestamp>2026-02-15T12:30:00Z</timestamp>
<command>crontab -l | grep fetch</command>
<error_message>No output, cron entry not found</error_message>

<root_cause>
Cron job wasn't actually added to crontab. setup_cron.sh had a bug that only logged, didn't add.
</root_cause>

<fix_applied>
Ran setup script again and verified with:
crontab -l | grep fetch
</fix_applied>

<prevention>
After adding cron, always verify:
1. Check crontab -l shows entry
2. Test command manually first
3. Check log file for output
</prevention>

<tags>
<tag>cron</tag>
<tag>system</tag>
<tag>verification</tag>
</tags>

<resolved>true</resolved>
</error_entry>

<!-- Add new errors above this line -->

---

## 🔍 Pre-Flight Checklist

**Before running similar commands, check ERRORS.md:**

```bash
# Command to run
echo "Running: YOUR_COMMAND"
echo "Checking for similar errors in ERRORS.md..."

# Check for related tags
grep -i "YOUR_TAG_CATEGORY" .openclaw/core/ERRORS.md

# Check for similar commands
grep -i "SIMILAR_COMMAND" .openclaw/core/ERRORS.md

# If error found, read the prevention section
# Apply prevention before running
```

---

## 📊 Error Statistics

<error_stats>
<total_errors>3</total_errors>
<resolved>3</resolved>
<unresolved>0</unresolved>
<resolution_rate>100%</resolution_rate>
<last_error>2026-02-15T14:20:00Z</last_error>
<most_common_category>bash</most_common_category>
</error_stats>

---

## 🏆 Error Hall of Fame

**Most Common Errors:**

| Category | Count | Pattern |
|----------|-------|---------|
| Bash Syntax | 1 | Quoting errors |
| Package Install | 1 | Wrong package manager |
| Cron | 1 | Missing verification |

**Lessons Learned:**
1. **Test scripts** before running with `bash -n`
2. **Verify cron jobs** immediately after adding
3. **Check package manager** before installing packages

---

## 🔄 Error Maintenance

**Monthly Review:**

1. **Review unresolved errors** - Can they be fixed?
2. **Archive old errors** - Move errors > 90 days to `memory/ARCHIVE_ERRORS.md`
3. **Update patterns** - Add new prevention rules to scripts
4. **Update stats** - Recalculate error statistics

**Archive Template:**
```markdown
# memory/ARCHIVE_ERRORS.md

> **Archived:** [Date]
> **Reason:** Errors older than 90 days

---

## Archived Errors

[Archived error entries]

---

## Prevention Rules Extracted

- Rule 1 from archived errors
- Rule 2 from archived errors
```

---

## 🚨 Unresolved Errors

<!-- Errors that haven't been fixed yet -->

<error_entry>
<timestamp>[ISO-8601]</timestamp>
<command>PENDING_COMMAND</command>
<error_message>ERROR_HERE</error_message>
<root_cause>UNKNOWN</root_cause>
<fix_applied>PENDING</fix_applied>
<prevention>PENDING</prevention>
<tags><tag>unresolved</tag></tags>
<resolved>false</resolved>
</error_entry>

---

<metadata>
<version>V1.0</version>
<created>2026-02-15</created>
<last_updated>2026-02-15T14:20:00Z</last_updated>
<next_archive>2026-05-15</next_archive>
</metadata>
