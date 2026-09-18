import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { corsHeaders } from "../_shared/cors.ts"
import { createSupabaseAdminClient } from "../_shared/supabaseAdmin.ts"
import { attemptDispatch } from "../_shared/dispatchMatching.ts"

// Real dispatch: given a trip_id, finds the nearest online + verified driver
// (PostGIS ST_DWithin/ST_Distance via find_nearest_eligible_drivers) who has
// not already been offered this trip, records the offer, and assigns the
// trip to them (status -> 'searching'). Replaces the previous stub that only
// logged the request without matching anyone.
serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders })
  }

  try {
    const { trip_id } = await req.json()

    if (!trip_id) {
      return new Response(JSON.stringify({ error: "trip_id is required" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      })
    }

    const supabase = createSupabaseAdminClient()
    const result = await attemptDispatch(supabase, trip_id)

    console.log(
      `[Dispatch] trip=${trip_id} matched=${result.matched} driver=${result.driverId ?? "-"} reason=${result.reason ?? "-"}`,
    )

    return new Response(JSON.stringify(result), {
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
