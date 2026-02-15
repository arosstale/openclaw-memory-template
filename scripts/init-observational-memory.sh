#!/usr/bin/env python3
"""
Initialize Observational Memory database and system.

This script creates the SQLite database and default configuration.
"""

import sys
import os
from pathlib import Path
import sqlite3

# Paths
OPENCLAW_DIR = Path(".openclaw")
DB_PATH = OPENCLAW_DIR / "observational_memory.db"


def init_database():
    """Initialize Observational Memory database."""
    import sqlite3

    print("📊 Initializing Observational Memory database...")

    # Ensure .openclaw directory exists
    OPENCLAW_DIR.mkdir(parents=True, exist_ok=True)

    # Create database
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Create observations table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS observations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT NOT NULL,
            priority TEXT NOT NULL,
            content TEXT NOT NULL,
            referenced_date TEXT,
            thread_id TEXT,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
    """)

    # Create memory_records table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS memory_records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            thread_id TEXT UNIQUE NOT NULL,
            observations_json TEXT NOT NULL,
            current_task TEXT,
            suggested_response TEXT,
            last_observed_at TEXT,
            updated_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
    """)

    conn.commit()
    conn.close()

    print(f"✅ Database created at: {DB_PATH}")
    print(f"📂 Observational Memory directory: {OPENCLAW_DIR}")
    return 0


def main():
    """Main entry point."""
    print("🐺📿 OpenClaw Observational Memory Initialization")
    print("="*60)

    try:
        return init_database()
    except Exception as e:
        print(f"❌ Error: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
