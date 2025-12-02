
---
rule_id: stakify-cli-boundaries
rule_name: "Stacked CLI Boundaries"
category: tooling
priority: medium
version: "1.0.1"
applies_to: project_setup
---

# Stacked CLI Boundaries (Minimized)

**Full Documentation**: `assets/docs/RULES/RULES-CLI-BOUNDARIES.md`

---

## What Stacked CLI Does

✅ **USE CLI FOR**:
- Project creation: `stacked create app {name}`
- View scaffolding: `stacked create view {name}`
- Service creation: `stacked create service {name}`
- Code generation: `stacked generate`

## What Stacked CLI Does NOT Do

❌ **DO NOT USE CLI FOR**:
- Data layer (Models, Repositories, Services)
- PocketBase integration
- Complex business logic
- Detailed feature implementation

Use Stakify SLG/VLG workflows instead.

---

**For Complete Details**: See `assets/docs/RULES/RULES-CLI-BOUNDARIES.md`