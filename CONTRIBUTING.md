# Contributing to Pikipiki Arua

Thank you for your interest in contributing to **Pikipiki Arua** — the localized Boda Boda mobility and logistics platform for Arua and the West Nile region in Uganda!

## Code of Conduct
We are committed to providing a welcoming, inclusive, and collaborative environment for all contributors, riders, and drivers.

## Repository Layout
This repository is organized as a monorepo:
- `apps/rider_app`: Flutter application for passengers and corporate deliveries.
- `apps/driver_app`: Flutter application for Boda Boda drivers (rides, offline stages, earnings).
- `backend/supabase`: PostgreSQL schema, PostGIS spatial queries, RLS policies, and Deno Edge Functions.
- `docs/`: Technical Requirements Document (TRD), architecture guides, and operational runbooks.

## Development Workflow
1. **Branching**:
   - Create a feature branch from `main`: `feature/rider-trip-history` or `fix/driver-radar-timeout`.
2. **Code Standards**:
   - Run `flutter analyze` and `flutter test` in the modified app directory.
   - Follow Flutter Riverpod 2.x and clean feature-first architecture (`data/`, `application/`, `presentation/`).
3. **Commit Messages**:
   - Follow Conventional Commits: `feat(rider): add MTN MoMo payment step`, `fix(driver): correct GPS tracking interval`.

## Submitting Pull Requests
- Ensure CI workflows pass.
- Include a summary of changes and visual screenshots/recordings for UI modifications.
