---
rule_id: stakify-viewmodel-patterns-core
rule_name: "ViewModel Patterns (Core)"
category: architecture
priority: critical
version: "1.0.1"
applies_to: viewmodel_generation
---

# ViewModel Patterns - Core (Minimized)

**Full Documentation**: `assets/docs/RULES/RULES-VIEWMODEL-PATTERNS-CORE.md`

---

## Base Classes

### BaseViewModel
For simple screens without forms:
```dart
class HomeViewModel extends BaseViewModel {
  // State and logic
}
```

### FormViewModel
For screens with forms:
```dart
class LoginViewModel extends FormViewModel {
  // Form logic with validation
}
```

---

## State Management Methods

### Loading State
```dart
setBusy(true);   // Show loading
await operation();
setBusy(false);  // Hide loading
```

### Error State
```dart
setError('Error message');  // Show error
setError(null);  // Clear error
```

### Notify Listeners
```dart
_data = newData;
notifyListeners();  // Update UI
```

---

## Service Integration

**ALWAYS use Services (never Repositories)**:

```dart
class PlayerViewModel extends BaseViewModel {
  final _playerService = locator<PlayerService>();
  
  Future<void> loadPlayers() async {
    setBusy(true);
    
    final result = await _playerService.getAll();
    
    result.when(
      success: (players) {
        _players = players;
        notifyListeners();
      },
      failure: (error) {
        setError(error.message);
      },
    );
    
    setBusy(false);
  }
}
```

---

## Navigation

```dart
final _navigationService = locator<NavigationService>();

// Navigate
await _navigationService.navigateTo(Routes.homeView);

// Navigate with result
final result = await _navigationService.navigateTo(Routes.editView);

// Navigate back
_navigationService.back();
```

---

## Quick Checklist

- [ ] Extends BaseViewModel or FormViewModel
- [ ] Uses locator<T>() for services
- [ ] Calls Services (NOT Repositories)
- [ ] Handles BusinessResult<T>
- [ ] Uses setBusy() for loading
- [ ] Uses setError() for errors
- [ ] Calls notifyListeners() after state changes

---

**For Complete Details**: See `assets/docs/RULES/RULES-VIEWMODEL-PATTERNS-CORE.md`

**Related Rules**:
- RULES-VIEWMODEL-PATTERNS-ASYNC.md
- RULES-VIEWMODEL-PATTERNS-BASIC.md
- RULES-ARCHITECTURE.md