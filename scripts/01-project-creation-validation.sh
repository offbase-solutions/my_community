#!/bin/bash
APP_NAME=$1
echo "Validating Step 1: $APP_NAME..."

# If APP_NAME is ".", we are already in the directory
if [ "$APP_NAME" != "." ]; then
  # Directory exists
  [ -d "$APP_NAME" ] || { echo "✗ FAIL: Directory missing"; exit 1; }
  echo "✓ Directory exists"
  cd "$APP_NAME" || exit 1
else
  echo "✓ Running in current directory"
fi

# lib/app/app.dart with @StackedApp
[ -f "lib/app/app.dart" ] || { echo "✗ FAIL: app.dart missing"; exit 1; }
grep -q "@StackedApp" lib/app/app.dart || { echo "✗ FAIL: @StackedApp missing"; exit 1; }
echo "✓ @StackedApp annotation present"

# lib/main.dart with setupLocator()
[ -f "lib/main.dart" ] || { echo "✗ FAIL: main.dart missing"; exit 1; }
grep -q "setupLocator()" lib/main.dart || { echo "✗ FAIL: setupLocator() missing"; exit 1; }
echo "✓ setupLocator() call present"

# pubspec.yaml with stacked package
[ -f "pubspec.yaml" ] || { echo "✗ FAIL: pubspec.yaml missing"; exit 1; }
grep -q "stacked:" pubspec.yaml || { echo "✗ FAIL: stacked package missing"; exit 1; }
echo "✓ stacked package present"

# Git repository
[ -d ".git" ] || { echo "✗ FAIL: Git not initialized"; exit 1; }
echo "✓ Git repository initialized"

# Initial commit
git log --oneline | grep -q "Initial commit" || { echo "✗ FAIL: Initial commit missing"; exit 1; }
echo "✓ Initial commit present"

echo "PASS: Step 1 validation complete"
