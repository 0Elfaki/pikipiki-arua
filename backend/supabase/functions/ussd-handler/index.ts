import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { corsHeaders } from "../_shared/cors.ts"

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // USSD Gateway payload from Africa's Talking (*284#)
    const formData = await req.formData()
    const sessionId = formData.get('sessionId')
    const serviceCode = formData.get('serviceCode')
    const phoneNumber = formData.get('phoneNumber')
    const text = (formData.get('text') || '') as string

    let response = ''

    if (text === '') {
      response = `CON Welcome to Pikipiki Arua\n1. Request Boda\n2. Check Fare\n3. Stage Directory`
    } else if (text === '1') {
      response = `CON Select Pickup Stage:\n1. Arua Market\n2. Arua Hill\n3. Muni University\n4. Onduparaka`
    } else if (text.startsWith('1*')) {
      response = `END Boda request received! The nearest verified driver will call you shortly.`
    } else if (text === '2') {
      response = `CON Standard Arua Town trip: 2,000 - 3,500 UGX\nPress 1 to Book`
    } else {
      response = `END Thank you for using Pikipiki Arua.`
    }

    return new Response(response, {
      headers: { ...corsHeaders, 'Content-Type': 'text/plain' },
      status: 200,
    })
  } catch (error) {
    return new Response(`END Error processing USSD: ${error.message}`, {
      headers: { ...corsHeaders, 'Content-Type': 'text/plain' },
      status: 200,
    })
  }
})
