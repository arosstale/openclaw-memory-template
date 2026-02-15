# Daily Log Template - [YYYY-MM-DD]

> **Purpose:** Session log with daily compaction hooks
> **Format:** Append-only for chronological tracking
> **Compaction:** Summarize yesterday at start of new day

---

## 📅 Date: [YYYY-MM-DD]

**Session Start:** [ISO-8601 Timestamp]
**Timezone:** [Timezone]

---

## 🔄 START OF DAY - DAILY COMPACTION

### Yesterday's Review

**Yesterday's Log:** memory/[YYYY-MM-DD].md

**Instructions:**
1. Read yesterday's daily log
2. Identify "Unfinished Tasks"
3. Summarize into "Current Focus" below
4. Mark completed tasks as "Archived"

### Current Focus (from yesterday)

<current_focus>
<!-- Summarize unfinished tasks from yesterday -->
- [ ] Task 1 from yesterday
- [ ] Task 2 from yesterday
- [ ] Task 3 from yesterday
</current_focus>

### Archived from Yesterday

<archived_tasks>
<!-- Completed tasks from yesterday -->
- ✅ Task 1 - completed
- ✅ Task 2 - completed
</archived_tasks>

---

## 🎯 Today's Goals

**Primary Objective:** [Today's main goal]

**Secondary Objectives:**
- [ ] Objective 1
- [ ] Objective 2
- [ ] Objective 3

---

## 📝 Session Notes

### Morning Session

<session>
  <time_start>[ISO-8601 Timestamp]</time_start>
  <time_end>[ISO-8601 Timestamp]</time_end>
  <duration>[Duration]</duration>
  
  <activities>
    - Activity 1
    - Activity 2
    - Activity 3
  </activities>
  
  <decisions>
    - Decision 1
    - Decision 2
  </decisions>
  
  <learnings>
    - Learning 1
    - Learning 2
  </learnings>
</session>

### Afternoon Session

<session>
  <time_start>[ISO-8601 Timestamp]</time_start>
  <time_end>[ISO-8601 Timestamp]</time_end>
  <duration>[Duration]</duration>
  
  <activities>
    - Activity 1
    - Activity 2
    - Activity 3
  </activities>
  
  <decisions>
    - Decision 1
    - Decision 2
  </decisions>
  
  <learnings>
    - Learning 1
    - Learning 2
  </learnings>
</session>

### Evening Session

<session>
  <time_start>[ISO-8601 Timestamp]</time_start>
  <time_end>[ISO-8601 Timestamp]</time_end>
  <duration>[Duration]</duration>
  
  <activities>
    - Activity 1
    - Activity 2
    - Activity 3
  </activities>
  
  <decisions>
    - Decision 1
    - Decision 2
  </decisions>
  
  <learnings>
    - Learning 1
    - Learning 2
  </learnings>
</session>

---

## ✅ Tasks Completed

<tasks_completed>
  <task>
    <id>1</id>
    <description>Task description</description>
    <completed_at>[ISO-8601]</completed_at>
    <duration>[Duration]</duration>
  </task>
  
  <task>
    <id>2</id>
    <description>Task description</description>
    <completed_at>[ISO-8601]</completed_at>
    <duration>[Duration]</duration>
  </task>
</tasks_completed>

---

## ⏳ Unfinished Tasks

<tasks_unfinished>
  <task>
    <id>1</id>
    <description>Task description</description>
    <started_at>[ISO-8601]</started_at>
    <reason_unfinished>Reason why not completed</reason_unfinished>
    <priority>high|medium|low</priority>
  </task>
  
  <task>
    <id>2</id>
    <description>Task description</description>
    <started_at>[ISO-8601]</started_at>
    <reason_unfinished>Reason why not completed</reason_unfinished>
    <priority>high|medium|low</priority>
  </task>
</tasks_unfinished>

**Note:** These will be carried over to tomorrow's "Current Focus"

---

## 🔍 Issues Encountered

<issues>
  <issue>
    <timestamp>[ISO-8601]</timestamp>
    <description>Issue description</description>
    <severity>critical|high|medium|low</severity>
    <resolution>Status or next steps</resolution>
  </issue>
  
  <issue>
    <timestamp>[ISO-8601]</timestamp>
    <description>Issue description</description>
    <severity>critical|high|medium|low</severity>
    <resolution>Status or next steps</resolution>
  </issue>
</issues>

---

## 📊 Memory Updates

### Files Updated

<memory_updates>
  <update>
    <file>MEMORY.md</file>
    <changes>Brief description of changes</changes>
    <timestamp>[ISO-8601]</timestamp>
  </update>
  
  <update>
    <file>LEARNINGS.md</file>
    <changes>Brief description of changes</changes>
    <timestamp>[ISO-8601]</timestamp>
  </update>
  
  <update>
    <file>PROJECT.md</file>
    <changes>Brief description of changes</changes>
    <timestamp>[ISO-8601]</timestamp>
  </update>
</memory_updates>

### Context Summary for Tomorrow

<context_summary>
**Key Points to Remember:**

1. [Key point 1]
2. [Key point 2]
3. [Key point 3]

**State of Important Projects:**

- **Project 1:** [Status]
- **Project 2:** [Status]
- **Project 3:** [Status]

**Pending Decisions:**

- [ ] Decision pending 1
- [ ] Decision pending 2

**User Preferences Observed Today:**

- [ ] Preference 1
- [ ] Preference 2
</context_summary>

---

## 🎯 End of Day Summary

**Session End:** [ISO-8601 Timestamp]
**Total Duration:** [Total time]
**Productivity Score:** [1-10]
**Overall Mood:** [positive/neutral/negative]

### Daily Achievements

<achievements>
- Achievement 1
- Achievement 2
- Achievement 3
</achievements>

### Lessons Learned

<lessons>
- Lesson 1
- Lesson 2
- Lesson 3
</lessons>

### Tomorrow's Preparation

<preparation>
- [ ] Review today's unfinished tasks
- [ ] Prepare tomorrow's goals
- [ ] Check for pending decisions
- [ ] Update CURRENT_CONTEXT.md
- [ ] Clear scratchpad if not needed
</preparation>

---

## 📋 End-of-Day Checklist

Before closing session:

- [ ] All tasks documented
- [ ] Memory files updated
- [ ] Unfinished tasks listed for tomorrow
- [ ] Context summary written
- [ ] CURRENT_CONTEXT.md updated or cleared
- [ ] PII redacted if present
- [ ] Errors recorded in ERRORS.md
- [ ] Git commit (if significant changes)
- [ ] Backup completed

---

## 🔄 COMPACTION INSTRUCTIONS FOR NEXT DAY

**When starting tomorrow's log:**

1. **Read Yesterday:** Read this file first
2. **Extract Tasks:** Copy "Unfinished Tasks" to tomorrow's "Current Focus"
3. **Archive Completed:** Mark "Tasks Completed" as archived
4. **Summarize:** Create brief summary for "Context Summary"
5. **Continue:** Start new day with clear context

**Compaction Example:**

```xml
<!-- Yesterday's unfinished -->
<tasks_unfinished>
  <task>
    <id>1</id>
    <description>Implement V2.7 features</description>
    <priority>high</priority>
  </task>
</tasks_unfinished>

<!-- Tomorrow's current focus -->
<current_focus>
  <task>
    <id>1</id>
    <description>Implement V2.7 features</description>
    <priority>high</priority>
    <notes>Started yesterday, continue implementation</notes>
  </task>
</current_focus>
```

---

## 📊 Daily Metrics

<daily_stats>
  <tasks_started>0</tasks_started>
  <tasks_completed>0</tasks_completed>
  <tasks_in_progress>0</tasks_in_progress>
  <issues_encountered>0</issues_encountered>
  <issues_resolved>0</issues_resolved>
  <memory_updates>0</memory_updates>
  <sessions>0</sessions>
  <total_duration>0h 0m</total_duration>
</daily_stats>

---

## 🏷️ Tags

<tags>
  <tag>daily-log</tag>
  <tag>compaction</tag>
  <tag>session-tracker</tag>
</tags>

---

<metadata>
  <date>[YYYY-MM-DD]</date>
  <created>[ISO-8601]</created>
  <last_updated>[ISO-8601]</last_updated>
  <day_of_week>[Monday/Tuesday/etc]</day_of_week>
  <week_number>[Week number]</week_number>
</metadata>
