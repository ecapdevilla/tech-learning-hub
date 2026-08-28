import { NextRequest, NextResponse } from "next/server";
import { getGradingAdminClient } from "@/modules/grading/data/supabase";
import { TEACHER_COOKIE } from "@/app/api/self-assessment/teacher-login/route";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const teacher = request.cookies.get(TEACHER_COOKIE)?.value;
  if (teacher !== "authorized") {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const client = getGradingAdminClient();
  if (!client) {
    return NextResponse.json({
      configured: false,
      msg: "⚠️ SUPABASE_SERVICE_ROLE_KEY no está configurada o mal en Vercel.",
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
      ? `⚠️ La conexión funciona (✅ key OK) pero las tablas están vacías: subjects=${subs.length} · periods=${pers.length}. Ejecuta los INSERT o revisa que sea el proyecto correcto.`
      : `✅ Conexión OK · ${subs.length} materia(s) · ${pers.length} periodo(s).`;

  return NextResponse.json({ configured: true, msg, subjects: subs, periods: pers });
}