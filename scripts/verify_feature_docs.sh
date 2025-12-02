#!/bin/bash
# File: scripts/verify_feature_docs.sh
# Purpose: Verify feature documentation is complete
# Usage: ./verify_feature_docs.sh [feature_number]

echo "=================================="
echo "Feature Documentation Verification"
echo "=================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get feature number from argument or prompt
if [ -z "$1" ]; then
    echo "Enter feature number (e.g., 01): "
    read FEATURE_NUM
else
    FEATURE_NUM=$1
fi

# Find feature directory
FEATURE_DIR=$(find docs/features -type d -name "${FEATURE_NUM}-*" | head -1)

if [ -z "$FEATURE_DIR" ]; then
    echo -e "${RED}✗${NC} Feature directory not found for: $FEATURE_NUM"
    echo "  Looking in: docs/features/"
    exit 1
fi

echo "Checking feature: $(basename $FEATURE_DIR)"
echo ""

# Required files
REQUIRED_FILES=(
    "FEATURE-00-BRIEF.md"
    "FEATURE-01-DEFINITION.md"
    "FEATURE-02-ARCHITECTURE.md"
    "FEATURE-03-TECH.md"
    "FEATURE-04-TASKS.md"
    "FEATURE-05-RULES.md"
)

ALL_PRESENT=true
for file in "${REQUIRED_FILES[@]}"; do
    filepath="${FEATURE_DIR}/${file}"
    if [ -f "$filepath" ]; then
        echo -e "${GREEN}✓${NC} $file"
        
        # Check file size
        size=$(wc -l < "$filepath")
        if [ $size -lt 20 ]; then
            echo -e "  ${YELLOW}⚠${NC} File seems incomplete ($size lines)"
        fi
    else
        echo -e "${RED}✗${NC} $file missing"
        ALL_PRESENT=false
    fi
done
echo ""

# Check FEATURE-01 critical sections
if [ -f "${FEATURE_DIR}/FEATURE-01-DEFINITION.md" ]; then
    echo "Validating FEATURE-01-DEFINITION.md..."
    
    DEF_FILE="${FEATURE_DIR}/FEATURE-01-DEFINITION.md"
    
    # Check for screens section
    if grep -q "Screen Inventory\|Screens" "$DEF_FILE"; then
        SCREEN_COUNT=$(grep -c "Screen" "$DEF_FILE" | tail -1)
        echo -e "${GREEN}✓${NC} Screens section found ($SCREEN_COUNT mentions)"
    else
        echo -e "${RED}✗${NC} Screens section missing"
        ALL_PRESENT=false
    fi
    
    # Check for data model section
    if grep -q "Data Model" "$DEF_FILE"; then
        echo -e "${GREEN}✓${NC} Data Model section found"
    else
        echo -e "${RED}✗${NC} Data Model section missing"
        ALL_PRESENT=false
    fi
    
    # Check for user flows
    if grep -q "User Flow\|User Journey" "$DEF_FILE"; then
        echo -e "${GREEN}✓${NC} User Flows section found"
    else
        echo -e "${YELLOW}⚠${NC} User Flows section may be missing"
    fi
fi
echo ""

# Check if feature is referenced in parent PROD-DOC
echo "Checking parent document reference..."
if [ -f "docs/product/PROD-DOC-01-PRODUCT.md" ]; then
    FEATURE_NAME=$(basename "$FEATURE_DIR" | cut -d'-' -f2-)
    if grep -q "$FEATURE_NAME\|$(basename $FEATURE_DIR)" "docs/product/PROD-DOC-01-PRODUCT.md"; then
        echo -e "${GREEN}✓${NC} Feature referenced in PROD-DOC-01-PRODUCT.md"
    else
        echo -e "${YELLOW}⚠${NC} Feature not referenced in parent document"
        echo "  Update PROD-DOC-01 with reference to this feature"
    fi
else
    echo -e "${YELLOW}⚠${NC} PROD-DOC-01-PRODUCT.md not found"
fi
echo ""

echo "=================================="
if [ "$ALL_PRESENT" = true ]; then
    echo -e "${GREEN}Feature documentation verified!${NC}"
else
    echo -e "${RED}Some documentation is missing or incomplete.${NC}"
    exit 1
fi
echo "=================================="