# Factory ERP Lite — Architecture

Production-grade, **offline-first** Factory ERP for manufacturing businesses.

| Component | Stack |
|-----------|-------|
| **Flutter Mobile App** | BLoC, Hive, Firebase sync |
| **Flutter Web Admin Panel** | Same Firebase backend, real-time Firestore |
| **Backend** | Firebase (Firestore, Auth, Storage, Remote Config, FCM) |
| **Offline storage** | Hive (business data) + GetStorage (app prefs) |
| **Planned integrations** | Google Sheet backup, PDF & Excel export |

> **Local persistence:** Business data follows **save to Hive first → sync to Firebase later**. App preferences (auth, locale, user id) use **`get_storage`** via `SharedPref`. See [Offline-First & Local Persistence](#offline-first--local-persistence).

---

## Architecture Principles

| Principle | Implementation |
|-----------|----------------|
| Clean Architecture | UI → BLoC → Repository → Hive / Firestore |
| Feature-first structure | `lib/modules/<feature>/` per ERP domain |
| State management | `flutter_bloc` — one BLoC per feature |
| Data access | Repository pattern with abstract + `*_impl.dart` |
| Dependency injection | `get_it` — `base/singleton.dart` |
| UI | Material 3 |
| SOLID | Interfaces for repos; BLoCs depend on abstractions |

### Clean Architecture layers (per feature)

```
modules/<feature>/
├── ui/              # Presentation — widgets, pages
├── bloc/            # Presentation — events, states, BLoC
├── repository/      # Data — abstract repo + impl (Hive + Firestore)
├── model/
│   ├── local/       # Hive entities (Freezed + syncStatus)
│   └── remote/      # Firestore DTOs / maps
└── <feature>.dart   # Barrel export
```

Use cases may be extracted to `domain/usecases/` when business logic outgrows the BLoC.

---

## Folder Structure

```
FactoryERPLite/
├── android/                    # Android platform project
├── ios/                        # iOS platform project
├── assets/
│   ├── json/
│   ├── png/
│   ├── svgs/
│   └── webp/
├── fonts/                      # Custom fonts (Hellix)
├── lib/
│   ├── main.dart               # App entry (Sentry + MaterialApp.router)
│   ├── app/                    # App shell: theme, widgets, i18n, init
│   │   ├── app.dart
│   │   ├── core/
│   │   │   ├── config/         # Constants, SharedPref (GetStorage prefs)
│   │   │   ├── theme/          # Colors, styles, dimensions, MyAppTheme
│   │   │   └── widgets/        # Reusable UI (buttons, forms, shimmer, etc.)
│   │   ├── enums/              # Environment, ApiType, BaseStateStatus, etc.
│   │   ├── initializer/        # AppInitializer (boot sequence)
│   │   └── translations/       # Localization delegates (en, hi)
│   ├── base/                   # DI, env config, responsive helpers
│   │   ├── base_config.dart
│   │   ├── main_config.dart
│   │   └── singleton.dart      # GetIt registrations
│   ├── core/                   # Shared domain (sync metadata keys)
│   │   └── domain/
│   ├── gen/                    # Generated assets/fonts (flutter_gen)
│   ├── modules/                # Feature modules (see Feature List)
│   ├── service/                # Cross-cutting infrastructure
│   │   ├── hive/               # HiveManager, box names, init
│   │   ├── firebase/           # FirebaseService, Firestore collections
│   │   ├── sync/               # Hive → Firebase sync orchestration
│   │   ├── navigation/         # go_router (target) + auto_route (current scaffold)
│   │   ├── network/            # Dio ApiClient, BaseRepository, models
│   │   ├── notification/       # FCM + Awesome Notifications
│   │   ├── permission/
│   │   └── sentry/
│   └── utils/                  # Extensions, encryption, exports barrel
├── prod_env.json / stage_env.json
├── pubspec.yaml
└── test/
```

### Module layout (repeated per feature)

Features that include business logic follow a consistent structure:

```
modules/<feature>/
├── bloc/           # Event / State / Bloc (+ bloc.dart barrel)
├── model/
│   ├── local/      # Hive entities (Freezed + syncStatus)
│   └── remote/     # Firestore DTOs / document maps
├── repository/     # Abstract repo + *_impl.dart (Hive + Firestore sync)
├── ui/             # Screens and widgets (@RoutePage or go_router)
└── <feature>.dart  # Barrel export
```

**Barrel import chain:** `main.dart` → `utils/exports.dart` → `modules/modules.dart` + `service/service.dart` + `base/base.dart` + `app/app.dart`

---

## Feature List

### Scaffold modules (template)

| Module | Layer | Description |
|--------|-------|-------------|
| **splash** | bloc, ui | Initial splash screen; routes onward on startup |
| **login** | bloc, model/local, ui | Email/password login form with validation |
| **dashboard** | ui | Shell with `AutoTabsRouter` + bottom navigation |
| **localization** | bloc | App-wide locale switching (`LocaleBloc`) |
| **force_update_under_maintenance** | bloc, model, ui | Force-update & maintenance via Remote Config |
| **page_not_found** | ui | 404 / catch-all route |

### ERP modules (foundation folders — implement per feature)

| Module | Hive box | Firestore collection |
|--------|----------|----------------------|
| **labor_management** | `labor_management` | `labor_management` |
| **person_management** | `person_management` | `person_management` |
| **truck_expenses** | `truck_expenses` | `truck_expenses` |
| **maintenance_expenses** | `maintenance_expenses` | `maintenance_expenses` |
| **electricity_expenses** | `electricity_expenses` | `electricity_expenses` |
| **material_purchases** | `material_purchases` | `material_purchases` |
| **miscellaneous_expenses** | `miscellaneous_expenses` | `miscellaneous_expenses` |
| **calendar_management** | `calendar_management` | `calendar_management` |
| **factory_status** | `factory_status` | `factory_status` |
| **reports_analytics** | `reports_analytics` | `reports_analytics` |
| **attachments** | `attachments` | `attachments` |
| **recurring_expenses** | `recurring_expenses` | `recurring_expenses` |

### Platform scope

| Platform | Backend | Offline | Responsibilities |
|----------|---------|---------|------------------|
| **Flutter Mobile** | Firebase (Firestore, Auth, Storage) | Hive | CRUD offline; sync on connectivity; attachments |
| **Flutter Web Admin** | Same Firebase project | Firestore cache | Dashboard, reports, export, management; real-time sync |

### Web admin rules

- Same Firebase project and Firestore collections as mobile.
- Reads/writes Firestore directly (no Hive on web).
- Real-time listeners for dashboard and operational views.
- Reports, analytics, and export (PDF / Excel) live on web first.
- Auth via `FirebaseService.auth` with role-based access (future).

### Future scope

| Area | Notes |
|------|-------|
| Multi-factory | `factoryId` on every document |
| Multi-user roles | Firebase Auth + Firestore security rules |
| Inventory management | New module |
| Production management | New module |
| Employee management | Extends person/labor modules |
| Google Sheet backup | Scheduled export service (planned) |
| PDF & Excel export | Web admin + mobile share (planned) |

---

## Dependencies

### Runtime (`dependencies`)

| Package | Role |
|---------|------|
| `flutter_bloc` | State management (BLoC) |
| `equatable` | Value equality for events/states |
| `get_it` | Service locator / DI |
| `go_router` | Declarative routing (foundation / target) |
| `auto_route` | Declarative routing (current scaffold — migrate to `go_router`) |
| `dio` | HTTP client |
| `awesome_dio_interceptor` | Request/response logging |
| `network_cache_interceptor` | Response caching |
| `connectivity_plus` | Network connectivity checks |
| `hive` / `hive_flutter` | Offline-first local database |
| `get_storage` | Lightweight key-value prefs (`SharedPref`) |
| `freezed` / `freezed_annotation` | Immutable models |
| `json_annotation` | JSON serialization annotations |
| `firebase_core` | Firebase initialization |
| `firebase_auth` | User authentication (mobile + web admin) |
| `cloud_firestore` | Primary cloud database (sync target) |
| `firebase_storage` | File attachments storage |
| `firebase_remote_config` | Force-update & maintenance flags |
| `firebase_messaging` | Push notifications (FCM) |
| `awesome_notifications` | Local notification display |
| `sentry_flutter` / `sentry_dio` / `sentry_logging` | Error monitoring & tracing |
| `flutter_easyloading` | Global loading overlay |
| `cached_network_image` | Image caching |
| `google_fonts` | Typography |
| `flutter_svg` | SVG assets |
| `shimmer` | Skeleton loading |
| `encrypt` | AES encryption utilities |
| `permission_handler` | Runtime permissions |
| `device_info_plus` / `package_info_plus` | Device & app metadata |
| `intl` | Date/number formatting |
| `url_launcher` / `url_strategy` | URLs & web path strategy |
| `universal_html` | Web platform helpers |
| `path_provider` | File system paths |
| `logger` | Structured console logging |
| `async` | Async utilities |

### Dev (`dev_dependencies`)

| Package | Role |
|---------|------|
| `build_runner` | Code generation orchestration |
| `auto_route_generator` | Route & `app_routes.gr.dart` generation |
| `json_serializable` | `.g.dart` JSON parsers |
| `flutter_gen_runner` | `lib/gen/` asset accessors |
| `flutter_lints` | Lint rules |

### SDK

- Dart `>=3.11.4 <4.0.0`
- Flutter `3.41.x` (stable)

---

## State Management

**Pattern:** [flutter_bloc](https://pub.dev/packages/flutter_bloc) — one BLoC per feature (or global concern).

### BLoCs

| BLoC | Scope | Registered in |
|------|-------|---------------|
| `LocaleBloc` | App-wide locale | `singleton.dart` + `MultiBlocProvider` in `main.dart` |
| `ForceUpdateUnderMaintenanceBloc` | Remote config checks | `singleton.dart` + `main.dart` |
| `SplashBloc` | Splash screen | `BlocProvider` on `SplashPage` |
| `LoginBloc` | Login form | `BlocProvider` on `LoginPage` |
| `TabOneBloc` | User details tab | `BlocProvider` on `TabOnePage` |
| `CustomPaginationBloc` | Paginated list | `BlocProvider` on `CustomPaginationPage` |

### Conventions

- **Events:** `sealed class` hierarchies extending `Equatable`
- **States:** `Equatable` classes with `copyWith`; shared status via `BaseStateStatus` enum (`initial`, `loading`, `success`, `failure`)
- **UI wiring:** `BlocProvider` at page level → `BlocBuilder` / `BlocListener` in child widgets
- **Models:** Freezed + `json_serializable` for API/local DTOs where applicable

```
┌─────────────┐   dispatch    ┌──────────┐   call    ┌────────────┐   read/write   ┌──────────┐
│  UI Widget  │ ────────────► │   Bloc   │ ────────► │ Repository │ ─────────────► │   Hive   │
└─────────────┘ ◄──────────── └──────────┘ ◄──────── └────────────┘ ◄───────────── └──────────┘
     rebuild      emit state                            sync (pending/synced/failed)
                                                          │
                                                          ▼
                                                   ┌─────────────┐
                                                   │  Firestore  │
                                                   └─────────────┘
```

**ERP modules use Firestore as the cloud store.** The legacy `ApiClient` / Dio layer remains for scaffold demo features (`tab_one`, `custom_pagination`) only.

**Offline-first repository contract:**

1. **Write:** persist to Hive immediately; set `syncStatus = pending`.
2. **Read:** serve from Hive (UI never blocks on network).
3. **Sync:** push pending records to Firebase/API when online; update to `synced` or `failed`.
4. **Remote fetch:** merge server data into Hive, preserving local pending changes where needed.

---

## Repository Flow

### Base layer (`service/network/`)

| Type | File | Purpose |
|------|------|---------|
| `ApiClient` | `api_client.dart` | Dio instance, interceptors (logging, Sentry, cache) |
| `Apis` | `api_endpoint.dart` | Endpoint constants |
| `BaseRepository` | `base_repository.dart` | `getParsedResponseHandler<T>()` — maps raw JSON → typed model |
| `ResponseHandler<T>` | `response_handler.dart` | Sealed `OnSuccessResponse` / `OnFailureResponse` |
| `BaseRequest` / `BaseResponse` | `model/` | Generic API envelope (head + body) |

### Feature repositories

| Repository | Implementation | API method |
|------------|----------------|------------|
| `TabOneRepository` | `TabOneRepositoryImpl` | `getUserDetails({int id})` → `UserDetailResponse` |
| `CustomPaginationRepository` | `CustomPaginationRepositoryImpl` | `getListOfDetails(...)` → `List<PaginationDetailResponse>` |

### DI registration (`base/singleton.dart`)

```dart
getIt
  ..registerLazySingleton<FirebaseService>(
    () => FirebaseService(getIt<DefaultFirebaseOptions>()),
  )
  ..registerLazySingleton<HiveManager>(() => HiveManager.instance)
    ..registerLazySingleton<SyncQueueLocalDataSource>(
      SyncQueueLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<SyncQueueRepository>(
      () => SyncQueueRepositoryImpl(
        localDataSource: getIt<SyncQueueLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<SyncRemoteDataSource>(
      NoOpSyncRemoteDataSource.new,
    )
    ..registerLazySingleton<SyncHandlerRegistry>(
      () => createDefaultSyncHandlerRegistry(hiveManager: getIt<HiveManager>()),
    )
    ..registerLazySingleton<SyncEngine>(
      () => SyncEngine(
        queueRepository: getIt<SyncQueueRepository>(),
        remoteDataSource: getIt<SyncRemoteDataSource>(),
        handlerRegistry: getIt<SyncHandlerRegistry>(),
        hiveManager: getIt<HiveManager>(),
      ),
    )
    ..registerLazySingleton<SyncCoordinator>(
      () => SyncCoordinator(
        queueRepository: getIt<SyncQueueRepository>(),
        syncEngine: getIt<SyncEngine>(),
      ),
    )
    ..registerLazySingleton<SyncService>(
      () => SyncService(
        hiveManager: getIt<HiveManager>(),
        syncEngine: getIt<SyncEngine>(),
      ),
    )
  ..registerSingleton<ApiClient>(ApiClient())
  ..registerLazySingleton<TabOneRepository>(TabOneRepositoryImpl.new)
  ..registerLazySingleton<CustomPaginationRepository>(
    CustomPaginationRepositoryImpl.new,
  );
```

### Request flow (offline-first ERP modules)

1. **UI** dispatches a BLoC event.
2. **BLoC** calls repository via `getIt<Repository>()`.
3. **Repository** reads/writes Hive first and returns local data.
4. **Repository** enqueues sync or calls `SyncService` (`pending` → `synced` / `failed`).
5. **BLoC** emits state from Hive; UI rebuilds via `BlocBuilder`.

### Request flow (legacy scaffold — Dio/API)

1. **UI** dispatches a BLoC event (e.g. load user details).
2. **BLoC** sets `BaseStateStatus.loading`, calls repository via `getIt<Repository>()`.
3. **Repository impl** calls `ApiClient` with endpoint from `Apis`.
4. **BaseRepository** parses `ResponseHandler<Map>` → `ResponseHandler<T>`.
5. **BLoC** emits success/failure state; UI rebuilds via `BlocBuilder`.

---

## Firebase Usage

| Service | Entry | Purpose |
|---------|-------|---------|
| **Firebase Core** | `FirebaseService.init()` | Single bootstrap for all Firebase SDKs |
| **Cloud Firestore** | `FirebaseService.firestore` | Cloud store for all ERP module data |
| **Firebase Auth** | `FirebaseService.auth` | Mobile + web admin authentication |
| **Firebase Storage** | `FirebaseService.storage` | Attachments and file uploads |
| **Remote Config** | `ForceUpdateUnderMaintenanceBloc` | Force-update & maintenance flags |
| **FCM** | `NotificationManager` | Push notifications |

### Config & service files

| File | Role |
|------|------|
| `service/firebase/firebase_options.dart` | Platform-specific Firebase options |
| `service/firebase/firebase_service.dart` | Init, Firestore/Auth/Storage accessors |
| `service/firebase/firestore_collections.dart` | Collection name constants per ERP module |

### Boot order (`AppInitializer`)

```
SentryService.init
  → DeviceInfo / PackageInfo
  → DebugLog
  → FirebaseService.init + configureFirestore
  → HiveManager.init
  → SyncService.startListening
  → NotificationManager (FCM)
  → GetStorage.init
```

### Firestore data model convention

- One top-level collection per ERP module (see `FirestoreCollections`).
- Every document includes `factoryId` for multi-factory support.
- Every syncable document includes `syncStatus`: `pending` | `synced` | `failed`.
- Mobile writes to Hive first; `SyncService` pushes pending records to Firestore when online.
- Web admin reads/writes Firestore directly with real-time listeners.

---

## Offline-First & Local Persistence

Factory ERP Lite uses **two complementary storage layers**. Do not mix their responsibilities.

| Layer | Package | Status | Use for |
|-------|---------|--------|---------|
| **Hive** | `hive` / `hive_flutter` | **Implemented** | Business entities, sync queue, per-module boxes |
| **GetStorage** | `get_storage` | Implemented | App prefs: auth flags, locale, user id, lightweight settings |

### Offline-first rules

1. **Save to Hive first** — all create/update/delete operations persist locally before any network call.
2. **Sync to Firebase later** — background or connectivity-triggered sync pushes pending records to Firebase/API.
3. **Maintain sync states** on every syncable record:

| State | Meaning |
|-------|---------|
| `pending` | Saved locally; not yet confirmed on server |
| `synced` | Local and remote are in agreement |
| `failed` | Sync attempted but failed; retry eligible |

### Hive (business data — implemented foundation)

| Component | Location | Role |
|-----------|----------|------|
| `HiveManager` | `service/hive/hive_manager.dart` | `Hive.initFlutter()`, opens all module boxes |
| `HiveBoxNames` | `service/hive/hive_box_names.dart` | Box name constants (1:1 with ERP modules) |
| `SyncStatus` | `core/enums/sync_status.dart` | `pending` / `synced` / `failed` |
| `SyncMetadataKeys` | `core/domain/sync_metadata_keys.dart` | Shared field keys for Hive maps & Firestore docs |
| `SyncQueueItem` | `core/sync/sync_queue_item.dart` | Queue entry persisted in Hive `sync_queue` box |
| `SyncEngine` | `service/sync/sync_engine.dart` | Processes queue, updates entity sync status |
| `SyncCoordinator` | `service/sync/sync_coordinator.dart` | Repositories enqueue mutations after Hive write |
| `SyncService` | `service/sync/sync_service.dart` | Connectivity listener; triggers `SyncEngine` |
| `SyncModuleHandler` | `service/sync/handlers/` | Per-module Hive payload + status updates |
| `SyncRemoteDataSource` | `service/sync/remote/` | Firestore push contract (Firebase phase) |

| Concern | Convention |
|---------|------------|
| Location | `lib/service/hive/` — init, box names, type adapters |
| Models | Freezed local models in `modules/<feature>/model/local/` with `syncStatus` field |
| Access | Feature repositories read/write Hive; BLoCs never access boxes directly |
| Init | `AppInitializer` → `HiveManager.init()` after Firebase |
| DI | `HiveManager`, `SyncService`, `FirebaseService` in `base/singleton.dart` |
| Boxes | `sync_queue`, `meta`, plus one box per ERP module (opened at bootstrap) |

```
┌──────────┐   write (pending)   ┌──────────┐   enqueue    ┌────────────┐
│   Bloc   │ ─────────────────► │   Hive   │ ───────────► │ sync_queue │
└──────────┘ ◄───────────────── └──────────┘              └─────┬──────┘
     read (local)                     ▲                            │
                                      │                     SyncEngine
                                      │ update status              │
                                      │ pending/synced/failed      ▼
                                      └─────────────────── Firestore (phase 10)
```

### Offline-first sync flow

1. **Save → Hive first** — repository persists locally with `syncStatus = pending`.
2. **Queue sync** — repository calls `SyncCoordinator.onLocalMutation(...)`.
3. **Process queue** — `SyncEngine` loads payload via `SyncModuleHandler`, pushes via `SyncRemoteDataSource`.
4. **Update sync status** — on success → `synced` + dequeue; on failure → `failed` + retry metadata.
5. **Retry failed sync** — `SyncService` retries when connectivity returns; max attempts → dead-letter queue item.

Repository integration (no UI changes):

```dart
await _localDataSource.addPerson(person);
await _syncCoordinator.onLocalMutation(
  module: SyncModuleType.personManagement,
  recordId: person.id,
  operation: SyncOperation.create,
);
```

### GetStorage (app preferences — current)

| Component | Location | Role |
|-----------|----------|------|
| `GetStorage` | `app/core/config/config.dart` | Exported package |
| `SharedPref` | `app/core/config/shared_preference.dart` | Typed get/set wrapper |
| Init | `AppInitializer._initStorage()` | `await GetStorage.init()` |

#### Known storage keys (`SharedPref`)

| Key | Constant |
|-----|----------|
| Login flag | `isLoggedInKey` |
| User ID | `userIdKey` |
| Locale | `currentLocaleKey` |

`SharedPref` is registered in GetIt as a lazy singleton and used by navigation guards (auth) and localization.

**Do not** store syncable business entities in `SharedPref`. Use Hive for entity data; reserve `SharedPref` for small, non-synced app state.

---

## Routing

Factory ERP Lite uses **two routing packages** during the foundation phase:

| Package | Status | Role |
|---------|--------|------|
| **`go_router`** | Foundation / target | New routes, redirects, deep links, auth guards |
| **`auto_route`** | Current scaffold | Existing `AppRouter`, `@RoutePage`, generated `app_routes.gr.dart` |

**Do not remove `auto_route` until navigation is migrated.** New feature work should prefer `go_router`; existing screens continue to use `auto_route` until ported.

### Current implementation (`auto_route` v9)

**Router:** `AppRouter extends RootStackRouter` (`service/navigation/app_routes.dart`)  
**Generated routes:** `service/navigation/app_routes.gr.dart` (via `auto_route_generator`)

### Route map

| Path constant (`AppPaths`) | Route | Notes |
|----------------------------|-------|-------|
| `/splash` | `SplashRoute` | **Initial** route; `MaintenanceMiddleware` guard |
| `/login` | `LoginRoute` | `AuthenticationMiddleWare` guard; fade transition |
| `/dashboard` | `DashboardRoute` | Tab shell (`AutoTabsRouter`) |
| `nested_tab_view` → `` | `TabOne` / `TabOneRoute` | Nested under dashboard |
| `tab_one_detail` | `TabOneDetailRoute` | Custom transition |
| `tab_two` | `TabTwoRoute` | Dashboard tab |
| `/tab_two_detail` | `TabTwoDetailRoute` | Top-level sibling route |
| `custom_pagination` | `CustomPaginationRoute` | Dashboard tab |
| `/maintenance` | `ForceUpdateUnderMaintenanceRoute` | Fullscreen dialog, no transition |
| `*` | `RouteNotFound` | Catch-all 404 |

### Navigation guards (`service/navigation/middleware/`)

| Guard | Behavior |
|-------|----------|
| `MaintenanceMiddleware` | Redirects to maintenance route when under maintenance |
| `AuthenticationMiddleWare` | Redirects authenticated users to dashboard |

### App integration

- `AppRouter` registered in GetIt (`singleton.dart`)
- `MaterialApp.router(routerConfig: getIt<AppRouter>().config(...))` in `main.dart`
- `CustomNavigationObserver` for route lifecycle logging
- Pages annotated with `@RoutePage()`; nested shell uses `@RoutePage(name: 'TabOne')`

### Dashboard tab structure

```
DashboardRoute (/dashboard)
├── TabOne (nested_tab_view)
│   ├── TabOneRoute
│   └── TabOneDetailRoute
├── TabTwoRoute (tab_two)
└── CustomPaginationRoute (custom_pagination)
```

### Target implementation (`go_router`)

- Register `GoRouter` in GetIt (`base/singleton.dart`) when migration begins.
- Use `MaterialApp.router(routerConfig: goRouter)` in `main.dart` after migration.
- Map existing `AppPaths` constants to `GoRoute` paths and `redirect` logic (replaces auto_route guards).

---

## Cross-cutting services (summary)

| Service | Entry point |
|---------|-------------|
| **DI** | `base/singleton.dart` — `configureDependencies()` |
| **Firebase** | `service/firebase/firebase_service.dart` |
| **Local DB** | `service/hive/hive_manager.dart` |
| **Sync** | `service/sync/sync_service.dart` |
| **App prefs** | `SharedPref` — `get_storage` wrapper |
| **Networking** | `service/network/network.dart` |
| **Notifications** | `NotificationManager` → FCM + `AwesomeNotificationManager` |
| **Sentry** | `SentryService` — transactions, breadcrumbs, user scope |
| **Permissions** | `PermissionManager` |
| **Assets** | `lib/gen/assets.gen.dart` (flutter_gen) |

---

## Code generation

Run after model/route changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

| Generator | Output |
|-----------|--------|
| `auto_route_generator` | `app_routes.gr.dart` |
| `json_serializable` | `*.g.dart` |
| `freezed` | `*.freezed.dart` |
| `flutter_gen_runner` | `lib/gen/assets.gen.dart`, `fonts.gen.dart` |

> **Hive adapters:** Use `hive_ce` + `hive_ce_generator` when adding `@HiveType` models. The legacy `hive_generator` conflicts with modern `build_runner` on Dart 3.11+.

---

## Foundation status

| Area | Status | Key files |
|------|--------|-----------|
| Dependencies | Done | `pubspec.yaml` |
| Folder structure | Done | `lib/modules/*`, `lib/service/hive`, `lib/service/firebase`, `lib/service/sync`, `lib/core` |
| Firebase setup | Done | `FirebaseService`, `FirestoreCollections`, `firebase_options.dart` |
| Hive setup | Done | `HiveManager`, `HiveBoxNames`, `SyncStatus`, `SyncMetadataKeys` |
| Sync orchestration | Implemented | `SyncEngine`, `SyncCoordinator`, `SyncQueueRepository`, module handlers |
| Firebase remote sync | Pending | `NoOpSyncRemoteDataSource` — replace in Firebase datasource phase |
| ERP module implementation | Pending | 12 module folders with placeholder barrels |
| Auth flow (Splash → Google Login → Dashboard) | Done | `AuthRepository`, `AuthGuard`, updated BLoCs |
| GoRouter migration | Pending | `auto_route` still powers current UI |
| Google Sheet / PDF / Excel | Planned | Not yet in dependencies |
