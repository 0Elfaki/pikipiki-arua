# 🛠️ System Design & Technical Specification

## 1. Stack Selection
- **Frontend Framework**: Flutter 3.x (Multi-platform: Android, iOS, Web, Windows Desktop)
- **State Management**: Flutter Riverpod 2.x (Feature-first, testable, immutable state)
- **Navigation**: GoRouter (declarative routing with auth state redirection)
- **Backend & Database**: Supabase (PostgreSQL 15 + PostGIS)
- **Realtime Layer**: Supabase Realtime Channels (PostgreSQL CDC via WebSockets)
- **Edge Computing**: Supabase Deno Functions

## 2. Dispatch Engine
1. Rider initiates trip request with pickup `(lat, lng)` and dropoff `(lat, lng)`.
2. Supabase PostGIS function `find_nearby_drivers` executes:
   ```sql
   SELECT id, current_location,
          ST_Distance(current_location, ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)::geography) AS distance_meters
   FROM public.drivers
   WHERE is_online = true AND verification_status = 'verified'
   ORDER BY distance_meters ASC
   LIMIT 5;
   ```
3. The closest driver receives a WebSocket push event and has 20 seconds to accept.
4. If timed out, request cascades to the next nearest driver or stage queue.
