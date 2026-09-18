# Pikipiki Arua: Rider Application

Passenger-facing Flutter mobile application for booking Boda Boda rides, tracking drivers in real-time, and settling fares in Arua City and West Nile, Uganda.

## Proprietary Notice

This software is the proprietary intellectual property of the organization. While this repository is publicly accessible for specific reasons, it is NOT open source software. All rights are reserved. Unauthorized reproduction, modification, distribution, or commercial deployment is strictly prohibited.

---

## Technical Stack

- Framework: Flutter (Android, iOS, Web, Windows)
- State Management: Flutter Riverpod 2.x
- Routing: GoRouter
- Backend: Supabase (PostgreSQL, Realtime WebSockets, PostGIS)
- Local Storage: Flutter Secure Storage

---

## Directory Structure

```
rider_app/
|-- lib/
|   |-- main.dart
|   |-- app/
|   |   |-- providers.dart
|   |   |-- router.dart
|   |   `-- theme.dart
|   |-- core/
|   |   |-- network/          # Supabase client wrapper
|   |   |-- storage/          # Secure storage service
|   |   |-- sync/             # Offline sync queue and idempotency
|   |   `-- utils/            # UGX currency and distance utils
|   |-- features/
|   |   |-- auth/             # Phone number OTP login
|   |   |-- trip/             # Interactive map, stage selector, booking
|   |   |-- payments/         # Cash and MTN / Airtel MoMo selector
|   |   `-- profile/          # User profile and safety contacts
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
