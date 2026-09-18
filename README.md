# Pikipiki Arua Platform

> Localized Boda Boda Ride-Hailing, Courier and Stage Logistics Platform for Arua City and West Nile, Uganda.

[![Flutter CI](https://github.com/0Elfaki/pikipiki-arua/actions/workflows/ci.yml/badge.svg)](https://github.com/0Elfaki/pikipiki-arua/actions/workflows/ci.yml)
[![License: Proprietary](https://img.shields.io/badge/License-Proprietary-red.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Flutter%20%7C%20Supabase-blue.svg)](https://flutter.dev)

---

## Intellectual Property and License Notice

This repository contains proprietary software and trade secrets belonging exclusively to the organization. 

Although this repository is publicly viewable for specific administrative, demonstration, and evaluation purposes, it is NOT open source software. All rights are strictly reserved by the organization. No part of this codebase, architecture, documentation, or assets may be reproduced, distributed, modified, sublicensed, or used for commercial purposes without prior written authorization from the organization.

For details, refer to the [LICENSE](LICENSE) file.

---

## Architecture Overview

Pikipiki Arua is engineered to tackle real-world urban mobility challenges in emerging secondary cities across East Africa. Key design requirements include low-bandwidth resilience (supporting intermittent 2G and 3G connections), integration with traditional stage-based driver unions, and dual payment support (Cash and Mobile Money).

```
pikipiki-arua/
|-- apps/
|   |-- rider_app/       # Flutter application for passengers (Android, iOS, Web, Windows)
|   `-- driver_app/      # Flutter application for Boda drivers (radar dispatch, earnings)
|-- backend/
|   `-- supabase/        # PostGIS schema, RLS policies, seed stages, Deno Edge Functions
|-- docs/                # Full TRD, Technical Architecture, and Stage Operations guides
|-- .github/workflows/   # CI/CD test and deployment pipelines
`-- .env.example         # Central environment variable template
```

---

## Quickstart

### Prerequisites
- Flutter SDK (v3.16 or higher)
- Supabase CLI
- Git and PowerShell or Bash

### 1. Environment Configuration
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

## Key Features

| Domain | Feature | Description |
|---|---|---|
| Ride Dispatch | Boda Stage Clustering | Dispatches to registered stages (Arua Hill, Taxi Park, Muni, Onduparaka) |
| Connectivity | Offline Sync and Cache | Optimistic trip booking and queued telemetry for network dead zones |
| Fintech | Dual Payments | Cash settlement alongside MTN MoMo and Airtel Money Uganda (UGX) |
| Safety | SOS and Stage Verification | Stage Chairman verification, plate validation, and emergency SOS |

---

## Documentation

Comprehensive specifications and operational runbooks are located in the [docs/](docs/) directory:
- [00. Start Here / Quickstart](docs/00_START_HERE/QUICKSTART.md)
- [01. Product Requirements Document (PRD)](docs/01_Product_And_Requirements/PRD.md)
- [02. System Technical Architecture](docs/02_Technical_Design/SYSTEM_DESIGN.md)
- [03. Offline Resilience Strategy](docs/02_Technical_Design/OFFLINE_SYNC_STRATEGY.md)
- [Full Technical Requirements Document (TRD)](docs/Piki_Piki_Arua_Full_TRD.md)

---

## License

Proprietary. All Rights Reserved. See [LICENSE](LICENSE) for terms.
