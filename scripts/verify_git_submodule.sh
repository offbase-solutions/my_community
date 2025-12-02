#!/bin/bash
# File: scripts/verify_git_submodule.sh
# Purpose: Verify git submodule is properly configured

echo "=================================="
echo "Git Submodule Verification"
echo "=================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if .gitmodules exists
if [ ! -f ".gitmodules" ]; then
    echo -e "${RED}✗${NC} .gitmodules not found"
    echo "  Submodule not configured"
    echo "  Add with: git submodule add https://github.com/offbase-solutions/stakify-codegen-docs.git assets/docs"
    exit 1
fi

echo -e "${GREEN}✓${NC} .gitmodules found"
echo ""

# Check submodule configuration
echo "Submodule configuration:"
cat .gitmodules
echo ""

# Check submodule status
echo "Checking submodule status..."
git submodule status
echo ""

# Check if submodule is initialized
if git submodule status | grep -q "^-"; then
    echo -e "${YELLOW}⚠${NC} Submodule not initialized"
    echo "  Run: git submodule init && git submodule update"
    exit 1
fi

# Check if submodule has updates
echo "Checking for submodule updates..."
cd assets/docs
git fetch origin
BEHIND=$(git rev-list HEAD..origin/main --count)
cd ../..

if [ "$BEHIND" -gt 0 ]; then
    echo -e "${YELLOW}⚠${NC} Submodule is $BEHIND commits behind"
    echo "  Update with: git submodule update --remote assets/docs"
else
    echo -e "${GREEN}✓${NC} Submodule is up to date"
fi
echo ""

# Check submodule commit
echo "Current submodule commit:"
git ls-tree HEAD assets/docs
echo ""

# Verify critical files exist in submodule
echo "Verifying critical files in submodule..."
CRITICAL_FILES=(
    "assets/docs/RULES/RULES-ARCHITECTURE.md"
    "assets/docs/PDG/PDG-AI-AGENT-TASK.md"
    "assets/docs/VLG/VLG-README-V2.md"
    "assets/docs/SLG/SLG-README.md"
)

ALL_PRESENT=true
for file in "${CRITICAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $(basename $file)"
    else
        echo -e "${RED}✗${NC} $(basename $file) missing"
        ALL_PRESENT=false
    fi
done
echo ""

echo "=================================="
if [ "$ALL_PRESENT" = true ]; then
    echo -e "${GREEN}Git submodule verified!${NC}"
else
    echo -e "${RED}Some files missing in submodule.${NC}"
    echo "Run: git submodule update --init --recursive"
    exit 1
fi
echo "=================================="