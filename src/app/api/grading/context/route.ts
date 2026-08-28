import { NextRequest, NextResponse } from "next/server";
import { getGradingAdminClient } from "@/modules/grading/data/supabase";
import { TEACHER_COOKIE } from "@/app/api/self-assessment/teacher-login/route";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const teacher = request.cookies.get(TEACHER_COOKIE)?.value;
  if (teacher !== "authorized") {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL ?? "";

  const client = getGradingAdminClient();
  if (!client) {
    return NextResponse.json({
      configured: false,
      msg: `⚠️ SUPABASE_SERVICE_ROLE_KEY no está configurada o mal en Vercel. URL: ${url}`,
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
  const msg =
    subs.length === 0 || pers.length === 0
      ? `⚠️ Conectado a: ${url} · La conexión funciona pero subjects=${subs.length} · periods=${pers.length}. Si esto está vacío, la clave apunta a un proyecto distinto del que insertó los datos.`
      : `✅ Conexión OK (${url}) · ${subs.length} materia(s) · ${pers.length} periodo(s).`;

  return NextResponse.json({ configured: true, msg, url, subjects: subs, periods: pers });
}