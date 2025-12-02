#!/bin/bash
# File: scripts/verify_pocketbase.sh
# Purpose: Verify PocketBase is running and accessible

echo "=================================="
echo "PocketBase Verification"
echo "=================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PB_URL="http://localhost:8090"

# Check if PocketBase is running
echo "Checking PocketBase health endpoint..."
if curl -s -f "${PB_URL}/api/health" > /dev/null; then
    echo -e "${GREEN}✓${NC} PocketBase is running at ${PB_URL}"
else
    echo -e "${RED}✗${NC} PocketBase is NOT running"
    echo "  Start with: cd db && ./pocketbase serve"
    exit 1
fi
echo ""

# Check PocketBase version
echo "Checking PocketBase version..."
HEALTH_RESPONSE=$(curl -s "${PB_URL}/api/health")
echo "  Response: $HEALTH_RESPONSE"
echo ""

# Check if pocketbase.yaml exists
echo "Checking pocketbase.yaml configuration..."
if [ -f "pocketbase.yaml" ]; then
    echo -e "${GREEN}✓${NC} pocketbase.yaml found"
    echo "  Contents:"
    cat pocketbase.yaml | grep -v "password"
else
    echo -e "${RED}✗${NC} pocketbase.yaml NOT found"
    echo "  Create this file in project root"
    exit 1
fi
echo ""

# Check MCP Server connection
echo "Checking MCP Server connection..."
if command -v mcp-cli &> /dev/null; then
    # Try to list tools
    mcp-cli list-tools pocketbase-* 2>&1 | grep -q "create_collection"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} MCP Server connected"
        echo "  Available tools:"
        mcp-cli list-tools pocketbase-* 2>&1 | grep -E "(create_|update_|delete_)" | head -5
    else
        echo -e "${YELLOW}⚠${NC} MCP Server not connected or not configured"
        echo "  Configure in .claude/mcp-servers.json"
    fi
else
    echo -e "${YELLOW}⚠${NC} mcp-cli not installed"
    echo "  MCP commands will need to be run through IDE AI assistant"
fi
echo ""

# Check admin UI accessibility
echo "Checking admin UI..."
if curl -s -f "${PB_URL}/_/" > /dev/null; then
    echo -e "${GREEN}✓${NC} Admin UI accessible at ${PB_URL}/_/"
else
    echo -e "${RED}✗${NC} Admin UI not accessible"
fi
echo ""

echo "=================================="
echo -e "${GREEN}PocketBase verification complete!${NC}"
echo "=================================="