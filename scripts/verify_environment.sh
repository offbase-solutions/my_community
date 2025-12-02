#!/bin/bash
# File: scripts/verify_environment.sh
# Purpose: Verify all required tools are installed and configured

echo "=================================="
echo "Stakify Environment Verification"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track overall status
ALL_CHECKS_PASSED=true

# Function to check command exists
check_command() {
    local cmd=$1
    local name=$2
    
    if command -v $cmd &> /dev/null; then
        echo -e "${GREEN}✓${NC} $name is installed"
        if [ -n "$3" ]; then
            local version=$($cmd $3 2>&1 | head -n 1)
            echo "  Version: $version"
        fi
        return 0
    else
        echo -e "${RED}✗${NC} $name is NOT installed"
        ALL_CHECKS_PASSED=false
        return 1
    fi
}

echo "Checking required tools..."
echo ""

# Check Flutter
check_command "flutter" "Flutter" "--version"
echo ""

# Check Dart
check_command "dart" "Dart" "--version"
echo ""

# Check Stacked CLI
check_command "stacked" "Stacked CLI" "--version"
echo ""

# Check Git
check_command "git" "Git" "--version"
echo ""

# Check Node.js
check_command "node" "Node.js" "--version"
echo ""

# Check npm
check_command "npm" "npm" "--version"
echo ""

# Check if PocketBase binary exists
echo "Checking PocketBase..."
if [ -f "./db/pocketbase" ]; then
    echo -e "${GREEN}✓${NC} PocketBase binary found"
    # Try to get version
    ./db/pocketbase --version 2>&1 | head -n 1
else
    echo -e "${YELLOW}⚠${NC} PocketBase binary not found in ./db/"
    echo "  Download from: https://pocketbase.io/docs/"
fi
echo ""

# Check MCP Server
echo "Checking PocketBase MCP Server..."
if npm list -g @pocketbase/mcp-server &> /dev/null; then
    echo -e "${GREEN}✓${NC} PocketBase MCP Server is installed globally"
else
    echo -e "${YELLOW}⚠${NC} PocketBase MCP Server not installed globally"
    echo "  Install with: npm install -g @pocketbase/mcp-server"
fi
echo ""

# Check Flutter doctor
echo "Running Flutter doctor..."
flutter doctor
echo ""

# Final status
echo "=================================="
if [ "$ALL_CHECKS_PASSED" = true ]; then
    echo -e "${GREEN}All core tools verified!${NC}"
    echo "You're ready to start development."
else
    echo -e "${RED}Some tools are missing.${NC}"
    echo "Please install missing tools before proceeding."
    exit 1
fi
echo "=================================="