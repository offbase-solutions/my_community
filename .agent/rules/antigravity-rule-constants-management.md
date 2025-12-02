---
rule_id: stakify-constants-management
rule_name: "Constants Management (Hungarian Notation)"
category: code-standards
priority: high
version: "1.0.1"
applies_to: all_code_generation
---

# Constants Management (Minimized)

**Full Documentation**: `assets/docs/RULES/RULES-CONSTANTS-MANAGEMENT.md`

---

## Hungarian Notation (MANDATORY)

All constants MUST use Hungarian notation prefixes:

### Color Constants: `kc` prefix

```dart
// ✅ Correct
const Color kcPrimaryBackground = Color(0xFFFFFFFF);
const Color kcAccent = Color(0xFF2196F3);
const Color kcTextPrimary = Color(0xFF000000);

// ❌ Wrong
const Color primaryBackground = Color(0xFFFFFFFF);
const Color ACCENT = Color(0xFF2196F3);
```

### Text Style Constants: `kts` prefix

```dart
// ✅ Correct
const TextStyle ktsHeading1 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: kcTextPrimary,
);

// ❌ Wrong
const TextStyle heading1 = TextStyle(...);
```

### Spacing Constants: `ksp` prefix

```dart
// ✅ Correct
const double kspScreenPadding = 16.0;
const double kspCardMargin = 8.0;

// ❌ Wrong
const double screenPadding = 16.0;
```

### Border Radius Constants: `krd` prefix

```dart
// ✅ Correct
const double krdButton = 8.0;
const double krdCard = 12.0;

// ❌ Wrong
const double buttonRadius = 8.0;
```

### String Constants: `kstr` prefix

```dart
// ✅ Correct
const String kstrAppName = 'Stakify';
const String kstrWelcomeMessage = 'Welcome!';

// ❌ Wrong
const String appName = 'Stakify';
```

---

## File Organization

**Location**: `lib/ui/common/app_constants.dart`

```dart
class AppConstants {
  // Colors
  static const Color kcPrimaryBackground = Color(0xFFFFFFFF);
  
  // Text Styles
  static const TextStyle ktsHeading1 = TextStyle(...);
  
  // Spacing
  static const double kspScreenPadding = 16.0;
  
  // Border Radius
  static const double krdButton = 8.0;
  
  // Strings
  static const String kstrAppName = 'Stakify';
}
```

---

## Quick Reference

| Prefix | Type | Example |
|--------|------|---------|
| `kc` | Color | `kcPrimaryBackground` |
| `kts` | TextStyle | `ktsHeading1` |
| `ksp` | Spacing | `kspScreenPadding` |
| `krd` | Border Radius | `krdButton` |
| `kstr` | String | `kstrWelcomeMessage` |

---

**For Complete Details**: See `assets/docs/RULES/RULES-CONSTANTS-MANAGEMENT.md`

**Related Rules**:
- RULES-NAMING-CONVENTIONS.md