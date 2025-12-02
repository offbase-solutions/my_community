#!/bin/bash
# File: scripts/01-product-brief-generation.sh
# Purpose: Validate PROD-DOC-00-BRIEF.md quality after Step 3
# Reference: Direct App Workflow v4.0 - Step 3.3

echo "========================================="
echo "Product Brief Validation"
echo "========================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

BRIEF_FILE="docs/product/PROD-DOC-00-BRIEF.md"
ALL_CHECKS_PASSED=true

# Check if file exists
echo "Checking file existence..."
if [ ! -f "$BRIEF_FILE" ]; then
    echo -e "${RED}✗${NC} PROD-DOC-00-BRIEF.md not found at: $BRIEF_FILE"
    echo "  Expected location: docs/product/PROD-DOC-00-BRIEF.md"
    exit 1
fi
echo -e "${GREEN}✓${NC} PROD-DOC-00-BRIEF.md found"
echo ""

# Check required sections
echo "Checking required sections..."

check_section() {
    local section=$1
    local pattern=$2
    
    if grep -q "$pattern" "$BRIEF_FILE"; then
        echo -e "${GREEN}✓${NC} Section present: $section"
        return 0
    else
        echo -e "${RED}✗${NC} Section missing: $section"
        ALL_CHECKS_PASSED=false
        return 1
    fi
}

check_section "1. Project Overview" "## .*Project Overview\|## .*Overview"
check_section "2. Vision & Mission" "## .*Vision\|## .*Mission"
check_section "3. Target Users" "## .*Target Users\|## .*Users"
check_section "4. Key Problems Solved" "## .*Problems\|## .*Problem"
check_section "5. Project Scope" "## .*Scope\|## .*Phase"
check_section "6. Success Criteria" "## .*Success\|## .*Criteria"
check_section "7. Core Principles" "## .*Principles\|## .*Values"
check_section "8. Unique Value Proposition" "## .*Value Proposition\|## .*UVP"

echo ""

# Check for placeholders and TODOs
echo "Checking for placeholders..."
PLACEHOLDER_COUNT=$(grep -i "TBD\|TODO\|FIXME\|XXX\|placeholder" "$BRIEF_FILE" | wc -l)

if [ $PLACEHOLDER_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓${NC} No placeholders found"
else
    echo -e "${RED}✗${NC} Found $PLACEHOLDER_COUNT placeholders"
    echo "  Found instances:"
    grep -n -i "TBD\|TODO\|FIXME\|XXX\|placeholder" "$BRIEF_FILE" | head -5
    ALL_CHECKS_PASSED=false
fi
echo ""

# Check MVP/Enhanced/Out of Scope clearly defined
echo "Checking project scope definition..."
if grep -q "MVP" "$BRIEF_FILE" && grep -q "Enhanced\|Enhanced Phase" "$BRIEF_FILE"; then
    echo -e "${GREEN}✓${NC} MVP and Enhanced phases defined"
else
    echo -e "${YELLOW}⚠${NC} MVP/Enhanced phases may not be clearly defined"
    echo "  Section 5 (Project Scope) should include:"
    echo "  - MVP Phase (essential features)"
    echo "  - Enhanced Phase (nice-to-have features)"
    echo "  - Out of Scope (explicitly excluded)"
fi

if grep -q "Out of Scope" "$BRIEF_FILE"; then
    echo -e "${GREEN}✓${NC} Out of Scope section present"
else
    echo -e "${YELLOW}⚠${NC} Out of Scope section not clearly marked"
fi
echo ""

# Check for measurable success criteria
echo "Checking success criteria..."
if grep -A 10 "Success Criteria\|Success" "$BRIEF_FILE" | grep -q "%" || \
   grep -A 10 "Success Criteria\|Success" "$BRIEF_FILE" | grep -q "[0-9]"; then
    echo -e "${GREEN}✓${NC} Success criteria appear measurable (contains numbers/percentages)"
else
    echo -e "${YELLOW}⚠${NC} Success criteria may not be measurable"
    echo "  Consider adding specific metrics (e.g., '80% user retention', '< 3s load time')"
fi
echo ""

# Check minimum content length
echo "Checking content completeness..."
WORD_COUNT=$(wc -w < "$BRIEF_FILE")
MIN_WORDS=800
MAX_WORDS=2000

if [ $WORD_COUNT -lt $MIN_WORDS ]; then
    echo -e "${RED}✗${NC} Content too brief: $WORD_COUNT words (minimum: $MIN_WORDS)"
    echo "  Brief may lack sufficient detail"
    ALL_CHECKS_PASSED=false
elif [ $WORD_COUNT -gt $MAX_WORDS ]; then
    echo -e "${YELLOW}⚠${NC} Content very detailed: $WORD_COUNT words (typical: 800-2000)"
    echo "  Consider condensing to essential information"
else
    echo -e "${GREEN}✓${NC} Content length appropriate: $WORD_COUNT words"
fi
echo ""

# Check for target user personas
echo "Checking target user definition..."
if grep -A 10 "Target Users" "$BRIEF_FILE" | wc -l | awk '{if ($1 > 5) exit 0; else exit 1}'; then
    echo -e "${GREEN}✓${NC} Target users section has content"
else
    echo -e "${RED}✗${NC} Target users section appears empty or too brief"
    ALL_CHECKS_PASSED=false
fi
echo ""

# Final summary
echo "========================================="
if [ "$ALL_CHECKS_PASSED" = true ]; then
    echo -e "${GREEN}✓ PROD-DOC-00-BRIEF.md VALIDATION PASSED${NC}"
    echo ""
    echo "Summary:"
    echo "  - All 8 required sections present"
    echo "  - No placeholders found"
    echo "  - Content length appropriate ($WORD_COUNT words)"
    echo "  - MVP/Enhanced phases defined"
    echo ""
    echo -e "${GREEN}Ready for Step 4: Generate Product Documentation${NC}"
    echo "========================================="
    exit 0
else
    echo -e "${RED}✗ PROD-DOC-00-BRIEF.md VALIDATION FAILED${NC}"
    echo ""
    echo "Please review and fix the issues above before proceeding to Step 4."
    echo ""
    echo "Common fixes:"
    echo "  1. Add missing sections (check section headings)"
    echo "  2. Remove TBD/TODO placeholders (replace with actual content)"
    echo "  3. Expand brief sections (minimum 50 words per section)"
    echo "  4. Define MVP, Enhanced, and Out of Scope clearly"
    echo "  5. Add measurable success criteria (use numbers/percentages)"
    echo "========================================="
    exit 1
fi
