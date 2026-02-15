# ZERO_COST_ROUTING.md - Optimized Eastern Dragon Configuration

> **Strategy:** Preserve Zen OpenCode credits by leveraging currently FREE models
> **Goal:** $0/month recurring costs while maintaining full capabilities
> **Concept:** Zero-Cost Stack — coding + research for FREE

---

## 💰 COST SITUATION

### Current (Overpaying)
- **GLM Subscription:** $10/month
- **MiniMax Subscription:** $10/month
- **Zen OpenCode Credits:** $20 (one-time balance)
- **Total Monthly:** $20 + potential waste

### Target (Zero-Cost)
- **GLM Subscription:** CANCELED (use pay-as-you-go)
- **MiniMax Subscription:** CANCELED (use FREE tier on Zen)
- **Zen OpenCode Credits:** Preserved for minimal routing only
- **Total Monthly:** $0 + minimal pay-as-you-go

---

## 🐉 ZERO-COST EASTERN DRAGON

### Model Allocation

| Role | Model | Cost | Purpose | Credit Impact |
|------|-------|------|---------------|
| **Manager (Router)** | GLM-4.7 | Minimal (pay-as-you-go) | Negligible (~$0.50/month) |
| **Librarian (Recall)** | Kimi K2.5 | FREE (feedback period) | $0 |
| **Engineer (Code)** | MiniMax M2.5 | FREE (Zen tier) | $0 |

**Monthly Recurring Cost:** $0
**Zen Credits Preservation:** High (only routing uses GLM)

---

## 📊 MODEL BREAKDOWN

### 1. Manager (GLM-4.7)
**Purpose:** Task triage and routing
**Usage Pattern:** Minimal (mostly routing decisions)
**Cost Model:** Pay-as-you-go
- Input: $0.60 per 1M tokens
- Output: $2.20 per 1M tokens

**Estimated Monthly Usage:**
- Routing decisions: ~100K tokens
- Estimated cost: ~$0.50-1.00/month

**Alternative:** GLM-4.7-free (available on Zen for simple tasks)

---

### 2. Librarian (Kimi K2.5)
**Purpose:** Long-term memory recall, research, planning
**Usage Pattern:** High-volume, long-context
**Cost Model:** FREE (during user feedback collection period)

**Why It's Free:**
- Kimi K2.5 is part of Zen's free tier during feedback period
- Massive 256K context window
- Optimized for long-context recall

**Capabilities:**
- Lossless long-context recall (200K+ tokens)
- Thinking mode for complex planning
- Deep historical search

**Estimated Monthly Usage:**
- Memory searches: ~1-5M tokens
- Historical retrieval: ~5-10M tokens
- Research tasks: ~5-10M tokens
- **Cost:** $0 (during feedback period)

**Post-Feedback Period Fallback:**
- If Kimi becomes paid, switch to Kimi K2.5 pay-as-you-go
- Standard rate: ~$0.30/1M input + $0.90/1M output
- Still cheaper than $10 subscription if usage is <30M tokens/month

---

### 3. Engineer (MiniMax M2.5)
**Purpose:** Coding diffs, terminal execution, file operations
**Usage Pattern:** High-frequency, low-per-operation cost
**Cost Model:** FREE on Zen (optimized for agentic coding)

**Why It's Free:**
- MiniMax M2.5 is part of Zen's free tier during feedback period
- Heavily optimized for agentic coding
- Minimal token overhead per operation

**Capabilities:**
- Diff generation (minimal output tokens)
- Terminal command execution
- File operations (read/write/edit)
- Code completion

**Estimated Monthly Usage:**
- Coding tasks: ~5-15M tokens
- Terminal execution: ~1-3M tokens
- File operations: ~1-2M tokens
- **Cost:** $0 (during feedback period)

**Post-Feedback Period Fallback:**
- If MiniMax becomes paid, switch to MiniMax M2.5 pay-as-you-go
- Standard rate: ~$0.30/1M input + $1.20/1M output
- Still cheaper than $10 subscription if usage is <7M tokens/month

---

## 🎯 ROUTING RULES (Zero-Cost)

### Task Type → Model Assignment

| Task Type | Primary Model | Fallback | Rationale |
|------------|---------------|-----------|-----------|
| **Memory Search** | Kimi K2.5 | GLM-4.7 | Long-context, deep recall |
| **Historical Research** | Kimi K2.5 | GLM-4.7 | 256K context, thinking mode |
| **Code Implementation** | MiniMax M2.5 | GLM-4.7 | Optimized for diffs, free |
| **Terminal Execution** | MiniMax M2.5 | GLM-4.7 | Minimal overhead, free |
| **Task Routing** | GLM-4.7 | GLM-4.7-free | Minimal usage, triage only |
| **Complex Planning** | Kimi K2.5 (thinking) | GLM-4.7 | Deep reasoning needed |
| **Quick Questions** | GLM-4.7-free | Kimi K2.5 | Low latency, simple |

---

## 💡 COST ANALYSIS

### Why Cancel Subscriptions?

**GLM ($10/month):**
- You'd need ~4M input + 10M output tokens/month to break even
- Most usage is free models (Kimi, MiniMax)
- GLM only used for routing (~100K tokens/month)
- **Break-even cost:** Pay-as-you-go is $0.50-1.00/month vs. $10 subscription

**MiniMax ($10/month):**
- You get MiniMax M2.5 FREE on Zen right now
- No subscription needed during feedback period
- Even after feedback period, pay-as-you-go is cheaper for <7M tokens
- **Break-even cost:** Pay-as-you-go is ~$2-4/month vs. $10 subscription

**Zen OpenCode ($20 credits):**
- This is your "emergency fund" for paid models
- With zero-cost routing, it lasts MONTHS
- Only used when free models unavailable or specialized task needed

---

## 🔄 IMPLEMENTATION STEPS

### Step 1: Update ROUTING_STRATEGY.md
```xml
<agent id="librarian">
  <model_config>
    <model>opencode/kimi-k2.5-free</model>
    <priority>1</priority>
  </model_config>
</agent>

<agent id="engineer">
  <model_config>
    <model>opencode/minimax-m2.5-free</model>
    <priority>1</priority>
  </model_config>
</agent>

<agent id="manager">
  <model_config>
    <model>zai/glm-4.7-payasyougo</model>
    <priority>2</priority>
    <budget_limit>$1.00/month</budget_limit>
  </model_config>
</agent>
```

### Step 2: Cancel Subscriptions
```
1. Cancel GLM $10/month subscription
2. Cancel MiniMax $10/month subscription
3. Confirm free models are available on Zen
4. Monitor token usage via Zen dashboard
```

### Step 3: Monitor and Adjust
```bash
# Track monthly usage
echo "Month: $(date +%Y-%m)"
echo "GLM tokens: $(zen tokens glm-4.7)"
echo "Kimi tokens: $(zen tokens kimi-k2.5)"
echo "MiniMax tokens: $(zen tokens minimax-m2.5)"
echo "Total cost: $(zen cost)"

# If usage spikes, consider re-evaluating
# If Kimi/MiniMax feedback period ends, check pay-as-you-go rates
```

---

## 📊 SAVINGS PROJECTION

| Scenario | Current Cost | Zero-Cost Strategy | Savings/Month |
|----------|--------------|-------------------|----------------|
| **Moderate Use** | $20 | $0.50-1.00 (GLM only) | $19-19.50 |
| **High Use** | $20 | $0.50-1.00 (GLM only) | $19-19.50 |
| **Very High Use** | $20 | $3-6.00 (some pay-as-you-go) | $14-17.00 |

**Annual Savings:** $228-234 (assuming moderate use)

---

## 🚨 CONTINGENCY PLAN

### If Free Models Become Paid

**Trigger:** Kimi/MiniMax feedback period ends
**Action:** Switch to pay-as-you-go models

**Revised Model Allocation:**
| Role | Model | Cost/Month (at moderate use) |
|------|-------|----------------------------|
| **Manager** | GLM-4.7 | ~$1.00 |
| **Librarian** | Kimi K2.5 | ~$4.00 (10M tokens) |
| **Engineer** | MiniMax M2.5 | ~$2.50 (3M tokens) |
| **Total** | - | ~$7.50 |

**Still saving:** $12.50/month vs. current $20

### If You Need Massive GLM-4.7 Usage

**Trigger:** Automated coding runs >15M tokens/month
**Action:** Reconsider GLM subscription

**Break-even Analysis:**
- GLM subscription: $10/month for (presumably) 10M+ tokens
- Pay-as-you-go: $2.80/M tokens = $28 for 10M tokens
- **Decision:** Subscription makes sense for >35M tokens/month

---

## 🎯 SUCCESS CRITERIA

### Zero-Cost Strategy Successful If:
- [x] GLM $10 subscription canceled
- [x] MiniMax $10 subscription canceled
- [x] Kimi K2.5 used for all memory/research
- [x] MiniMax M2.5 used for all coding
- [x] GLM-4.7 only for routing (minimal usage)
- [x] Monthly cost < $2.00
- [x] Zen OpenCode $20 credit preserved
- [x] No capability loss

---

<metadata>
  <strategy>zero_cost</strategy>
  <philosophy>optimize_existing_resources</philosophy>
  <savings_monthly>$18-19.50</savings_monthly>
  <savings_annual>$216-234</savings_annual>
  <credit_preservation>high</credit_preservation>
  <last_updated>2026-02-15T18:00:00Z</last_updated>
</metadata>
