---
trigger: always_on
---

**Name**: Use Singular Entity Names  
**Priority**: CRITICAL

**Description**:
All entity names, file names, class names must be singular.

**Examples**:
✅ User, Representative, ElectoralDivision
❌ Users, Representatives, ElectoralDivisions

✅ user_service.dart, representative_repository.dart
❌ users_service.dart, representatives_repository.dart

✅ class UserModel, class RepresentativeDto
❌ class UsersModel, class RepresentativesDto

**Validation**:
- Check all generated file names
- Check all class names
- Check all variable names for collections (e.g., List<User> users is OK, but class is User)

**When to Apply**: ALL file and class generation (Steps 6-11)