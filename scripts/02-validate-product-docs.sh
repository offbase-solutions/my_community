#!/bin/bash
# File: scripts/02-validate-product-docs.sh
# Purpose: Validate all 5 PROD-DOC files after Step 4 (Foundational Documentation)
# Reference: Direct App Workflow v4.0 - Step 4.2

echo "========================================="
echo "Product Documentation Validation"
echo "Foundational Documentation (Step 4)"
echo "========================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOCS_DIR="docs/product"
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

# 1. Check all files exist
echo -e "${BLUE}1. Checking file existence...${NC}"
echo ""

FILES=(
    "PROD-DOC-00-BRIEF.md"
    "PROD-DOC-01-PRODUCT.md"
    "PROD-DOC-02-ARCHITECTURE.md"
    "PROD-DOC-03-TECH.md"
    "PROD-DOC-04-TASKS.md"
    "PROD-DOC-05-CUSTOM-RULES.md"
)

for file in "${FILES[@]}"; do
    if [ -f "$DOCS_DIR/$file" ]; then
        echo -e "${GREEN}✓${NC} $file exists"
        check_pass
    else
        echo -e "${RED}✗${NC} $file missing"
        check_fail
    fi
done
echo ""

# 2. Validate PROD-DOC-01-PRODUCT.md (CRITICAL)
echo -e "${BLUE}2. Validating PROD-DOC-01-PRODUCT.md...${NC}"
echo ""

PROD_DOC_01="$DOCS_DIR/PROD-DOC-01-PRODUCT.md"

if [ ! -f "$PROD_DOC_01" ]; then
    echo -e "${RED}✗${NC} PROD-DOC-01-PRODUCT.md not found"
    exit 1
fi

# Check Sections 1-3 are complete (no placeholders)
echo "Checking Sections 1-3 (Why, How, Goals)..."
SECTIONS_123_PLACEHOLDERS=$(sed -n '/^## Section 1/,/^## Section 4/p' "$PROD_DOC_01" | grep -c "TO BE DOCUMENTED\|TBD\|TODO" || echo 0)

if [ $SECTIONS_123_PLACEHOLDERS -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Sections 1-3 complete (no placeholders)"
    check_pass
else
    echo -e "${RED}✗${NC} Sections 1-3 contain placeholders ($SECTIONS_123_PLACEHOLDERS found)"
    check_fail
fi

# Check Section 4: Features are BRIEF (1-2 sentences)
echo "Checking Section 4 (Feature Breakdown)..."

# Check for "Awaiting Step 6 Documentation" status
if grep -q "⏳ Awaiting Step 6 Documentation\|Awaiting.*Documentation" "$PROD_DOC_01"; then
    echo -e "${GREEN}✓${NC} Features marked as 'Awaiting Step 6 Documentation'"
    check_pass
else
    echo -e "${YELLOW}⚠${NC} Features may not have proper status markers"
    echo "  Expected: '⏳ Awaiting Step 6 Documentation'"
fi

# Check for "(TO BE DOCUMENTED)" references
if grep -q "TO BE DOCUMENTED" "$PROD_DOC_01"; then
    echo -e "${GREEN}✓${NC} Features have '(TO BE DOCUMENTED)' placeholder references"
    check_pass
else
    echo -e "${RED}✗${NC} Features missing '(TO BE DOCUMENTED)' references"
    echo "  Each feature should reference: 'See docs/features/XX-feature/ for details (TO BE DOCUMENTED)'"
    check_fail
fi

# Check features are brief (not detailed)
FEATURE_SECTION=$(sed -n '/^## Section 4/,/^## Section 5/p' "$PROD_DOC_01")
FEATURE_COUNT=$(echo "$FEATURE_SECTION" | grep -c "^### Feature")

if [ $FEATURE_COUNT -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Found $FEATURE_COUNT features in Section 4"
    check_pass
    
    # Check if any feature has excessive detail (indication of over-generation)
    EXCESSIVE_DETAIL=$(echo "$FEATURE_SECTION" | grep -A 20 "^### Feature" | grep -c "#### \|Detailed\|FEATURE-00\|FEATURE-01" || echo 0)
    
    if [ $EXCESSIVE_DETAIL -gt 0 ]; then
        echo -e "${RED}✗${NC} Section 4 features appear overly detailed"
        echo "  Features should be BRIEF (1-2 sentences) in foundational docs"
        echo "  Detailed docs come in Step 6 (FEATURE-00 through FEATURE-05)"
        check_fail
    else
        echo -e "${GREEN}✓${NC} Features appear appropriately brief"
        check_pass
    fi
else
    echo -e "${RED}✗${NC} No features found in Section 4"
    check_fail
fi

# Check Section 5: Complete Screen Inventory
echo "Checking Section 5 (Screen Inventory)..."

SCREEN_COUNT=$(grep -c "→ \*\*SCREEN\*\*:" "$PROD_DOC_01" || echo 0)

if [ $SCREEN_COUNT -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Found $SCREEN_COUNT screens using '→ **SCREEN**:' format"
    check_pass
else
    echo -e "${RED}✗${NC} No screens found with proper format '→ **SCREEN**:'"
    echo "  Expected format: '→ **SCREEN**: HomeScreen'"
    check_fail
fi

# Check all screens have priority assigned
SCREENS_WITH_PRIORITY=$(grep -A 1 "→ \*\*SCREEN\*\*:" "$PROD_DOC_01" | grep -c "Priority: MVP\|Priority: Enhanced\|Priority: Future" || echo 0)

if [ $SCREENS_WITH_PRIORITY -eq $SCREEN_COUNT ]; then
    echo -e "${GREEN}✓${NC} All screens have priority assigned"
    check_pass
else
    echo -e "${YELLOW}⚠${NC} Some screens may be missing priority (MVP/Enhanced/Future)"
fi

# Check Section 6: User Flows
echo "Checking Section 6 (User Flows)..."

if grep -q "^## Section 6" "$PROD_DOC_01"; then
    echo -e "${GREEN}✓${NC} Section 6 (User Flows) present"
    check_pass
else
    echo -e "${RED}✗${NC} Section 6 (User Flows) missing"
    check_fail
fi

# Check Section 7: Data Model Overview
echo "Checking Section 7 (Data Model)..."

ENTITY_COUNT=$(sed -n '/^## Section 7/,$p' "$PROD_DOC_01" | grep -c "^#### " || echo 0)

if [ $ENTITY_COUNT -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Found $ENTITY_COUNT entities in Section 7"
    check_pass
else
    echo -e "${RED}✗${NC} No entities found in Section 7"
    check_fail
fi

echo ""

# 3. Cross-reference validation
echo -e "${BLUE}3. Cross-reference validation...${NC}"
echo ""

# Extract screen count from Section 4 vs Section 5
echo "Checking screen count consistency..."
SECTION_4_SCREEN_REFS=$(sed -n '/^## Section 4/,/^## Section 5/p' "$PROD_DOC_01" | grep -c "screens" || echo 0)
SECTION_5_SCREEN_COUNT=$SCREEN_COUNT

if [ $SECTION_5_SCREEN_COUNT -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Section 5 has $SECTION_5_SCREEN_COUNT screens documented"
    check_pass
    echo "  Note: Verify counts match feature descriptions in Section 4"
else
    echo -e "${RED}✗${NC} Screen count verification needed"
fi

# Extract entity count from Section 4 vs Section 7
echo "Checking entity count consistency..."
SECTION_7_ENTITY_COUNT=$ENTITY_COUNT

if [ $SECTION_7_ENTITY_COUNT -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Section 7 has $SECTION_7_ENTITY_COUNT entities documented"
    check_pass
    echo "  Note: Verify counts match feature descriptions in Section 4"
else
    echo -e "${YELLOW}⚠${NC} Entity count verification needed"
fi

echo ""

# 4. Validate PROD-DOC-02-ARCHITECTURE.md
echo -e "${BLUE}4. Validating PROD-DOC-02-ARCHITECTURE.md...${NC}"
echo ""

PROD_DOC_02="$DOCS_DIR/PROD-DOC-02-ARCHITECTURE.md"

if [ -f "$PROD_DOC_02" ]; then
    # Check for layer boundaries
    if grep -q "View.*ViewModel.*Service.*Repository\|Layer.*Boundaries" "$PROD_DOC_02"; then
        echo -e "${GREEN}✓${NC} Layer boundaries documented"
        check_pass
    else
        echo -e "${RED}✗${NC} Layer boundaries not clearly documented"
        check_fail
    fi
    
    # Check for BusinessResult pattern
    if grep -q "BusinessResult" "$PROD_DOC_02"; then
        echo -e "${GREEN}✓${NC} BusinessResult<T> pattern documented"
        check_pass
    else
        echo -e "${RED}✗${NC} BusinessResult<T> pattern not documented"
        check_fail
    fi
    
    # Check for RULES references
    RULES_REFS=$(grep -c "@RULES\|RULES-" "$PROD_DOC_02" || echo 0)
    if [ $RULES_REFS -gt 0 ]; then
        echo -e "${GREEN}✓${NC} References to RULES files present ($RULES_REFS references)"
        check_pass
    else
        echo -e "${YELLOW}⚠${NC} No references to base RULES files found"
    fi
fi

echo ""

# 5. Validate PROD-DOC-03-TECH.md
echo -e "${BLUE}5. Validating PROD-DOC-03-TECH.md...${NC}"
echo ""

PROD_DOC_03="$DOCS_DIR/PROD-DOC-03-TECH.md"

if [ -f "$PROD_DOC_03" ]; then
    # Check for tech stack
    if grep -q "Flutter\|Stacked\|PocketBase" "$PROD_DOC_03"; then
        echo -e "${GREEN}✓${NC} Core tech stack documented (Flutter, Stacked, PocketBase)"
        check_pass
    else
        echo -e "${RED}✗${NC} Core tech stack not clearly documented"
        check_fail
    fi
    
    # Check for dependencies with versions
    if grep -q ":\s*\^[0-9]\|:\s*[0-9]" "$PROD_DOC_03"; then
        echo -e "${GREEN}✓${NC} Dependencies with versions present"
        check_pass
    else
        echo -e "${YELLOW}⚠${NC} Dependencies may not have version numbers"
    fi
fi

echo ""

# 6. Validate PROD-DOC-04-TASKS.md
echo -e "${BLUE}6. Validating PROD-DOC-04-TASKS.md...${NC}"
echo ""

PROD_DOC_04="$DOCS_DIR/PROD-DOC-04-TASKS.md"

if [ -f "$PROD_DOC_04" ]; then
    # Check for phase structure
    if grep -q "Phase 1.*Foundation\|Phase 2.*Features\|Phase 3" "$PROD_DOC_04"; then
        echo -e "${GREEN}✓${NC} Development phases documented"
        check_pass
    else
        echo -e "${RED}✗${NC} Development phases not clearly structured"
        check_fail
    fi
    
    # Check for feature-by-feature approach
    if grep -q "feature-by-feature\|Feature 1\|Feature 2" "$PROD_DOC_04"; then
        echo -e "${GREEN}✓${NC} Feature-by-feature workflow documented"
        check_pass
    else
        echo -e "${YELLOW}⚠${NC} Feature-by-feature workflow may not be documented"
    fi
fi

echo ""

# 7. Validate PROD-DOC-05-CUSTOM-RULES.md
echo -e "${BLUE}7. Validating PROD-DOC-05-CUSTOM-RULES.md...${NC}"
echo ""

PROD_DOC_05="$DOCS_DIR/PROD-DOC-05-CUSTOM-RULES.md"

if [ -f "$PROD_DOC_05" ]; then
    # Check for project-specific patterns
    WORD_COUNT=$(wc -w < "$PROD_DOC_05")
    if [ $WORD_COUNT -gt 500 ]; then
        echo -e "${GREEN}✓${NC} Project-specific rules documented ($WORD_COUNT words)"
        check_pass
    else
        echo -e "${YELLOW}⚠${NC} Custom rules may be too brief ($WORD_COUNT words)"
    fi
    
    # Check doesn't contradict base rules
    if ! grep -q "ignore.*RULES\|override.*RULES\|violate" "$PROD_DOC_05"; then
        echo -e "${GREEN}✓${NC} No contradictions to base RULES detected"
        check_pass
    else
        echo -e "${YELLOW}⚠${NC} Possible contradictions to base RULES - review carefully"
    fi
fi

echo ""

# Final summary
echo "========================================="
echo -e "${BLUE}VALIDATION SUMMARY${NC}"
echo "========================================="
echo ""
echo "Total Checks: $TOTAL_CHECKS"
echo -e "Passed: ${GREEN}$PASSED_CHECKS${NC}"
echo -e "Failed: ${RED}$((TOTAL_CHECKS - PASSED_CHECKS))${NC}"
echo ""

if [ "$ALL_CHECKS_PASSED" = true ]; then
    echo -e "${GREEN}✓ PRODUCT DOCUMENTATION VALIDATION PASSED${NC}"
    echo ""
    echo "Summary:"
    echo "  - All 6 PROD-DOC files present"
    echo "  - PROD-DOC-01 Section 4 properly formatted (foundational)"
    echo "  - Screen format correct (→ **SCREEN**:)"
    echo "  - Entities documented in Section 7"
    echo "  - Architecture patterns present"
    echo "  - Tech stack documented"
    echo ""
    echo -e "${GREEN}Ready for Step 5: Feature Identification Decision${NC}"
    echo "========================================="
    exit 0
else
    echo -e "${RED}✗ PRODUCT DOCUMENTATION VALIDATION FAILED${NC}"
    echo ""
    echo "Please review and fix the issues above before proceeding."
    echo ""
    echo "Common fixes:"
    echo "  1. Ensure Section 4 features are BRIEF (1-2 sentences only)"
    echo "  2. Add '⏳ Awaiting Step 6 Documentation' status to features"
    echo "  3. Add '(TO BE DOCUMENTED)' placeholder references"
    echo "  4. Use exact format '→ **SCREEN**: ScreenName' in Section 5"
    echo "  5. Verify all screens have priority (MVP/Enhanced/Future)"
    echo "  6. Check cross-references match (screen/entity counts)"
    echo "========================================="
    exit 1
fi
