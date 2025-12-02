#!/bin/bash
# File: scripts/03-validate-feature-docs.sh
# Purpose: Validate feature documentation after Step 6
# Reference: Direct App Workflow v4.0 - Step 6.4
# Usage: ./03-validate-feature-docs.sh [feature_number]

echo "========================================="
echo "Feature Documentation Validation"
echo "Step 6: Detailed Feature Docs"
echo "========================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get feature number from argument (default to 01)
FEATURE_NUM=${1:-01}
FEATURE_DIR="docs/features/${FEATURE_NUM}-"

# Find feature directory (handle varying naming)
ACTUAL_FEATURE_DIR=$(find docs/features -maxdepth 1 -type d -name "${FEATURE_NUM}-*" | head -1)

if [ -z "$ACTUAL_FEATURE_DIR" ]; then
    echo -e "${RED}✗${NC} Feature directory not found for feature ${FEATURE_NUM}"
    echo "  Expected: docs/features/${FEATURE_NUM}-{feature-name}/"
    echo "  Available features:"
    ls -d docs/features/*/ 2>/dev/null || echo "    (none)"
    exit 1
fi

echo -e "${BLUE}Validating feature: $ACTUAL_FEATURE_DIR${NC}"
echo ""

ALL_CHECKS_PASSED=true
TOTAL_CHECKS=0
PASSED_CHECKS=0

check_pass() {
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
}

check_fail() {
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    ALL_CHECKS_PASSED=false
}

# 1. Check all 6 FEATURE files exist
echo -e "${BLUE}1. Checking file existence...${NC}"
echo ""

FEATURE_FILES=(
    "FEATURE-00-BRIEF.md"
    "FEATURE-01-DEFINITION.md"
    "FEATURE-02-ARCHITECTURE.md"
    "FEATURE-03-TECH.md"
    "FEATURE-04-TASKS.md"
    "FEATURE-05-RULES.md"
)

for file in "${FEATURE_FILES[@]}"; do
    if [ -f "$ACTUAL_FEATURE_DIR/$file" ]; then
        echo -e "${GREEN}✓${NC} $file exists"
        check_pass
    else
        echo -e "${RED}✗${NC} $file missing"
        check_fail
    fi
done
echo ""

# 2. Validate FEATURE-01-DEFINITION.md (MOST CRITICAL)
echo -e "${BLUE}2. Validating FEATURE-01-DEFINITION.md (CRITICAL)...${NC}"
echo ""

FEATURE_DEF="$ACTUAL_FEATURE_DIR/FEATURE-01-DEFINITION.md"

if [ ! -f "$FEATURE_DEF" ]; then
    echo -e "${RED}✗${NC} FEATURE-01-DEFINITION.md not found"
    exit 1
fi

# Check for 6 required sections
echo "Checking 6 required sections..."

check_section() {
    local section_num=$1
    local section_name=$2
    local pattern=$3
    
    if grep -q "$pattern" "$FEATURE_DEF"; then
        echo -e "${GREEN}✓${NC} Section $section_num: $section_name"
        check_pass
        return 0
    else
        echo -e "${RED}✗${NC} Section $section_num: $section_name MISSING"
        echo "  Expected pattern: $pattern"
        check_fail
        return 1
    fi
}

check_section "1" "Feature Overview" "## Section 1.*Feature Overview\|## .*Overview"
check_section "2" "User Stories" "## Section 2.*User Stories\|## .*User Stories"
check_section "3" "Business Rules" "## Section 3.*Business Rules\|## .*Rules"
check_section "4" "Screen Inventory" "## Section 4.*Screen Inventory\|## .*Screens"
check_section "5" "User Flows" "## Section 5.*User Flows\|## .*Flows"
check_section "6" "Data Model" "## Section 6.*Data Model\|## .*Data"

echo ""

# 3. Validate Section 4: Complete Screen Inventory (CRITICAL FOR VLG)
echo -e "${BLUE}3. Validating Section 4 (Screens) - CRITICAL FOR VLG...${NC}"
echo ""

# Extract Section 4
SECTION_4=$(sed -n '/^## Section 4/,/^## Section 5/p' "$FEATURE_DEF")

# Count screens
SCREEN_COUNT=$(echo "$SECTION_4" | grep -c "Screen\s*-\|^###.*Screen\|^\*\*.*Screen" || echo 0)

if [ $SCREEN_COUNT -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Found $SCREEN_COUNT screens in Section 4"
    check_pass
    
    # Check screens are DETAILED (not brief)
    AVG_SCREEN_LINES=$(echo "$SECTION_4" | grep -A 10 "Screen" | wc -l)
    AVG_PER_SCREEN=$((AVG_SCREEN_LINES / SCREEN_COUNT))
    
    if [ $AVG_PER_SCREEN -gt 5 ]; then
        echo -e "${GREEN}✓${NC} Screens appear detailed (avg $AVG_PER_SCREEN lines per screen)"
        check_pass
    else
        echo -e "${RED}✗${NC} Screens may be too brief (avg $AVG_PER_SCREEN lines per screen)"
        echo "  Each screen should have detailed purpose and behavior"
        check_fail
    fi
    
    # Check for states mentioned
    if echo "$SECTION_4" | grep -q "loading\|error\|empty\|success\|default"; then
        echo -e "${GREEN}✓${NC} Screen states documented (loading/error/empty/success)"
        check_pass
    else
        echo -e "${YELLOW}⚠${NC} Screen states may not be documented"
        echo "  Consider documenting: default, loading, error, empty, success states"
    fi
else
    echo -e "${RED}✗${NC} No screens found in Section 4"
    echo "  Section 4 must list all screens for this feature"
    check_fail
fi

echo ""

# 4. Validate Section 5: User Flows (CRITICAL FOR VLG)
echo -e "${BLUE}4. Validating Section 5 (User Flows) - CRITICAL FOR VLG...${NC}"
echo ""

SECTION_5=$(sed -n '/^## Section 5/,/^## Section 6/p' "$FEATURE_DEF")

# Check for flow diagrams or transitions
if echo "$SECTION_5" | grep -q "→\|→\|-->\|Flow\|Transition"; then
    echo -e "${GREEN}✓${NC} User flows with transitions documented"
    check_pass
else
    echo -e "${RED}✗${NC} User flows may not have clear transitions"
    echo "  Use arrows (→) or 'Flow:' to show screen transitions"
    check_fail
fi

# Check for error handling flows
if echo "$SECTION_5" | grep -q "error\|failure\|invalid"; then
    echo -e "${GREEN}✓${NC} Error handling flows documented"
    check_pass
else
    echo -e "${YELLOW}⚠${NC} Error handling flows may not be documented"
fi

echo ""

# 5. Validate Section 6: Data Model (CRITICAL FOR SLG)
echo -e "${BLUE}5. Validating Section 6 (Data Model) - CRITICAL FOR SLG...${NC}"
echo ""

SECTION_6=$(sed -n '/^## Section 6/,/^## Section 7/p' "$FEATURE_DEF")

# Count entities
ENTITY_COUNT=$(echo "$SECTION_6" | grep -c "^###.*\|^####.*\|^\*\*Entity" || echo 0)

if [ $ENTITY_COUNT -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Found $ENTITY_COUNT entities in Section 6"
    check_pass
    
    # Check for field specifications
    if echo "$SECTION_6" | grep -q "field\|Field\|Key Fields\|Properties"; then
        echo -e "${GREEN}✓${NC} Entity fields documented"
        check_pass
    else
        echo -e "${RED}✗${NC} Entity fields not clearly documented"
        echo "  Each entity must list: fields, types, descriptions, validation"
        check_fail
    fi
    
    # Check for relationships
    if echo "$SECTION_6" | grep -q "relationship\|Relationship\|belongs to\|has many\|1:1\|1:N\|N:M"; then
        echo -e "${GREEN}✓${NC} Entity relationships documented"
        check_pass
    else
        echo -e "${RED}✗${NC} Entity relationships not documented"
        echo "  Specify relationships: 1:1, 1:N, N:M with other entities"
        check_fail
    fi
    
    # Check for validation rules
    if echo "$SECTION_6" | grep -q "required\|unique\|validation\|constraint\|index"; then
        echo -e "${GREEN}✓${NC} Validation rules/constraints documented"
        check_pass
    else
        echo -e "${YELLOW}⚠${NC} Validation rules may not be documented"
        echo "  Consider: required fields, unique constraints, indexes"
    fi
    
    # Check content completeness for SLG
    SECTION_6_WORDS=$(echo "$SECTION_6" | wc -w)
    MIN_WORDS_PER_ENTITY=100
    MIN_TOTAL=$((ENTITY_COUNT * MIN_WORDS_PER_ENTITY))
    
    if [ $SECTION_6_WORDS -ge $MIN_TOTAL ]; then
        echo -e "${GREEN}✓${NC} Section 6 sufficiently detailed for SLG ($SECTION_6_WORDS words)"
        check_pass
    else
        echo -e "${RED}✗${NC} Section 6 may lack detail for SLG ($SECTION_6_WORDS words, need ~$MIN_TOTAL)"
        echo "  Each entity needs: purpose, fields, types, relationships, constraints"
        check_fail
    fi
else
    echo -e "${RED}✗${NC} No entities found in Section 6"
    echo "  Section 6 must document all entities for SLG Step 0"
    check_fail
fi

echo ""

# 6. Validate other FEATURE files
echo -e "${BLUE}6. Validating other FEATURE files...${NC}"
echo ""

# FEATURE-00-BRIEF.md
FEATURE_BRIEF="$ACTUAL_FEATURE_DIR/FEATURE-00-BRIEF.md"
if [ -f "$FEATURE_BRIEF" ]; then
    BRIEF_WORDS=$(wc -w < "$FEATURE_BRIEF")
    if [ $BRIEF_WORDS -ge 300 ]; then
        echo -e "${GREEN}✓${NC} FEATURE-00-BRIEF.md adequately detailed ($BRIEF_WORDS words)"
        check_pass
    else
        echo -e "${YELLOW}⚠${NC} FEATURE-00-BRIEF.md may be too brief ($BRIEF_WORDS words)"
    fi
fi

# FEATURE-02-ARCHITECTURE.md
FEATURE_ARCH="$ACTUAL_FEATURE_DIR/FEATURE-02-ARCHITECTURE.md"
if [ -f "$FEATURE_ARCH" ]; then
    if grep -q "Service\|Repository\|Data flow" "$FEATURE_ARCH"; then
        echo -e "${GREEN}✓${NC} FEATURE-02-ARCHITECTURE.md documents services and data flow"
        check_pass
    else
        echo -e "${YELLOW}⚠${NC} Services/repositories may not be documented"
    fi
fi

# FEATURE-04-TASKS.md
FEATURE_TASKS="$ACTUAL_FEATURE_DIR/FEATURE-04-TASKS.md"
if [ -f "$FEATURE_TASKS" ]; then
    if grep -q "VLG Pass 1\|SLG\|VLG Pass 2" "$FEATURE_TASKS"; then
        echo -e "${GREEN}✓${NC} FEATURE-04-TASKS.md documents VLG/SLG workflow"
        check_pass
    else
        echo -e "${YELLOW}⚠${NC} VLG/SLG workflow may not be documented"
    fi
fi

echo ""

# 7. Check PROD-DOC-01 update
echo -e "${BLUE}7. Checking PROD-DOC-01 update...${NC}"
echo ""

PROD_DOC_01="docs/product/PROD-DOC-01-PRODUCT.md"

if [ -f "$PROD_DOC_01" ]; then
    # Check if feature status updated to "Complete"
    if grep -A 20 "^### Feature ${FEATURE_NUM}" "$PROD_DOC_01" | grep -q "✓.*Complete\|Documentation Complete"; then
        echo -e "${GREEN}✓${NC} Feature ${FEATURE_NUM} marked as 'Documentation Complete' in PROD-DOC-01"
        check_pass
    else
        echo -e "${RED}✗${NC} Feature ${FEATURE_NUM} not marked as complete in PROD-DOC-01"
        echo "  Update PROD-DOC-01 Section 4 using Step 6.5 template"
        check_fail
    fi
    
    # Check for links to all 6 FEATURE files
    if grep -A 20 "^### Feature ${FEATURE_NUM}" "$PROD_DOC_01" | grep -q "FEATURE-00\|FEATURE-01\|FEATURE-02\|FEATURE-03\|FEATURE-04\|FEATURE-05"; then
        echo -e "${GREEN}✓${NC} Links to FEATURE docs present in PROD-DOC-01"
        check_pass
    else
        echo -e "${RED}✗${NC} Missing links to FEATURE docs in PROD-DOC-01"
        check_fail
    fi
else
    echo -e "${YELLOW}⚠${NC} PROD-DOC-01 not found - cannot verify update"
fi

echo ""

# Final summary
echo "========================================="
echo -e "${BLUE}VALIDATION SUMMARY${NC}"
echo "========================================="
echo ""
echo "Feature: $ACTUAL_FEATURE_DIR"
echo "Total Checks: $TOTAL_CHECKS"
echo -e "Passed: ${GREEN}$PASSED_CHECKS${NC}"
echo -e "Failed: ${RED}$((TOTAL_CHECKS - PASSED_CHECKS))${NC}"
echo ""

if [ "$ALL_CHECKS_PASSED" = true ]; then
    echo -e "${GREEN}✓ FEATURE DOCUMENTATION VALIDATION PASSED${NC}"
    echo ""
    echo "Summary:"
    echo "  - All 6 FEATURE files present"
    echo "  - FEATURE-01-DEFINITION.md has 6 required sections"
    echo "  - Section 4 (Screens) detailed for VLG"
    echo "  - Section 5 (Flows) detailed for VLG"
    echo "  - Section 6 (Data Model) complete for SLG"
    echo "  - PROD-DOC-01 updated with feature completion"
    echo ""
    echo -e "${GREEN}Ready for Step 7: VLG Pass 1 (Screen Documentation)${NC}"
    echo "========================================="
    exit 0
else
    echo -e "${RED}✗ FEATURE DOCUMENTATION VALIDATION FAILED${NC}"
    echo ""
    echo "Please review and fix the issues above before proceeding."
    echo ""
    echo "Common fixes:"
    echo "  1. Ensure all 6 FEATURE files created"
    echo "  2. FEATURE-01-DEFINITION.md must have 6 sections"
    echo "  3. Section 4: List all screens with detailed descriptions"
    echo "  4. Section 5: Document complete user flows with transitions"
    echo "  5. Section 6: Complete entity specs (fields, types, relationships)"
    echo "  6. Update PROD-DOC-01 Section 4 with '✓ Documentation Complete'"
    echo "  7. Add links to all 6 FEATURE docs in PROD-DOC-01"
    echo ""
    echo "Reference: Direct App Workflow v4.0 - Step 6.4 and 6.5"
    echo "========================================="
    exit 1
fi
