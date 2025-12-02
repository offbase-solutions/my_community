#!/bin/bash
# File: scripts/verify_dto_generation.sh
# Purpose: Verify DTOs were generated correctly

echo "=================================="
echo "DTO Generation Verification"
echo "=================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if pb directory exists
if [ ! -d "lib/data/pb" ]; then
    echo -e "${RED}✗${NC} lib/data/pb directory not found"
    echo "  Create with: mkdir -p lib/data/pb"
    exit 1
fi

echo -e "${GREEN}✓${NC} lib/data/pb directory exists"
echo ""

# List all DTO files
echo "Generated DTO files:"
find lib/data/pb -name "*_data.dart" -type f | while read file; do
    filename=$(basename "$file")
    
    # Check if using singular naming
    if [[ "$filename" =~ s_data\.dart$ ]]; then
        echo -e "  ${YELLOW}⚠${NC} $filename (plural name - should be singular!)"
    else
        echo -e "  ${GREEN}✓${NC} $filename"
    fi
    
    # Check if has corresponding .g.dart
    g_file="${file%.dart}.g.dart"
    if [ -f "$g_file" ]; then
        echo -e "    ${GREEN}✓${NC} Generated file: $(basename $g_file)"
    else
        echo -e "    ${YELLOW}⚠${NC} Missing .g.dart file - run build_runner"
    fi
done
echo ""

# Check for barrel file
if [ -f "lib/data/pb/dto_generated.dart" ]; then
    echo -e "${GREEN}✓${NC} Barrel file exists: dto_generated.dart"
else
    echo -e "${YELLOW}⚠${NC} Barrel file missing: dto_generated.dart"
fi
echo ""

# Check for GeoPoint support
if [ -f "lib/data/pb/geo_point_data.dart" ]; then
    echo -e "${GREEN}✓${NC} GeoPoint support: geo_point_data.dart found"
else
    echo -e "${YELLOW}⚠${NC} No GeoPoint fields in collections"
fi
echo ""

# Verify compilation
echo "Checking DTO compilation..."
if flutter analyze lib/data/pb/ 2>&1 | grep -q "error"; then
    echo -e "${RED}✗${NC} DTOs have compilation errors"
    echo "  Run: flutter analyze lib/data/pb/"
    exit 1
else
    echo -e "${GREEN}✓${NC} DTOs compile without errors"
fi
echo ""

# Check custom pocketbase_plus package
echo "Verifying pocketbase_plus package..."
if grep -q "pocketbase_plus:" pubspec.yaml; then
    if grep -A2 "pocketbase_plus:" pubspec.yaml | grep -q "git:"; then
        echo -e "${GREEN}✓${NC} Using custom pocketbase_plus from GitHub"
    else
        echo -e "${RED}✗${NC} Using pub.dev pocketbase_plus (should use GitHub version)"
        echo "  Update pubspec.yaml to use:"
        echo "  pocketbase_plus:"
        echo "    git: https://github.com/offbase-solutions/pocketbase_plus"
    fi
else
    echo -e "${RED}✗${NC} pocketbase_plus not in pubspec.yaml"
fi
echo ""

echo "=================================="
echo -e "${GREEN}DTO generation verification complete!${NC}"
echo "=================================="