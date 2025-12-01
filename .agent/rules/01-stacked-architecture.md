---
trigger: always_on
---

**Name**: Follow Stacked Architecture  
**Priority**: CRITICAL

**Description**:
Always use Stacked MVVM pattern with strict layer boundaries.

**Key Principles**:
- View → ViewModel → Service → Repository
- No business logic in Views
- ViewModels extend BaseViewModel or ReactiveViewModel
- Services are singletons registered in app.dart
- Use BusinessResult<T> for all operations
- Never skip layers (e.g., View → Service directly)

**Validation**:
- Every View has corresponding ViewModel
- Every ViewModel has corresponding Service
- Services use Repositories for data access
- All dependencies injected via DI

**When to Apply**: ALL code generation steps (Steps 9-11)