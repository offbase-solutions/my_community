---
rule_id: stakify-anti-patterns
rule_name: "Anti-Patterns to Avoid"
category: code-quality
priority: critical
version: "1.0.1"
applies_to: all_code_generation
---

# Anti-Patterns (Minimized)

**Full Documentation**: `assets/docs/RULES/RULES-ANTI-PATTERNS.md`

---

## FORBIDDEN Patterns

### 1. ViewModel → Repository (CRITICAL)

```dart
// ❌ WRONG - Never do this!
class HomeViewModel extends BaseViewModel {
  final _repository = locator<PlayerRepository>();
}

// ✅ CORRECT - Use Service
class HomeViewModel extends BaseViewModel {
  final _service = locator<PlayerService>();
}
```

### 2. Direct PocketBase Access

```dart
// ❌ WRONG
pb.collection('players').getList();

// ✅ CORRECT
await _playerRepository.getAll();
```

### 3. Business Logic in Views

```dart
// ❌ WRONG
class HomeView extends StackedView {
  void _validateEmail() { ... }  // Logic in View
}

// ✅ CORRECT
// Put logic in ViewModel
```

### 4. Plural Entity Names

```dart
// ❌ WRONG
class PlayersModel { }

// ✅ CORRECT
class PlayerModel { }
```

### 5. Missing Error Handling

```dart
// ❌ WRONG
final result = await _service.getAll();
final players = result;  // Assumes success

// ✅ CORRECT
result.when(
  success: (data) => handleSuccess(data),
  failure: (error) => handleError(error),
);
```

---

**For Complete Details**: See `assets/docs/RULES/RULES-ANTI-PATTERNS.md`