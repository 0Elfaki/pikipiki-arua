# Implementation Plan

Companion to 01_PRD.md and 02_TRD.md. This is the phased delivery plan: what gets built, in what order, with what exit criteria, and where the super app groundwork from TRD.md section 8 and BACKEND_SCHEMA.md section 2 actually gets scheduled (deliberately late, so it never competes with shipping Phase 1).

Each milestone is a working, demoable slice, not a technical layer. Move to the next milestone only when the current one is genuinely done, not "90 percent done."

---

## Phase 1: Core Platform (the product in PRD.md sections 4.1 and 6)

| Milestone | Scope | Exit criteria | Status |
|---|---|---|---|
| M0. Foundations | Supabase environments, schema migrations, CI/CD skeleton, phone OTP auth | A user can sign up and log in on a real device | **Done** for rider auth. Driver auth still runs a demo identity. |
| M1. Rider core loop | Landmark/stage search, fare calculation, driver matching, helmet check gate, live trip screen | A rider can complete a full trip end to end in the app | **Mostly done.** Stage search, fare calc, and real dispatch/matching are live. Helmet check gate not started. |
| M2. Driver core loop | Compliance dashboard, go online, accept/decline, pickup navigation, handover checklist | A driver can go online, accept a request, and complete a trip against a real rider client | **Partially done.** Go online/offline, real incoming offers, and accept/decline are real and working. Compliance dashboard and handover checklist not started. Driver auth is still a demo identity, seeded to a real database row for testing. |
| M3. Payments | Cash confirmation, MTN MoMo integration (or PSP aggregator), Airtel Money integration, payment reconciliation, commission ledger | A real sandbox mobile money payment can be initiated, confirmed, and reflected in both apps and the ledger | Not started. UI selection exists; no live integration. |
| M4. Safety | SOS (loud variant first), safety report checklist, control centre alert queue and live map, trip sharing SMS | A triggered SOS reaches the control centre and a designated contact within an agreed SLA in field testing | Not started. |
| M5. Degraded channel | USSD menu tree, SMS driver assignment and share/SOS templates, app to SMS handoff, sync on reconnect | A feature phone only test user can complete a full trip via USSD/SMS with no app involved | Not started. A static USSD menu stub exists, not yet backed by the real trip and matching engine. |
| M6. Admin console | Live map, driver compliance management, fare configuration, incident queue, USSD/SMS session logs | Operations staff can manage driver onboarding and respond to an incident without engineering involvement | Not started. |
| M7. Hardening and field pilot | Load/latency testing on throttled networks, low end device testing, offline sync edge cases, security review, a limited real world pilot | Pilot cohort completes real trips over at least one week with acceptable crash/error and support ticket rates | Not started. |
| M8. Launch readiness | App store submission, aggregator production credentials, monitoring/alerting live, support runbook, legal/compliance sign off | Go/no go checklist cleared for public launch in Arua | Not started. |

### Recommended near term sequencing (next 4 to 6 work sessions)

1. **Close out M1**: helmet and ID safety gate (blocks trip start on both apps, per PRD.md 6.1/6.2).
2. **Close out M2**: real driver phone OTP auth (replace the demo identity so RLS can be used directly instead of routing every driver write through a service role Edge Function), then the compliance dashboard and handover checklist.
3. **Start M3**: cash confirmation flow first (no external dependency), then a sandboxed MTN MoMo integration behind the existing payment method selector, PSP aggregator route recommended for v1 per TRD.md section 2.3.
4. **Start M4**: loud variant SOS first, since it is the highest safety value for the lowest implementation cost (a directly callable, minimal dependency SMS path per TRD.md section 7).
5. Reassess before M5 to M8: these depend on aggregator sandbox credentials, a live pilot cohort, and possibly the outcome of M3/M4 in the field.

## Phase 2: Super App Foundations (do not start until Phase 1 has a working, field validated core loop)

This phase is intentionally sequenced after M7 (field pilot), not before it. Building generic abstractions before the ride hailing core loop has proven itself in the field risks over-engineering for a future that has not been validated yet.

| Milestone | Scope | Exit criteria |
|---|---|---|
| S1. Wallet unification | Introduce `wallets` and `wallet_transactions` per BACKEND_SCHEMA.md section 2.2 step 1; migrate existing driver earnings/commission data into it | Driver earnings and commission continue to work unchanged, now backed by the generic ledger |
| S2. Order abstraction | Introduce `orders` and `ride_details` with a compatibility view named `trips`, per BACKEND_SCHEMA.md section 2.2 step 2 | Existing app code runs unchanged against the new schema; no regression in the trip flow |
| S3. Provider abstraction | Introduce `service_providers` and `provider_compliance` with a compatibility view named `drivers`, per BACKEND_SCHEMA.md section 2.2 step 3 | Existing driver flow runs unchanged against the new schema |
| S4. Module registry and app shell | Introduce `service_modules`; update the rider app home screen to read available services from configuration rather than a single hardcoded screen | Ride remains the only visible service, but toggling it via configuration (rather than a code change) is possible in a test environment |
| S5. First new vertical (candidate: parcel delivery) | Build `delivery_details`, a delivery specific matching/pricing path reusing the generic dispatch engine's matching primitives, and a second tile on the rider home screen | A rider can request a delivery using the same account, wallet, and driver network as a ride |

Which vertical goes into S5 (delivery, errands, or bill pay) should be decided based on Phase 1 field data (what riders and drivers actually ask for), not decided speculatively now. PRD.md section 4.2 lists the candidates.

## Working Practices

- **Definition of done** for any task: merged via a reviewed pull request, has at least a basic automated test or a recorded manual test script, works against the real Supabase backend including RLS, any new environment variable is documented, and the change is logged in CHANGELOG.md.
- **A milestone is not done** until every task in it meets that bar and the milestone's user facing outcome can be demoed end to end on a real or realistic device, including the offline/degraded network case if the milestone touches connectivity.
- **Scope control**: a new idea that surfaces mid milestone goes into a backlog, not into the milestone in progress.
- **Priority order** when deciding what to work on next: anything blocking the current milestone's demo; anything that is a security or data integrity risk (auth bugs, RLS gaps, payment correctness); anything a real user or tester is currently blocked on; everything else, in the order it appears in the current milestone's task list.
- **Field testing** on real, low end Android devices over real Arua network conditions starts at M1, not only at M7.

## Related Documents

- 01_PRD.md for why each milestone matters.
- 02_TRD.md for the technical detail behind each milestone.
- 03_BACKEND_SCHEMA.md for the exact schema changes referenced in Phase 2.
- CHANGELOG.md in the codebase for what has actually shipped, dated.
