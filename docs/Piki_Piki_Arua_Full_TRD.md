# 📜 Pikipiki Arua: Full Technical Requirements Document (TRD)

## 1. Document Overview
- **Project Name**: Pikipiki Arua
- **Version**: 1.0.0
- **Target Geography**: Arua City, West Nile, Uganda
- **Core Product**: Boda Boda On-Demand Mobility, Stage Logistics & Digital Fare Collection

---

## 2. System Objectives & Architecture Requirements
- **Sub-3s Dispatch Latency**: Direct WebSocket push via Supabase Realtime to drivers within 2.5km.
- **Offline Fault-Tolerance**: Zero trip state loss during momentary cellular dropouts in outskirts (e.g. Pajulu, Muni, Ayivu).
- **Dual Payment Protocol**: Native cash reconciliation and mobile money escrow.
- **Strict Data Security**: PostgreSQL Row-Level Security (RLS) ensuring drivers only access their trips and riders only access their ride details.

---

## 3. Flutter Client Specifications

### Rider App (`apps/rider_app`)
- **State Architecture**: `flutter_riverpod` (NotifierProvider pattern)
- **Routing**: `go_router`
- **Key Modules**:
  - `features/auth`: SMS phone number login with OTP
  - `features/trip`: Realtime map, stage selection, price calculation (UGX), driver tracking
  - `features/payments`: Cash and MTN MoMo / Airtel Money selector
  - `features/profile`: Profile, ride receipts, emergency contacts

### Driver App (`apps/driver_app`)
- **Key Modules**:
  - `features/auth`: Driver onboarding, Stage ID association
  - `features/trip`: Radar screen, accept/reject countdown timer, stage queue status, turn-by-turn navigation, start/complete trip buttons
  - `features/earnings`: Daily/weekly earnings in UGX, wallet withdraw trigger
  - `features/profile`: Verification status badge, motorcycle details

---

## 4. Backend & Database Specifications
- **Database Engine**: PostgreSQL 15 with PostGIS spatial extension.
- **Authentication**: Supabase Auth (Phone OTP & JWT).
- **Storage**: Supabase Storage for driver licenses, motorcycle photos, and profile avatars.
- **Edge Runtime**: Deno TypeScript functions for dispatch webhooks and USSD fallback handling.

---

## 5. Non-Functional Requirements
- **Performance**: Mobile app startup time < 2.0 seconds on low-end Android devices (e.g., 2GB RAM).
- **Payload Footprint**: APK size < 25MB.
- **Security**: All API traffic encrypted over TLS 1.3. Driver National IDs hashed at rest.
