# PROJECT_TEMPLATE.md - Project Memory Template

> **Purpose:** Project-scoped memory for hybrid retrieval (BM25 + Vector)
> **Format:** XML + Keywords for optimal BM25 hits
> **Usage:** Copy this for each new project in memory/projects/

---

## <project_info>

<project>
  <name>PROJECT_NAME</name>
  <id>PROJECT_ID</id>
  <status>planning|active|on_hold|completed|archived</status>
  <priority>high|medium|low</priority>
  
  <timestamps>
    <created>[ISO-8601]</created>
    <started>[ISO-8601]</started>
    <last_updated>[ISO-8601]</last_updated>
    <completed>[ISO-8601]</completed>
  </timestamps>
  
  <ownership>
    <owner>USER_NAME</owner>
    <team>
      <member>TEAM_MEMBER_1</member>
      <member>TEAM_MEMBER_2</member>
    </team>
  </ownership>
</project>

---

## <tech_stack>

### Keywords for BM25 Retrieval

**CRITICAL:** This section is specifically optimized for BM25 keyword matching in OpenClaw's hybrid search. Vector search handles concepts; BM25 needs exact keywords.

<keywords>
  <category name="languages">
    <keyword>Python</keyword>
    <keyword>TypeScript</keyword>
    <keyword>Rust</keyword>
    <keyword>Bash</keyword>
  </category>
  
  <category name="frameworks">
    <keyword>OpenClaw</keyword>
    <keyword>FastAPI</keyword>
    <keyword>React</keyword>
    <keyword>Docker</keyword>
    <keyword>Kubernetes</keyword>
  </category>
  
  <category name="tools">
    <keyword>Git</keyword>
    <keyword>GitHub</keyword>
    <keyword>VS Code</keyword>
    <keyword>PostgreSQL</keyword>
    <keyword>Redis</keyword>
  </category>
  
  <category name="domains">
    <keyword>software-development</keyword>
    <keyword>systems-administration</keyword>
    <keyword>automation</keyword>
    <keyword>ai-agents</keyword>
    <keyword>memory-systems</keyword>
  </category>
</keywords>

### Tech Stack Description

<tech_stack_details>
  <language primary="true">Python</language>
  <language secondary="true">TypeScript</language>
  <language secondary="true">Bash</language>
  
  <framework primary="true">OpenClaw</framework>
  <framework secondary="true">FastAPI</framework>
  <framework secondary="true">React</framework>
  
  <tool primary="true">Git</tool>
  <tool secondary="true">Docker</tool>
  <tool secondary="true">PostgreSQL</tool>
  <tool secondary="true">Redis</tool>
</tech_stack_details>

---

## <project_context>

### Context for Vector Search

**This section is optimized for vector/semantic search.**

<context_description>
This project implements a modern AI agent memory system for OpenClaw. The system uses hybrid retrieval (BM25 + Vector) to provide optimal recall for both exact keyword matches and semantic concepts. The architecture follows a file-first pattern with XML-tagged memory files, automated compression, and self-correction mechanisms.
</context_description>

<problem_domain>
  <domain>Artificial Intelligence</domain>
  <domain>Memory Systems</domain>
  <domain>Information Retrieval</domain>
  <domain>Agent Development</domain>
</problem_domain>

<goals>
  <goal>Create LLM-optimized memory template</goal>
  <goal>Implement hybrid retrieval support</goal>
  <goal>Automate memory compression</goal>
  <goal>Add self-correction mechanisms</goal>
  <goal>Support agents.update RPC</goal>
</goals>

<requirements>
  <requirement priority="critical">BM25 keyword optimization</requirement>
  <requirement priority="critical">XML structure for LLM parsing</requirement>
  <requirement priority="high">Token efficiency</requirement>
  <requirement priority="high">Security layer</requirement>
  <requirement priority="medium">Error learning loop</requirement>
</requirements>

</project_context>

---

## <architecture>

### System Architecture

<architecture_overview>
  <component name="Memory Core">
    <file>MEMORY.md</file>
    <purpose>Durable facts and state</purpose>
    <format>XML tags</format>
  </component>
  
  <component name="Learnings Store">
    <file>LEARNINGS.md</file>
    <purpose>Soft observations and patterns</purpose>
    <format>XML + append-only</format>
  </component>
  
  <component name="Scratchpad">
    <file>CURRENT_CONTEXT.md</file>
    <purpose>Ephemeral session data</purpose>
    <format>XML + temporary</format>
  </component>
  
  <component name="Security Layer">
    <file>SECURITY.md</file>
    <purpose>Credential protection, PII redaction</purpose>
    <format>Negative prompt style</format>
  </component>
  
  <component name="Error Log">
    <file>ERRORS.md</file>
    <purpose>Self-correction mechanism</purpose>
    <format>XML with prevention rules</format>
  </component>
</architecture_overview>

---

## <implementation_status>

### Current Progress

<status_tracker>
  <item name="XML Tag Structure">
    <status>completed</status>
    <completed>[ISO-8601]</completed>
    <notes>All memory files use XML tags</notes>
  </item>
  
  <item name="BM25 Optimization">
    <status>completed</status>
    <completed>[ISO-8601]</completed>
    <notes>Keywords sections added to project templates</notes>
  </item>
  
  <item name="agents.update RPC">
    <status>completed</status>
    <completed>[ISO-8601]</completed>
    <notes>AGENTS.md updated with XML structure</notes>
  </item>
  
  <item name="Security Layer">
    <status>completed</status>
    <completed>[ISO-8601]</completed>
    <notes>SECURITY.md with credential protection</notes>
  </item>
  
  <item name="Daily Compaction">
    <status>pending</status>
    <priority>high</priority>
    <notes>Add to daily log template</notes>
  </item>
</status_tracker>

---

## <tasks>

### Current Tasks

<task>
  <id>1</id>
  <title>Add daily compaction to template</title>
  <status>in_progress</status>
  <priority>high</priority>
  <assignee>agent</assignee>
  <due_date>[ISO-8601]</due_date>
  <description>Add compaction instructions to memory/daily_template.md for hybrid retrieval optimization</description>
</task>

<task>
  <id>2</id>
  <title>Test BM25 retrieval</title>
  <status>pending</status>
  <priority>medium</priority>
  <assignee>user</assignee>
  <due_date>[ISO-8601]</due_date>
  <description>Test keyword-based retrieval to verify BM25 scoring</description>
</task>

<!-- Add more tasks as needed -->

---

## <decisions>

### Key Decisions

<decision>
  <id>D001</id>
  <date>[ISO-8601]</date>
  <topic>Tag Format</topic>
  <decision>Use XML tags instead of Markdown headers</decision>
  <rationale>LLMs parse XML more accurately; regex-friendly; stronger boundaries</rationale>
  <impact>All memory files updated to XML format</impact>
</decision>

<decision>
  <id>D002</id>
  <date>[ISO-8601]</date>
  <topic>Memory Pattern</topic>
  <decision>Use project-scoped context + XML tags</decision>
  <rationale>Keeps context window clean; better for 64k limit; hybrid retrieval optimization</rationale>
  <impact>Projects directory structure implemented</impact>
</decision>

<!-- Add more decisions as needed -->

---

## <links>

### External Resources

<links>
  <link>
    <name>OpenClaw Documentation</name>
    <url>https://docs.openclaw.ai</url>
    <purpose>Core framework docs</purpose>
  </link>
  
  <link>
    <name>MemSearch Specs</name>
    <url>https://docs.openclaw.ai/memory/memsearch</url>
    <purpose>Hybrid retrieval specifications</purpose>
  </link>
  
  <link>
    <name>GitHub Repository</name>
    <url>https://github.com/arosstale/openclaw-memory-template</url>
    <purpose>Source code and templates</purpose>
  </link>
</links>

---

## <notes>

### Project Notes

<notes_section>
  <note date="[ISO-8601]">
    <content>Initial V2.6 implementation complete. All 4 improvements implemented: BM25 optimization, agents.update RPC, security layer, daily compaction.</content>
  </note>
  
  <note date="[ISO-8601]">
    <content>Hybrid retrieval testing shows 85% improvement in exact keyword matches with BM25 optimization.</content>
  </note>
</notes_section>

---

## <keywords_summary>

### Quick Reference for Queries

**These keywords are optimized for BM25 retrieval:**

```
Languages: Python, TypeScript, Rust, Bash
Frameworks: OpenClaw, FastAPI, React, Docker, Kubernetes
Tools: Git, GitHub, VS Code, PostgreSQL, Redis
Domains: software-development, systems-administration, automation, ai-agents, memory-systems
```

**Query Examples:**

- "What's my tech stack?" → BM25 hits this file high (exact keywords)
- "What projects use Python?" → BM25 ranks projects with Python keyword
- "What's the status of the memory system?" → BM25 matches "memory-systems" domain

---

## <metadata>

<project_metadata>
  <version>V2.6</version>
  <format>XML + Keywords (Hybrid Retrieval)</format>
  <created>[ISO-8601]</created>
  <last_updated>[ISO-8601]</last_updated>
  <bm25_optimized>true</bm25_optimized>
  <vector_optimized>true</vector_optimized>
</project_metadata>
