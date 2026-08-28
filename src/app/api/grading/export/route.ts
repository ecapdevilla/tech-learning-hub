import { NextRequest, NextResponse } from "next/server";
import * as XLSX from "xlsx";
import { gradingRepository, computeStudent } from "@/modules/grading/data/gradingRepository";
import { TEACHER_COOKIE } from "@/app/api/self-assessment/teacher-login/route";
import { isGradeId } from "@/modules/grades/types/grade";
import { isValidClassroom } from "@/modules/student-projects/services/studentProjectService";
import { ENTRADAS } from "@/modules/grading/types/grading";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const teacher = request.cookies.get(TEACHER_COOKIE)?.value;
  if (teacher !== "authorized") {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const subjectId = request.nextUrl.searchParams.get("subject") ?? "";
  const periodId = request.nextUrl.searchParams.get("period") ?? "";
  const grade = Number(request.nextUrl.searchParams.get("grade"));
  const classroom = request.nextUrl.searchParams.get("classroom") ?? "";
  if (!isGradeId(grade)) return NextResponse.json({ error: "bad_grade" }, { status: 400 });
  if (!isValidClassroom(grade, classroom)) {
    return NextResponse.json({ error: "bad_classroom" }, { status: 400 });
  }

  await gradingRepository.ensureDimensions(subjectId, periodId);
  const dimensions = (await gradingRepository.getDimensions()).filter(
    (d) => d.subject_id === subjectId && d.period_id === periodId
  );
  const students = await gradingRepository.getStudents(grade, classroom);
  const gradeRows = await gradingRepository.getGrades(dimensions.map((d) => d.id));

  const computed = students.map((s) => computeStudent(s, dimensions, gradeRows));

  // Encabezado de dos filas (estilo institucional):
  // Fila 1: N° | Nombre Completo | SABER (span 5) | HACER (span 5) | SER (span 4) | NOTA FINAL
  // Fila 2:      |                | n1 n2 n3 n4 | Parcial | n1 n2 n3 n4 | Parcial | n1 n2 n3 | Parcial |
  const num = (v: number | null) => (v === null ? "" : Number(v.toFixed(1)));

  const saberCount = ENTRADAS.saber;
  const hacerCount = ENTRADAS.hacer;
  const serCount = ENTRADAS.ser;

  const headerRow1 = [
    "N°",
    "Nombre Completo",
    "SABER",
    ...Array(saberCount + 1).fill(""),
    "HACER",
    ...Array(hacerCount + 1).fill(""),
    "SER",
    ...Array(serCount + 1).fill(""),
    "NOTA FINAL",
  ];

  const headerRow2 = [
    "",
    "",
    ...Array.from({ length: saberCount }, (_, i) => `n${i + 1}`),
    "Parcial",
    ...Array.from({ length: hacerCount }, (_, i) => `n${i + 1}`),
    "Parcial",
    ...Array.from({ length: serCount }, (_, i) => `n${i + 1}`),
    "Parcial",
    "",
  ];

  const dataRows = computed.map((c, i) => [
    i + 1,
    `${c.student.last_name} ${c.student.first_name}`,
    ...c.valores.saber.map(num),
    num(c.parcialSaber),
    ...c.valores.hacer.map(num),
    num(c.parcialHacer),
    ...c.valores.ser.map(num),
    num(c.parcialSer),
    num(c.notaFinal),
  ]);

  const ws = XLSX.utils.aoa_to_sheet([headerRow1, headerRow2, ...dataRows]);
  ws["!cols"] = [{ wch: 4 }, { wch: 30 }, ...Array(16).fill({ wch: 9 })];
  ws["!merges"] = [
    { s: { r: 0, c: 2 }, e: { r: 0, c: 2 + saberCount } }, // SABER (col 2..6)
    { s: { r: 0, c: 3 + saberCount }, e: { r: 0, c: 3 + saberCount + hacerCount } }, // HACER (col 7..11)
    { s: { r: 0, c: 4 + saberCount + hacerCount }, e: { r: 0, c: 4 + saberCount + hacerCount + serCount } }, // SER (col 12..15)
  ];

  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, "Notas");
  const buf = XLSX.write(wb, { type: "buffer", bookType: "xlsx" });

  const filename = `notas-grado${grade}-${classroom}.xlsx`;
  return new NextResponse(buf, {
    status: 200,
    headers: {
      "Content-Type":
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "Content-Disposition": `attachment; filename="${filename}"`,
    },
  });
}