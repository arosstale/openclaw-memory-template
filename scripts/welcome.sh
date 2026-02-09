#!/bin/bash
# OpenClaw V2.1 Elite - Welcome Script
# Pi's onboarding experience for new users

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

clear

cat << 'EOF'
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║   🐺  Welcome to OpenClaw V2.1 Elite - Pi                     ║
║                                                                ║
║   The Self-Evolving Agent Operating System                     ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
EOF

echo ""
echo "Initializing Pi's neural pathways..."
echo ""

# Step 1: Check Docker
echo -e "${BLUE}[1/6]${NC} Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker not found${NC}"
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker daemon not running${NC}"
    echo "Please start Docker and try again"
    exit 1
fi

echo -e "${GREEN}✅ Docker is ready${NC}"
sleep 1

# Step 2: Check Docker Compose
echo ""
echo -e "${BLUE}[2/6]${NC} Checking Docker Compose..."
if ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ Docker Compose not found${NC}"
    echo "Please install Docker Compose v2"
    exit 1
fi

echo -e "${GREEN}✅ Docker Compose is ready${NC}"
sleep 1

# Step 3: Set up environment
echo ""
echo -e "${BLUE}[3/6]${NC} Setting up environment..."

if [ ! -f ".env" ]; then
    cat > .env << EOF
# OpenClaw Elite Environment
DB_PASSWORD=changeme_in_production_$(openssl rand -hex 8)
QDRANT_API_KEY=
EOF
    echo -e "${GREEN}✅ Created .env file${NC}"
else
    echo -e "${YELLOW}⚠️  .env file already exists${NC}"
fi

sleep 1

# Step 4: Start PostgreSQL
echo ""
echo -e "${BLUE}[4/6]${NC} Starting PostgreSQL sidecar..."
if ! docker compose -f docker-compose.postgres.yml up -d; then
    echo -e "${RED}❌ Failed to start PostgreSQL${NC}"
    exit 1
fi

echo -e "${GREEN}✅ PostgreSQL sidecar started${NC}"
sleep 2

# Step 5: Initialize database
echo ""
echo -e "${BLUE}[5/6]${NC} Initializing database schema..."

# Wait for PostgreSQL to be ready
MAX_TRIES=10
TRY=0
while [ $TRY -lt $MAX_TRIES ]; do
    if docker exec openclaw-postgres pg_isready -U openclaw -d openclaw_elite &> /dev/null; then
        echo -e "${GREEN}✅ PostgreSQL is ready${NC}"
        break
    fi
    TRY=$((TRY + 1))
    echo "Waiting for PostgreSQL... ($TRY/$MAX_TRIES)"
    sleep 2
done

if [ $TRY -eq $MAX_TRIES ]; then
    echo -e "${RED}❌ PostgreSQL failed to start${NC}"
    exit 1
fi

# Initialize schema
docker exec openclaw-postgres psql -U openclaw -d openclaw_elite -f /docker-entrypoint-initdb.d/init-postgres.sql

echo -e "${GREEN}✅ Database schema initialized${NC}"
sleep 1

# Step 6: Start QMD (optional)
echo ""
echo -e "${BLUE}[6/6]${NC} Starting QMD sidecar (optional, recommended)..."

read -p "Start QMD sidecar for ultra-fast hybrid search? [Y/n] " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]] || [ -z "$REPLY" ]; then
    if ! docker compose -f docker-compose.qmd.yml up -d; then
        echo -e "${RED}❌ Failed to start QMD sidecar${NC}"
        echo "You can start it later with: docker compose -f docker-compose.qmd.yml up -d"
    else
        echo -e "${GREEN}✅ QMD sidecar started${NC}"
        echo ""
        echo "📊 Search Architecture:"
        echo "   • QMD (BM25 + Vector): Ultra-fast current logs"
        echo "   • PostgreSQL: Structured evolution & metrics"
    fi
else
    echo -e "${YELLOW}⚠️  Skipping QMD (you can enable it later)${NC}"
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}🎉 Pi is now online!${NC}"
echo ""
echo "📋 Next Steps:"
echo "   1. Run your first GEPA mutation"
echo "   2. Check MUTATION_LOG.md for IQ tracking"
echo "   3. Review DASHBOARD.md for system status"
echo ""
echo "🔧 Useful Commands:"
echo "   • Check PostgreSQL: docker exec openclaw-postgres psql -U openclaw -d openclaw_elite"
echo "   • Run maintenance: ./scripts/postgres-maintenance.sh"
echo "   • Prune old logs:   ./scripts/prune-elite.sh"
echo "   • Thermal check:    ./scripts/thermal-check.sh"
echo ""
echo "📚 Documentation:"
echo "   • README.md              - Quick start guide"
echo "   • V2_RELEASE_NOTES.md    - Feature overview"
echo "   • PROTOCOL.md            - Swarm coordination"
echo "   • .openclaw/core/AGENTS.md - Pi's behavior rules"
echo ""
echo "🐺 Pi is ready to evolve. LFG!"
echo ""
