---
rule_id: stakify-rules-index
rule_name: "Stakify Rules Index"
category: meta
priority: critical
version: "1.0.1"
applies_to: all_code_generation
---

# Stakify Rules Index (Quick Reference)

**Full Documentation Directory**: `assets/docs/RULES/`

---

## Core Architecture Rules (CRITICAL)

1. **RULES-ARCHITECTURE.md**
   - File: `antigravity-rule-architecture.md`
   - Priority: CRITICAL
   - Three-tier architecture enforcement

2. **RULES-NAMING-CONVENTIONS.md**
   - File: `antigravity-rule-naming-conventions.md`
   - Priority: CRITICAL
   - Singular naming, snake_case files

3. **RULES-CONSTANTS-MANAGEMENT.md**
   - File: `antigravity-rule-constants-management.md`
   - Priority: HIGH
   - Hungarian notation (kc, kts, ksp, krd, kstr)

---

## ViewModel Patterns (HIGH PRIORITY)

4. **RULES-VIEWMODEL-PATTERNS-CORE.md**
   - File: `antigravity-rule-viewmodel-patterns-core.md`
   - Base classes, state management

5. **RULES-VIEWMODEL-PATTERNS-ASYNC.md**
   - File: `antigravity-rule-viewmodel-patterns-async.md`
   - Async operations, error handling

6. **RULES-VIEWMODEL-PATTERNS-BASIC.md**
   - File: `antigravity-rule-viewmodel-patterns-basic.md`
   - Templates and examples

---

## Supporting Rules

7. **RULES-DEPENDENCY-INJECTION.md**
   - File: `antigravity-rule-dependency-injection.md`
   - locator<T>() usage

8. **RULES-PROJECT-STRUCTURE.md**
   - File: `antigravity-rule-project-structure.md`
   - Directory organization

9. **RULES-ANTI-PATTERNS.md**
   - File: `antigravity-rule-anti-patterns.md`
   - What NOT to do

10. **RULES-CLI-BOUNDARIES.md**
    - File: `antigravity-rule-cli-boundaries.md`
    - When to use Stacked CLI

11. **RULES-PERFORMANCE-PATTERNS.md**
    - File: `antigravity-rule-performance-patterns.md`
    - Optimization patterns

---

## Usage in Antigravity

### Directory Structure
```
.agent/
└── rules/
    ├── antigravity-rule-architecture.md
    ├── antigravity-rule-naming-conventions.md
    ├── antigravity-rule-constants-management.md
    ├── antigravity-rule-viewmodel-patterns-core.md
    ├── antigravity-rule-viewmodel-patterns-async.md
    ├── antigravity-rule-viewmodel-patterns-basic.md
    ├── antigravity-rule-dependency-injection.md
    ├── antigravity-rule-project-structure.md
    ├── antigravity-rule-anti-patterns.md
    ├── antigravity-rule-cli-boundaries.md
    ├── antigravity-rule-performance-patterns.md
    └── antigravity-rules-index.md
```

### Load Order
1. Architecture (CRITICAL)
2. Naming Conventions (CRITICAL)
3. ViewModel Patterns (HIGH)
4. Supporting rules as needed

---

## Quick Validation Checklist

Before generating any code, verify:

- [ ] Three-tier architecture maintained
- [ ] Singular naming used
- [ ] Hungarian notation for constants
- [ ] ViewModel → Service (not Repository)
- [ ] BusinessResult<T> handled
- [ ] All files snake_case
- [ ] All classes PascalCase
- [ ] Proper DI with locator<T>()
- [ ] No anti-patterns present

---

**For Complete Documentation**: See `assets/docs/RULES/RULES-README.md`