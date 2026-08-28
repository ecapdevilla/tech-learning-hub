import { NextRequest, NextResponse } from "next/server";
import * as XLSX from "xlsx";
import { gradingRepository } from "@/modules/grading/data/gradingRepository";
import { TEACHER_COOKIE } from "@/app/api/self-assessment/teacher-login/route";
import { isGradeId } from "@/modules/grades/types/grade";
import { isValidClassroom } from "@/modules/student-projects/services/studentProjectService";
import { ENTRADAS, type Grade } from "@/modules/grading/types/grading";

export const dynamic = "force-dynamic";

const norm = (s: string) =>
  s
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/\s+/g, " ")
    .trim();

export async function POST(request: NextRequest) {
  const teacher = request.cookies.get(TEACHER_COOKIE)?.value;
  if (teacher !== "authorized") {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const form = await request.formData();
  const file = form.get("file");
  const subjectId = (form.get("subject") as string) ?? "";
  const periodId = (form.get("period") as string) ?? "";
  const grade = Number(form.get("grade"));
  const classroom = (form.get("classroom") as string) ?? "";

  if (!(file instanceof File) || !isGradeId(grade) || !isValidClassroom(grade, classroom)) {
    return NextResponse.json({ error: "bad_request" }, { status: 400 });
  }

  const buf = Buffer.from(await file.arrayBuffer());
  const wb = XLSX.read(buf, { type: "buffer" });
  const ws = wb.Sheets[wb.SheetNames[0]];
  const rows = XLSX.utils.sheet_to_json<Record<string, unknown>>(ws, { defval: "" });

  // Buscar la fila que tiene Nombre Completo en la primera columna y las notas en las siguientes.
  // Formato del export: [N°, Nombre Completo, Saber n1..4, Parcial Saber, Hacer n1..4, Parcial Hacer, Ser n1..3, Parcial Ser, Nota final]
  // El import espera las celdas de notas sin encabezados complejos; por simplicidad, busca por nombre en cada fila y las columnas 2.. en adelante.

  // Cargar estudiantes del salón para mapear por nombre.
  await gradingRepository.ensureDimensions(subjectId, periodId);
  const dims = (await gradingRepository.getDimensions()).filter(
    (d) => d.subject_id === subjectId && d.period_id === periodId
  );
  const dimByGrade = Object.fromEntries(dims.map((d) => [d.dimension, d.id])) as Record<Grade, string>;

  const students = await gradingRepository.getStudents(grade, classroom);
  const studentsByNorm = new Map<string, { id: string }>();
  for (const s of students) {
    const key = norm(`${s.last_name} ${s.first_name}`);
    if (!studentsByNorm.has(key)) studentsByNorm.set(key, s);
  }

  // Parse: cada fila debe tener el nombre. El orden de valores esperados (índices) es:
  // 0:N°, 1:nombre, 2..(2+4-1):saber, (2+4):parcialSaber, (2+5)..(2+5+4-1):hacer, ... etc.
  const saberCount = ENTRADAS.saber;
  const hacerCount = ENTRADAS.hacer;
  const serCount = ENTRADAS.ser;
  const oSaber = 2;
  const oSaberP = oSaber + saberCount;
  const oHacer = oSaberP + 1;
  const oHacerP = oHacer + hacerCount;
  const oSer = oHacerP + 1;
  const oSerP = oSer + serCount;

  const flat: { person: string; dim: Grade; index: number; value: number | null }[] = [];

  for (const row of rows) {
    const values = Object.values(row);
    const nombre = String(values[1] ?? "").trim();
    if (!nombre) continue;
    const personKey = norm(nombre);
    const student = studentsByNorm.get(personKey);
    if (!student) continue;

    const read = (idx: number): number | null => {
      const raw = values[idx];
      if (raw === undefined || raw === null || String(raw).trim() === "") return null;
      const n = Number(String(raw).replace(",", "."));
      if (Number.isNaN(n)) return null;
      return Number(n.toFixed(1));
    };

    for (let i = 0; i < saberCount; i++) {
      const v = read(oSaber + i);
      if (v !== null) flat.push({ person: student.id, dim: "saber", index: i + 1, value: v });
    }
    for (let i = 0; i < hacerCount; i++) {
      const v = read(oHacer + i);
      if (v !== null) flat.push({ person: student.id, dim: "hacer", index: i + 1, value: v });
    }
    for (let i = 0; i < serCount; i++) {
      const v = read(oSer + i);
      if (v !== null) flat.push({ person: student.id, dim: "ser", index: i + 1, value: v });
    }
  }

  if (flat.length === 0) {
    return NextResponse.json({ error: "no_data", message: "No se encontraron notas para importar (revisa el formato del archivo)." }, { status: 422 });
  }

  await gradingRepository.saveGrades(
    flat.map((f) => ({
      student_id: f.person,
      dimension_id: dimByGrade[f.dim],
      entrega_index: f.index,
      value: f.value,
    }))
  );

  return NextResponse.json({ ok: true, imported: flat.length });
}