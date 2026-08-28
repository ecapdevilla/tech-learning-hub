import { NextRequest, NextResponse } from "next/server";
import { gradingRepository } from "@/modules/grading/data/gradingRepository";
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
      message: "SUPABASE_SERVICE_ROLE_KEY no está configurada en Vercel.",
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
      message: "Error al leer Supabase:",
      error: subjErr?.message || perErr?.message || "desconocido",
      subjects: [],
      periods: [],
    });
  }

  return NextResponse.json({
    configured: true,
    message: "",
    subjects: subjects ?? [],
    periods: periods ?? [],
  });
}