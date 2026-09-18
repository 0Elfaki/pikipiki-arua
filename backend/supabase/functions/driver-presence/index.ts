import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { corsHeaders } from "../_shared/cors.ts"
import { createSupabaseAdminClient } from "../_shared/supabaseAdmin.ts"

// Updates a driver's online/offline status and/or last-known position.
// Routed through a service-role Edge Function (rather than a direct
// client-side table update) because the driver app currently runs against a
// fixed demo identity with no real Supabase Auth session, so RLS's
// `auth.uid() = id` update policy on `drivers` would otherwise reject the
// write. This keeps `is_online`/`current_location` authoritative for the
// matching engine regardless of the driver app's auth state.
serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders })
  }

  try {
    const { driver_id, is_online, latitude, longitude } = await req.json()

    if (!driver_id) {
      return new Response(JSON.stringify({ error: "driver_id is required" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      })
    }

    // deno-lint-ignore no-explicit-any
    const patch: Record<string, any> = {}
    if (typeof is_online === "boolean") patch.is_online = is_online
    if (typeof latitude === "number") patch.current_latitude = latitude
    if (typeof longitude === "number") patch.current_longitude = longitude

    if (Object.keys(patch).length === 0) {
      return new Response(JSON.stringify({ error: "nothing to update" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      })
    }

    const supabase = createSupabaseAdminClient()
    const { data, error } = await supabase
      .from("drivers")
      .update(patch)
      .eq("id", driver_id)
      .select()
      .single()

    if (error) throw error

    return new Response(JSON.stringify({ driver: data }), {
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
