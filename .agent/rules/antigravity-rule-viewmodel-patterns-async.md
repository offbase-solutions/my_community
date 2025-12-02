---
rule_id: stakify-viewmodel-patterns-async
rule_name: "ViewModel Patterns (Async)"
category: architecture
priority: high
version: "1.0.1"
applies_to: viewmodel_generation
---

# ViewModel Patterns - Async (Minimized)

**Full Documentation**: `assets/docs/RULES/RULES-VIEWMODEL-PATTERNS-ASYNC.md`

---

## Async Operation Pattern

```dart
Future<void> loadData() async {
  setBusy(true);
  
  try {
    final result = await _service.getData();
    
    result.when(
      success: (data) {
        _data = data;
        notifyListeners();
      },
      failure: (error) {
        setError(error.message);
      },
    );
  } catch (e) {
    setError('Unexpected error: $e');
  } finally {
    setBusy(false);
  }
}
```

---

## Multiple Async Operations

```dart
Future<void> loadAll() async {
  setBusy(true);
  
  final results = await Future.wait([
    _playerService.getAll(),
    _teamService.getAll(),
  ]);
  
  final playersResult = results[0];
  final teamsResult = results[1];
  
  // Handle results...
  
  setBusy(false);
}
```

---

## Debounced Search

```dart
Timer? _debounceTimer;

void search(String query) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(Duration(milliseconds: 300), () {
    _performSearch(query);
  });
}
```

---

**For Complete Details**: See `assets/docs/RULES/RULES-VIEWMODEL-PATTERNS-ASYNC.md`