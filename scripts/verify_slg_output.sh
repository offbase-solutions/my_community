#!/bin/bash
# File: scripts/verify_slg_output.sh
# Purpose: Verify SLG generated all required files for an entity
# Usage: ./verify_slg_output.sh [entity_name]

echo "=================================="
echo "SLG Output Verification"
echo "=================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get entity name
if [ -z "$1" ]; then
    echo "Enter entity name (singular, e.g., user): "
    read ENTITY_NAME
else
    ENTITY_NAME=$1
fi

echo "Checking SLG outputs for entity: $ENTITY_NAME"
echo ""

# Check documentation files
echo "Checking documentation files..."
DOC_DIR="docs/entities/${ENTITY_NAME}"

DOC_FILES=(
    "00-${ENTITY_NAME}-ui-requirements.md"
    "01-projections.md"
    "02-mixins.md"
    "03-model.md"
    "04-model-extensions.md"
    "05-projection-extensions.md"
    "06-specifications.md"
    "07-repository-interface.md"
    "08-repository-implementation.md"
    "09-service.md"
    "10-barrel-file.md"
)

DOCS_COMPLETE=true
for doc in "${DOC_FILES[@]}"; do
    if [ -f "${DOC_DIR}/${doc}" ]; then
        echo -e "${GREEN}✓${NC} $doc"
    else
        echo -e "${RED}✗${NC} $doc missing"
        DOCS_COMPLETE=false
    fi
done
echo ""

# Check generated code files
echo "Checking generated code files..."

# Model files
echo "Models:"
MODEL_FILES=(
    "lib/data/models/${ENTITY_NAME}/${ENTITY_NAME}_model.dart"
    "lib/data/models/${ENTITY_NAME}/${ENTITY_NAME}_projections.dart"
    "lib/data/models/${ENTITY_NAME}/${ENTITY_NAME}_mixins.dart"
)

CODE_COMPLETE=true
for file in "${MODEL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ${GREEN}✓${NC} $(basename $file)"
    else
        echo -e "  ${RED}✗${NC} $(basename $file) missing"
        CODE_COMPLETE=false
    fi
done
echo ""

# Repository files
echo "Repositories:"
REPO_FILES=(
    "lib/data/repositories/${ENTITY_NAME}/i_${ENTITY_NAME}_repository.dart"
    "lib/data/repositories/${ENTITY_NAME}/${ENTITY_NAME}_repository.dart"
)

for file in "${REPO_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ${GREEN}✓${NC} $(basename $file)"
        
        # Check if implements interface
        if [ $(basename $file) = "${ENTITY_NAME}_repository.dart" ]; then
            if grep -q "implements I.*Repository" "$file"; then
                echo -e "    ${GREEN}✓${NC} Implements interface"
            fi
            
            # Check extends BaseCollectionRepository
            if grep -q "extends BaseCollectionRepository" "$file"; then
                echo -e "    ${GREEN}✓${NC} Extends BaseCollectionRepository"
            else
                echo -e "    ${RED}✗${NC} Should extend BaseCollectionRepository"
            fi
        fi
    else
        echo -e "  ${RED}✗${NC} $(basename $file) missing"
        CODE_COMPLETE=false
    fi
done
echo ""

# Service file
echo "Service:"
SERVICE_FILE="lib/services/${ENTITY_NAME}_service.dart"
if [ -f "$SERVICE_FILE" ]; then
    echo -e "  ${GREEN}✓${NC} $(basename $SERVICE_FILE)"
    
    # Check returns BusinessResult
    if grep -q "BusinessResult" "$SERVICE_FILE"; then
        echo -e "    ${GREEN}✓${NC} Uses BusinessResult pattern"
    else
        echo -e "    ${YELLOW}⚠${NC} May not use BusinessResult pattern"
    fi
    
    # Check uses repository
    if grep -q "I.*Repository" "$SERVICE_FILE"; then
        echo -e "    ${GREEN}✓${NC} Uses repository interface"
    fi
else
    echo -e "  ${RED}✗${NC} Service file missing"
    CODE_COMPLETE=false
fi
echo ""

# Check DTO exists
echo "DTO:"
DTO_FILE="lib/data/pb/${ENTITY_NAME}_data.dart"
if [ -f "$DTO_FILE" ]; then
    echo -e "  ${GREEN}✓${NC} $(basename $DTO_FILE)"
    
    # Check for .g.dart
    if [ -f "${DTO_FILE%.dart}.g.dart" ]; then
        echo -e "    ${GREEN}✓${NC} Generated file present"
    fi
else
    echo -e "  ${RED}✗${NC} DTO missing - run: dart run pocketbase_plus:main"
fi
echo ""

# Compile check
echo "Checking compilation..."
if flutter analyze lib/data/models/${ENTITY_NAME} lib/data/repositories/${ENTITY_NAME} lib/services/${ENTITY_NAME}_service.dart 2>&1 | grep -q "error"; then
    echo -e "${RED}✗${NC} Compilation errors found"
    CODE_COMPLETE=false
else
    echo -e "${GREEN}✓${NC} No compilation errors"
fi
echo ""

echo "=================================="
if [ "$DOCS_COMPLETE" = true ] && [ "$CODE_COMPLETE" = true ]; then
    echo -e "${GREEN}SLG outputs verified for ${ENTITY_NAME}!${NC}"
else
    if [ "$DOCS_COMPLETE" = false ]; then
        echo -e "${RED}Documentation incomplete.${NC}"
    fi
    if [ "$CODE_COMPLETE" = false ]; then
        echo -e "${RED}Code generation incomplete.${NC}"
    fi
    exit 1
fi
echo "=================================="