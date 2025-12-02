#!/bin/bash
# File: scripts/verify_project_structure.sh
# Purpose: Verify project follows Stakify directory structure

echo "=================================="
echo "Project Structure Verification"
echo "=================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ALL_CHECKS_PASSED=true

check_dir() {
    local dir=$1
    local desc=$2
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} $desc exists: $dir"
        return 0
    else
        echo -e "${RED}✗${NC} $desc missing: $dir"
        ALL_CHECKS_PASSED=false
        return 1
    fi
}

check_file() {
    local file=$1
    local desc=$2
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $desc exists: $file"
        return 0
    else
        echo -e "${RED}✗${NC} $desc missing: $file"
        ALL_CHECKS_PASSED=false
        return 1
    fi
}

echo "Checking core directories..."
check_dir "lib/app" "App configuration directory"
check_dir "lib/core" "Core infrastructure directory"
check_dir "lib/ui" "UI directory"
check_dir "lib/services" "Services directory"
check_dir "lib/data" "Data directory"
echo ""

echo "Checking critical files..."
check_file "lib/app/app.dart" "App configuration"
check_file "lib/core/service_core.dart" "Service core (BusinessResult)"
check_file "lib/main.dart" "Main entry point"
check_file "pubspec.yaml" "Package configuration"
echo ""

echo "Checking generated files..."
if [ -f "lib/app/app.locator.dart" ]; then
    echo -e "${GREEN}✓${NC} Dependency injection generated"
else
    echo -e "${YELLOW}⚠${NC} app.locator.dart not generated yet"
    echo "  Run: stacked generate"
fi

if [ -f "lib/app/app.router.dart" ]; then
    echo -e "${GREEN}✓${NC} Routes generated"
else
    echo -e "${YELLOW}⚠${NC} app.router.dart not generated yet"
    echo "  Run: stacked generate"
fi
echo ""

echo "Checking documentation directories..."
check_dir "docs" "Documentation root"
check_dir "docs/product" "Product docs"
check_dir "docs/features" "Feature docs"
check_dir "docs/screens" "Screen docs"
check_dir "docs/entities" "Entity docs"
check_dir "docs/integration" "Integration docs"
echo ""

echo "Checking Stakify assets..."
check_dir "assets/docs" "Stakify documentation"
if [ -d "assets/docs" ]; then
    check_dir "assets/docs/RULES" "RULES documentation"
    check_dir "assets/docs/PDG" "PDG documentation"
    check_dir "assets/docs/VLG" "VLG documentation"
    check_dir "assets/docs/SLG" "SLG documentation"
fi
echo ""

# Check if it's a git submodule
echo "Checking if docs are git submodule..."
if [ -f ".gitmodules" ]; then
    if grep -q "assets/docs" .gitmodules; then
        echo -e "${GREEN}✓${NC} assets/docs is a git submodule"
    else
        echo -e "${YELLOW}⚠${NC} .gitmodules exists but assets/docs not listed"
    fi
else
    echo -e "${YELLOW}⚠${NC} assets/docs not configured as submodule"
    echo "  Direct copy method being used"
fi
echo ""

echo "=================================="
if [ "$ALL_CHECKS_PASSED" = true ]; then
    echo -e "${GREEN}Project structure verified!${NC}"
else
    echo -e "${RED}Some directories/files are missing.${NC}"
    echo "Please create missing items."
    exit 1
fi
echo "=================================="