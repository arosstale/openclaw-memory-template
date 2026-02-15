# PHEROMONES.md - Stigmergic Indirect Coordination

> **Bio-Inspired Function:** Ant colony pheromone trails
> **Purpose:** Contextual markers for agent signaling without direct communication
> **Concept:** Agents modify environment to signal others (indirect coordination)

---

## 🐜 STIGMERGY CONCEPT

In ant colonies, ants don't communicate directly. They:
1. **Deposit** pheromones when finding food
2. **Follow** existing trails
3. **Reinforce** successful paths
4. **Evaporate** unused trails

**Agents work the same way:**
- Leave "contextual markers" in files
- Other agents follow high-intensity trails
- Unused markers decay and vanish
- Environment becomes the communication channel

---

## 💪 PHEROMONE INTENSITY LEVELS

| Intensity | Score | Lifespan | Behavior |
|-----------|--------|----------|----------|
| **High** | 0.8-1.0 | 72h+ | Reinforced, critical, frequently accessed |
| **Medium** | 0.5-0.7 | 48h | Active, useful, moderate access |
| **Low** | 0.2-0.4 | 24h | Experimental, tentative, low access |
| **Faint** | 0.1-0.1 | 12h | Temporary, debug, single-use |

---

## 📍 ACTIVE PHEROMONE TRAILS

### Trail: Auth Middleware Development
<pheromone_trail id="P001">
  <task_name>Implement JWT authentication</task_name>
  <intensity>0.85</intensity>
  <created>2026-02-15T14:00:00Z</created>
  <last_reinforced>2026-02-15T16:30:00Z</last_reinforced>
  <decay_timer>48h</decay_timer>
  
  <marker>
    <type>progress</type>
    <location>src/auth/middleware.py</location>
    <status>in_progress</status>
    <context>JWT token validation implemented, refresh token pending</context>
  </marker>
  
  <agent_contributions>
    <agent id="engineer" intensity="0.90">Code implementation</agent>
    <agent id="manager" intensity="0.70">Task assignment</agent>
    <agent id="librarian" intensity="0.50">Context retrieval</agent>
  </agent_contributions>
  
  <referenced_by>
    <agent>engineer</agent>
    <agent>manager</agent>
  </referenced_by>
  
  <next_steps>
    - Implement refresh token rotation
    - Add rate limiting
    - Document API endpoints
  </next_steps>
</pheromone_trail>

### Trail: Database Migration
<pheromone_trail id="P002">
  <task_name>Migration to PostgreSQL</task_name>
  <intensity>0.60</intensity>
  <created>2026-02-14T09:00:00Z</created>
  <last_reinforced>2026-02-15T10:00:00Z</last_reinforced>
  <decay_timer>24h</decay_timer>
  
  <marker>
    <type>planning</type>
    <location>memory/projects/database.md</location>
    <status>planned</status>
    <context>Schema migration plan complete, awaiting approval</context>
  </marker>
  
  <agent_contributions>
    <agent id="librarian" intensity="0.80">Research and planning</agent>
    <agent id="manager" intensity="0.50">Task coordination</agent>
  </agent_contributions>
  
  <referenced_by>
    <agent>librarian</agent>
  </referenced_by>
</pheromone_trail>

---

## 🔄 PHEROMONE REINFORCEMENT RULES

### When to Reinforce
- **Task Progress:** Agent makes progress → +0.1 intensity
- **Reference by Other Agent:** Agent reads marker → +0.15 intensity
- **User Approval:** User acknowledges → +0.2 intensity
- **Critical Path:** Blocker for other tasks → +0.25 intensity

### When to Decay
- **No Activity:** >24h without reinforcement → -0.1 intensity
- **Task Completed:** Mark as complete, set decay to 0
- **User Cancel:** Immediate decay to 0
- **Obsoleted by New Task:** Decay old task, spawn new trail

### Evaporation Policy
```
Intensity 0.8-1.0 → Lifespan 72h (critical)
Intensity 0.5-0.7 → Lifespan 48h (active)
Intensity 0.2-0.4 → Lifespan 24h (experimental)
Intensity 0.1-0.1 → Lifespan 12h (temporary)
```

---

## 🧬 PHEROMONE BEHAVIOR PATTERNS

### Pattern 1: Trail Following
```
Agent A: Starts task "Implement JWT" → Leaves P001 (intensity: 0.5)
Agent B: Needs context on JWT → Reads P001 → Reinforces (+0.15)
Agent C: Continues JWT work → Updates P001 → Reinforces (+0.1)
Result: Trail intensity rises, becomes "High" priority signal
```

### Pattern 2: Trail Abandonment
```
Agent A: Starts task "X feature" → Leaves P005 (intensity: 0.3)
No agents reference for 24h → Decays to 0.2
No agents reference for 48h → Decays to 0.1
Result: Trail evaporates, removed from PHEROMONES.md
```

### Pattern 3: Trail Competition
```
Task A: "Use FastAPI" → Trail P010 (intensity: 0.6)
Task B: "Use Flask" → Trail P011 (intensity: 0.3)
Agent C needs framework choice → Reads both → Reinforces P010 (+0.15)
Result: P010 dominates, P011 evaporates
```

---

## 📊 PHEROMONE STATISTICS

| Metric | Value |
|--------|--------|
| **Active Trails** | 2 |
| **High Intensity** | 1 (50%) |
| **Medium Intensity** | 1 (50%) |
| **Low Intensity** | 0 (0%) |
| **Average Intensity** | 0.73 |
| **Total Agent Contributions** | 6 |

---

## 🔍 STIGMERGY WORKFLOW

### For Agent Starting New Task
1. **Search PHEROMONES.md** for related trails
2. **Follow** existing trail if found
3. **Reinforce** trail (add contribution, update intensity)
4. **Create** new trail if no match

### For Agent Completing Task
1. **Update** trail status to "complete"
2. **Set** decay timer to 0 (immediate evaporation)
2. **Document** learnings in EVOLUTION.md
3. **Archive** to MEMORY.md if high entropy

### For Idle Maintenance
1. **Check** trails for decay status
2. **Prune** trails with intensity < 0.1
3. **Consolidate** related trails if they overlap
4. **Update** statistics

---

<metadata>
  <bio_layer>stigmergy</bio_layer>
  <indirect_coordination>true</indirect_coordination>
  <decay_policy>intensity_based</decay_policy>
  <last_pruned>[ISO-8601]</last_pruned>
</metadata>
