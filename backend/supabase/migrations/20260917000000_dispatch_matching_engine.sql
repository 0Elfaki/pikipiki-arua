-- ==============================================================================
-- Pikipiki Arua: Dispatch & Matching Engine
-- Adds a PostGIS nearest-eligible-driver RPC and a dispatch-offer audit trail,
-- used by the dispatch-webhook / dispatch-respond Edge Functions to replace
-- the previous stub/demo matching with real driver assignment.
-- ==============================================================================

-- 1. Dispatch offer audit trail.
-- Records every driver a trip was offered to, so a decline/timeout can move
-- on to the next-nearest candidate instead of re-offering the same driver,
-- and so accept/decline/timeout rates can be measured later (see docs'
-- Telemetry & Logging requirements).
CREATE TABLE IF NOT EXISTS public.trip_dispatch_offers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trip_id UUID NOT NULL REFERENCES public.trips(id) ON DELETE CASCADE,
    driver_id UUID NOT NULL REFERENCES public.drivers(id) ON DELETE CASCADE,
    distance_km NUMERIC(6, 2),
    status TEXT NOT NULL DEFAULT 'offered'
        CHECK (status IN ('offered', 'accepted', 'declined', 'expired')),
    offered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    responded_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_dispatch_offers_trip ON public.trip_dispatch_offers(trip_id);
CREATE INDEX IF NOT EXISTS idx_dispatch_offers_driver ON public.trip_dispatch_offers(driver_id, status);

ALTER TABLE public.trip_dispatch_offers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Participants can view dispatch offers" ON public.trip_dispatch_offers FOR SELECT
USING (
    auth.uid() = driver_id
    OR EXISTS (
        SELECT 1 FROM public.trips t
        WHERE t.id = trip_dispatch_offers.trip_id AND t.rider_id = auth.uid()
    )
);
-- No INSERT/UPDATE policy: all writes happen from the Edge Functions using
-- the service-role key, which bypasses RLS. This keeps the matching engine
-- as the single source of truth for who a trip has been offered to.

-- 2. Nearest eligible driver RPC.
-- Ranks online, verified drivers within p_radius_km of the pickup point,
-- excluding any driver already offered this trip. Distance is computed in
-- meters via geography and returned in km.
CREATE OR REPLACE FUNCTION public.find_nearest_eligible_drivers(
    p_pickup_lat DOUBLE PRECISION,
    p_pickup_lng DOUBLE PRECISION,
    p_radius_km NUMERIC DEFAULT 5,
    p_exclude_driver_ids UUID[] DEFAULT ARRAY[]::UUID[],
    p_limit INT DEFAULT 5
)
RETURNS TABLE (
    driver_id UUID,
    distance_km NUMERIC
)
LANGUAGE sql
STABLE
AS $$
    SELECT
        d.id AS driver_id,
        ROUND((
            ST_Distance(
                d.current_location::geography,
                ST_SetSRID(ST_MakePoint(p_pickup_lng, p_pickup_lat), 4326)::geography
            ) / 1000.0
        )::numeric, 2) AS distance_km
    FROM public.drivers d
    WHERE d.is_online = TRUE
      AND d.verification_status = 'verified'
      AND d.current_location IS NOT NULL
      AND NOT (d.id = ANY (p_exclude_driver_ids))
      AND ST_DWithin(
            d.current_location::geography,
            ST_SetSRID(ST_MakePoint(p_pickup_lng, p_pickup_lat), 4326)::geography,
            p_radius_km * 1000
          )
    ORDER BY
        d.current_location::geography <-> ST_SetSRID(ST_MakePoint(p_pickup_lng, p_pickup_lat), 4326)::geography
    LIMIT p_limit;
$$;

GRANT EXECUTE ON FUNCTION public.find_nearest_eligible_drivers TO service_role;
GRANT EXECUTE ON FUNCTION public.find_nearest_eligible_drivers TO authenticated;

-- 3. Enable Realtime on trips so rider/driver clients can subscribe to
-- dispatch/match updates (status + driver_id changes) as they happen.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'trips'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.trips;
    END IF;
EXCEPTION WHEN undefined_object THEN
    RAISE NOTICE 'supabase_realtime publication not found - enable Realtime for public.trips manually in the Supabase dashboard.';
END $$;
