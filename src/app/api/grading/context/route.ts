import { NextRequest, NextResponse } from "next/server";
import { getGradingAdminClient, serviceRoleRef, serviceRoleRole, projectUrl } from "@/modules/grading/data/supabase";
import { TEACHER_COOKIE } from "@/app/api/self-assessment/teacher-login/route";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const teacher = request.cookies.get(TEACHER_COOKIE)?.value;
  if (teacher !== "authorized") {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL ?? "";
  const keyRef = serviceRoleRef();
  const keyRole = serviceRoleRole();

  const client = getGradingAdminClient();
  if (!client) {
    return NextResponse.json({
      configured: false,
      msg: `⚠️ SUPABASE_SERVICE_ROLE_KEY no configurada o mal. URL: ${url} · key ref: ${keyRef} · role: ${keyRole}`,
      url,
      subjects: [],
      periods: [],
    });
  }

  const { data: subjects, error: subjErr } = await client
    .from("subjects")
    .select("*")
    .order("name");
  const { data: periods, error: perErr } = await client
    .from("periods")
    .select("*")
    .order("academic_year", { ascending: false });

  if (subjErr || perErr) {
    return NextResponse.json({
      configured: true,
      msg: `⚠️ Error al leer Supabase: ${subjErr?.message || perErr?.message}`,
      subjects: [],
      periods: [],
    });
  }

  const subs = subjects ?? [];
  const pers = periods ?? [];
  const refMatch = keyRef === "fpbffoqqkbgqijvxjihs" ? "SÍ" : "NO";
  const msg =
    subs.length === 0 || pers.length === 0
      ? `❌ URL=${url} · key ref=${keyRef} (${refMatch}) · role=${keyRole} → La conexión funciona pero subjects=${subs.length} · periods=${pers.length} (datos vacíos). La service_role key NO corresponde al proyecto donde están los datos.`
      : `✅ Conexión OK · ${subs.length} materia(s) · ${pers.length} periodo(s).`;

  return NextResponse.json({ configured: true, msg, url, keyRef, keyRole, subjects: subs, periods: pers });
}