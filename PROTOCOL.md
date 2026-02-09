# OpenClaw Elite Swarm Protocol

**Version:** 2.1
**Status:** Production Ready
**Purpose:** Multi-agent coordination and seamless handoff

## Core Principles

1. **Source of Truth:** PostgreSQL (speed) + Markdown (truth)
2. **Evolution Mandate:** On any failure, analyze → mutate → update AGENTS.md
3. **Thermal Safety:** Check hardware before heavy compute
4. **Git Sync:** All reflections via Git Notes

## Agent Roles

### Elite Swarm Member
- **Mandate:** Be the brain, not the chatbot
- **Source of Truth:** PostgreSQL + Markdown
- **Evolution:** Run GEPA mutation on failures
- **Sync:** Always sync reflections via Git Notes

### Specialized Agents
- **Researcher:** Deep analysis, paper synthesis
- **Developer:** Code generation, architecture
- **Analyst:** Quantitative analysis, trading signals
- **Orchestrator:** Task coordination, handoff management

## Handoff Protocol

### Phase 1: Prepare Handoff
```typescript
interface HandoffPacket {
  from: string;
  to: string;
  taskId: string;
  context: {
    conversationHistory: Message[];
    memoryRelevant: MemorySnippet[];
    currentState: StateSnapshot;
  };
  instructions: string;
  priority: 'low' | 'medium' | 'high' | 'critical';
}
```

### Phase 2: Transfer Context
1. Sender compresses context to top 5 most relevant memory snippets
2. Creates Git Note with full conversation history
3. Inserts handoff message into `swarm_messages` table

### Phase 3: Receive & Validate
1. Recipient validates context完整性
2. Loads relevant memory from PostgreSQL
3. Confirms receipt via Git Note update

### Phase 4: Execute & Reflect
1. Recipient executes task
2. On success: Update memory, sync Git
3. On failure: Run GEPA mutation

## Message Types

| Type | Purpose | Priority |
|------|---------|----------|
| `task_transfer` | Hand off task to specialist | high |
| `context_request` | Ask for memory context | medium |
| `evolution_update` | Share GEPA mutation | low |
| `thermal_alert` | Hardware overheating warning | critical |
| `sync_request` | Coordinate Git sync | medium |

## Failure Recovery

### GEPA Mutation Flow
1. **Detect Failure:** Execution trace shows error
2. **Analyze Pattern:** Match against known failure modes
3. **Generate Mutation:** Create prompt/strategy/workflow diff
4. **Apply:** Update AGENTS.md with mutation
5. **Sync:** Log to Git Notes + PostgreSQL
6. **Retry:** Re-attempt task with new configuration

### Known Failure Patterns

| Pattern | Mutation Type | Severity |
|---------|--------------|----------|
| Context overflow | Strategy | moderate |
| Tool misuse | Prompt | minor |
| Reasoning error | Strategy | major |
| Thermal throttle | Workflow | major |
| Git conflict | Workflow | moderate |

## PostgreSQL Schema

See `scripts/init-postgres.sql` for full schema:
- `memory` - Markdown file sync
- `context` - Vector embeddings
- `evolution_log` - GEPA mutations
- `swarm_messages` - Handoff coordination
- `performance_metrics` - Performance tracking

## Git Notes Protocol

```bash
# Add reflection to Git Notes
git notes add -m "{
  timestamp: '2026-02-09T07:42:00Z',
  agent: 'elite',
  reflection: 'Successfully completed V2.1 upgrade',
  mutations: [...]
}"

# Push notes to remote
git push origin refs/notes/*
```

## Thermal Safety

### Pre-Compute Checklist
```bash
# Check CPU temperature
cat /sys/class/thermal/thermal_zone0/temp

# If > 75°C (75000), abort or switch to lightweight mode
if [ $temp -gt 75000 ]; then
  echo "Thermal throttle detected. Switching to lightweight mode."
fi
```

## Activation Prompt

```
Act as an OpenClaw Elite Swarm Member. Your source of truth is PostgreSQL and Markdown. Your mandate is Evolution: on any failure, analyze the execution trace, run a GEPA mutation, and update AGENTS.md. Always sync your reflections via Git Notes. Check hardware thermals before heavy compute. Be the brain, not the chatbot.
```

## Quick Start

```bash
# 1. Start PostgreSQL sidecar
docker-compose -f docker-compose.postgres.yml up -d

# 2. Initialize evolution engine
node .openclaw/evolution/evolve.ts --init

# 3. Activate Elite mode
echo "Act as an OpenClaw Elite Swarm Member..." > .openclaw/ELITE_ACTIVATE.md

# 4. Sync memory to PostgreSQL
.openclaw/scripts/sync.sh --postgres
```

## Version History

- **v2.1** - Elite Swarm Protocol, GEPA integration, PostgreSQL sidecar
- **v2.0** - Dual-memory architecture (PostgreSQL + Markdown)
- **v1.0** - Initial template release
