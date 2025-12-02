#!/bin/bash
# File: scripts/verify_code_generation.sh
# Purpose: Verify Stacked code generation completed successfully

echo "=================================="
echo "Code Generation Verification"
echo "=================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check generated files exist
echo "Checking generated files..."

GENERATED_FILES=(
    "lib/app/app.locator.dart"
    "lib/app/app.router.dart"
)

ALL_GENERATED=true
for file in "${GENERATED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
        
        # Check for generated header
        if head -5 "$file" | grep -q "GENERATED CODE"; then
            echo -e "  ${GREEN}✓${NC} Has 'GENERATED CODE' header"
        else
            echo -e "  ${YELLOW}⚠${NC} Missing 'GENERATED CODE' header"
        fi
    else
        echo -e "${RED}✗${NC} $file missing"
        ALL_GENERATED=false
    fi
done
echo ""

# Check for form generation
echo "Checking for form-generated files..."
FORM_FILES=$(find lib -name "*.form.dart" -type f)
if [ -n "$FORM_FILES" ]; then
    echo "$FORM_FILES" | while read file; do
        echo -e "${GREEN}✓${NC} $file"
    done
else
    echo -e "${YELLOW}⚠${NC} No form files found (expected if no FormViewModel used)"
fi
echo ""

# Check for build_runner generated files
echo "Checking build_runner generated files..."
G_FILES=$(find lib -name "*.g.dart" -type f)
if [ -n "$G_FILES" ]; then
    G_COUNT=$(echo "$G_FILES" | wc -l)
    echo -e "${GREEN}✓${NC} Found $G_COUNT .g.dart files"
else
    echo -e "${YELLOW}⚠${NC} No .g.dart files found"
    echo "  Run: flutter pub run build_runner build --delete-conflicting-outputs"
fi
echo ""

# Verify no compilation errors
echo "Checking for compilation errors..."
if flutter analyze 2>&1 | grep -q "error •"; then
    echo -e "${RED}✗${NC} Compilation errors found"
    echo "  Run: flutter analyze"
    exit 1
else
    echo -e "${GREEN}✓${NC} No compilation errors"
fi
echo ""

# Check app.dart configuration
echo "Checking app.dart configuration..."
if [ -f "lib/app/app.dart" ]; then
    if grep -q "@StackedApp" "lib/app/app.dart"; then
        echo -e "${GREEN}✓${NC} @StackedApp annotation present"
        
        # Check for routes
        if grep -q "routes:" "lib/app/app.dart"; then
            ROUTE_COUNT=$(grep -c "MaterialRoute\\|CupertinoRoute\\|AdaptiveRoute" "lib/app/app.dart")
            echo -e "  ${GREEN}✓${NC} Routes configured: $ROUTE_COUNT"
        else
            echo -e "  ${YELLOW}⚠${NC} No routes configured yet"
        fi
        
        # Check for dependencies
        if grep -q "dependencies:" "lib/app/app.dart"; then
            DEP_COUNT=$(grep -c "LazySingleton\\|Singleton\\|Factory" "lib/app/app.dart")
            echo -e "  ${GREEN}✓${NC} Dependencies configured: $DEP_COUNT"
        else
            echo -e "  ${YELLOW}⚠${NC} No dependencies configured yet"
        fi
    else
        echo -e "${RED}✗${NC} @StackedApp annotation missing"
    fi
else
    echo -e "${RED}✗${NC} app.dart not found"
fi
echo ""

echo "=================================="
if [ "$ALL_GENERATED" = true ]; then
    echo -e "${GREEN}Code generation verified!${NC}"
else
    echo -e "${RED}Some generated files are missing.${NC}"
    echo "Run: stacked generate"
    exit 1
fi
echo "=================================="