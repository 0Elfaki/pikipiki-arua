import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { corsHeaders } from "../_shared/cors.ts"
import { createSupabaseAdminClient } from "../_shared/supabaseAdmin.ts"
import { attemptDispatch } from "../_shared/dispatchMatching.ts"

// A driver's response to an offered trip. 'accept' confirms the match.
// 'decline'/'timeout' releases the trip and immediately re-runs the matching
// engine so it is offered to the next-nearest eligible driver, without the
// rider having to re-request.
serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders })
  }

  try {
    const { trip_id, driver_id, action } = await req.json()

    if (!trip_id || !driver_id || !["accept", "decline", "timeout"].includes(action)) {
      return new Response(
        JSON.stringify({
          error: "trip_id, driver_id and action ('accept'|'decline'|'timeout') are required",
        }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 },
      )
    }

    const supabase = createSupabaseAdminClient()

    const { data: trip, error: tripError } = await supabase
      .from("trips")
      .select("id, status, driver_id")
      .eq("id", trip_id)
      .single()

    if (tripError || !trip) {
      return new Response(JSON.stringify({ error: "trip_not_found" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 404,
      })
    }

    if (trip.status !== "searching" || trip.driver_id !== driver_id) {
      // Someone else already accepted/declined this offer, or it expired.
      return new Response(JSON.stringify({ error: "offer_no_longer_valid", trip }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 409,
      })
    }

    const { data: offer } = await supabase
      .from("trip_dispatch_offers")
      .select("id")
      .eq("trip_id", trip_id)
      .eq("driver_id", driver_id)
      .eq("status", "offered")
      .order("offered_at", { ascending: false })
      .limit(1)
      .maybeSingle()

    if (action === "accept") {
      if (offer) {
        await supabase
          .from("trip_dispatch_offers")
          .update({ status: "accepted", responded_at: new Date().toISOString() })
          .eq("id", offer.id)
      }
      await supabase.from("trips").update({ status: "accepted" }).eq("id", trip_id)

      return new Response(JSON.stringify({ trip_id, status: "accepted", driver_id }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      })
    }

    // decline / timeout: mark this offer resolved, clear driver_id, then try
    // the next-nearest candidate (excluding everyone already offered).
    if (offer) {
      await supabase
        .from("trip_dispatch_offers")
        .update({
          status: action === "timeout" ? "expired" : "declined",
          responded_at: new Date().toISOString(),
        })
        .eq("id", offer.id)
    }
    await supabase.from("trips").update({ status: "requested", driver_id: null }).eq("id", trip_id)

    const result = await attemptDispatch(supabase, trip_id)

    console.log(
      `[Dispatch] trip=${trip_id} driver=${driver_id} ${action} -> matched=${result.matched} next=${result.driverId ?? "-"}`,
    )

    return new Response(JSON.stringify({ trip_id, driver_responded: driver_id, action, ...result }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: (error as Error).message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    })
  }
})
