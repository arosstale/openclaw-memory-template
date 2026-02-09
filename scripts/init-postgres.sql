-- OpenClaw V2.1 PostgreSQL Initialization Script
-- Creates tables for memory, context, and evolution tracking

-- Memory storage (Markdown sync)
CREATE TABLE IF NOT EXISTS memory (
    id SERIAL PRIMARY KEY,
    path TEXT NOT NULL UNIQUE,
    content TEXT,
    hash TEXT,
    last_synced TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Context snippets for fast retrieval
CREATE TABLE IF NOT EXISTS context (
    id SERIAL PRIMARY KEY,
    memory_id INTEGER REFERENCES memory(id) ON DELETE CASCADE,
    section TEXT,
    content TEXT,
    embedding vector(1536),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Evolution mutations (GEPA log)
CREATE TABLE IF NOT EXISTS evolution_log (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mutation_type TEXT NOT NULL,
    severity TEXT NOT NULL,
    description TEXT,
    diff TEXT,
    trace_id TEXT,
    status TEXT DEFAULT 'applied'
);

-- Swarm protocol messages
CREATE TABLE IF NOT EXISTS swarm_messages (
    id SERIAL PRIMARY KEY,
    sender TEXT NOT NULL,
    recipient TEXT NOT NULL,
    message_type TEXT NOT NULL,
    payload JSONB,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivered_at TIMESTAMP
);

-- Performance metrics
CREATE TABLE IF NOT EXISTS performance_metrics (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    model TEXT,
    task_type TEXT,
    tokens_used INTEGER,
    latency_ms INTEGER,
    outcome TEXT,
    thermal_check BOOLEAN DEFAULT FALSE,
    cpu_temp REAL
);

-- Indexes for performance
CREATE INDEX idx_memory_path ON memory(path);
CREATE INDEX idx_context_memory_id ON context(memory_id);
CREATE INDEX idx_evolution_timestamp ON evolution_log(timestamp);
CREATE INDEX idx_swarm_recipient ON swarm_messages(recipient, status);
CREATE INDEX idx_performance_timestamp ON performance_metrics(timestamp);

-- Enable pgvector for embeddings
CREATE EXTENSION IF NOT EXISTS vector;

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO openclaw;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO openclaw;

-- Auto-vacuum configuration for high-frequency tables
-- swarm_messages is written frequently during handoffs
ALTER TABLE swarm_messages SET (autovacuum_vacuum_scale_factor = 0.1);
ALTER TABLE swarm_messages SET (autovacuum_analyze_scale_factor = 0.05);
ALTER TABLE swarm_messages SET (autovacuum_vacuum_cost_delay = '10ms');

-- evolution_log tracks mutations
ALTER TABLE evolution_log SET (autovacuum_vacuum_scale_factor = 0.2);
ALTER TABLE evolution_log SET (autovacuum_analyze_scale_factor = 0.1);

-- performance_metrics collects thermal data
ALTER TABLE performance_metrics SET (autovacuum_vacuum_scale_factor = 0.15);
ALTER TABLE performance_metrics SET (autovacuum_analyze_scale_factor = 0.07);

-- Comment tables
COMMENT ON TABLE memory IS 'Markdown file sync - source of truth';
COMMENT ON TABLE context IS 'Fast vector embeddings for semantic search';
COMMENT ON TABLE evolution_log IS 'GEPA mutation history';
COMMENT ON TABLE swarm_messages IS 'Multi-agent coordination protocol';
COMMENT ON TABLE performance_metrics IS 'Agent performance tracking and thermal safety';
