---
name: factory-erp-lite-developer
description: Develop, refactor, and fix Factory ERP Lite features following the project's architecture and coding standards. Use when working on Factory ERP Lite tasks, Flutter/Dart feature development, refactors, bug fixes, offline-first behavior, BLoC, repositories, or GetIt DI within this repository.
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

## Project notes (Factory ERP Lite specific)

- **Hive vs GetStorage:** See `ARCHITECTURE.md` → *Offline-First & Local Persistence*. Hive is the target for syncable business data (`pending` / `synced` / `failed`); `SharedPref` (`get_storage`) is for lightweight app prefs only. Hive is planned but not yet in `lib/` — introduce it per feature when building offline-first flows.

