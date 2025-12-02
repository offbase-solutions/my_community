---
rule_id: stakify-project-structure
rule_name: "Project Structure"
category: organization
priority: high
version: "1.0.1"
applies_to: all_code_generation
---

# Project Structure (Minimized)

**Full Documentation**: `assets/docs/RULES/RULES-PROJECT-STRUCTURE.md`

---

## Standard Structure

```
lib/
├── app/
│   ├── app.dart           # Stacked config
│   ├── app.locator.dart   # Generated DI
│   └── app.router.dart    # Generated routes
├── core/
│   └── service_core.dart  # BusinessResult
├── data/
│   ├── models/
│   │   └── {entity}/
│   │       ├── {entity}_model.dart
│   │       ├── {entity}_projections.dart
│   │       └── {entity}_mixins.dart
│   ├── repositories/
│   │   └── {entity}/
│   │       ├── i_{entity}_repository.dart
│   │       └── {entity}_repository.dart
│   └── pb/
│       └── {entity}_data.dart  # Generated DTOs
├── services/
│   └── {entity}_service.dart
└── ui/
    ├── common/
    │   └── app_constants.dart
    └── views/
        └── {feature}/
            └── {screen}/
                ├── {screen}_view.dart
                └── {screen}_viewmodel.dart
```

---

**For Complete Details**: See `assets/docs/RULES/RULES-PROJECT-STRUCTURE.md`