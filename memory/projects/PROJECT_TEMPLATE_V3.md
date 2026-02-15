# PROJECT_TEMPLATE_V3.md - Bio-Inspired Project Memory

> **Version:** V3.0 (Mycelium-Linked)
> **Purpose:** Project-scoped memory with semantic cross-project linking
> **Bio-Inspired Function:** Fungal mycelium network (nutrient sharing)

---

## 🍄 YAML HEADER (Semantic Mycelium)

```yaml
---
tags:
  - auth-service
  - python-patterns
  - api-standard-v2
  - jwt-authentication

related_to:
  - ../shared-library-x/shared-library.md
  - ../project-b-auth/auth-patterns.md

project_type: microservice
language: python-3.11
framework: fastapi

confidence_score: 0.85
relevance_decay: low
created: 2026-02-15T16:00:00Z
last_updated: 2026-02-15T16:00:00Z
---
```

---

## 🧬 MYCELIUM CONCEPT

In nature, fungal mycelium networks connect plants across vast distances, sharing nutrients and information. The network is **decentralized**, **resilient**, and **self-healing**.

**Your project memory works the same way:**
- Tags act as "connection points" in the mycelium
- Related projects are linked via semantic tags
- Knowledge flows across projects without centralized management
- When one project learns something, others benefit

---

## 🔗 SEMANTIC TAGGING SYSTEM

### Tag Categories

**Technology Tags:**
- `python-3.11`, `python-3.12`
- `fastapi`, `flask`, `django`
- `postgresql`, `mongodb`, `redis`
- `docker`, `kubernetes`

**Pattern Tags:**
- `auth-patterns`, `api-standard-v2`
- `error-handling-async`, `circuit-breaker`
- `logging-structured`, `monitoring-prometheus`

**Domain Tags:**
- `auth-service`, `user-management`
- `data-processing`, `analytics-dashboard`
- `trading-system`, `research-engine`

**Lifecycle Tags:**
- `production-ready`, `in-development`, `experimental`
- `deprecated`, `archived`, `migrated`

### Tag Conventions
```
Technology: [language]-[major].[minor]  → python-3.11
Framework: [name]                     → fastapi
Pattern: [domain]-[concept]            → auth-patterns
Lifecycle: [status]                    → production-ready
```

---

## 🌐 CROSS-PROJECT LINKING

### Related Projects
<related_projects>
  <project path="../shared-library-x/shared-library.md">
    <tags_match>api-standard-v2, python-3.11</tags_match>
    <relationship>Shared authentication utilities</relationship>
    <confidence_score>0.90</confidence_score>
  </project>
  
  <project path="../project-b-auth/auth-patterns.md">
    <tags_match>auth-patterns, jwt-authentication</tags_match>
    <relationship>Auth implementation patterns</relationship>
    <confidence_score>0.85</confidence_score>
  </project>
</related_projects>

---

## 📊 PROJECT CONTEXT

### Project Status
<status>
  <name>Auth Service</name>
  <phase>in-development</phase>
  <completion>0.65</completion>
  <priority>high</priority>
  <blockers>None</blockers>
</status>

### Tech Stack
<tech_stack>
  <language primary="true">Python 3.11</language>
  <framework primary="true">FastAPI</framework>
  <database>PostgreSQL 15</database>
  <cache>Redis 7</cache>
  <auth>JWT (HS256)</auth>
  <containerization>Docker</containerization>
  <orchestration>Kubernetes</orchestration>
</tech_stack>

---

## 🔍 HYBRID RETRIEVAL (BM25 + Vector)

### Keywords for BM25 Scoring
<keywords>
  <category name="languages">
    <keyword>Python</keyword>
    <keyword>Python 3.11</keyword>
  </category>
  
  <category name="frameworks">
    <keyword>FastAPI</keyword>
    <keyword>Pydantic</keyword>
  </category>
  
  <category name="domains">
    <keyword>Authentication</keyword>
    <keyword>Authorization</keyword>
    <keyword>JWT</keyword>
  </category>
  
  <category name="patterns">
    <keyword>Middleware</keyword>
    <keyword>Dependency Injection</keyword>
    <keyword>Async/Await</keyword>
  </category>
</keywords>

**Why Keywords Matter:**
- **Vector Search:** Handles concepts ("how do I authenticate users?")
- **BM25 Search:** Needs exact matches ("what's my auth framework?")
- **Combined:** Optimal recall for both semantic and keyword queries

---

## 📝 PROJECT HISTORY

### Recent Changes
<recent_changes>
  <change>
    <timestamp>2026-02-15T14:00:00Z</timestamp>
    <type>feature</type>
    <description>Implemented JWT token validation</description>
    <agent>engineer</agent>
    <files_changed>src/auth/middleware.py</files_changed>
  </change>
  
  <change>
    <timestamp>2026-02-15T10:00:00Z</timestamp>
    <type>refactor</type>
    <description>Moved auth logic to separate service</description>
    <agent>engineer</agent>
    <files_changed>src/auth/service.py</files_changed>
  </change>
</recent_changes>

### Decisions Made
<decisions>
  <decision id="D001">
    <timestamp>2026-02-14T16:00:00Z</timestamp>
    <context>Choosing between Flask and FastAPI</context>
    <choice>FastAPI</choice>
    <rationale>
      - Native async support
      - Automatic OpenAPI docs
      - Type hints built-in
      - Better performance
    </rationale>
    <confidence_score>0.90</confidence_score>
  </decision>
  
  <decision id="D002">
    <timestamp>2026-02-13T11:00:00Z</timestamp>
    <context>Choosing between JWT and OAuth2</context>
    <choice>JWT</choice>
    <rationale>
      - Simpler to implement
      - Stateless (no database lookup)
      - Good for microservices
    </rationale>
    <confidence_score>0.85</confidence_score>
  </decision>
</decisions>

---

## 🎯 ANCESTRAL KNOWLEDGE

### Inherited from Related Projects
<ancestral_knowledge>
  <pattern source="project-b-auth/auth-patterns.md">
    <description>Rate limiting on auth endpoints</description>
    <confidence_score>0.90</confidence_score>
    <implementation>Use slowapi or custom middleware</implementation>
  </pattern>
  
  <pattern source="shared-library-x/shared-library.md">
    <description>Structured logging for auth events</description>
    <confidence_score>0.95</confidence_score>
    <implementation>Use loguru with JSON formatter</implementation>
  </pattern>
</ancestral_knowledge>

---

## 📈 MYCELIUM HEALTH

### Connection Metrics
| Metric | Value |
|--------|--------|
| **Connected Projects** | 2 |
| **Shared Tags** | 3 |
| **Ancestral Patterns** | 2 |
| **Avg Confidence** | 0.87 |
| **Network Health** | Healthy |

---

<metadata>
  <bio_layer>mycelium</bio_layer>
  <semantic_linking>true</semantic_linking>
  <cross_project_sharing>true</cross_project_sharing>
  <graphiti_compatible>true</graphiti_compatible>
  <version>V3.0</version>
</metadata>
