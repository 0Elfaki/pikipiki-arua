# Product Requirements Document (PRD)

**Product (working name):** Pikipiki Arua
**Vision framing:** Phase 1 is a boda boda ride hailing and light logistics platform for Arua City and West Nile, Uganda. The product, data model, and platform architecture are deliberately built so that later phases can add new service verticals (delivery, errands, bill payments, a digital wallet, a marketplace) onto the same rider base, driver/agent network, and backend, without a rewrite. This document describes both the Phase 1 product and the extension points reserved for that future.

**Status:** Master planning document, Version 1.0
**Owner:** Hope Foundation Uganda / Pikipiki Arua Platform team

> Naming note: "Pikipiki Arua" is a working name. Confirm domain and trademark availability with a registrar before final launch, and update this document once a brand name is locked in.

---

## 1. Problem Statement

In Arua City and across West Nile, boda bodas (motorcycle taxis) are the backbone of intra city transport and last mile logistics. That market runs almost entirely on unstructured, street corner negotiation: fares are haggled per ride and are frequently inflated for visitors, women, and night riders; there is no reliable way to verify who is actually driving a given motorcycle or to hold them accountable afterward; riders often travel without a helmet; and there is no built in way to call for help during a ride. Layered on top of this, smartphone and data access is inconsistent, addresses are landmark based rather than street based, and payment happens in a mix of cash and mobile money (MTN MoMo and Airtel Money).

A second, longer horizon problem: once a platform has earned daily trust from a critical mass of riders and a network of vetted drivers, that same trust and network is a natural foundation for other everyday needs in the same towns, package delivery, small errands, bill payments, and simple commerce, the same pattern that turned single purpose ride hailing apps in other markets into "super apps." Building Phase 1 without planning for that leads to a costly rebuild later. Building Phase 1 with that in mind, without over engineering before it is needed, is the goal of this document.

## 2. Goals and Objectives

| Objective | What it means concretely |
|---|---|
| Predictable pricing | A fixed, distance based fare in UGX is shown and locked before a ride is requested. Drivers cannot alter it in app. |
| Vetted, accountable drivers | Drivers are verified against national ID, motorcycle registration, and stage chairman endorsement before they can go online. Compliance can be revoked without an app redeploy. |
| Rider safety by default | A helmet and ID check gates the start of every ride. SOS is reachable at all times during a trip and reaches the control centre, a police contact, and personal emergency contacts at once. |
| Works without a smartphone or reliable data | Every core flow has a USSD/SMS equivalent, and the app itself remains usable offline for cached data. |
| Financial inclusion | Cash and mobile money (MTN MoMo, Airtel Money) are treated as equally first class payment paths. |
| Fair driver economics | Drivers see earnings, cash versus mobile money split, and commission owed at all times, even offline. |
| Extensible by design | The data model, identity system, wallet, and navigation shell are built once as generic, reusable primitives, so a second and third service vertical can be added later as new modules rather than parallel apps. |

## 3. Target Users

- **Riders**, who need safe, affordable, predictable rides without a lengthy price negotiation each time.
- **Drivers**, who want a steady stream of requests, better net daily earnings, and protection from fare disputes.
- **Stage chairmen**, who oversee the riders registered to a stage, resolve disputes, and vouch for driver credibility.
- **Operations and control centre staff**, who monitor safety incidents, manage driver compliance, and configure fares without needing an engineer.
- **Future personas (Phase 2+, informing design now, not built now):** small shop owners who could list goods for delivery, senders and receivers of parcels, and utility/airtime bill payers.

## 4. Scope

### 4.1 In scope for Phase 1 (the product being built now)

- Rider app (Android first, Flutter): phone based signup, stage or landmark based booking, upfront fare, driver matching, helmet check gate, live trip view, SOS, cash and mobile money payment, rating and safety reporting.
- Driver app (Android first, Flutter): compliance gating, go online/offline, real time dispatch, pickup navigation by landmark, handover checklist, trip lifecycle, earnings and commission view.
- Backend (Supabase: Postgres, PostGIS, Auth, Realtime, Storage, Edge Functions): fare calculation, driver matching and dispatch, trip lifecycle, payment orchestration, and the USSD/SMS gateway integration.
- Degraded channel (USSD and SMS via an aggregator such as Africa's Talking): booking, fare confirmation, driver assignment notice, SOS, and trip sharing for riders without a smartphone or without data.
- Admin and control centre web console: live map of drivers and trips, safety incident queue, driver compliance management, fare configuration, USSD/SMS session logs.

### 4.2 Explicitly out of scope for Phase 1, but reserved for Phase 2+ (super app expansion)

- Package and parcel delivery as a distinct requestable service.
- Small errands or task requests fulfilled by the same driver network.
- A general purpose digital wallet (store of value, peer to peer transfer, airtime/bill payment), beyond the pay for a trip flow.
- A lightweight marketplace for local vendors to list goods for delivery.
- Additional cities and a multi tenant/regional configuration layer.

None of the above is being engineered now. What is being done now is making sure the identity model, the order/booking model, the payment ledger, and the app's navigation shell do not have to be rebuilt to add them later. Section 9 spells out exactly what that means in practice.

### 4.3 Out of scope indefinitely (not part of the super app vision either)

- Car hailing or any four wheeled vehicle category.
- Long distance freight or inter city logistics.
- Anything requiring a banking license (Pikipiki Arua integrates with licensed mobile money providers rather than becoming one).

## 5. Product Principles

1. **Single source of truth for fare and dispatch logic.** The app and the USSD/SMS channel call the same backend services. Never duplicated per channel.
2. **No single point of failure for SOS.** Safety alerts do not depend on the full dispatch pipeline being healthy.
3. **Design for intermittent connectivity, not just absent connectivity.** Short timeouts, exponential backoff, idempotent retries.
4. **Landmark first, not street address first.** Matches how people in Arua actually describe places.
5. **Data cost is a UX cost.** No live raster map tiles by default. Aggressive caching.
6. **Aggregator risk is abstracted from day one.** Both the USSD/SMS gateway and the mobile money integrations sit behind an internal interface so a second provider can be added without touching business logic.
7. **Model the business, not the screen.** A "trip" in the database is one instance of a generic, extensible "order" concept, not a bespoke table that only ever makes sense for rides. See section 9.
8. **One identity, one wallet, many services.** A person should never have to create a second account or hold a second balance to use a second service the platform later offers.

## 6. Functional Requirements (Phase 1)

### 6.1 Rider app
- Phone number registration with SMS OTP (4 digit code), resend, and voice readout fallback.
- Language selection (Lugbara, English, Kiswahili), persisted per device.
- Landmark based destination search with category filters and a pin drop fallback.
- A deterministic fare quote computed server side (fixed base plus per kilometre rate), shown before matching begins and itemised on request.
- Driver matching against nearby online, compliant drivers within a configurable radius, with automatic degrade to the SMS relay path if data drops mid search.
- Driver profile display after a match: name, photo, jacket ID, plate, rating, certification badges.
- A mandatory helmet and ID confirmation step before the trip can start, plus a "report a problem" path that makes the ride free and opens a safety report.
- A live trip view with ETA, live route, and trip sharing to designated contacts.
- An SOS control reachable from the trip screen at all times.
- Payment supporting cash and mobile money (MTN MoMo, Airtel Money) via USSD push, confirmed server side.
- Post trip rating plus a structured safety incident checklist.
- Offline accessible trip history and SMS deliverable receipts.
- Full functional equivalence over USSD/SMS.

### 6.2 Driver app
- Compliance dashboard (background check, road safety certification, first aid certification, a weekly spare helmet photo) gating "go online."
- Go online/offline toggle with position broadcast at a configurable interval.
- Incoming ride request card with fare, distance, pickup distance, and a short accept/decline timeout.
- Text based, landmark referenced directions to pickup.
- A two sided handover checklist before the trip can start.
- In trip SOS with the same guarantees as the rider's.
- Independent cash/mobile money payment confirmation.
- Daily and rolling earnings view with a mobile money commission remittance action.
- Financial and compliance data cached locally, synced opportunistically.

### 6.3 Degraded channel (USSD and SMS)
- A short code USSD menu exposing: request a boda, last trip, emergency, language, pay commission.
- Landmark pickup selection ranked by subscriber history, with a free text fallback.
- A fare confirmation screen reproducing the same fixed fare guarantee as the app.
- A driver assignment notification as a single structured SMS.
- Trip sharing and SOS as plain SMS, requiring no smartphone on either end.
- Seamless handoff when the app detects data loss mid flow.

### 6.4 Admin and control centre
- Live map of online drivers and active trips.
- Safety incident and SOS alert queue with one click contact.
- Driver compliance record management.
- Fare table configuration without an app redeploy.
- Reconciliation view for cash versus mobile money and commission collection.
- USSD/SMS session logs for support and dispute resolution.

## 7. Core User Journeys (summary; full detail in APP_FLOW.md)

1. Rider happy path (app): sign up, pick a destination, confirm fare, get matched, verify driver, pass helmet/ID check, ride with SOS visible, pay, rate, get a receipt.
2. Rider degraded path (USSD/SMS): dial short code, request, confirm fare, receive driver SMS, ride, with SMS based sharing/SOS throughout.
3. Connectivity loss mid flow: automatic detection, offer to continue by SMS, reconciliation once back online.
4. Driver happy path: clear compliance, go online, accept, navigate to pickup, handover checklist, trip, collect payment, see earnings update.
5. Emergency, any channel: SOS reaches the control centre, a police contact, and personal emergency contacts simultaneously, with location.

## 8. Non-Functional Requirements

| Category | Requirement |
|---|---|
| Availability | Core booking and SOS paths, including USSD/SMS, target 99.5% uptime. SOS has an independent, minimal dependency delivery route. |
| Latency | Fare quote and matching p95 under 3 seconds on a 3G equivalent connection. USSD menu responses under 3 seconds. |
| Offline resilience | Apps remain usable with zero connectivity for cached data. All mutating offline actions queue and sync without loss or duplication. |
| Data efficiency | Initial app size 15 MB or less. No live raster map tiles by default. |
| Localization | Full UI and SMS/USSD copy in Lugbara, English, and Kiswahili from v1. |
| Security | OTP based auth only. Payment callbacks verified via provider signatures. PII encrypted at rest. Role based admin access. |
| Auditability | Every fare, compliance, or payment state change is logged with actor, timestamp, and before/after values. |
| Accessibility | Large touch targets, high contrast driver theme, voice readout fallback. |
| Scalability | Matching/dispatch and the SMS/USSD gateway scale independently of the core CRUD API. |
| Regulatory | Uganda Data Protection and Privacy Act (2019). Mobile money integrations meet Bank of Uganda and aggregator KYC/settlement rules. |
| Extensibility | Adding a second service vertical must not require a new identity system, a new wallet, or a new mobile app shell. See section 9. |

## 9. Super App Extensibility Requirements

These are requirements on Phase 1's design, not features to build in Phase 1.

1. **Generic identity.** One `users`/`profiles` record per person regardless of how many roles or services they use (rider today, courier customer tomorrow). Roles are additive, not exclusive.
2. **Generic order abstraction.** A ride is one `order_type` inside a generic orders model, not a standalone `trips` table with no shared shape. See BACKEND_SCHEMA.md section 3 for the exact design, and how the current, already implemented `trips` table maps onto it.
3. **Generic wallet and ledger.** One balance and one transaction history per user, tagged by purpose (trip fare, future delivery fee, future bill payment), not a second balance system per vertical.
4. **Generic provider/agent model.** A "driver" is one type of "service provider." A future courier or errand runner is another type on the same verification and payout rails.
5. **Module driven app shell.** The rider app's home screen is built as a small, fixed set of primary actions today (request a ride), but the navigation and layout are built so a second service tile can be added to the same home screen later without restructuring the app.
6. **Config over redeploy.** Which modules are visible to which users, in which regions, is a server side flag, not a compiled in constant.
7. **Regional/tenant readiness.** Fare tables, stage lists, and language sets are already modeled as data, not hardcoded, so a second town or region is a data entry exercise, not a code change.

## 10. Success Metrics (Phase 1)

| Metric | Why it matters |
|---|---|
| Trip funnel conversion (requested to matched to completed), by channel | Shows real conversion and where riders drop off. |
| Median and p95 time to match a driver | The biggest driver of repeat usage. |
| Percentage of trips completed via USSD/SMS | Validates the degraded channel is reaching its intended segment. |
| SOS trigger to acknowledgement time | The most safety critical metric in the system. |
| Driver day 1 and week 1 retention after onboarding | Whether the compliance and earnings experience keeps drivers coming back. |
| Cash versus mobile money mix and commission collection rate | Core to unit economics. |
| Safety report rate per 1,000 trips, and time to close | Whether verification and helmet checks are working. |

## 11. Current Implementation Status

- Built and real: rider phone OTP auth, seeded Arua boda stages with distance based fares, a real Postgres/PostGIS schema (profiles, boda_stages, drivers, trips, driver_earnings, trip_dispatch_offers), and a real dispatch/matching engine (PostGIS nearest eligible driver query, offer/accept/decline with automatic re offer, realtime updates on both apps).
- Scaffolded, not yet real: driver phone OTP auth (demo identity today, seeded to a real database row), payment UI without a live mobile money integration, earnings screens without a real ledger write path.
- Not started: the helmet/ID safety gate, SOS, the USSD/SMS degraded channel logic, the admin console, localization.

See CHANGELOG.md in the codebase for a dated history, and IMPLEMENTATION_PLAN.md in this package for what comes next and in what order.

## 12. Risks and Open Decisions

- Brand name not finalised; verify domain/trademark before launch.
- Both the USSD/SMS gateway and mobile money integrations are third party dependencies outside the team's control; both must stay behind an internal interface.
- Driver auth is currently a demo identity in the app; real phone based driver login needs to land before any real driver onboarding.
- Data retention policy for driver ID documents and rider location history needs a documented plan consistent with the Data Protection and Privacy Act.
- Actual 2G/3G network conditions in Arua should be measured directly, not assumed, before finalising payload size and timeout targets.
- The super app extensibility requirements in section 9 add some upfront schema complexity; the implementation plan sequences this so Phase 1 delivery is not slowed down waiting for Phase 2 abstractions to be perfect.
