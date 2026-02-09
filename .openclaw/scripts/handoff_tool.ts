#!/usr/bin/env node
/**
 * OpenClaw Elite Swarm Handoff Tool
 * Handles task transfer between specialized agents
 *
 * Usage: node handoff_tool.ts --to <agent> --task <description> [--priority <level>]
 */

import fs from 'fs/promises';
import path from 'path';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

interface HandoffPacket {
  from: string;
  to: string;
  taskId: string;
  context: {
    conversationHistory: any[];
    memoryRelevant: any[];
    currentState: any;
  };
  instructions: string;
  priority: 'low' | 'medium' | 'high' | 'critical';
}

class HandoffTool {
  private workspace: string;
  private agentsPath: string;

  constructor(workspace: string) {
    this.workspace = workspace;
    this.agentsPath = path.join(workspace, '.openclaw', 'core', 'AGENTS.md');
  }

  async prepareHandoff(
    toAgent: string,
    taskDescription: string,
    priority: HandoffPacket['priority'] = 'medium'
  ): Promise<HandoffPacket> {
    const taskId = `handoff_${Date.now()}`;

    // Load current AGENTS.md to determine sender role
    const agentsContent = await fs.readFile(this.agentsPath, 'utf8');
    const senderRole = this.detectAgentRole(agentsContent);

    // Gather relevant memory snippets
    const memoryRelevant = await this.getRelevantMemory(taskDescription);

    // Capture current state
    const currentState = await this.captureCurrentState();

    const packet: HandoffPacket = {
      from: senderRole,
      to: toAgent,
      taskId,
      context: {
        conversationHistory: [], // Would be loaded from Git Notes
        memoryRelevant,
        currentState,
      },
      instructions: taskDescription,
      priority,
    };

    return packet;
  }

  private detectAgentRole(agentsContent: string): string {
    // Simple role detection based on AGENTS.md content
    if (agentsContent.includes('research')) return 'researcher';
    if (agentsContent.includes('develop')) return 'developer';
    if (agentsContent.includes('analyst')) return 'analyst';
    if (agentsContent.includes('orchestrat')) return 'orchestrator';
    return 'elite';
  }

  private async getRelevantMemory(query: string): Promise<any[]> {
    // In production, this would query PostgreSQL for vector similarity
    // For now, return mock snippets
    return [
      {
        path: 'MEMORY.md',
        content: '# Identity\n- Agent: Pi-agent\n- User: Artale',
        relevance: 0.95,
      },
      {
        path: 'HEARTBEAT.md',
        content: '# HEARTBEAT\n- Security: PASS\n- Thermal: CHECK',
        relevance: 0.88,
      },
    ];
  }

  private async captureCurrentState(): Promise<any> {
    try {
      // Capture thermal state
      const { stdout: thermalOutput } = await execAsync('cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo "N/A"');
      const tempC = thermalOutput.trim() !== 'N/A' ? parseInt(thermalOutput.trim()) / 1000 : null;

      // Capture git state
      const { stdout: gitBranch } = await execAsync('git branch --show-current 2>/dev/null || echo "N/A"');

      return {
        timestamp: new Date().toISOString(),
        thermal: {
          cpuTempC: tempC,
          safe: tempC ? tempC < 75 : true,
        },
        git: {
          branch: gitBranch.trim(),
          dirty: false, // Would check git status
        },
        memory: {
          postgresConnected: false, // Would check connection
          lastSync: new Date().toISOString(),
        },
      };
    } catch (error) {
      return {
        timestamp: new Date().toISOString(),
        error: 'Failed to capture state',
      };
    }
  }

  async executeHandoff(packet: HandoffPacket): Promise<boolean> {
    try {
      // 1. Log handoff to Git Notes
      await this.logHandoffToGitNotes(packet);

      // 2. In production: Insert into PostgreSQL swarm_messages table
      // await this.insertToSwarmMessages(packet);

      // 3. Display handoff confirmation
      this.displayHandoffConfirmation(packet);

      return true;
    } catch (error) {
      console.error('Handoff failed:', error);
      return false;
    }
  }

  private async logHandoffToGitNotes(packet: HandoffPacket): Promise<void> {
    const noteContent = JSON.stringify({
      timestamp: new Date().toISOString(),
      type: 'handoff',
      packet,
    }, null, 2);

    try {
      await execAsync(`git notes add -m '${noteContent.replace(/'/g, "\\'")}'`);
      console.log('📝 Handoff logged to Git Notes');
    } catch (error) {
      console.log('⚠️  Git Notes unavailable, skipping log');
    }
  }

  private displayHandoffConfirmation(packet: HandoffPacket): void {
    console.log('\n' + '='.repeat(60));
    console.log('🤝 ELITE SWARM HANDOFF');
    console.log('='.repeat(60));
    console.log(`From: ${packet.from.toUpperCase()}`);
    console.log(`To: ${packet.to.toUpperCase()}`);
    console.log(`Task: ${packet.taskId}`);
    console.log(`Priority: ${packet.priority.toUpperCase()}`);
    console.log('─'.repeat(60));
    console.log('Instructions:');
    console.log(`  ${packet.instructions}`);
    console.log('─'.repeat(60));
    console.log('Context:');
    console.log(`  Memory snippets: ${packet.context.memoryRelevant.length}`);
    console.log(`  Thermal check: ${packet.context.currentState.thermal?.safe ? '✅ PASS' : '⚠️ THROTTLE'}`);
    console.log('='.repeat(60) + '\n');
  }
}

// CLI Interface
async function main() {
  const args = process.argv.slice(2);
  const toAgent = args.find((_, i) => args[i - 1] === '--to');
  const task = args.find((_, i) => args[i - 1] === '--task');
  const priority = args.find((_, i) => args[i - 1] === '--priority');

  if (!toAgent || !task) {
    console.error('Usage: node handoff_tool.ts --to <agent> --task <description> [--priority <level>]');
    console.error('Agents: researcher, developer, analyst, orchestrator, elite');
    process.exit(1);
  }

  const tool = new HandoffTool(process.cwd());

  const packet = await tool.prepareHandoff(
    toAgent,
    task,
    (priority as any) || 'medium'
  );

  const success = await tool.executeHandoff(packet);

  if (success) {
    console.log(`✅ Handoff to ${toAgent} complete`);
    process.exit(0);
  } else {
    console.error('❌ Handoff failed');
    process.exit(1);
  }
}

main().catch(console.error);
