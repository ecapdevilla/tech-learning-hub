import { NextRequest, NextResponse } from "next/server";
import { gradingRepository } from "@/modules/grading/data/gradingRepository";
import { TEACHER_COOKIE } from "@/app/api/self-assessment/teacher-login/route";
import type { Grade } from "@/modules/grading/types/grading";

export const dynamic = "force-dynamic";

export async function POST(request: NextRequest) {
  const teacher = request.cookies.get(TEACHER_COOKIE)?.value;
  if (teacher !== "authorized") {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const body = (await request.json()) as {
    subject_id: string;
    period_id: string;
    rows: { student_id: string; dimension: Grade; entrega_index: number; value: number | null }[];
  };
  if (!body.subject_id || !body.period_id || !Array.isArray(body.rows)) {
    return NextResponse.json({ error: "bad_request" }, { status: 400 });
  }

  await gradingRepository.ensureDimensions(body.subject_id, body.period_id);
  const dims = (await gradingRepository.getDimensions()).filter(
    (d) => d.subject_id === body.subject_id && d.period_id === body.period_id
  );
  const dimByGrade = Object.fromEntries(dims.map((d) => [d.dimension, d.id])) as Record<
    Grade,
    string
  >;

  const mapped = body.rows.map((r) => ({
    student_id: r.student_id,
    dimension_id: dimByGrade[r.dimension],
    entrega_index: r.entrega_index,
    value: r.value,
  }));

  const ok = await gradingRepository.saveGrades(mapped);
  if (!ok) return NextResponse.json({ error: "save_failed" }, { status: 500 });
  return NextResponse.json({ ok: true });
}