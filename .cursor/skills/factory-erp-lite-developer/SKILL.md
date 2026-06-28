---
name: factory-erp-lite-developer
description: Develop, refactor, and fix Factory ERP Lite features following the project's architecture and coding standards. Use when working on Factory ERP Lite tasks, Flutter/Dart feature development, refactors, bug fixes, offline-first Hive-to-Firestore sync, BLoC, repositories, Firestore, or GetIt DI within this repository.
disable-model-invocation: true
---

# Factory ERP Lite Developer

Develop, refactor, and fix Factory ERP Lite features following the project's architecture and coding standards.

## Instructions

Before starting any task:

1. Read ARCHITECTURE.md.
2. Follow existing project patterns.
3. Do not introduce new architecture without justification.
4. Analyze only files relevant to the task.
5. Minimize token usage by avoiding full project scans.

Architecture Requirements:

* Clean Architecture
* Feature First Structure
* Flutter BLoC
* Repository Pattern
* GetIt Dependency Injection
* Material 3

Offline First Rules:

* Save to Hive first.
* Sync to Firebase later.
* Maintain sync states:

  * pending
  * synced
  * failed

Feature Development Workflow:

1. Understand the requirement.
2. Check ARCHITECTURE.md.
3. Find similar existing feature.
4. Reuse existing patterns.
5. Show implementation plan.
6. List files to create.
7. List files to modify.
8. Implement production-ready code.

Bug Fix Workflow:

1. Identify root cause.
2. Analyze only affected files.
3. Avoid unnecessary refactoring.
4. Explain the fix.
5. Verify no architecture violations.

Code Generation Rules:

* Follow SOLID principles.
* Keep widgets modular.
* Use BLoC for state management.
* Use repositories for data access.
* Use abstractions/interfaces.
* Support offline-first behavior.
* Keep code scalable for:

  * Multi Factory
  * Multi User Roles
  * Inventory Management
  * Production Management

Response Rules:

* Be concise.
* Avoid explaining basic Flutter concepts.
* Prefer modifying existing code over creating duplicates.
* Always follow ARCHITECTURE.md as the source of truth.

## UI conventions (mandatory)

* **Structure:** `ui/<feature>_page.dart` + `ui/widget/` — never `presentation/`.
* **Imports:** `import '../../../utils/exports.dart';` (adjust depth) — never `../../../../app/core/...`.
* **Spacing:** `Dimens.space*`, `Dimens.padding*`, `Dimens.radius*`, `Dimens.fontSize*` — no raw numbers.
* **Widgets:** `CustomTextLabelWidget`, `CustomButtonWidget`, `CustomTextFormFieldWidget` — not raw `Text` / `FilledButton` / `TextField`.
* **Theme:** `context.appThemeColors`, `AppStyles.instance.textTheme`, `AppColors` — no inline hex colors.
* **Assets:** `Assets` / `SvgGenImage` from `gen/assets.gen.dart` — avoid hardcoded asset path strings.

## Project notes (Factory ERP Lite specific)

- **Stack:** Flutter mobile + Flutter web admin; Firebase (Firestore, Auth, Storage); Hive offline; GetStorage for prefs only.
- **Hive vs GetStorage:** See `ARCHITECTURE.md` → *Offline-First & Local Persistence*. `HiveManager` and module boxes are implemented; `SharedPref` is for auth/locale only.
- **Cloud store:** ERP modules sync to **Firestore** via `FirebaseService` and `FirestoreCollections` — not Dio.
- **Core modules:** labor, person, truck/maintenance/electricity/misc expenses, material purchases, calendar, factory status, reports, attachments, recurring expenses.
- **Foundation services:** `FirebaseService`, `HiveManager`, `SyncService` — registered in `singleton.dart`, initialized in `AppInitializer`.
