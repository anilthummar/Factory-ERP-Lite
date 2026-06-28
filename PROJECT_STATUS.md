# Factory ERP Lite — Project Status

**Last updated:** June 2026  
**Firebase project:** `factory-erp-lite`  
**Verdict:** **MVP complete — not production-shipped yet**

The core product works offline on mobile and syncs with a web admin panel. Remaining work is mostly deploy, polish, and future-scope features.

---

## Executive summary

| Question | Answer |
|----------|--------|
| Can we use it for daily factory data? | **Yes** — persons, labor, expenses, recurring, factory status, attachments |
| Does mobile ↔ web sync work? | **Yes** — push on save, pull on refresh (mobile + web shell) |
| Is everything in ARCHITECTURE.md built? | **No** — reports UI, multi-factory, inventory, etc. are future |
| Ready for production without more steps? | **No** — deploy rules + hosting + real-device QA first |

---

## What is done

### Mobile app

| Feature | Status |
|---------|--------|
| Login (Firebase Auth) | ✅ |
| Dashboard (metrics, factory status, recent activity) | ✅ |
| Persons — CRUD, search, delete, pull-to-refresh + Firestore pull | ✅ |
| Labor — CRUD, search, delete, pull-to-refresh + Firestore pull | ✅ |
| Expenses (material, truck, maintenance, electricity, misc) | ✅ |
| Recurring expenses — CRUD, delete, pull-to-refresh | ✅ |
| Factory status — view, change, history | ✅ |
| Calendar (aggregated events) | ✅ |
| Attachments — pick, upload, sync | ✅ |
| Records Explorer — global search, filters, export PDF/Excel | ✅ |
| Sync diagnostics (Firebase health, queue, retry) | ✅ |
| Backup / restore (local JSON) | ✅ |
| PDF / Excel export (person, labor, expense, monthly reports) | ✅ |
| Offline-first (Hive → sync queue → Firestore) | ✅ |
| Localization (English + Hindi) | ✅ |

### Web admin (`lib/main_web.dart`)

| Feature | Status |
|---------|--------|
| Firebase Auth login | ✅ |
| Dashboard (metrics, factory status, charts) | ✅ |
| Persons / Labor / Expenses — list, search, add, edit, bulk delete | ✅ |
| Factory Status — view, change, history | ✅ |
| Attachments — list, upload, open, delete | ✅ |
| Settings + Sync diagnostics | ✅ |
| Reports / export center (tabs) | ✅ |
| Shell pull on init + top-bar refresh | ✅ |
| Localization | ✅ |

### Firebase & sync

| Item | Status |
|------|--------|
| Firestore collections aligned with mobile | ✅ |
| Sync push engine (Hive → Firestore) | ✅ |
| Sync pull engine (Firestore → Hive) | ✅ |
| `firestore.rules` + `storage.rules` in repo | ✅ Written |
| Rules deployed to Firebase Console | ⬜ **Not verified** |
| Firebase Hosting deployed | ⬜ **Not done** |
| `firebase.json` + `.firebaserc` configured | ✅ |

### Config files

| File | Purpose |
|------|---------|
| `stage_env.json` | Stage/dev Firebase + API keys |
| `prod_env.json` | Production Firebase keys |
| `web/firebase-messaging-sw.js` | Web FCM service worker |

---

## What is left (priority order)

### P0 — Ship to production

1. **Install Firebase CLI** and log in  
2. **Deploy Firestore + Storage rules**  
3. **Build web admin** and **deploy Hosting**  
4. **Firebase Console:** enable Auth providers, add hosting domains to authorized domains  
5. **End-to-end test:** Android add → web refresh → web edit → Android pull-to-refresh  
6. **Production mobile build** (signed APK/AAB or iOS) with `prod_env.json`

### P1 — Polish before wider rollout

| Item | Notes |
|------|--------|
| Mobile report screens show `—` placeholders | Wire live data like PDF export already does |
| Records Explorer View/Edit | Opens module list; could open specific record form |
| Records Explorer custom date range | Preset exists; date pickers not wired |
| Login Terms / Privacy links | Not wired |
| `vapidKey` in env | Empty — web push notifications |
| `sentryDSN` in env | Empty — crash reporting |
| Web admin Records Explorer | Mobile only today |
| Expense delete UI on mobile | Labor/recurring done; verify all expense modules |

### P2 — Future (ARCHITECTURE.md scope)

| Item | Notes |
|------|--------|
| Multi-factory (`factoryId` on documents) | Schema hooks exist |
| Multi-user roles in security rules | Currently: any signed-in user |
| Inventory management | New module |
| Production management | New module |
| Google Sheet backup | Planned |
| `go_router` migration | auto_route still in use |
| Real-time Firestore listeners on web | Pull-on-refresh today |

---

## Run commands

### Mobile (stage)

```bash
flutter run --flavor stage --dart-define-from-file=stage_env.json
```

### Web admin (local)

```bash
flutter run -d chrome -t lib/main_web.dart --dart-define-from-file=stage_env.json
```

### Analyze

```bash
flutter analyze
```

### Regenerate routes (after new `@RoutePage`)

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Deploy walkthrough

### Prerequisites

- Node.js + npm (you have these)
- Firebase CLI: `npm install -g firebase-tools`
- Logged into Google account with access to project `factory-erp-lite`

### Step 1 — Install Firebase CLI

```bash
npm install -g firebase-tools
firebase --version
```

### Step 2 — Login and select project

```bash
cd /Users/anil.thummar/Documents/FactoryERPLite
firebase login
firebase use factory-erp-lite
```

### Step 3 — Deploy security rules

```bash
firebase deploy --only firestore:rules,storage
```

**Verify in Firebase Console:**

- Firestore → Rules → published
- Storage → Rules → published

### Step 4 — Build web admin

**Stage:**

```bash
flutter build web \
  -t lib/main_web.dart \
  --dart-define-from-file=stage_env.json \
  --release
```

**Production:**

```bash
flutter build web \
  -t lib/main_web.dart \
  --dart-define-from-file=prod_env.json \
  --release
```

Output: `build/web/`

### Step 5 — Deploy Hosting

```bash
firebase deploy --only hosting
```

**URLs (after deploy):**

- https://factory-erp-lite.web.app
- https://factory-erp-lite.firebaseapp.com

### Step 6 — Firebase Console checklist

1. **Authentication → Sign-in method** — Email/Password and/or Google enabled  
2. **Authentication → Settings → Authorized domains** — add `factory-erp-lite.web.app` and `factory-erp-lite.firebaseapp.com`  
3. **Firestore** — data visible from mobile sync  
4. **Storage** — attachment uploads work from web + mobile  

### Step 7 — Smoke test

| Step | Action |
|------|--------|
| 1 | Open hosting URL, sign in |
| 2 | Dashboard loads metrics |
| 3 | Add person on Android |
| 4 | Refresh web → person appears |
| 5 | Edit on web |
| 6 | Pull-to-refresh on Android → change appears |
| 7 | Settings → Sync diagnostics → Firestore/Storage **OK** |

### One-shot deploy (rules + hosting)

```bash
firebase deploy --only firestore:rules,storage,hosting
```

---

## Module map (quick reference)

| Module | Mobile | Web admin | Sync pull (mobile) |
|--------|--------|-----------|-------------------|
| Persons | ✅ | ✅ | ✅ |
| Labor | ✅ | ✅ | ✅ |
| Expenses (5 types) | ✅ | ✅ | ✅ |
| Recurring | ✅ | ✅ | ✅ |
| Factory status | ✅ | ✅ | ✅ (shell refresh) |
| Attachments | ✅ | ✅ | ✅ |
| Calendar | ✅ | — | — |
| Records Explorer | ✅ | — | ✅ |
| Reports (live UI) | ⬜ placeholders | Partial | — |
| Dashboard | ✅ | ✅ | ✅ |

---

## Definition of “done”

Treat the project as **production-complete** when:

- [ ] Rules deployed and tested (no permission denied in diagnostics)
- [ ] Hosting live with prod env
- [ ] Two-way sync verified on real Android + web
- [ ] Signed mobile build tested against prod Firebase
- [ ] P1 polish items triaged (accept or fix)

Until then: **MVP complete, production deploy pending.**
