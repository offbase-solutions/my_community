#!/bin/bash
# File: scripts/verify_architecture.sh
# Purpose: Verify code follows Stacked Architecture patterns

echo "=================================="
echo "Architecture Compliance Verification"
echo "=================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

VIOLATIONS=0

# Check View patterns
echo "Checking View patterns..."
VIEW_FILES=$(find lib/ui/views -name "*_view.dart" -type f 2>/dev/null)

if [ -n "$VIEW_FILES" ]; then
    echo "$VIEW_FILES" | while read view_file; do
        view_name=$(basename "$view_file" .dart)
        
        # Check extends StatelessWidget
        if grep -q "class.*View extends StatelessWidget" "$view_file"; then
            echo -e "${GREEN}✓${NC} $view_name extends StatelessWidget"
        elif grep -q "class.*View extends StatefulWidget" "$view_file"; then
            echo -e "${RED}✗${NC} $view_name extends StatefulWidget (should be Stateless)"
            VIOLATIONS=$((VIOLATIONS + 1))
        fi
        
        # Check uses ViewModelBuilder
        if grep -q "ViewModelBuilder" "$view_file"; then
            echo -e "${GREEN}✓${NC} $view_name uses ViewModelBuilder"
        else
            echo -e "${YELLOW}⚠${NC} $view_name may not use ViewModelBuilder"
        fi
    done
else
    echo -e "${YELLOW}⚠${NC} No View files found"
fi
echo ""

# Check ViewModel patterns
echo "Checking ViewModel patterns..."
VM_FILES=$(find lib/ui/views -name "*_viewmodel.dart" -type f 2>/dev/null)

if [ -n "$VM_FILES" ]; then
    echo "$VM_FILES" | while read vm_file; do
        vm_name=$(basename "$vm_file" .dart)
        
        # Check extends BaseViewModel or variant
        if grep -q "extends.*ViewModel" "$vm_file"; then
            echo -e "${GREEN}✓${NC} $vm_name extends ViewModel variant"
        else
            echo -e "${RED}✗${NC} $vm_name doesn't extend ViewModel"
            VIOLATIONS=$((VIOLATIONS + 1))
        fi
        
        # Check for Repository access (FORBIDDEN)
        if grep -q "locator<.*Repository>" "$vm_file"; then
            echo -e "${RED}✗${NC} $vm_name accesses Repository directly (FORBIDDEN)"
            echo "     ViewModels should only access Services"
            VIOLATIONS=$((VIOLATIONS + 1))
        fi
        
        # Check for Service access (ALLOWED)
        if grep -q "locator<.*Service>" "$vm_file"; then
            echo -e "${GREEN}✓${NC} $vm_name accesses Services properly"
        fi
        
        # Check for BusinessResult handling
        if grep -q "BusinessResult" "$vm_file"; then
            echo -e "${GREEN}✓${NC} $vm_name uses BusinessResult pattern"
        fi
    done
else
    echo -e "${YELLOW}⚠${NC} No ViewModel files found"
fi
echo ""

# Check Service patterns
echo "Checking Service patterns..."
SERVICE_FILES=$(find lib/services -name "*_service.dart" -type f 2>/dev/null)

if [ -n "$SERVICE_FILES" ]; then
    echo "$SERVICE_FILES" | while read service_file; do
        service_name=$(basename "$service_file" .dart)
        
        # Check returns BusinessResult
        if grep -q "BusinessResult" "$service_file"; then
            echo -e "${GREEN}✓${NC} $service_name returns BusinessResult"
        else
            echo -e "${YELLOW}⚠${NC} $service_name may not use BusinessResult"
        fi
        
        # Check uses Repository
        if grep -q "locator<.*Repository>" "$service_file" || grep -q "_.*Repository" "$service_file"; then
            echo -e "${GREEN}✓${NC} $service_name uses Repository"
        fi
    done
else
    echo -e "${YELLOW}⚠${NC} No Service files found"
fi
echo ""

# Check for hard-coded values
echo "Checking for hard-coded values..."
if grep -r "Color(0x" lib/ui/views 2>/dev/null | grep -v ".g.dart"; then
    echo -e "${RED}✗${NC} Hard-coded colors found (should use design tokens)"
    VIOLATIONS=$((VIOLATIONS + 1))
fi

if grep -r '"[A-Z]' lib/ui/views 2>/dev/null | grep -v ".g.dart" | grep -v "import" | grep -v "//" | head -5; then
    echo -e "${YELLOW}⚠${NC} Potential hard-coded strings found (should use constants)"
fi
echo ""

echo "=================================="
if [ $VIOLATIONS -eq 0 ]; then
    echo -e "${GREEN}Architecture compliance verified!${NC}"
    echo "No violations found."
else
    echo -e "${RED}Found $VIOLATIONS architecture violations!${NC}"
    echo "Please fix violations before proceeding."
    exit 1
fi
echo "=================================="