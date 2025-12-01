#!/bin/bash
# Validation for Step 2: Add Stakify Documentation

echo "Validating Step 2..."

# Check submodule
if [ -d "assets/docs" ] && [ -f "assets/docs/GETTING-STARTED.md" ]; then
    echo "✓ Submodule added successfully"
else
    echo "✗ Submodule missing or incomplete"
    exit 1
fi

# Check .gitmodules
if grep -q "stakify-codegen-docs" .gitmodules; then
    echo "✓ .gitmodules configured"
else
    echo "✗ .gitmodules missing entry"
    exit 1
fi

# Check pubspec.yaml
if grep -q "assets/docs/RULES/" pubspec.yaml; then
    echo "✓ pubspec.yaml assets configured"
else
    echo "✗ pubspec.yaml missing assets"
    exit 1
fi

# Check directory structure
DIRS=("docs/product" "docs/features" "docs/screens" "docs/entities" "docs/integration" "docs/config" "scripts")
for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "✓ Directory exists: $dir"
    else
        echo "✗ Directory missing: $dir"
        exit 1
    fi
done

echo "PASS: Step 2 validation complete"
