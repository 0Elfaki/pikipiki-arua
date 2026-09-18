import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

// SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are automatically injected into
// every Edge Function's environment by the Supabase platform - no need to
// set them manually in .env / project secrets.
export function createSupabaseAdminClient() {
  const supabaseUrl = Deno.env.get("SUPABASE_URL")
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")

  if (!supabaseUrl || !serviceRoleKey) {
    throw new Error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY environment variables")
  }

  return createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  })
}
