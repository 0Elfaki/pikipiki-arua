# App Flow

Companion to 01_PRD.md section 7 and 06_UI_UX_DESIGN.md. Screen level flows for the rider app, the driver app, the admin console, and a conceptual future super app home screen. Each flow references the actual screen files in the codebase where they already exist.

---

## 1. Rider App Flow

### 1.1 Screen map (current)
- `login_screen` (phone entry, OTP entry)
- `home_screen` (map, pickup/dropoff stage selectors, fare, payment method, request button)
- `active_trip_screen` (dispatch status, matched driver card, route, cancel)
- `profile_screen`

### 1.2 Onboarding and login

```mermaid
flowchart TD
    A[App opens] --> B{Session exists?}
    B -- yes --> H[Home screen]
    B -- no --> C[Login screen: enter phone number]
    C --> D[Request OTP]
    D --> E[Enter 4-digit OTP]
    E --> F{Valid?}
    F -- no --> E
    F -- yes --> G[Fetch/create profile]
    G --> H
```

### 1.3 Booking and dispatch (as implemented)

```mermaid
flowchart TD
    H[Home screen] --> S1[Select pickup stage]
    S1 --> S2[Select dropoff stage]
    S2 --> F[Fare auto-calculated from distance]
    F --> P[Choose payment method: cash / MTN MoMo / Airtel Money]
    P --> R[Tap Request Pikipiki Boda]
    R --> T1[Trip row created, status=requested]
    T1 --> T2[dispatch-webhook invoked]
    T2 --> AT[Active trip screen: Looking for nearest boda]
    AT --> M{Matched?}
    M -- no drivers nearby --> AT2[Status message: no drivers online nearby, keep trying]
    M -- yes --> AT3[Real matched driver card: name, plate, rating]
    AT3 --> ACC{Driver accepts?}
    ACC -- declines/times out --> AT[Automatically re-offered to next-nearest driver]
    ACC -- accepts --> LIVE[Live trip: en route, SOS visible]
    LIVE --> HELM[Helmet/ID check gate - not yet built]
    HELM --> RIDE[Trip in progress]
    RIDE --> PAY[Payment step]
    PAY --> RATE[Rate + safety checklist]
    RATE --> DONE[Trip complete, receipt available offline]
```

### 1.4 Cancellation

```mermaid
flowchart TD
    AT[Active trip screen, any dispatch state] --> C[Tap Cancel Trip Request]
    C --> U[Unsubscribe from realtime channel]
    U --> HOME[Return to home screen]
```

### 1.5 Connectivity loss mid-flow (per PRD.md section 7, not yet built)

```mermaid
flowchart TD
    REQ[Rider submits a request] --> TO{API reachable within timeout?}
    TO -- yes --> NORMAL[Continue app-path flow]
    TO -- no --> PROMPT[Show: No data connection, continue by SMS?]
    PROMPT -- confirm --> SMS[Re-issue same request as SMS payload]
    SMS --> Q[Show queued state]
    Q --> RECON[On reconnect: fetch active trip, resume correct screen]
```

## 2. Driver App Flow

### 2.1 Screen map (current)
- `driver_login_screen` (demo identity today; real phone OTP planned)
- `driver_radar_screen` (online/offline toggle, incoming offer modal)
- `active_navigation_screen` (pickup navigation, handover, trip lifecycle, payment collection)
- `earnings_screen`, `driver_profile_screen`

### 2.2 Going online and receiving a real offer (as implemented)

```mermaid
flowchart TD
    A[Driver radar screen] --> B{Compliance dashboard clear? - not yet built}
    B -- yes/skipped in current build --> C[Tap GO ONLINE]
    C --> D[driver-presence Edge Function sets is_online=true]
    D --> E[Subscribe to realtime offers for this driver_id]
    E --> F{Offer arrives? status=searching, driver_id=me}
    F -- yes --> G[Incoming ride request modal: fare, pickup, dropoff]
    G --> H{Accept or Decline?}
    H -- Decline --> I[dispatch-respond: decline]
    I --> J[Trip re-offered to next-nearest driver server-side]
    J --> F
    H -- Accept --> K[dispatch-respond: accept]
    K --> L{Still available?}
    L -- no, taken/expired --> M[Show: request no longer available]
    L -- yes --> N[Navigate to Active Navigation screen]
```

### 2.3 Trip lifecycle (post-accept)

```mermaid
flowchart TD
    N[Active navigation screen: Head to pickup] --> O[Tap ARRIVED AT PICKUP STAGE]
    O --> HC[Handover checklist: helmet given, jacket/ID visible - not yet built]
    HC --> P[Tap START TRIP]
    P --> Q[Ride in progress, one instruction at a time, SOS visible - SOS not yet built]
    Q --> R[Tap COMPLETE TRIP & COLLECT FARE]
    R --> S[Payment collection dialog: cash or MoMo confirmation]
    S --> T[Earnings updated]
    T --> U[Back to Stage Radar]
```

## 3. Admin / Control Centre Flow (planned, not yet built)

```mermaid
flowchart TD
    A[Admin login] --> B[Live map: online drivers, active trips]
    B --> C{Incoming SOS alert?}
    C -- yes --> D[Alert queue: identity, last location, one-click contact]
    D --> E[Mark resolved or false alarm]
    B --> F[Driver compliance management: renew/suspend]
    B --> G[Fare table configuration]
    B --> H[Cash vs mobile money reconciliation]
    B --> I[USSD/SMS session logs for support]
```

## 4. Emergency / SOS Flow (planned, not yet built)

```mermaid
flowchart TD
    T[SOS triggered: slide / quiet volume-key sequence / SMS reply S] --> P[Send location, trip ID, driver/plate, rider identity]
    P --> A[Police contact]
    P --> B[Control centre]
    P --> C[Saved emergency contacts]
    A & B & C --> W[Alert stays open]
    W --> R{Resolved by operator, or cancelled by triggering party?}
    R -- cancel quiet variant --> PIN[Requires PIN, so a third party cannot silence it]
    R -- resolved --> CLOSE[Alert closed]
```

## 5. Future: Super App Home Screen Concept (design reference only, not being built now)

This is included so current navigation code is not built in a way that forecloses it later, per PRD.md section 9 and TRD.md section 8.5. It is not a Phase 1 deliverable.

```mermaid
flowchart TD
    H[Super app home] --> S1[Service tile: Request a Boda - live today]
    H --> S2[Service tile: Send a Parcel - future]
    H --> S3[Service tile: Pay a Bill - future]
    S1 --> RIDEFLOW[Existing rider booking flow, section 1.3]
    S2 --> DELIVERYFLOW[Future delivery booking flow, same map/stage UI pattern, generic orders model]
    H --> WALLET[Wallet tab: one balance, one transaction history across all tiles]
    H --> PROFILE[Profile: one identity across all tiles]
```

The point of this diagram is narrow: the home screen's service list should already be data driven (see UI_UX_DESIGN.md section 6) so that adding `S2` later is adding a row to a list, not restructuring the app.

## 6. Related Documents

- 01_PRD.md section 7 for the narrative version of these flows.
- 06_UI_UX_DESIGN.md for the visual treatment of each screen referenced here.
- 02_TRD.md section 4 for the backend sequence diagram behind section 1.3/2.2 above.
