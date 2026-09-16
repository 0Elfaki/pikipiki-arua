# 🗄️ Database Schema & Data Dictionary

The Pikipiki Arua schema is managed via timestamped SQL migrations in `backend/supabase/migrations/`.

## Entities

### `profiles`
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | UUID | PK, FK auth.users | User UID |
| `phone_number` | TEXT | UNIQUE, NOT NULL | Primary Ugandan MSISDN (+256...) |
| `full_name` | TEXT | NOT NULL | User's legal name |
| `role` | user_role | ENUM | 'rider', 'driver', 'stage_chairman', 'admin' |
| `rating` | NUMERIC(3,2) | DEFAULT 5.00 | Average rating |

### `boda_stages`
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | UUID | PK | Unique stage ID |
| `name` | TEXT | NOT NULL | Local stage name (e.g. Arua Hill Roundabout) |
| `code` | TEXT | UNIQUE | Stage reference code |
| `latitude` | DOUBLE | NOT NULL | Stage coordinate |
| `longitude` | DOUBLE | NOT NULL | Stage coordinate |
| `location` | GEOMETRY(Point, 4326) | GIST Indexed | Spatial point for PostGIS calculations |

### `drivers`
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | UUID | PK, FK profiles.id | Driver profile reference |
| `stage_id` | UUID | FK boda_stages.id | Affiliated boda stage |
| `number_plate` | TEXT | UNIQUE, NOT NULL | E.g., UFL 234X |
| `is_online` | BOOLEAN | DEFAULT false | Driver availability |
| `current_location` | GEOMETRY(Point, 4326) | GIST Indexed | Current GPS coordinate |

### `trips`
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | UUID | PK | Trip UUID |
| `rider_id` | UUID | FK profiles.id | Passenger |
| `driver_id` | UUID | FK drivers.id (NULLABLE)| Assigned Boda Driver |
| `status` | trip_status | ENUM | requested, accepted, in_progress, completed, etc. |
| `fare_ugx` | NUMERIC(10,2)| NOT NULL | Calculated trip fare |
| `payment_method`| payment_method | ENUM | cash, mtn_momo, airtel_money |
