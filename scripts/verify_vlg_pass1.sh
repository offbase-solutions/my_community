#!/bin/bash
# File: scripts/verify_vlg_pass1.sh
# Purpose: Verify VLG Pass 1 screen documentation is complete
# Usage: ./verify_vlg_pass1.sh [screen_name]

echo "=================================="
echo "VLG Pass 1 Output Verification"
echo "=================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get screen name from argument or prompt
if [ -z "$1" ]; then
    echo "Enter screen name (e.g., login_screen): "
    read SCREEN_NAME
else
    SCREEN_NAME=$1
fi

SCREEN_DOC="docs/screens/${SCREEN_NAME}.md"

if [ ! -f "$SCREEN_DOC" ]; then
    echo -e "${RED}✗${NC} Screen documentation not found: $SCREEN_DOC"
    exit 1
fi

echo "Checking screen documentation: $SCREEN_NAME"
echo ""

# Required sections (13 total)
SECTIONS=(
    "Section 1: Screen Overview"
    "Section 2: Visual Hierarchy"
    "Section 3: Design Tokens"
    "Section 4: String Constants"
    "Section 5: Component Specifications"
    "Section 6: Stacked Architecture Mapping"
    "Section 7: User Interactions"
    "Section 8: Data Operations"
    "Section 9: Navigation"
    "Section 10: State Management"
    "Section 11: Error Handling"
    "Section 12: AI Code Generation Prompt"
    "Section 13: Validation Checklist"
)

echo "Checking for all 13 required sections..."
ALL_SECTIONS=true

for section in "${SECTIONS[@]}"; do
    if grep -q "$section" "$SCREEN_DOC"; then
        echo -e "${GREEN}✓${NC} $section"
    else
        echo -e "${RED}✗${NC} $section missing"
        ALL_SECTIONS=false
    fi
done
echo ""

# Check Section 3: Design Tokens
echo "Validating Section 3: Design Tokens..."
if grep -q "kcPrimary\|kcBackground\|ktsH1\|kspMd" "$SCREEN_DOC"; then
    echo -e "${GREEN}✓${NC} Design tokens present (Hungarian notation)"
else
    echo -e "${YELLOW}⚠${NC} Design tokens may be missing or incorrectly formatted"
fi
echo ""

# Check Section 4: String Constants
echo "Validating Section 4: String Constants..."
if grep -q "ksAuth\|ksValidation\|ksCommon" "$SCREEN_DOC"; then
    echo -e "${GREEN}✓${NC} String constants present"
else
    echo -e "${YELLOW}⚠${NC} String constants may be missing"
fi
echo ""

# Check Section 8: Data Operations (critical for SLG)
echo "Validating Section 8: Data Operations..."
if grep -q "Entity\|Field\|Operation\|CRUD" "$SCREEN_DOC"; then
    echo -e "${GREEN}✓${NC} Entity usage documented (feeds SLG)"
else
    echo -e "${YELLOW}⚠${NC} Entity usage not clear - required for SLG Step 0"
fi
echo ""

# Check file size
FILE_SIZE=$(wc -l < "$SCREEN_DOC")
echo "File metrics:"
echo "  Lines: $FILE_SIZE"

if [ $FILE_SIZE -lt 200 ]; then
    echo -e "  ${YELLOW}⚠${NC} File seems short for complete 13-section doc"
elif [ $FILE_SIZE -gt 500 ]; then
    echo -e "  ${GREEN}✓${NC} Comprehensive documentation"
else
    echo -e "  ${GREEN}✓${NC} Good documentation length"
fi
echo ""

echo "=================================="
if [ "$ALL_SECTIONS" = true ]; then
    echo -e "${GREEN}VLG Pass 1 documentation verified!${NC}"
    echo "Ready for SLG entity aggregation."
else
    echo -e "${RED}Some sections are missing.${NC}"
    echo "Complete all 13 sections before proceeding."
    exit 1
fi
echo "=================================="