# 🏁 Quickstart Guide: Pikipiki Arua Developer Setup

Welcome to the **Pikipiki Arua** monorepo. This guide walks you through bootstrapping both mobile applications and the Supabase backend.

---

## 1. Environment Setup

Copy `.env.example` to `.env` in the root repository:
```bash
cp .env.example .env
```

---

## 2. Running Rider Application (`apps/rider_app`)

The Rider App serves passengers booking rides across Arua City.

```bash
cd apps/rider_app
flutter pub get
flutter run
```

To run on a specific device (e.g. Chrome, Windows Desktop, or Android emulator):
```bash
flutter run -d chrome
# or
flutter run -d windows
```

---

## 3. Running Driver Application (`apps/driver_app`)

The Driver App gives Boda Boda operators incoming ride radar, stage queue status, turn-by-turn navigation, and daily UGX earnings.

```bash
cd apps/driver_app
flutter pub get
flutter run
```

---

## 4. Local Backend (Supabase)

To run the local database and Edge Functions:
```bash
# Start local Supabase containers (Docker required)
supabase start

# Run database migrations & seed data
supabase db reset
```
Local Studio dashboard will be accessible at [http://localhost:54323](http://localhost:54323).
