# DECISION_MATRIX.md - The Agent's Handbook (G008)
# Part of OpenClaw Memory Template V3.1
# Purpose: Tool selection guidelines to prevent "tool obsession" waste

---

## 🎯 Why This Matters

**The Trap:** Agents default to tools they know (usually Bash) for everything, even when it's the wrong tool for the job.

**The Cost:**
- Using wrong tool = 3x effort, 2x debugging time
- Choosing right tool = immediate success, cleaner code

**Goal:** Provide decision matrix so agents choose the RIGHT tool on first try.

---

## 📊 TOOL SELECTION MATRIX

### 1. Data Structure Processing

| Data Type | Primary Tool | Secondary Tools | When to Use |
|-----------|-------------|----------------|-------------|
| **XML / JSON** | **Python** | xmltodict, json module, pyyaml | Structured, hierarchical data with schemas |
| **YAML** | **Python** | PyYAML, ruamel.yaml | Config files, Kubernetes manifests |
| **CSV / TSV** | **Python** (pandas) OR **awk** | Small files: awk, Large data: pandas | Tabular data processing |
| **Plain Text** | **Bash** | awk, sed, grep, cut | Line-based operations, simple transforms |
| **Markdown** | **Bash** OR **Python** | sed for regex, Python for AST | Content manipulation |

**Decision Tree:**
```
Is data structured (XML/JSON/YAML)?
├─ Yes → Python (use parser modules)
└─ No
    ├─ Is it tabular (CSV/TSV)?
    │  ├─ Yes → Python (pandas) if large, else awk
    └─ No
        ├─ Is it simple text line processing?
        │  ├─ Yes → Bash (awk, sed, grep)
        └─ No → Consider Python
```

---

### 2. System Interaction

| Task Type | Primary Tool | Secondary Tools | Examples |
|-----------|-------------|----------------|---------|
| **File Operations** | **Bash** | find, cp, mv, rm | Copy, move, delete files |
| **Permissions** | **Bash** | chmod, chown, sudo | ACL changes |
| **Process Mgmt** | **Bash** | ps, kill, systemctl | Service control |
| **Network** | **Bash (curl) OR Python** | requests, urllib3 | API calls (small: curl, complex: Python) |
| **Package Install** | **npm/pip/apt** | See package manager table | Installing software |

**Decision Tree:**
```
Is it a system command?
├─ Yes → Bash (native shell tools)
└─ No
    ├─ Is it an API call?
    │  ├─ Simple/One-shot → Bash (curl)
    │  └─ Complex/Parsed response → Python (requests)
    └─ Is it installing software?
        └─ Use package manager (npm for Node, pip for Python, apt for system)
```

---

### 3. Code Generation

| Task | Primary Tool | Secondary Tools | When to Use |
|------|-------------|----------------|-------------|
| **Template Files** | **Python** (jinja2, f-strings) OR **Bash** (sed) | Dynamic code generation |
| **Config Files** | **Bash** (sed, envsubst) | Environment variable substitution |
| **Multi-file Edit** | **Python** | Complex find-replace logic |
| **Regex-based Transform** | **Bash** (sed) | Simple patterns, line-based |
| **AST Manipulation** | **Python** | ast module, code parsing |

**Decision Tree:**
```
Is code generation based on template?
├─ Yes
│  ├─ Simple substitution → Bash (envsubst, sed)
│  └─ Complex logic → Python (jinja2, f-strings)
└─ No
    ├─ Is it regex-based? → Bash (sed)
    └─ Is it AST parsing? → Python (ast module)
```

---

### 4. Debugging & Validation

| Task | Primary Tool | Secondary Tools | When to Use |
|------|-------------|----------------|-------------|
| **Syntax Check** | **Bash -n** OR **python -m py_compile** | Validate before running |
| **Test Execution** | **Bash** OR **Python pytest** | Run unit tests |
| **Log Analysis** | **Bash** (grep, awk) OR **Python** (pandas) | Parse logs |
| **Output Validation** | **Python** (xml.etree, json.loads) | Validate generated files |

**Decision Tree:**
```
Is validation needed?
├─ Yes
│  ├─ Bash script → bash -n syntax check
│  ├─ Python script → python -m py_compile
│  └─ Generated file → Use language-specific parser (Python json.loads, Bash grep)
└─ No → Proceed
```

---

## 💡 CASE STUDIES (From T009)

### Case 1: prune_buffer.sh → Python Migration

**Problem:** Tried 3 times to parse XML `<buffer_entry>` tags with bash regex. Failed each time.

**Wrong Tool Approach:**
```bash
# Attempt 1 (FAILED)
grep -oP '<buffer_entry>.*</buffer_entry>' file | sed 's/extract/pattern'
```

**Right Tool Approach:**
```python
# SUCCEEDED on first attempt
import xml.etree.ElementTree as ET
tree = ET.parse('BUFFER.md')
for entry in tree.findall('.//buffer_entry'):
    # Process structured data
```

**Lesson:** For structured data (XML/JSON), Python's parser modules are designed for this. Bash regex is fragile.

---

### Case 2: validate_xml.sh Metadata Count

**Problem:** Bash variable assignment from grep output failed due to newlines.

**Wrong Tool Approach:**
```bash
# FAILED - Newlines break array assignment
GOAL_IDS=$(grep -oE 'id="G[0-9]{3}"' file | sed 's/id="//g')
```

**Right Tool Approach:**
```bash
# SUCCEEDED - mapfile creates array line-by-line
mapfile -t GOAL_IDS < <(grep -oE 'id="G[0-9]{3}"' file | sed 's/id="//g')
```

**Lesson:** Use `mapfile` when converting multi-line grep output to bash arrays.

---

## 🚨 ANTI-PATTERNS (What NOT to Do)

### Pattern 1: "Bash First" Obsession

**Symptom:** Defaulting to Bash even for XML parsing, JSON manipulation, or complex regex.

**Why It's Wrong:**
- Bash text processing is line-based, not structure-aware
- XML/JSON require proper parsers to handle nested structures
- Complex regex in Bash is brittle and hard to debug

**Prevention:**
- See "Data Structure Processing" section above
- When in doubt, start with Python for structured data
- Use Bash for line-based text processing

---

### Pattern 2: "One Tool Does Everything"

**Symptom:** Using same tool (e.g., sed) for file operations, parsing, AND testing.

**Why It's Wrong:**
- Different tasks have different optimal tools
- Specialized tools exist for a reason
- Multi-tool approach = faster, more maintainable

**Prevention:**
- Use this DECISION_MATRIX.md as reference
- Before implementing, check matrix for task type
- Default to primary tool, keep secondaries in mind

---

## 🔄 EVOLUTIONARY STATUS

**G008 Progress:** 100% ✅
**Created:** 2026-02-15T18:00:00Z
**Based On:** T009 (Match Tool to Data Structure)

**Next Iterations:**
- Add case studies from future experiences
- Refine decision trees based on patterns
- Integrate with pre-commit hooks for tool validation

---

<metadata>
  <type>agent_handbook</type>
  <goal_id>G008</goal_id>
  <target>tool_selection_guidelines</target>
  <status>complete</status>
  <confidence>1.0</confidence>
  <last_updated>2026-02-15T18:00:00Z</last_updated>
</metadata>
