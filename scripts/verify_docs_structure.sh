#!/bin/bash
# File: scripts/verify_docs_structure.sh
# Purpose: Verify documentation follows Stakify structure

echo "=================================="
echo "Documentation Structure Verification"
echo "=================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check product documentation
echo "Checking product documentation..."
PROD_DOCS_COMPLETE=true

PROD_DOCS=(
    "PROD-DOC-00-BRIEF.md"
    "PROD-DOC-01-PRODUCT.md"
    "PROD-DOC-02-ARCHITECTURE.md"
    "PROD-DOC-03-TECH.md"
    "PROD-DOC-04-TASKS.md"
    "PROD-DOC-05-CUSTOM-RULES.md"
)

for doc in "${PROD_DOCS[@]}"; do
    if [ -f "docs/product/$doc" ]; then
        echo -e "${GREEN}✓${NC} $doc"
        
        # Check if file has content
        if [ $(wc -l < "docs/product/$doc") -lt 10 ]; then
            echo -e "  ${YELLOW}⚠${NC} File seems too short (< 10 lines)"
        fi
    else
        echo -e "${RED}✗${NC} $doc missing"
        PROD_DOCS_COMPLETE=false
    fi
done
echo ""

# Check PROD-DOC-01 for critical sections
if [ -f "docs/product/PROD-DOC-01-PRODUCT.md" ]; then
    echo "Validating PROD-DOC-01-PRODUCT.md critical sections..."
    
    if grep -q "→ \*\*SCREEN\*\*:" "docs/product/PROD-DOC-01-PRODUCT.md"; then
        echo -e "${GREEN}✓${NC} Screen format present (→ **SCREEN**:)"
    else
        echo -e "${YELLOW}⚠${NC} Screen format not found - check Section 5"
    fi
    
    if grep -q "Complete Screen Inventory" "docs/product/PROD-DOC-01-PRODUCT.md"; then
        echo -e "${GREEN}✓${NC} Complete Screen Inventory section found"
    else
        echo -e "${YELLOW}⚠${NC} Complete Screen Inventory section missing"
    fi
    
    if grep -q "Data Model Overview" "docs/product/PROD-DOC-01-PRODUCT.md"; then
        echo -e "${GREEN}✓${NC} Data Model Overview section found"
    else
        echo -e "${YELLOW}⚠${NC} Data Model Overview section missing"
    fi
fi
echo ""

# Check feature documentation
echo "Checking feature documentation..."
FEATURE_COUNT=0

if [ -d "docs/features" ]; then
    for feature_dir in docs/features/*/; do
        if [ -d "$feature_dir" ]; then
            FEATURE_COUNT=$((FEATURE_COUNT + 1))
            feature_name=$(basename "$feature_dir")
            echo ""
            echo "Feature: $feature_name"
            
            # Check required files
            FEATURE_DOCS=(
                "FEATURE-00-BRIEF.md"
                "FEATURE-01-DEFINITION.md"
                "FEATURE-02-ARCHITECTURE.md"
                "FEATURE-03-TECH.md"
                "FEATURE-04-TASKS.md"
                "FEATURE-05-RULES.md"
            )
            
            for doc in "${FEATURE_DOCS[@]}"; do
                if [ -f "${feature_dir}${doc}" ]; then
                    echo -e "  ${GREEN}✓${NC} $doc"
                else
                    echo -e "  ${RED}✗${NC} $doc missing"
                fi
            done
            
            # Check FEATURE-01 for screens and entities
            if [ -f "${feature_dir}FEATURE-01-DEFINITION.md" ]; then
                SCREEN_COUNT=$(grep -c "Screen" "${feature_dir}FEATURE-01-DEFINITION.md" || echo "0")
                echo -e "  Screens mentioned: $SCREEN_COUNT"
                
                if grep -q "Data Model" "${feature_dir}FEATURE-01-DEFINITION.md"; then
                    echo -e "  ${GREEN}✓${NC} Data Model section present"
                fi
            fi
        fi
    done
fi

echo ""
echo "Total features documented: $FEATURE_COUNT"
echo ""

echo "=================================="
if [ "$PROD_DOCS_COMPLETE" = true ]; then
    echo -e "${GREEN}Documentation structure verified!${NC}"
else
    echo -e "${YELLOW}Some documentation files are missing.${NC}"
    echo "Run product documentation generation if needed."
fi
echo "=================================="