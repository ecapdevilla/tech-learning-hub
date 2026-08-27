import { createClient, SupabaseClient } from "@supabase/supabase-js";

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

let admin: SupabaseClient | null = null;

// Cliente administrativo (solo server / route handlers) con service role.
// El grading NO se expone al cliente: todos los requests pasan por el servidor.
export function getGradingAdminClient(): SupabaseClient | null {
  if (!url || !serviceRoleKey) return null;
  if (!admin) {
    admin = createClient(url, serviceRoleKey, { auth: { persistSession: false } });
  }
  return admin;
}

export function gradingConfigured(): boolean {
  return getGradingAdminClient() !== null;
}