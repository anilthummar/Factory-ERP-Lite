# Factory ERP Lite — Architecture

Offline-first Flutter ERP scaffold organized by **feature modules**, **shared services**, and a central **`utils/exports.dart` barrel** that wires the app together.

> **Local persistence:** Business data follows an **offline-first** model — **save to Hive first**, **sync to Firebase later**. Lightweight app preferences (auth flags, locale, user id) use **`get_storage`** via `SharedPref`. See [Offline-First & Local Persistence](#offline-first--local-persistence).

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
│   ├── gen/                    # Generated assets/fonts (flutter_gen)
│   ├── modules/                # Feature modules (see Feature List)
│   ├── service/                # Cross-cutting infrastructure
│   │   ├── hive/               # Hive boxes, adapters, init (planned)
│   │   ├── firebase/           # firebase_options.dart
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
├── model/          # local/ (Freezed + Hive/sync fields) and/or response/ (API DTOs)
├── repository/     # Abstract repo + *_impl.dart (Hive + API/Firebase sync)
├── ui/             # @RoutePage screens and widgets
└── <feature>.dart  # Barrel export
```

**Barrel import chain:** `main.dart` → `utils/exports.dart` → `modules/modules.dart` + `service/service.dart` + `base/base.dart` + `app/app.dart`

---

## Feature List

| Module | Layer | Description |
|--------|-------|-------------|
| **splash** | bloc, ui | Initial splash screen; routes onward on startup |
| **login** | bloc, model/local, ui | Email/password login form with validation |
| **dashboard** | ui | Shell with `AutoTabsRouter` + bottom navigation |
| **tab_one** | bloc, model/response, repository, ui | Tab screen with API-backed user details |
| **tab_one_detail** | ui | Detail view for tab one |
| **tab_two** | ui | Second dashboard tab |
| **tab_two_detail** | ui | Detail view for tab two |
| **custom_pagination** | bloc, model, repository, ui | Paginated list with shimmer/loader |
| **force_update_under_maintenance** | bloc, model, ui | Force-update & maintenance via Remote Config |
| **localization** | bloc | App-wide locale switching (`LocaleBloc`) |
| **page_not_found** | ui | 404 / catch-all route |

### Planned scope (from `pubspec.yaml` description)

Labor management, expense tracking, material purchases, calendar, factory status, reporting, analytics, and sync — the current codebase is a **template/scaffold** with representative features above.

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
| `hive` / `hive_flutter` | Offline-first local database (foundation added; not yet in `lib/`) |
| `get_storage` | Lightweight key-value prefs (`SharedPref`) |
| `freezed` / `freezed_annotation` | Immutable models |
| `json_annotation` | JSON serialization annotations |
| `firebase_core` | Firebase initialization |
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
     rebuild      emit state              ResponseHandler<T>              sync (pending/synced/failed)
                                                    │
                                                    ▼ HTTP / Firebase
                                              ┌───────────┐
                                              │ ApiClient │
                                              └───────────┘
```

**Target repository contract (offline-first features):**

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
  ..registerSingleton<ApiClient>(ApiClient())
  ..registerLazySingleton<TabOneRepository>(TabOneRepositoryImpl.new)
  ..registerLazySingleton<CustomPaginationRepository>(CustomPaginationRepositoryImpl.new);
```

### Request flow (API-only features — current scaffold)

1. **UI** dispatches a BLoC event (e.g. load user details).
2. **BLoC** sets `BaseStateStatus.loading`, calls repository via `getIt<Repository>()`.
3. **Repository impl** calls `ApiClient` with endpoint from `Apis`.
4. **BaseRepository** parses `ResponseHandler<Map>` → `ResponseHandler<T>`.
5. **BLoC** emits success/failure state; UI rebuilds via `BlocBuilder`.

### Request flow (offline-first features — target)

1. **UI** dispatches a BLoC event.
2. **BLoC** calls repository via `getIt<Repository>()`.
3. **Repository** reads/writes Hive first and returns local data.
4. **Repository** triggers background sync (`pending` → `synced` / `failed`).
5. **BLoC** emits state from Hive; UI rebuilds via `BlocBuilder`.

---

## Firebase Usage

| Service | Where used | Purpose |
|---------|------------|---------|
| **Firebase Core** | `NotificationManager`, `exports.dart` | `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` |
| **Firebase Remote Config** | `ForceUpdateUnderMaintenanceBloc` | Force-update version gates & maintenance mode JSON |
| **Firebase Messaging** | `NotificationManager` | FCM token, foreground/background handlers, `onMessageOpenedApp` |

### Config files

- `lib/service/firebase/firebase_options.dart` — platform-specific Firebase options (generated)
- `lib/service/firebase/firebase.dart` — barrel export

### Boot order (`AppInitializer`)

```
SentryService.init → DeviceInfo/PackageInfo → DebugLog → NotificationManager (Firebase) → GetStorage.init
```

---

## Offline-First & Local Persistence

Factory ERP Lite uses **two complementary storage layers**. Do not mix their responsibilities.

| Layer | Package | Status | Use for |
|-------|---------|--------|---------|
| **Hive** | `hive` / `hive_flutter` | Planned (not yet in `lib/`) | Business entities, offline queues, sync metadata |
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

### Hive (business data — target)

**Status:** Planned. No `hive` imports or boxes exist in `lib/` yet. New offline-first features should introduce Hive following the repository pattern.

| Concern | Convention |
|---------|------------|
| Location | `lib/service/hive/` — init, box names, type adapters |
| Models | Freezed local models in `modules/<feature>/model/local/` with `syncStatus` field |
| Access | Feature repositories read/write Hive; BLoCs never access boxes directly |
| Init | `AppInitializer` — `Hive.initFlutter()` + `openBox()` before repositories run |
| DI | Register box accessors or local data sources in `base/singleton.dart` |

```
┌──────────┐     write      ┌──────────┐    background    ┌───────────┐
│   Bloc   │ ────────────► │   Hive   │ ───────────────► │ Firebase  │
└──────────┘ ◄──────────── └──────────┘ ◄──────────────── └───────────┘
              read (local)        pending / synced / failed
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
| **Local DB** | `service/hive/` — Hive init & boxes (planned) |
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
