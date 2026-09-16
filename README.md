# 🏍️ Pikipiki Arua Platform

> **Localized Boda Boda Ride-Hailing, Courier & Stage Logistics Platform for Arua City & West Nile, Uganda.**

[![Flutter CI](https://github.com/0Elfaki/pikipiki-arua/actions/workflows/ci.yml/badge.svg)](https://github.com/0Elfaki/pikipiki-arua/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-amber.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Flutter%20%7C%20Supabase-blue.svg)](https://flutter.dev)

---

## 📌 Architecture Overview

Pikipiki Arua is engineered to tackle real-world mobility challenges in emerging East African secondary cities: spotty network connectivity (2G/3G in rural fringes), stage-based driver unions, and mixed payment models (Cash & Mobile Money).

```
pikipiki-arua/
├── apps/
│   ├── rider_app/       # Flutter application for passengers (iOS/Android/Web/Windows)
│   └── driver_app/      # Flutter application for Boda drivers (radar dispatch, earnings)
├── backend/
│   └── supabase/        # PostGIS schema, RLS policies, seed stages, Deno Edge Functions
├── docs/                # Comprehensive TRD, Architecture, and Stage Operations runbooks
├── .github/workflows/   # CI/CD test and deployment pipelines
└── .env.example         # Central environment variable template
```

---

## 🚀 Quickstart

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.16+ recommended)
- [Supabase CLI](https://supabase.com/docs/guides/cli)
- Git & PowerShell / Bash

### 1. Clone & Environment Setup
```bash
# Copy local environment settings
cp .env.example .env
```

### 2. Launch Rider Application
```bash
cd apps/rider_app
flutter pub get
flutter run
```

### 3. Launch Driver Application
```bash
cd apps/driver_app
flutter pub get
flutter run
```

---

## 🌟 Key Features

| Domain | Feature | Description |
|---|---|---|
| **Ride Dispatch** | Boda Stage Clustering | Dispatches to registered stages (Arua Hill, Taxi Park, Muni, Onduparaka) |
| **Connectivity** | Offline Sync & Cache | Optimistic trip booking & queued telemetry for network dead zones |
| **Fintech** | Dual Payments | Cash settlement alongside MTN MoMo & Airtel Money Uganda (UGX) |
| **Safety** | SOS & Stage Verification | Stage Chairman verification, plate validation, and one-tap emergency SOS |

---

## 📚 Documentation

Detailed specifications and architectural guides are available in the [`docs/`](docs/) directory:
- [00. Start Here / Quickstart](docs/00_START_HERE/QUICKSTART.md)
- [01. Product Requirements Document (PRD)](docs/01_Product_And_Requirements/PRD.md)
- [02. System Technical Architecture](docs/02_Technical_Design/SYSTEM_DESIGN.md)
- [03. Offline Resilience Strategy](docs/02_Technical_Design/OFFLINE_SYNC_STRATEGY.md)
- [Full Technical Requirements Document (TRD)](docs/Piki_Piki_Arua_Full_TRD.md)

---

## 📄 License
This project is open source and licensed under the [MIT License](LICENSE).
