---
rule_id: stakify-performance-patterns
rule_name: "Performance Patterns"
category: optimization
priority: medium
version: "1.0.1"
applies_to: all_code_generation
---

# Performance Patterns (Minimized)

**Full Documentation**: `assets/docs/RULES/RULES-PERFORMANCE-PATTERNS.md`

---

## Key Patterns

### 1. Use const Constructors

```dart
// ✅ Good
const Text('Hello');
const SizedBox(height: 16);

// ❌ Avoid
Text('Hello');
SizedBox(height: 16);
```

### 2. Lazy Loading

```dart
// Load data only when needed
@override
void onViewModelReady(HomeViewModel viewModel) {
  viewModel.loadData();  // Not in constructor
}
```

### 3. Pagination

```dart
// Don't load all data at once
Future<void> loadMore() async {
  final result = await _service.getPage(page: _currentPage);
  // Handle result
}
```

### 4. Debouncing

```dart
// Debounce search
Timer? _debounce;
void onSearchChanged(String query) {
  _debounce?.cancel();
  _debounce = Timer(Duration(milliseconds: 300), () {
    search(query);
  });
}
```

---

**For Complete Details**: See `assets/docs/RULES/RULES-PERFORMANCE-PATTERNS.md`