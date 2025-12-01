---
trigger: always_on
---

**Name**: Constant Naming Prefixes  
**Priority**: HIGH

**Description**:
Use Hungarian notation for UI constants.

**Prefixes**:
- kc* - Colors (kcPrimaryBlue, kcSecondaryGreen)
- kts* - Text Styles (ktsHeading1, ktsBodyText)
- ksp* - Spacing (ksp8, ksp16, ksp24)
- krd* - Radius (krd4, krd8, krd16)
- kdur* - Duration (kdur200ms, kdur500ms)

**Examples**:
```dart
static const kcPrimaryBlue = Color(0xFF0066CC);
static const ktsHeading1 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
static const ksp16 = 16.0;
static const krd8 = 8.0;
```

**When to Apply**: UI constant generation (Step 10)