import { NextRequest, NextResponse } from "next/server";
import { selfAssessmentRepository } from "@/modules/self-assessment/data/selfAssessmentRepository";
import { TEACHER_COOKIE } from "@/app/api/self-assessment/teacher-login/route";
import { isGradeId } from "@/modules/grades/types/grade";
import { isValidClassroom } from "@/modules/student-projects/services/studentProjectService";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const teacher = request.cookies.get(TEACHER_COOKIE)?.value;
  if (teacher !== "authorized") {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const grade = Number(request.nextUrl.searchParams.get("grade"));
  const classroom = request.nextUrl.searchParams.get("classroom") ?? "";
  if (!isGradeId(grade)) return NextResponse.json({ error: "bad_grade" }, { status: 400 });
  if (!isValidClassroom(grade, classroom)) {
    return NextResponse.json({ error: "bad_classroom" }, { status: 400 });
  }

  const rows = await selfAssessmentRepository.getSubmissions(grade, classroom);
  if (!rows) return NextResponse.json({ error: "not_configured" }, { status: 500 });

  const header = [
    "Apellido",
    "Nombre",
    "P1",
    "P2",
    "P3",
    "P4",
    "P5",
    "P6",
    "P7",
    "P8",
    "P9",
    "P10",
    "P11",
    "Total",
    "Nota",
    "Nivel",
  ];

  const escape = (v: string | number) => {
    const s = String(v);
    return /["\n,;]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
  };

  const lines = [
    header.join(","),
    ...rows.map((r) =>
      [
        r.last_name,
        r.first_name,
        r.p1,
        r.p2,
        r.p3,
        r.p4,
        r.p5,
        r.p6,
        r.p7,
        r.p8,
        r.p9,
        r.p10,
        r.p11,
        r.total,
        Number(r.nota).toFixed(1),
        r.nivel,
      ]
        .map(escape)
        .join(",")
    ),
  ];

  const csv = "\uFEFF" + lines.join("\r\n");
  const filename = `autoevaluacion-ciclo6-grado${grade}-${classroom}.csv`;

  return new NextResponse(csv, {
    status: 200,
    headers: {
      "Content-Type": "text/csv; charset=utf-8",
      "Content-Disposition": `attachment; filename="${filename}"`,
    },
  });
}