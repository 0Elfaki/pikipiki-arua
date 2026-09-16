# 🏛️ Architecture Overview

The Pikipiki Arua platform is built with a distributed, offline-resilient architecture tailored for emerging urban environments with variable connectivity.

```
                    +-----------------------------+
                    |        Rider App            |
                    | (Flutter / Clean Riverpod)  |
                    +--------------+--------------+
                                   |
                  HTTPS / WSS      | Realtime Sync
                                   v
             +---------------------+---------------------+
             |            Supabase BaaS                  |
             |  - PostGIS Spatial Queries                |
             |  - PostgreSQL Row Level Security (RLS)    |
             |  - Realtime WebSockets                    |
             |  - Edge Functions (Dispatch, USSD)        |
             +---------------------+---------------------+
                                   ^
                  HTTPS / WSS      | Realtime GPS Telemetry
                                   |
                    +--------------+--------------+
                    |        Driver App           |
                    | (Flutter / Clean Riverpod)  |
                    +-----------------------------+
```

### Key Principles
1. **Low-Bandwidth Optimization**: JSON payloads are kept minimal (< 5KB), and map vector tiles are cached aggressively.
2. **Stage-Centric Dispatch**: Incorporates traditional East African Boda Boda stage hierarchies (stage chairmen, stage queues) rather than pure random-floating dispatch.
3. **Dual Payment Modality**: Frictionless Cash payments alongside MTN Mobile Money and Airtel Money Uganda.
