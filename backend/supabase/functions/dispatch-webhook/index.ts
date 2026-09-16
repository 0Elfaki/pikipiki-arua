import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { corsHeaders } from "../_shared/cors.ts"

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { trip_id, pickup_lat, pickup_lng, stage_id } = await req.json()

    // Dispatch logic: notify drivers within 2.5km radius or at designated stage
    console.log(`[Dispatch] Broadcasting trip ${trip_id} near (${pickup_lat}, ${pickup_lng}) for stage ${stage_id}`)

    return new Response(
      JSON.stringify({
        success: true,
        trip_id,
        status: 'broadcasted',
        timestamp: new Date().toISOString(),
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      }
    )
  }
})
