# Pikipiki Arua: Driver Application

Boda Boda driver application for ride radar dispatching, stage queue management, turn-by-turn navigation, and digital earnings collection in Arua City and West Nile, Uganda.

## Proprietary Notice

This software is the proprietary intellectual property of the organization. While this repository is publicly accessible for specific reasons, it is NOT open source software. All rights are reserved. Unauthorized reproduction, modification, distribution, or commercial deployment is strictly prohibited.

---

## Technical Stack

- Framework: Flutter (Android, iOS, Web, Windows)
- State Management: Flutter Riverpod 2.x
- Routing: GoRouter
- Backend: Supabase (PostgreSQL, PostGIS, Realtime)
- Interface: High-contrast outdoor mode optimized for sunlight visibility on motorcycle phone mounts

---

## Directory Structure

```
driver_app/
|-- lib/
|   |-- main.dart
|   |-- app/
|   |   |-- providers.dart
|   |   |-- router.dart
|   |   `-- theme.dart
|   |-- core/
|   |   |-- network/          # Supabase client wrapper
|   |   |-- storage/          # Driver session storage
|   |   |-- sync/             # Telemetry queue for dead zones
|   |   `-- utils/            # Distance and UGX fare calculations
|   |-- features/
|   |   |-- auth/             # Driver authentication and stage link
|   |   |-- trip/             # Radar dispatch, accept/reject, lifecycle
|   |   |-- earnings/         # Daily and weekly earnings in UGX
|   |   `-- profile/          # Stage verification and vehicle info
|   `-- l10n/                 # Localization strings
`-- test/
```

---

## Running Locally

```bash
# Fetch packages
flutter pub get

# Run static code analysis
flutter analyze

# Run unit and widget tests
flutter test

# Start application
flutter run
```
