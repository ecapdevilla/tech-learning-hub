import { createClient, SupabaseClient } from "@supabase/supabase-js";

const url = process.env.NEXT_PUBLIC_SUPABASE_URL ?? "";
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";

let admin: SupabaseClient | null = null;

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

// Decodifica el payload del JWT para saber a QUIÉN pertenece la service_role key.
// El campo "ref" es el id del proyecto de Supabase.
export function serviceRoleRef(): string {
  try {
    const payload = serviceRoleKey.split(".")[1];
    const json = JSON.parse(Buffer.from(payload, "base64url").toString("utf8"));
    return (json as { ref?: string }).ref ?? "";
  } catch {
    return "";
  }
}

export function serviceRoleRole(): string {
  try {
    const payload = serviceRoleKey.split(".")[1];
    const json = JSON.parse(Buffer.from(payload, "base64url").toString("utf8"));
    return (json as { role?: string }).role ?? "";
  } catch {
    return "";
  }
}

export function projectUrl(): string {
  return url;
}