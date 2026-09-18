// Shared dispatch/matching logic used by both dispatch-webhook (initial
// dispatch after a trip is requested) and dispatch-respond (re-dispatch to
// the next-nearest driver after a decline/timeout). Keeping this in one
// place means there is exactly one implementation of "who gets offered this
// trip next" - never duplicated per code path.

// deno-lint-ignore no-explicit-any
type SupabaseClient = any

const MATCH_RADIUS_KM = 5

export interface DispatchResult {
  matched: boolean
  tripId: string
  driverId?: string
  distanceKm?: number
  reason?: string
}

export async function attemptDispatch(
  supabase: SupabaseClient,
  tripId: string,
): Promise<DispatchResult> {
  const { data: trip, error: tripError } = await supabase
    .from("trips")
    .select("id, status, pickup_latitude, pickup_longitude")
    .eq("id", tripId)
    .single()

  if (tripError || !trip) {
    return { matched: false, tripId, reason: "trip_not_found" }
  }

  if (!["requested", "searching"].includes(trip.status)) {
    return { matched: false, tripId, reason: `trip_not_dispatchable:${trip.status}` }
  }

  const { data: priorOffers, error: priorOffersError } = await supabase
    .from("trip_dispatch_offers")
    .select("driver_id")
    .eq("trip_id", tripId)

  if (priorOffersError) throw priorOffersError

  const excludeIds = (priorOffers ?? []).map((o: { driver_id: string }) => o.driver_id)

  const { data: candidates, error: matchError } = await supabase.rpc(
    "find_nearest_eligible_drivers",
    {
      p_pickup_lat: trip.pickup_latitude,
      p_pickup_lng: trip.pickup_longitude,
      p_radius_km: MATCH_RADIUS_KM,
      p_exclude_driver_ids: excludeIds,
      p_limit: 1,
    },
  )

  if (matchError) throw matchError

  const candidate = candidates?.[0]

  if (!candidate) {
    await supabase.from("trips").update({ status: "requested", driver_id: null }).eq("id", tripId)
    return { matched: false, tripId, reason: "no_drivers_available" }
  }

  const { error: offerError } = await supabase.from("trip_dispatch_offers").insert({
    trip_id: tripId,
    driver_id: candidate.driver_id,
    distance_km: candidate.distance_km,
    status: "offered",
  })
  if (offerError) throw offerError

  const { error: updateError } = await supabase
    .from("trips")
    .update({ status: "searching", driver_id: candidate.driver_id })
    .eq("id", tripId)
  if (updateError) throw updateError

  return {
    matched: true,
    tripId,
    driverId: candidate.driver_id,
    distanceKm: candidate.distance_km,
  }
}
