#!/bin/bash

# OpenClaw Bootstrap Script
# Sets up directory structure and moves existing files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$SCRIPT_DIR")"

echo "🚀 OpenClaw V2 Self-Evolution Setup"
echo "======================================"
echo ""

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p "$WORKSPACE/.openclaw/core"
mkdir -p "$WORKSPACE/.openclaw/context"
mkdir -p "$WORKSPACE/.openclaw/scripts"
mkdir -p "$WORKSPACE/.openclaw/logs"
mkdir -p "$WORKSPACE/memory/core"
mkdir -p "$WORKSPACE/memory/daily"
mkdir -p "$WORKSPACE/memory/projects"
mkdir -p "$WORKSPACE/templates"
mkdir -p "$WORKSPACE/docs"

echo "✓ Directories created"

# Move core files if they exist
echo ""
echo "📦 Moving core files..."
for file in IDENTITY.md SOUL.md USER.md TOOLS.md HEARTBEAT.md AGENTS.md; do
    if [ -f "$WORKSPACE/$file" ]; then
        mv "$WORKSPACE/$file" "$WORKSPACE/.openclaw/core/$file" 2>/dev/null
        echo "✓ Moved $file"
    elif [ -f "$WORKSPACE/.openclaw/core/$file" ]; then
        echo "✓ $file already in .openclaw/core/"
    else
        echo "⚠️  $file not found"
    fi
done

# Move memory files
echo ""
echo "🧠 Moving memory files..."
for file in MEMORY.md; do
    if [ -f "$WORKSPACE/$file" ]; then
        mv "$WORKSPACE/$file" "$WORKSPACE/memory/core/$file" 2>/dev/null
        echo "✓ Moved $file to memory/core/"
    fi
done

# Initialize Git in memory/
echo ""
echo "🔧 Initializing Git repository in memory/..."
if [ ! -d "$WORKSPACE/memory/.git" ]; then
    cd "$WORKSPACE/memory" || exit 1
    git init
    git add .
    git commit -m "Initial commit: Migrate to OpenClaw V2 structure"
    echo "✓ Git repo initialized"
    echo "📝 Don't forget to: git remote add origin <your-repo-url>"
    echo "   And update .openclaw/scripts/sync.sh with GIT_REMOTE"
else
    echo "✓ Git repo already exists"
fi

# Create daily log for today
echo ""
echo "📝 Creating today's daily log..."
"$WORKSPACE/.openclaw/scripts/log.sh"

# Create templates
echo ""
echo "📋 Creating templates..."
cat > "$WORKSPACE/templates/daily-log.md" << 'EOF'
---
date: {{DATE}}
session_start: {{SESSION_START}}
session_end: {{SESSION_END}}
projects: []

# Session
## Active Projects
- 
## Tasks Completed
- 
## Blockers
-

## Learnings
- 

## Decisions
- 

## Next Steps
-
EOF

cat > "$WORKSPACE/templates/project.md" << 'EOF'
# {{PROJECT_NAME}}

**Status**: {{ACTIVE|PAUSED|COMPLETE}}
**Created**: {{DATE}}
**Updated**: {{LAST_UPDATE}}

## Context
{{PROJECT_CONTEXT}}

## Progress
- [ ] Milestone 1
- [ ] Milestone 2

## Notes
{{NOTES}}

## Resources
{{RESOURCES}}
EOF

echo "✓ Templates created"

# Make scripts executable
chmod +x "$WORKSPACE/.openclaw/scripts/"*.sh"

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Set up Git remote: cd memory && git remote add origin <your-repo-url>"
echo "2. Update sync script: Edit .openclaw/scripts/sync.sh with your remote"
echo "3. Run sync: .openclaw/scripts/sync.sh"
echo "4. Update AGENTS.md with new directives (see V2_SELF_EVOLUTION_PLAN.md)"
