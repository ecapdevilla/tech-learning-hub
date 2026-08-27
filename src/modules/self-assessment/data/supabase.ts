import { createClient, SupabaseClient } from "@supabase/supabase-js";

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

let client: SupabaseClient | null = null;
let adminClient: SupabaseClient | null = null;

export function getSelfAssessmentClient(): SupabaseClient | null {
  if (!url || !anonKey) return null;
  if (!client) {
    client = createClient(url, anonKey);
  }
  return client;
}

// Cliente administrativo (solo server / route handlers) usando service role.
// Evita que el estudiante pueda leer resultados con la key pública (anon).
export function getSelfAssessmentAdminClient(): SupabaseClient | null {
  if (!url || !serviceRoleKey) return null;
  if (!adminClient) {
    adminClient = createClient(url, serviceRoleKey, { auth: { persistSession: false } });
  }
  return adminClient;
}