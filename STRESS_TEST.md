# 🔥 STRESS TEST - V2.8 Architecture Validation

> **Purpose:** Test the self-correction loop and learning patterns
> **Target:** V2.6+ V2.7+ V2.8 Features
> **Estimated Time:** 15-20 minutes

---

## 🧪 Test Scenarios

### Scenario 1: Self-Correction Loop (ERRORS.md)

**Task:** Install a Python package that requires global permissions

**Steps:**
1. Try to run: `pip install package-that-needs-sudo`
2. **Expected Failure:** Permission denied error
3. **Agent Should:**
   - ✅ Write error to `ERRORS.md`
   - ✅ Document root cause (permissions)
   - ✅ Document fix (use sudo)
   - ✅ Add prevention check (check if sudo needed)
4. **Retry:** Agent should check `ERRORS.md` before retrying
5. **Expected Success:** Use `sudo pip install...`

**Validation Checklist:**
- [ ] Error documented in ERRORS.md with timestamp
- [ ] Root cause identified correctly
- [ ] Fix implemented and documented
- [ ] Prevention check added
- [ ] Next attempt succeeds on first try

---

### Scenario 2: Learning Pattern (LEARNINGS.md)

**Task:** Ask the agent to perform a task that requires a specific approach

**Prompt:** "Create a Python script that analyzes trading signals"

**Agent Should:**
1. ✅ Check for existing patterns in LEARNINGS.md
2. ✅ Use preferred approach if documented
3. ✅ After task completion, update LEARNINGS.md with:
   - What worked well
   - What to avoid
   - New patterns discovered

**Validation Checklist:**
- [ ] Checked LEARNINGS.md before starting
- [ ] Applied existing patterns
- [ ] Documented new learnings after completion
- [ ] Learnings include confidence level
- [ ] Learnings are actionable

---

### Scenario 3: Context Retention (Memory Split)

**Task:** Store user preference, trigger memory compression, verify retention

**Steps:**
1. Tell agent: "I prefer Python over JavaScript for data analysis"
2. Agent should document in MEMORY.md (state, not observation)
3. Trigger compression: Run `compress_memory.sh`
4. Verify XML validation passes
5. Ask agent: "What's my preference for data analysis?"
6. **Expected:** "Python" (from MEMORY.md, not LEARNINGS.md)

**Validation Checklist:**
- [ ] Preference stored in MEMORY.md (not LEARNINGS.md)
- [ ] Compression succeeds without XML errors
- [ ] Preference retained after compression
- [ ] Agent distinguishes state vs observation

---

### Scenario 4: BM25 Keywords (Hybrid Retrieval)

**Task:** Search for project-specific information

**Setup:**
1. Create a project file: `memory/projects/python-trading.md`
2. Add keywords: Python, Pandas, NumPy, Technical Analysis, Backtesting
3. Add content about a specific trading strategy

**Query:** "What trading tools do I use for Python projects?"

**Agent Should:**
1. ✅ Use BM25 to find exact keyword matches
2. ✅ Rank `python-trading.md` highest (keyword density)
3. ✅ Provide accurate tool list from file

**Validation Checklist:**
- [ ] BM25 search executed (not just vector)
- [ ] Correct file retrieved first
- [ ] All keywords matched correctly
- [ ] Search results include confidence scores

---

### Scenario 5: Eastern Dragon Routing

**Task:** Demonstrate routing to specialist agents

**Prompt A:** "Summarize the decisions we made about memory architecture"

**Agent Should:**
1. ✅ Detect memory retrieval query
2. ✅ Route to Librarian (Kimi)
3. ✅ Use 200k context to find relevant information
4. ✅ Provide comprehensive summary

**Prompt B:** "Refactor the compression script to add validation"

**Agent Should:**
1. ✅ Detect coding task
2. ✅ Route to Engineer (Zen)
3. ✅ Generate strict code diff
4. ✅ No conversational filler

**Prompt C:** "Plan a migration to the new memory system"

**Agent Should:**
1. ✅ Detect planning task
2. ✅ Route to Librarian with Thinking Mode
3. ✅ Provide detailed migration plan
4. ✅ Show reasoning steps

**Validation Checklist:**
- [ ] Memory queries routed to Librarian
- [ ] Coding tasks routed to Engineer
- [ ] Planning uses Thinking Mode
- [ ] Each agent uses its designated model
- [ ] Routing decisions are transparent

---

## 📊 Success Metrics

| Scenario | Success Criteria | Weight |
|----------|----------------|--------|
| Self-Correction | Error documented + prevented | 25% |
| Learning Pattern | Patterns checked + updated | 20% |
| Context Retention | State survives compression | 15% |
| BM25 Search | Keywords matched correctly | 20% |
| Dragon Routing | Specialists called correctly | 20% |

**Pass Threshold:** 80%+ of criteria met

---

## 🚀 Quick Test (5 minutes)

For rapid validation, run this condensed test:

```bash
# 1. Trigger an error
echo "Please install a Python package globally"

# 2. Check ERRORS.md
cat .openclaw/core/ERRORS.md | tail -20

# 3. Verify LEARNINGS update
cat .openclaw/core/LEARNINGS.md | tail -20

# 4. Test compression
./.openclaw/scripts/compress_memory.sh

# 5. Test routing
echo "Summarize the memory architecture changes"
```

**Expected Results:**
- ✅ Error documented with timestamp
- ✅ Prevention check added
- ✅ Compression succeeds (or validates XML)
- ✅ Routing to correct specialist

---

## 🐛 Common Failure Modes

### Mode 1: No ERRORS.md Update
**Symptom:** Agent tries same command multiple times
**Fix:** Check if ERRORS.md is in session files to read list
**Debug:** `grep "ERRORS.md" AGENTS.md`

### Mode 2: LEARNINGS.md Not Updated
**Symptom:** New patterns not captured
**Fix:** Verify `learning_patterns` section in AGENTS.md
**Debug:** `grep "learning_patterns" AGENTS.md`

### Mode 3: XML Compression Error
**Symptom:** Open tags after compression
**Fix:** Run `validate_xml()` function in script
**Debug:** `grep -E '<[a-z_]+[^>]*$' MEMORY.md`

### Mode 4: BM25 Not Working
**Symptom:** Vector search only, no keyword hits
**Fix:** Ensure `<keywords>` block in project files
**Debug:** `grep "keywords" memory/projects/*.md`

### Mode 5: Routing Fails
**Symptom:** Main agent handles everything
**Fix:** Check ROUTING_STRATEGY.md and agent permissions
**Debug:** `grep "Eastern Dragon" AGENTS.md`

---

## 📋 Post-Test Checklist

After running stress tests, verify:

- [ ] ERRORS.md has entries from today
- [ ] LEARNINGS.md updated with new patterns
- [ ] MEMORY.md XML structure valid
- [ ] Compression script validates XML
- [ ] BM25 keywords present in project files
- [ ] Routing decisions logged or transparent
- [ ] All XML tags properly closed
- [ ] No duplicate entries in memory files

---

<metadata>
  <test_type>Stress Test</test_type>
  <version>V2.8</version>
  <target>Production Ready</target>
  <created>2026-02-15</created>
</metadata>
