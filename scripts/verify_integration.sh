#!/bin/bash
# File: scripts/verify_integration.sh
# Purpose: Verify app integration is complete

echo "=================================="
echo "Integration Verification"
echo "=================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check app.dart configuration
echo "Checking app.dart configuration..."
if [ -f "lib/app/app.dart" ]; then
    echo -e "${GREEN}✓${NC} app.dart exists"
    
    # Count routes
    ROUTE_COUNT=$(grep -c "Route(page:" "lib/app/app.dart" || echo "0")
    echo "  Routes registered: $ROUTE_COUNT"
    
    # Count services
    SERVICE_COUNT=$(grep -c "LazySingleton(classType:.*Service" "lib/app/app.dart" || echo "0")
    echo "  Services registered: $SERVICE_COUNT"
    
    # Count repositories
    REPO_COUNT=$(grep -c "LazySingleton.*Repository" "lib/app/app.dart" || echo "0")
    echo "  Repositories registered: $REPO_COUNT"
else
    echo -e "${RED}✗${NC} app.dart not found"
    exit 1
fi
echo ""

# Check generated files
echo "Checking generated integration files..."
if [ -f "lib/app/app.locator.dart" ]; then
    echo -e "${GREEN}✓${NC} Dependency injection generated"
else
    echo -e "${RED}✗${NC} app.locator.dart missing - run: stacked generate"
fi

if [ -f "lib/app/app.router.dart" ]; then
    echo -e "${GREEN}✓${NC} Routes generated"
else
    echo -e "${RED}✗${NC} app.router.dart missing - run: stacked generate"
fi
echo ""

# Check main.dart
echo "Checking main.dart..."
if [ -f "lib/main.dart" ]; then
    if grep -q "setupLocator()" "lib/main.dart"; then
        echo -e "${GREEN}✓${NC} setupLocator() called in main"
    else
        echo -e "${RED}✗${NC} setupLocator() not called"
    fi
    
    if grep -q "StackedRouter" "lib/main.dart"; then
        echo -e "${GREEN}✓${NC} StackedRouter configured"
    else
        echo -e "${YELLOW}⚠${NC} StackedRouter may not be configured"
    fi
else
    echo -e "${RED}✗${NC} main.dart not found"
    exit 1
fi
echo ""

# Check PocketBase configuration
echo "Checking PocketBase configuration..."
if [ -f "pocketbase.yaml" ]; then
    echo -e "${GREEN}✓${NC} pocketbase.yaml exists"
else
    echo -e "${YELLOW}⚠${NC} pocketbase.yaml missing"
fi

# Check if PocketBase is running
if curl -s -f "http://localhost:8090/api/health" > /dev/null; then
    echo -e "${GREEN}✓${NC} PocketBase is running"
else
    echo -e "${YELLOW}⚠${NC} PocketBase not running - start with: cd db && ./pocketbase serve"
fi
echo ""

# Try to build
echo "Attempting build..."
if flutter build apk --debug 2>&1 | grep -q "BUILD SUCCESSFUL\|BUILD SUCCEEDED"; then
    echo -e "${GREEN}✓${NC} Build successful"
else
    echo -e "${RED}✗${NC} Build failed - check errors with: flutter build apk --debug"
fi
echo ""

# Check for integration notes
echo "Checking integration documentation..."
INTEGRATION_DOCS=$(find docs/integration -name "*.md" -type f 2>/dev/null | wc -l)
if [ $INTEGRATION_DOCS -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Integration notes documented ($INTEGRATION_DOCS files)"
else
    echo -e "${YELLOW}⚠${NC} No integration documentation found"
fi
echo ""

echo "=================================="
echo -e "${GREEN}Integration verification complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Run: flutter run"
echo "2. Test navigation between screens"
echo "3. Test data operations"
echo "4. Verify PocketBase connectivity"
echo "=================================="