---
rule_id: stakify-architecture
rule_name: "Stacked Architecture Rules"
category: core-architecture
priority: critical
version: "1.0.1"
applies_to: all_code_generation
---

# Stacked Architecture Rules (Minimized)

**Full Documentation**: `assets/docs/RULES/RULES-ARCHITECTURE.md` (441 lines)

---

## CRITICAL: Three-Tier Architecture (MANDATORY)

```
View → ViewModel → Service → Repository
```

**Layer Boundaries (STRICT)**:
- ✅ View calls ViewModel only
- ✅ ViewModel calls Service only  
- ✅ Service calls Repository only
- ❌ ViewModel NEVER calls Repository directly
- ❌ View NEVER calls Service or Repository

---

## View Layer Rules

**MUST**:
- Extend `StackedView<T>`
- Be stateless and reactive
- Contain zero to minimal logic
- Only render ViewModel state
- Put lifecycle in View (`onViewModelReady`, `onDispose`)

**MUST NOT**:
- Use Services directly
- Use Repositories directly
- Contain business logic

---

## ViewModel Layer Rules

**MUST**:
- Extend `BaseViewModel` or `FormViewModel`
- Call Services only (NEVER Repositories)
- Handle all business logic
- Manage UI state
- Use `BusinessResult<T>` for all operations
- Use `locator<T>()` for dependency injection

**Pattern**:
```dart
class HomeViewModel extends BaseViewModel {
  final _service = locator<PlayerService>();
  
  Future<void> loadData() async {
    setBusy(true);
    final result = await _service.getAll();
    result.when(
      success: (data) => _data = data,
      failure: (error) => setError(error.message),
    );
    setBusy(false);
  }
}
```

---

## Service Layer Rules

**MUST**:
- Implement business features
- Call Repositories for data
- Return `BusinessResult<T>`
- Use `locator<T>()` for dependencies
- Handle all error cases

**Pattern**:
```dart
class PlayerService {
  final _repository = locator<IPlayerRepository>();
  
  Future<BusinessResult<List<Player>>> getAll() async {
    return await _repository.getAll();
  }
}
```

---

## Repository Layer Rules

**MUST**:
- Implement interface (`IEntityRepository`)
- Extend `BaseCollectionRepository`
- Return `BusinessResult<T>`
- Handle data operations only
- No business logic

---

## Key Patterns

### 1. BusinessResult Pattern (CRITICAL)
```dart
// In Repository
BusinessResult<Player>.success(player)
BusinessResult<Player>.failure(BusinessError(...))

// In ViewModel
result.when(
  success: (data) => handleSuccess(data),
  failure: (error) => handleError(error),
);
```

### 2. Dependency Injection
```dart
final _service = locator<PlayerService>();  // ✅ Correct
final _repository = locator<IPlayerRepository>();  // In Service only
```

### 3. State Management
```dart
setBusy(true);   // Show loading
setError(msg);   // Show error
notifyListeners();  // Update UI
```

---

## Anti-Patterns (FORBIDDEN)

❌ **ViewModel → Repository**:
```dart
// WRONG - Don't do this!
class HomeViewModel {
  final _repository = locator<PlayerRepository>();  // ❌
}
```

❌ **View with Business Logic**:
```dart
// WRONG - Logic belongs in ViewModel
class HomeView {
  void _validateAndSubmit() {  // ❌
    if (email.isValid) { ... }
  }
}
```

❌ **Direct PocketBase Access**:
```dart
// WRONG - Use Repository instead
pb.collection('players').getList();  // ❌
```

---

## Quick Checklist

Before generating any code, verify:

- [ ] View extends StackedView<T>
- [ ] ViewModel extends BaseViewModel/FormViewModel
- [ ] ViewModel uses Services only (not Repositories)
- [ ] Service calls Repository
- [ ] All operations return BusinessResult<T>
- [ ] Dependencies injected via locator<T>()
- [ ] No layer boundary violations

---

**For Complete Details**: See `assets/docs/RULES/RULES-ARCHITECTURE.md`

**Related Rules**:
- RULES-VIEWMODEL-PATTERNS-CORE.md
- RULES-VIEWMODEL-PATTERNS-ASYNC.md
- RULES-DEPENDENCY-INJECTION.md
