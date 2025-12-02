#!/bin/bash
# File: scripts/verify_complete_workflow.sh
# Purpose: Comprehensive verification of complete workflow
# Usage: ./verify_complete_workflow.sh [feature_number]

echo "========================================="
echo "Complete Workflow Verification"
echo "========================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

FEATURE_NUM=${1:-01}

echo -e "${BLUE}Verifying complete workflow for Feature ${FEATURE_NUM}${NC}"
echo ""

TOTAL_CHECKS=0
PASSED_CHECKS=0

run_check() {
    local check_name=$1
    local check_script=$2
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}CHECK: ${check_name}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if bash "$check_script"; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        echo -e "${GREEN}✓ ${check_name} PASSED${NC}"
    else
        echo -e "${RED}✗ ${check_name} FAILED${NC}"
    fi
}

# Run all verification scripts
run_check "Environment Setup" "scripts/verify_environment.sh"
run_check "Project Structure" "scripts/verify_project_structure.sh"
run_check "Documentation Structure" "scripts/verify_docs_structure.sh"
run_check "Git Submodule" "scripts/verify_git_submodule.sh"
run_check "PocketBase" "scripts/verify_pocketbase.sh"
run_check "DTO Generation" "scripts/verify_dto_generation.sh"
run_check "Code Generation" "scripts/verify_code_generation.sh"
run_check "Architecture Compliance" "scripts/verify_architecture.sh"
run_check "Integration" "scripts/verify_integration.sh"

# Feature-specific checks
if [ -n "$FEATURE_NUM" ]; then
    run_check "Feature ${FEATURE_NUM} Documentation" "scripts/verify_feature_docs.sh $FEATURE_NUM"
fi

# Final summary
echo ""
echo "========================================="
echo -e "${BLUE}VERIFICATION SUMMARY${NC}"
echo "========================================="
echo ""
echo "Total Checks: $TOTAL_CHECKS"
echo -e "Passed: ${GREEN}$PASSED_CHECKS${NC}"
echo -e "Failed: ${RED}$((TOTAL_CHECKS - PASSED_CHECKS))${NC}"
echo ""

if [ $PASSED_CHECKS -eq $TOTAL_CHECKS ]; then
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ ALL CHECKS PASSED!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Workflow is complete and verified!"
    echo "Ready for testing and deployment."
else
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}✗ SOME CHECKS FAILED${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Please review failed checks and fix issues."
    exit 1
fi
echo ""
echo "========================================="