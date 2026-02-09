#!/usr/bin/env node
/**
 * GEPA (Genetic Evolution via Prompt Adaptation)
 * OpenClaw Elite V2.1 Self-Correcting Mutation Engine
 *
 * On any failure: analyze execution trace → run GEPA mutation → update AGENTS.md
 *
 * Usage: node .openclaw/evolution/evolve.ts --trace <trace.json> --failure <error>
 */

import fs from 'fs/promises';
import path from 'path';

interface GEPAConfig {
  workspace: string;
  maxMutations: number;
  learningRate: number;
}

interface ExecutionTrace {
  timestamp: string;
  task: string;
  outcome: 'success' | 'failure';
  error?: string;
  context: {
    model: string;
    reasoningMode: string;
    tokensUsed: number;
  };
}

interface Mutation {
  type: 'prompt' | 'strategy' | 'workflow';
  severity: 'minor' | 'moderate' | 'major';
  description: string;
  diff: string;
}

class GEPAMutator {
  private config: GEPAConfig;
  private workspace: string;
  private agentsPath: string;

  constructor(config: GEPAConfig) {
    this.config = config;
    this.workspace = config.workspace;
    this.agentsPath = path.join(this.workspace, '.openclaw', 'core', 'AGENTS.md');
  }

  async analyzeFailure(trace: ExecutionTrace): Promise<Mutation[]> {
    const mutations: Mutation[] = [];

    // Analyze error patterns and generate mutations
    if (trace.error) {
      mutations.push(...this.detectMutationPatterns(trace));
    }

    return mutations;
  }

  private detectMutationPatterns(trace: ExecutionTrace): Mutation[] {
    const mutations: Mutation[] = [];
    const error = trace.error?.toLowerCase() || '';

    // Pattern 1: Context overflow → reduce context window
    if (error.includes('context') && error.includes('limit')) {
      mutations.push({
        type: 'strategy',
        severity: 'moderate',
        description: 'Add context compression before large tasks',
        diff: `-   For complex tasks, provide full context immediately
+   For complex tasks, compress context to top 5 most relevant items first`,
      });
    }

    // Pattern 2: Tool misuse → clarify tool selection
    if (error.includes('tool') && error.includes('not found')) {
      mutations.push({
        type: 'prompt',
        severity: 'minor',
        description: 'Add tool availability verification step',
        diff: `+   Before using any tool, verify it exists in your available toolset`,
      });
    }

    // Pattern 3: Reasoning errors → enable verbose reasoning
    if (error.includes('reasoning') || error.includes('logic')) {
      mutations.push({
        type: 'strategy',
        severity: 'major',
        description: 'Enable verbose reasoning for this task type',
        diff: `-   Default reasoning mode: low
+   Default reasoning mode: high for logic-heavy tasks`,
      });
    }

    // Pattern 4: Hardware throttle → check thermals first
    if (error.includes('thermal') || error.includes('temperature')) {
      mutations.push({
        type: 'workflow',
        severity: 'critical',
        description: 'Add thermal check with 72°C hard limit and 60s cool down at 68°C',
        diff: `+   Before any heavy compute:
+     1. Check CPU temp via /sys/class/thermal/thermal_zone0/temp
+     2. If temp > 68°C (68000): Abort and cool down for 60 seconds
+     3. If temp > 72°C (72000): Hard abort - do not proceed
+     4. Only resume if temp < 65°C`,
      });
    }

    // Pattern 5: Git conflicts → add pre-push sync
    if (error.includes('git') && error.includes('conflict')) {
      mutations.push({
        type: 'workflow',
        severity: 'moderate',
        description: 'Run git sync before pushes',
        diff: `+   Before git push: .openclaw/scripts/sync.sh --pull-first`,
      });
    }

    return mutations;
  }

  async applyMutation(mutation: Mutation): Promise<boolean> {
    try {
      const agentsContent = await fs.readFile(this.agentsPath, 'utf8');

      // Apply mutation to AGENTS.md
      const newContent = this.patchAgentsMd(agentsContent, mutation);

      await fs.writeFile(this.agentsPath, newContent, 'utf8');

      // Log mutation to Git Notes
      await this.logToGitNotes(mutation);

      return true;
    } catch (error) {
      console.error('Failed to apply mutation:', error);
      return false;
    }
  }

  private patchAgentsMd(content: string, mutation: Mutation): string {
    const timestamp = new Date().toISOString();

    // Add mutation to AGENTS.md evolution log
    const evolutionEntry = `
## Evolution Log - ${timestamp}

### ${mutation.type.toUpperCase()} Mutation (${mutation.severity})
**Description:** ${mutation.description}

**Diff:**
\`\`\`diff
${mutation.diff}
\`\`\`
`;

    return content + evolutionEntry;
  }

  private async logToGitNotes(mutation: Mutation): Promise<void> {
    const noteContent = JSON.stringify({
      timestamp: new Date().toISOString(),
      mutation,
      workspace: this.workspace,
    }, null, 2);

    // Note: Git Notes requires git to be available
    // This would be executed via: git notes add -m "${noteContent}"
  }

  async run(trace: ExecutionTrace): Promise<boolean> {
    const mutations = await this.analyzeFailure(trace);

    if (mutations.length === 0) {
      console.log('No mutations generated - pattern not recognized');
      return false;
    }

    console.log(`🧬 GEPA: Generated ${mutations.length} mutation(s)`);

    let successCount = 0;
    for (const mutation of mutations.slice(0, this.config.maxMutations)) {
      const applied = await this.applyMutation(mutation);
      if (applied) {
        successCount++;
        console.log(`✅ Applied: ${mutation.description}`);
      }
    }

    return successCount > 0;
  }
}

// CLI Interface
async function main() {
  const args = process.argv.slice(2);
  const tracePath = args.find((_, i) => args[i - 1] === '--trace');
  const failure = args.find((_, i) => args[i - 1] === '--failure');

  if (!tracePath) {
    console.error('Usage: node evolve.ts --trace <path> [--failure <error>]');
    process.exit(1);
  }

  const trace: ExecutionTrace = JSON.parse(await fs.readFile(tracePath, 'utf8'));

  if (failure) {
    trace.error = failure;
    trace.outcome = 'failure';
  }

  const mutator = new GEPAMutator({
    workspace: process.cwd(),
    maxMutations: 5,
    learningRate: 0.1,
  });

  await mutator.run(trace);
}

main().catch(console.error);
