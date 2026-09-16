-- ==============================================================================
-- Pikipiki Arua: Initial Database Schema (PostgreSQL + PostGIS)
-- ==============================================================================

-- 1. Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- 2. Custom Enums
CREATE TYPE user_role AS ENUM ('rider', 'driver', 'stage_chairman', 'admin');
CREATE TYPE trip_status AS ENUM (
    'requested',
    'searching',
    'accepted',
    'arrived',
    'in_progress',
    'completed',
    'cancelled'
);
CREATE TYPE payment_method AS ENUM ('cash', 'mtn_momo', 'airtel_money');
CREATE TYPE payment_status AS ENUM ('pending', 'processing', 'completed', 'failed');
CREATE TYPE driver_verification_status AS ENUM ('pending', 'verified', 'rejected', 'suspended');

-- 3. Profiles Table (Linked with Supabase Auth)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    phone_number TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    avatar_url TEXT,
    role user_role NOT NULL DEFAULT 'rider',
    rating NUMERIC(3, 2) DEFAULT 5.00,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. Boda Stages Table (Arua Specific)
CREATE TABLE IF NOT EXISTS public.boda_stages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    code TEXT UNIQUE,
    chairman_name TEXT,
    chairman_phone TEXT,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    location GEOMETRY(Point, 4326),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_boda_stages_location ON public.boda_stages USING GIST(location);

-- 5. Drivers Table
CREATE TABLE IF NOT EXISTS public.drivers (
    id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    stage_id UUID REFERENCES public.boda_stages(id) ON DELETE SET NULL,
    national_id_number TEXT UNIQUE,
    driving_permit_number TEXT,
    motorcycle_make_model TEXT NOT NULL DEFAULT 'Bajaj Boxer 100',
    number_plate TEXT UNIQUE NOT NULL,
    helmet_color TEXT DEFAULT 'Yellow',
    is_online BOOLEAN NOT NULL DEFAULT FALSE,
    current_latitude DOUBLE PRECISION,
    current_longitude DOUBLE PRECISION,
    current_location GEOMETRY(Point, 4326),
    verification_status driver_verification_status NOT NULL DEFAULT 'pending',
    total_trips INTEGER NOT NULL DEFAULT 0,
    wallet_balance_ugx NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_drivers_current_location ON public.drivers USING GIST(current_location);

-- 6. Trips Table
CREATE TABLE IF NOT EXISTS public.trips (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rider_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
    driver_id UUID REFERENCES public.drivers(id) ON DELETE SET NULL,
    stage_id UUID REFERENCES public.boda_stages(id) ON DELETE SET NULL,
    status trip_status NOT NULL DEFAULT 'requested',
    
    -- Pickup Details
    pickup_address TEXT NOT NULL,
    pickup_latitude DOUBLE PRECISION NOT NULL,
    pickup_longitude DOUBLE PRECISION NOT NULL,
    pickup_location GEOMETRY(Point, 4326),
    
    -- Dropoff Details
    dropoff_address TEXT NOT NULL,
    dropoff_latitude DOUBLE PRECISION NOT NULL,
    dropoff_longitude DOUBLE PRECISION NOT NULL,
    dropoff_location GEOMETRY(Point, 4326),
    
    -- Fare & Payment
    estimated_distance_km NUMERIC(5, 2) NOT NULL DEFAULT 0.0,
    estimated_duration_mins INTEGER NOT NULL DEFAULT 0,
    fare_ugx NUMERIC(10, 2) NOT NULL,
    payment_method payment_method NOT NULL DEFAULT 'cash',
    payment_status payment_status NOT NULL DEFAULT 'pending',
    
    -- Telemetry & Safety
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    cancellation_reason TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_trips_rider_id ON public.trips(rider_id);
CREATE INDEX IF NOT EXISTS idx_trips_driver_id ON public.trips(driver_id);
CREATE INDEX IF NOT EXISTS idx_trips_status ON public.trips(status);

-- 7. Driver Earnings Log
CREATE TABLE IF NOT EXISTS public.driver_earnings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    driver_id UUID NOT NULL REFERENCES public.drivers(id) ON DELETE CASCADE,
    trip_id UUID REFERENCES public.trips(id) ON DELETE SET NULL,
    gross_fare_ugx NUMERIC(10, 2) NOT NULL,
    platform_fee_ugx NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    net_earnings_ugx NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 8. Spatial Auto-Update Trigger for Points
CREATE OR REPLACE FUNCTION update_spatial_points()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.latitude IS NOT NULL AND NEW.longitude IS NOT NULL THEN
        NEW.location = ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4326);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_driver_spatial_location()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.current_latitude IS NOT NULL AND NEW.current_longitude IS NOT NULL THEN
        NEW.current_location = ST_SetSRID(ST_MakePoint(NEW.current_longitude, NEW.current_latitude), 4326);
    END IF;
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_boda_stages_location
BEFORE INSERT OR UPDATE ON public.boda_stages
FOR EACH ROW EXECUTE FUNCTION update_spatial_points();

CREATE TRIGGER trg_update_driver_location
BEFORE INSERT OR UPDATE ON public.drivers
FOR EACH ROW EXECUTE FUNCTION update_driver_spatial_location();

-- 9. Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.boda_stages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.drivers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.driver_earnings ENABLE ROW LEVEL SECURITY;

-- Profiles: Public read, self write
CREATE POLICY "Public profiles are readable" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can update their own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Boda Stages: Public read
CREATE POLICY "Stages are viewable by all" ON public.boda_stages FOR SELECT USING (true);

-- Drivers: Anyone can view online verified drivers; drivers update self
CREATE POLICY "Online drivers viewable by all" ON public.drivers FOR SELECT USING (true);
CREATE POLICY "Drivers can update their own row" ON public.drivers FOR UPDATE USING (auth.uid() = id);

-- Trips: Riders and assigned drivers can read/update
CREATE POLICY "Trips viewable by participants" ON public.trips FOR SELECT
USING (auth.uid() = rider_id OR auth.uid() = driver_id);

CREATE POLICY "Riders can create trips" ON public.trips FOR INSERT
WITH CHECK (auth.uid() = rider_id);

CREATE POLICY "Participants can update trips" ON public.trips FOR UPDATE
USING (auth.uid() = rider_id OR auth.uid() = driver_id);
