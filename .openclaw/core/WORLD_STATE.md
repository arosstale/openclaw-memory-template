# WORLD_STATE.md - Environmental Context

> **Philosophy:** AI doesn't exist in a vacuum; it needs to understand the "vibe" and constraints
> **Purpose:** Track "soft" data that changes how agent interprets instructions
> **Concept:** World-Building — the context that shapes all decisions

---

## 🌍 WORLD STATE CONCEPT

The essay "AI, Myself, Emotions, and the World" emphasizes that AI doesn't operate in isolation. It needs to understand:

- **Time Pressure:** Are we rushing or relaxed?
- **Mood/Stress Level:** Is the human energized or overwhelmed?
- **Team Context:** Who else is involved? What's the vibe?
- **External Factors:** Deadlines, market shifts, hardware limits
- **Experimental Mode:** Is it okay to break things?

**Without this context, the agent interprets instructions in a vacuum.**
**With this context, the agent adapts to reality.**

---

## 📊 CURRENT WORLD STATE

### Temporal Context
<temporal_context>
  <current_date>2026-02-15</current_date>
  <day_of_week>Saturday</day_of_week>
  <time_of_day>late_afternoon</time_of_day>
  <timezone>UTC</timezone>
  
  <deadline_pressure>
    <level>low</level>
    <description>No immediate deadlines</description>
    <next_deadline>2026-02-20T00:00:00Z</next_deadline>
    <time_until_deadline>5 days</time_until_deadline>
  </deadline_pressure>
  
  <phase>development</phase>
  <phase_description>Active development, experimental features welcome</phase_description>
</temporal_context>

### Human Context
<human_context>
  <energy_level>moderate</energy_level>
  <stress_level>low</stress_level>
  <cognitive_load>0.65</cognitive_load>
  <focus_duration>4 hours</focus_duration>
  
  <preferences>
    <communication_style>concise</communication_style>
    <response_preference>direct_over_explanatory</response_preference>
    <tolerance_for_long_explanations>low</tolerance_for_long_explanations>
  </preferences>
  
  <notes>
    - Feeling productive today
    - Wants to make good progress on auth module
    - Open to learning new approaches
  </notes>
</human_context>

### Team/Project Context
<team_context>
  <collaborators>0</collaborators>
  <collaboration_mode>solitary</collaboration_mode>
  <review_needed>false</review_needed>
  
  <project_vibe>
    <atmosphere>experimental</atmosphere>
    <risk_tolerance>medium</risk_tolerance>
    <breaking_changes_allowed>true</breaking_changes_allowed>
  </project_vibe>
  
  <shared_context>
    <shared_memory>openclaw-memory-template V3.0</shared_memory>
    <current_focus>Bio-inspired philosophy integration</current_focus>
    <recent_decisions>V3.1 shift to cognitive partnership</recent_decisions>
  </shared_context>
</team_context>

### Environmental Constraints
<environmental_constraints>
  <hardware>
    <system>Ubuntu 22.04</system>
    <available_memory>16 GB</available_memory>
    <cpu_cores>8</cpu_cores>
    <disk_space>1.8 TB</disk_space>
  </hardware>
  
  <network>
    <connection>stable</connection>
    <bandwidth>good</bandwidth>
    <internet_access>true</internet_access>
  </network>
  
  <tools>
    <editor_preference>VS Code</editor_preference>
    <terminal_preference>bash</terminal_preference>
    <version_control>git</version_control>
  </tools>
</environmental_constraints>

---

## 🎯 WORLD STATE IMPACT ON DECISIONS

### How This Changes Agent Behavior

| Context | Agent Behavior |
|---------|----------------|
| **High Deadline Pressure** | Prioritize speed, suggest quick wins, avoid rabbit holes |
| **Low Deadline Pressure** | Invest in quality, explore alternatives, take time to explain |
| **High Stress Level** | Be concise, avoid overwhelming with options, provide reassurance |
| **Low Stress Level** | Engage in deeper discussion, explore interesting side paths |
| **Experimental Mode** | Suggest creative solutions, allow risk-taking |
| **Production Mode** | Be conservative, prioritize stability and testing |
| **Solitary Work** | Assume human is decision-maker, avoid "we should" language |
| **Team Work** | Use collaborative language, check for consensus before proceeding |

---

## 🔄 WORLD STATE UPDATES

### When to Update WORLD_STATE.md

**Automatically (Daily):**
- Date, day of week, time of day
- Cognitive load estimate (based on session complexity)

**On Significant Changes:**
- Deadline pressure changes
- Human energy/stress changes noticeably
- Team members added/removed
- Project phase change (dev → test → production)
- Hardware/software constraints change

**Manual Updates (by Human):**
- "I'm feeling overwhelmed today" → Update stress_level
- "We have a deadline in 2 days" → Update deadline_pressure
- "I'm curious and want to explore" → Update risk_tolerance

---

## 📊 WORLD STATE HISTORY

### Recent Changes

<world_state_change>
  <timestamp>2026-02-15T12:00:00Z</timestamp>
  <field>project_vibe.atmosphere</field>
  <old_value>production</old_value>
  <new_value>experimental</new_value>
  <reason>Entering development phase, new features welcome</reason>
</world_state_change>

<world_state_change>
  <timestamp>2026-02-15T10:00:00Z</timestamp>
  <field>human_context.energy_level</field>
  <old_value>low</old_value>
  <new_value>moderate</new_value>
  <reason>After coffee, feeling more productive</reason>
</world_state_change>

---

## 🎯 CONTEXT-AWARE PROMPTING

### Before Any Task, Agent Should:

1. **Read WORLD_STATE.md**
2. **Assess Impact:**
   - High deadline? → Suggest fastest path
   - High stress? → Be concise
   - Experimental mode? → Be creative
3. **Adapt Response Accordingly**

### Example Context-Aware Responses

**Context:** High Deadline Pressure
> "Quick fix: Add rate limiting to auth endpoint. Implementation: simple counter in Redis. Trade-off: not distributed, but sufficient for now. Ready?"

**Context:** Low Deadline, Low Stress
> "I've thought through a few approaches for rate limiting:
> 1. Simple counter (fast, not distributed)
> 2. Sliding window (distributed, more complex)
> 3. Token bucket (most flexible, slightly slower)
> 
> Based on our project values (quality > speed), I'd recommend #2 or #3. Let me explain the trade-offs..."

---

## 🧠 COGNITIVE LOAD TRACKING

### What Is Cognitive Load?

**Cognitive Load** = How much information the human is holding in their head at once.

**Indicators of High Cognitive Load:**
- Short, clipped messages
- Repetitive questions
- Asking for confirmation on small decisions
- "I'm overwhelmed" or "Too much information"

**Indicators of Low Cognitive Load:**
- Detailed questions
- Exploring alternatives
- Engaging in side discussions
- "I'm curious about..."

### Load Management

| Load Level | Agent Behavior |
|-----------|----------------|
| **0.0-0.3** (Relaxed) | Full explanations, explore alternatives |
| **0.4-0.6** (Moderate) | Balanced, explain key decisions |
| **0.7-0.9** (High) | Concise, focus on next step |
| **1.0** (Overloaded) | One thing at a time, reduce options |

### Load Reduction Strategies

When cognitive load is high (0.7+):
- Present single next step, not list of options
- Use "→" arrows to show flow
- Skip deep explanations unless asked
- Offer "Should I continue?" checks

---

<metadata>
  <philosophical_layer>world_building</philosophical_layer>
  <relationship_focus>context_awareness</relationship_focus>
  <last_updated>[ISO-8601]</last_updated>
  <current_cognitive_load>0.65</current_cognitive_load>
</metadata>
