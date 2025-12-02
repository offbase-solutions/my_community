---
rule_id: stakify-naming-conventions
rule_name: "Naming Conventions"
category: code-standards
priority: critical
version: "1.0.1"
applies_to: all_code_generation
---

# Naming Conventions (Minimized)

**Full Documentation**: `assets/docs/RULES/RULES-NAMING-CONVENTIONS.md` (447 lines)

---

## File Naming (STRICT)

**ALL files MUST use `snake_case.dart`**

| Type | Pattern | Example |
|------|---------|---------|
| View | `{feature}_view.dart` | `home_view.dart` |
| ViewModel | `{feature}_viewmodel.dart` | `home_viewmodel.dart` |
| Service | `{service}_service.dart` | `player_service.dart` |
| Model | `{entity}.dart` (singular) | `player.dart` |
| DTO | `{entity}_data.dart` (singular) | `player_data.dart` |
| Repository | `{entity}_repository.dart` | `player_repository.dart` |
| Interface | `i_{entity}_repository.dart` | `i_player_repository.dart` |
| Enum | `{name}_type.dart` | `user_status_type.dart` |

---

## Folder Naming (STRICT)

**ALL folders MUST use `snake_case/`**

✅ Correct: `user_profile/`, `bottom_sheets/`  
❌ Wrong: `UserProfile/`, `BottomSheets/`

---

## Class Naming (PascalCase)

| Type | Pattern | Example |
|------|---------|---------|
| View | `{Feature}View` | `HomeView` |
| ViewModel | `{Feature}ViewModel` | `HomeViewModel` |
| Service | `{Purpose}Service` | `PlayerService` |
| Model | `{Entity}` (singular) | `Player` |
| DTO | `{Entity}Data` (singular) | `PlayerData` |
| Repository | `{Entity}Repository` | `PlayerRepository` |
| Interface | `I{Entity}Repository` | `IPlayerRepository` |
| Projection | `{Entity}{Type}Projection` | `PlayerCardProjection` |

---

## CRITICAL: Singular vs Plural

**ALWAYS USE SINGULAR** (not plural):

✅ Correct:
- `Player` (not `Players`)
- `player.dart` (not `players.dart`)
- `PlayerService` (not `PlayersService`)
- `PlayerRepository` (not `PlayersRepository`)
- From collection `players` → Model `Player`

❌ Wrong:
- `Players`
- `players.dart` (for model)
- `PlayersService`

---

## Variable Naming

**Use camelCase for all variables**

```dart
// ✅ Correct
String userName;
int playerId;
List<Player> playerList;

// ❌ Wrong
String UserName;
String user_name;
```

---

## Method Naming

**Use camelCase starting with verb**

```dart
// ✅ Correct
Future<void> loadPlayers()
void updateScore()
bool isValid()
Player getPlayerById(String id)

// ❌ Wrong
Future<void> LoadPlayers()
void update_score()
bool valid()
```

---

## Collection to Entity Mapping

**PocketBase Collection → Dart Entity**

| Collection Name | Model Name | File Name | DTO Name |
|----------------|------------|-----------|----------|
| `players` | `Player` | `player.dart` | `PlayerData` |
| `teams` | `Team` | `team.dart` | `TeamData` |
| `users` | `User` | `user.dart` | `UserData` |
| `match_results` | `MatchResult` | `match_result.dart` | `MatchResultData` |

---

## Quick Checklist

Before generating any code:

- [ ] All files use snake_case.dart
- [ ] All folders use snake_case/
- [ ] All classes use PascalCase
- [ ] All variables/methods use camelCase
- [ ] Entity names are SINGULAR
- [ ] Collections → Models follow mapping
- [ ] Enums end with _type suffix
- [ ] Interfaces start with I prefix

---

**For Complete Details**: See `assets/docs/RULES/RULES-NAMING-CONVENTIONS.md`

**Related Rules**:
- RULES-CONSTANTS-MANAGEMENT.md
- RULES-PROJECT-STRUCTURE.md
