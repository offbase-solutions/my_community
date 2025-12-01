---
trigger: always_on
---

**Name**: Run Validation After Every Step  
**Priority**: CRITICAL

**Description**:
Execute validation script after every code generation or file creation step.

**Process**:
1. Complete step action (create files, generate code)
2. Run validation script: `bash scripts/XX-validation.sh`
3. Check result: PASS or FAIL
4. If FAIL: Stop and report error
5. If PASS: Generate Walkthrough and continue

**Validation Output**:
```bash
✓ Check 1 passed
✓ Check 2 passed
✗ Check 3 failed
FAIL: Step validation failed
```

**When to Apply**: ALL steps with file/code creation