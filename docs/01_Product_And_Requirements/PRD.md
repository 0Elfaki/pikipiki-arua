# 📋 Product Requirements Document (PRD)

**Product (working name):** Pikipiki Arua
**Market:** Arua City and the wider West Nile sub-region, Uganda
**Status:** Living document. Last updated September 18, 2026.
**Owner:** Hope Foundation Uganda / Pikipiki Arua Platform team

> Note on naming: "Pikipiki Arua" is a working name only. Candidates under consideration for the final brand include FairBoda, ClearBoda, and TrustBoda. Domain and trademark availability have not yet been verified with a registrar. Update this file once a final name is confirmed.

---

## 1. Problem Statement

In Arua City and across West Nile, boda bodas (motorcycle taxis) are the primary means of intra city transport and last mile logistics. Today that market runs almost entirely on unstructured, street corner negotiation: fares are haggled per ride and are frequently inflated for visitors, women, and night riders; there is no reliable way to verify who is actually driving a given motorcycle or to hold them accountable afterward; riders often travel without a helmet; and there is no built in way to call for help during a ride. On top of this, the market itself is mixed: many riders and drivers have inconsistent access to smartphones and mobile data, addresses are landmark based rather than street based, and payment happens in a mix of cash and mobile money (MTN MoMo and Airtel Money).

Pikipiki Arua exists to bring predictable pricing, driver accountability, and rider safety to this market, without assuming every user has a modern smartphone or a stable data connection.

## 2. Goals and Objectives

| Objective | What it means concretely |
|---|---|
| Predictable pricing | A fixed, distance based fare in UGX is shown and locked before a ride is requested. The driver cannot alter it in app, and the arithmetic is available on request. |
| Vetted, accountable drivers | Drivers are verified against national ID, motorcycle registration, and stage chairman endorsement before they can go online. A driver's compliance status can be revoked without an app redeploy. |
| Rider safety by default | A helmet and ID check gates the start of every ride on both apps. SOS is reachable at all times during a trip and reaches the control centre, a police contact, and personal emergency contacts at once. |
| Works without a smartphone or data | Every core flow (request a ride, confirm a fare, get matched with a driver, trigger SOS) has a USSD/SMS equivalent, and the app itself remains usable offline for cached data. |
| Financial inclusion | Cash and mobile money (MTN MoMo, Airtel Money) are treated as equally first class payment paths. |
| Fair driver economics | Drivers can see their earnings, cash versus mobile money split, and commission owed at all times, even offline. |

## 3. Target Users

Full persona detail lives in `USER_PERSONAS.md` in this folder. In short:

- **Riders** such as Amina, a daily commuter and student who needs safe, affordable, predictable rides without a lengthy price negotiation each time.
- **Drivers** such as Juma, an experienced boda operator who wants a steady stream of requests, better net daily earnings, and protection from fare disputes.
- **Stage chairmen** such as Bakole, who oversee the riders registered to a stage, resolve disputes, and vouch for driver credibility within the community.
- **Operations / control centre staff**, who monitor safety incidents, manage driver compliance, and configure fares without needing an engineer.

## 4. Scope

### 4.1 In scope for v1

- Rider app (Android first, Flutter): phone based signup, stage to stage or landmark based booking, upfront fare, driver matching, helmet check gate, live trip view, SOS, cash and mobile money payment, rating and safety reporting.
- Driver app (Android first, Flutter): compliance gating, go online/offline, real time dispatch, pickup navigation by landmark, handover checklist, trip lifecycle, earnings and commission view.
- Backend (Supabase: Postgres, PostGIS, Auth, Realtime, Storage, Edge Functions): fare calculation, driver matching/dispatch, trip lifecycle, payment orchestration, and the USSD/SMS gateway integration.
- Degraded channel (USSD and SMS via an aggregator such as Africa's Talking): booking, fare confirmation, driver assignment notice, SOS, and trip sharing for riders without a smartphone or without data.
- Admin / control centre web console: live map of drivers and trips, safety incident queue, driver compliance management, fare configuration, USSD/SMS session logs.

### 4.2 Out of scope for v1

- iOS release (the Flutter codebase supports it, but the initial rollout is Android first; iOS ships once Android is validated in market).
- Direct integration with a live turn by turn mapping provider beyond an offline, pre clipped map extract of Arua (a Google Maps style fallback is a future expansion item, not a v1 requirement).
- Expansion beyond Arua City and West Nile.
- Any product other than passenger ride hailing and light courier/logistics for boda drivers (no car hailing, no food delivery).
- Direct bank settlement rails beyond MTN MoMo and Airtel Money (or a payment aggregator standing in for them).

## 5. Product Principles

These are the constraints that should shape every design and engineering decision, not just guidelines to keep in mind:

1. **Single source of truth for fare and dispatch logic.** The app and the USSD/SMS channel must call the same backend services. Fare and matching logic is never re implemented per channel, so a smartphone user and a feature phone user are never quoted differently for the same trip.
2. **No single point of failure for SOS.** Safety alerts must not depend on the full dispatch pipeline being healthy. SOS is a minimal, directly callable path straight to the SMS gateway with its own retry logic.
3. **Design for intermittent connectivity, not just absent connectivity.** The harder case is a connection that drops in and out, not one that is simply off. Client networking uses short timeouts, exponential backoff, and idempotent retries rather than long hangs.
4. **Landmark first, not street address first.** Location entry, navigation, and driver directions are built around how people in Arua actually describe places (a market, a school, a stage), not a geocoded street address system that does not match local usage.
5. **Data cost is a UX cost.** No live raster map tiles by default. Aggressive caching. Every network payload's size is treated as something a rider or driver pays for, not just a performance number.
6. **Aggregator risk is abstracted from day one.** Both the USSD/SMS gateway and the mobile money integrations sit with third party providers outside the team's control. Both are wrapped behind an internal interface so a second provider can be added without touching business logic.

## 6. Functional Requirements

### 6.1 Rider app

- Phone number registration with SMS OTP (4 digit code), resend option, and a voice readout fallback for low literacy users.
- Language selection (Lugbara, English, Kiswahili), persisted per device.
- Landmark based destination search with category filters (market, school, clinic, church) and a pin drop fallback.
- A deterministic fare quote computed server side from a fixed base fare plus a per kilometre rate, shown before driver search begins and itemised on request.
- Driver matching against nearby online, compliant drivers within a configurable radius. If the client loses data mid search, the request degrades to the SMS relay path automatically.
- Driver profile display after a match: name, photo, jacket ID, plate number, rating, and certification badges.
- A mandatory helmet and ID confirmation step before the trip is allowed to start, plus a "report a problem" path that both makes the ride free and opens a safety report.
- A live trip view with ETA, live route, and the ability to share the trip with designated contacts.
- An SOS control reachable from the trip screen at all times, triggering simultaneous alerts to a police contact, the control centre, and personal emergency contacts, all with location.
- A payment step supporting cash acknowledgement and mobile money (MTN MoMo, Airtel Money) via USSD push, with the confirmation recorded server side.
- Post trip rating plus a separate, structured safety incident checklist routed to the control centre.
- Offline accessible trip history and SMS deliverable receipts.
- Everything above is also reachable and functionally equivalent through the USSD/SMS degraded channel (see 6.3).

### 6.2 Driver app

- A compliance dashboard (background check, road safety certification, first aid certification, a weekly spare helmet photo) that gates the "go online" action. Any lapsed clearance blocks dispatch eligibility.
- A go online/offline toggle with position broadcast at a configurable interval while online.
- An incoming ride request card showing fare, distance, pickup distance, and a short accept/decline timeout window.
- Text based, landmark referenced turn directions to pickup, with no mandatory map rendering.
- A handover checklist (spare helmet given, jacket and ID visible) that must be confirmed before the trip can start. This mirrors the rider side checklist for two sided confirmation.
- An in trip SOS with the same guarantees as the rider's.
- A collection/confirmation step for both cash and mobile money payment, recorded independently of the rider's confirmation (a two sided payment record).
- A daily and rolling earnings view (cash collected, mobile money collected, commission owed), with a mobile money based commission remittance action.
- All financial and compliance data is cached locally and synced opportunistically when connectivity returns.

### 6.3 Degraded channel (USSD and SMS)

- A short code USSD menu (for example `*284*7#`) exposing: request a boda, last trip, emergency, language, and pay commission.
- Landmark pickup selection ranked by the subscriber's history, with a free text fallback.
- A fare confirmation screen that reproduces the same fixed fare guarantee as the app before the request is committed.
- A driver assignment notification delivered as a single structured SMS: name, jacket ID, plate, rating, ETA, fare, and reply codes for "no helmet" and "emergency."
- Trip sharing and SOS available as plain SMS with a trackable link, requiring no smartphone on either end.
- A seamless handoff: the smartphone app must detect loss of data mid flow and offer to continue the same request over SMS without restarting it.

### 6.4 Admin / control centre

- A live map of online drivers and active trips.
- A safety incident and SOS alert queue, with driver/rider identity, last known location, and one click contact.
- Driver compliance record management: uploading and renewing certifications, suspending non compliant drivers.
- Fare table configuration (base fare, per kilometre rate, zone overrides) without requiring an app redeploy.
- A reconciliation view for cash versus mobile money trips and commission collection.
- USSD/SMS session logs for support and dispute resolution.

## 7. Core User Journeys

Full detail lives in `04_User_Journeys.md`. Summarised here:

1. **Rider, happy path (app).** Select language, sign up by phone, verify OTP, land on a home screen with cached map and saved landmarks, pick a destination, see and confirm the fare, get matched with a driver, verify the driver (jacket ID, plate), pass the helmet and ID check, ride with live route and SOS visible, arrive, pay by MoMo or cash, rate the trip and complete a safety checklist, and get an offline available receipt.
2. **Rider, degraded path (USSD/SMS).** Dial the short code, choose "request a boda," pick a landmark, confirm the fare, receive a driver assignment SMS, ride, with trip sharing and SOS available as plain SMS throughout. Any queued rating or receipt syncs to the app automatically the next time data is available.
3. **Rider, connectivity loss mid flow.** The app detects a failed request within a timeout, offers to continue over SMS, re issues the same request as an SMS payload, shows a queued state, and reconciles the trip's true state from the backend once connectivity returns.
4. **Driver, happy path.** Open the app, clear the compliance dashboard (or see the specific reason it is blocked), go online after the daily spare helmet photo, receive a request card, accept within the timeout, follow text based directions to pickup, complete the handover checklist with the rider, start the trip, follow one instruction at a time with SOS visible, complete the trip, collect payment, and see earnings update immediately.
5. **Emergency, either party, any channel.** SOS is triggered (slide, a quiet volume key sequence, or an SMS reply). Location, trip ID, driver/plate, and rider identity go out immediately and in parallel to a police contact, the control centre, and the triggering party's saved emergency contacts. The alert stays open until an operator resolves it or the triggering party cancels it as a false alarm (a PIN is required to cancel the quiet variant, so a third party cannot silence it).

## 8. Non-Functional Requirements

| Category | Requirement |
|---|---|
| Availability | Core booking and SOS paths, including USSD/SMS, target 99.5% uptime. SOS has an independent, minimal dependency delivery route so it does not depend on the full API being healthy. |
| Latency | Fare quote and matching request p95 under 3 seconds on a 3G equivalent connection. USSD menu responses under 3 seconds, given typical 15 to 30 second telco session timeouts. |
| Offline resilience | Rider and driver apps remain usable (cached map, saved landmarks, trip history, compliance status) with zero connectivity. Every mutating action taken offline queues and syncs without data loss or duplication. |
| Data efficiency | Initial app size target of 15 MB or less. Map data is pre cached vector/landmark data, not live raster tiles, by default. |
| Localization | Full UI and SMS/USSD copy available in Lugbara, English, and Kiswahili from v1. |
| Security | OTP based auth only, no stored passwords. All payment callbacks are verified via provider signatures. PII (phone numbers, driver ID uploads) is encrypted at rest. Role based access on the admin console. |
| Auditability | Every action that changes a fare, a driver's compliance status, or a payment's state is logged with actor, timestamp, and before/after values. |
| Accessibility | Large touch targets, a high contrast dark theme for the driver app for outdoor daylight legibility, and a voice readout fallback for OTP and low literacy flows. |
| Scalability | The matching/dispatch service and the SMS/USSD gateway must be able to scale independently of the core CRUD API, since their load and burst profiles differ significantly. |
| Regulatory | Compliance with Uganda's Data Protection and Privacy Act (2019). Mobile money integrations comply with Bank of Uganda and telco aggregator KYC and settlement rules. |

## 9. Success Metrics

| Metric | Why it matters |
|---|---|
| Trip funnel conversion (requested to matched to completed), by channel | Shows whether the app and the degraded channel are actually converting requests into completed rides, and where riders drop off. |
| Median and p95 time to match a driver | The single biggest driver of whether a rider trusts the app enough to use it again. |
| Percentage of trips completed via USSD/SMS | A direct read on whether the degraded channel is reaching the feature phone segment it was built for, not just a checkbox feature. |
| SOS trigger to acknowledgement time | The most safety critical metric in the system. Should be tracked and alerted on independently from general app telemetry. |
| Driver day one and week one retention after onboarding | Whether the compliance and earnings experience is good enough to keep drivers coming back online. |
| Cash versus mobile money trip mix and commission collection rate | Core to unit economics and to validating the dual payment model. |
| Safety report rate per 1,000 trips, and time to close | Whether the helmet check and verification steps are actually reducing incidents, not just adding friction. |

## 10. Current Implementation Status

This section reflects the actual state of the codebase as of this document's last update, not just the plan. See `CHANGELOG.md` at the repository root for the full history.

**Built and working:**
- Monorepo foundation (`apps/rider_app`, `apps/driver_app`, `backend/supabase`), CI/CD skeleton, and a feature first Flutter/Riverpod architecture on both apps.
- Rider phone number OTP sign up and login against real Supabase Auth.
- A seeded set of real Arua boda stages (Main Market, Arua Hill, Muni University, Referral Hospital, Onduparaka) with distance based fare calculation.
- A real Postgres/PostGIS schema: profiles, boda_stages, drivers, trips, driver_earnings, and a trip_dispatch_offers audit trail.
- A real dispatch and matching engine: a PostGIS nearest eligible driver query, an Edge Function that assigns a trip to the nearest online, verified driver, a second Edge Function for driver accept/decline/timeout that automatically re offers to the next nearest driver, and realtime updates so both apps reflect the live match instead of demo data.
- Basic offline sync queue scaffolding on both apps.

**Scaffolded but not yet real:**
- Driver phone OTP auth (the driver app currently runs a fixed demo identity, seeded to a real database row so dispatch testing works end to end; real driver auth is a near term follow up).
- Payment UI (cash and mobile money selection exists in the rider app) without a live MTN MoMo or Airtel Money integration behind it yet.
- Earnings and commission screens without a real ledger write path yet.

**Not started:**
- The helmet and ID safety gate before trip start.
- SOS (loud and quiet variants), the safety report checklist, and the control centre alert queue.
- The USSD/SMS degraded channel (an edge function exists with a static menu tree, not yet backed by the real trip and matching engine).
- The admin/control centre web console.
- Localization into Lugbara and Kiswahili.

## 11. Milestone Roadmap

| Milestone | Scope | Exit criteria |
|---|---|---|
| M0. Foundations | Supabase environments, schema migrations, CI/CD, phone OTP auth | A user can sign up and log in on a real device, in all three languages |
| M1. Rider core loop | Landmark search, fare calculation, driver matching, helmet check gate, live trip screen | A rider can complete a full trip end to end in the app |
| M2. Driver core loop | Compliance dashboard, go online, accept/decline, pickup navigation, handover checklist | A driver can go online, accept a request, and complete a trip against a real rider client |
| M3. Payments | Cash confirmation, MTN MoMo and Airtel Money integration, commission ledger | A real sandbox mobile money payment can be initiated, confirmed, and reflected in both apps and the ledger |
| M4. Safety | SOS (loud variant first), safety report checklist, control centre alert queue | A triggered SOS reaches the control centre and a designated contact within an agreed SLA in field testing |
| M5. Degraded channel | USSD menu tree, SMS templates, app to SMS handoff, sync on reconnect | A feature phone only test user can complete a full trip via USSD/SMS with no app involved |
| M6. Admin console | Live map, compliance management, fare configuration, incident queue | Operations staff can manage driver onboarding and respond to an incident without engineering involvement |
| M7. Hardening and field pilot | Throttled network and low end device testing, offline sync edge cases, security review, limited pilot | Pilot cohort completes real trips over at least one week with acceptable crash and support ticket rates |
| M8. Launch readiness | App store submission, production aggregator credentials, monitoring, support runbook | Go/no go checklist cleared for public launch in Arua |

Dispatch and matching, the highest risk item within M1/M2, is now real (see section 10). The next highest leverage items are the helmet check safety gate and wiring a real payment provider.

## 12. Risks and Open Decisions

- **Brand name not finalised.** "Pikipiki Arua" is a working name. Domain and trademark availability need to be checked with an actual registrar before committing.
- **Aggregator dependency.** Both the USSD/SMS gateway and the mobile money integrations depend on third party providers outside the team's control. Both must stay behind an internal interface so a second provider can be swapped in without a business logic rewrite.
- **Driver auth is currently a demo identity.** Dispatch and matching work against a real database row, but the driver app does not yet enforce real phone based login the way the rider app does. This needs to be closed before any real driver onboarding.
- **Regulatory and data handling review.** Storing driver ID documents and rider location history needs a documented retention policy consistent with Uganda's Data Protection and Privacy Act before broader field testing.
- **Field network conditions are still assumptions, not measurements.** Actual 2G/3G throughput and latency in Arua should be measured directly, not just assumed from general West Nile connectivity data, before finalising payload size and timeout targets.

## 13. Related Documents

- `USER_PERSONAS.md`, in this same folder, for full persona detail.
- `docs/00_START_HERE/ARCHITECTURE_OVERVIEW.md` for the system architecture diagram.
- `docs/02_Technical_Design/DATABASE_SCHEMA.md` for the current schema.
- `docs/Piki_Piki_Arua_Full_TRD.md` for the original, fully detailed technical requirements document this PRD is condensed from.
- `CHANGELOG.md` at the repository root for a dated history of what has actually shipped.
