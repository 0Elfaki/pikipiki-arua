# 📡 Offline Sync & Low-Connectivity Resilience Strategy

Arua City and surrounding West Nile districts (Maracha, Terego, Koboko, Zombo) feature pockets of spotty 2G/3G connectivity. The Pikipiki Arua platform implements an aggressive offline-first sync engine.

## 1. Local Persistence Layer
- **Secure Storage**: Cryptographic storage of user session JWTs, driver profile, and active trip tokens.
- **Local SQLite / Shared Cache**: Cached stage boundaries, standard stage fare rate tables, and user trip history.

## 2. Telemetry Queue (Driver App)
When a driver is on an active trip and traverses a dead zone:
1. GPS coordinate updates are stamped with `UUIDv4` idempotency keys and recorded to an in-memory / local SQLite queue.
2. The UI continues to function locally, updating distance and estimated fare based on local odometry.
3. Upon reconnection to 3G/4G, the sync service flushes queued telemetry payloads in batches with exponential backoff.

## 3. Idempotency & Conflict Resolution
- Every trip mutation (`accept_trip`, `start_trip`, `complete_trip`, `pay_trip`) carries an `idempotency_key`.
- The backend checks:
  ```sql
  INSERT INTO public.idempotency_records (key, response_payload) ...
  ```
  ensuring duplicate network retries never lead to duplicate charges or duplicate trip status updates.
