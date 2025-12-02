---
rule_id: stakify-dependency-injection
rule_name: "Dependency Injection"
category: architecture
priority: high
version: "1.0.1"
applies_to: all_code_generation
---

# Dependency Injection (Minimized)

**Full Documentation**: `assets/docs/RULES/RULES-DEPENDENCY-INJECTION.md`

---

## Registration (app.dart)

```dart
@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
  ],
  dependencies: [
    // Services
    LazySingleton(classType: PlayerService),
    
    // Repositories
    LazySingleton(
      classType: PlayerRepository,
      asType: IPlayerRepository,
    ),
  ],
)
class App {}
```

---

## Usage (locator)

```dart
// In ViewModel
final _playerService = locator<PlayerService>();

// In Service
final _playerRepository = locator<IPlayerRepository>();
```

---

## Pattern

1. **Register** in app.dart
2. **Generate** with `stacked generate`
3. **Inject** with `locator<T>()`

---

**For Complete Details**: See `assets/docs/RULES/RULES-DEPENDENCY-INJECTION.md`