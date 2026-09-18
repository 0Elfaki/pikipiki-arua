# Changelog

All notable changes to the **Pikipiki Arua** platform will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Real dispatch/matching engine: PostGIS `find_nearest_eligible_drivers` RPC
  (online + verified drivers, radius search, excludes already-declined
  drivers) and a `trip_dispatch_offers` audit trail.
- `dispatch-webhook` Edge Function rewritten from a logging stub into the
  real matching call; new `dispatch-respond` Edge Function for
  driver accept/decline/timeout, which re-offers to the next-nearest driver
  automatically; new `driver-presence` Edge Function for online/offline +
  location updates.
- Realtime trip subscriptions on both apps: riders see live match status and
  real assigned-driver details on the active trip screen; drivers receive
  real incoming-offer cards (replacing the old "Simulate Incoming Ride
  Request" demo button) and can accept/decline for real.
- Seed data for three demo online/verified drivers (`backend/supabase/seed.sql`)
  so the matching engine has real candidates to test against; the driver
  app's demo identity now maps to a real seeded `drivers` row.
- Realtime enabled on `public.trips` via `supabase_realtime` publication.

## [0.1.0] - 2026-09-16
### Added
- Monorepo foundation with `apps/rider_app`, `apps/driver_app`, and `backend/supabase`.
- Initial database schema with PostGIS spatial indexing for Arua stages and driver dispatch.
- Clean feature-first Flutter Riverpod architecture across both mobile applications.
- Offline sync queue for low-bandwidth resilience in West Nile rural zones.
- Cash and MTN MoMo / Airtel Money UGX payment integrations.
- Complete Technical Requirements Document (TRD) and operational guides in `docs/`.
- GitHub Actions CI/CD workflows for automated testing and deployment.
