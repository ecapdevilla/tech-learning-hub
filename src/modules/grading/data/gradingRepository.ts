import { getGradingAdminClient, gradingConfigured } from "@/modules/grading/data/supabase";
import type {
  Grade,
  GradeDimension,
  GradeRow,
  Period,
  Student,
  StudentComputed,
  Subject,
} from "@/modules/grading/types/grading";
import { ENTRADAS, WEIGHTS } from "@/modules/grading/types/grading";

export interface GradingRepository {
  isConfigured(): boolean;
  getSubjects(): Promise<Subject[]>;
  getPeriods(): Promise<Period[]>;
  getStudents(grade: number, classroom: string): Promise<Student[]>;
  getDimensions(): Promise<GradeDimension[]>;
  getGrades(dimensionIds: string[]): Promise<GradeRow[]>;
  ensureDimensions(subjectId: string, periodId: string): Promise<void>;
  saveGrades(
    rows: { student_id: string; dimension_id: string; entrega_index: number; value: number | null }[]
  ): Promise<boolean>;
  getSelfAssessmentNotes(grade: number, classroom: string): Promise<{ first_name: string; last_name: string; nota: number }[]>;
}

export const gradingRepository: GradingRepository = {
  isConfigured: gradingConfigured,

  async getSubjects() {
    const c = getGradingAdminClient();
    if (!c) return [];
    const { data } = await c.from("subjects").select("*").order("name");
    return (data ?? []) as Subject[];
  },

  async getPeriods() {
    const c = getGradingAdminClient();
    if (!c) return [];
    const { data } = await c.from("periods").select("*").order("academic_year", { ascending: false });
    return (data ?? []) as Period[];
  },

  async getStudents(grade, classroom) {
    const c = getGradingAdminClient();
    if (!c) return [];
    const { data } = await c
      .from("grading_students")
      .select("*")
      .eq("grade", grade)
      .eq("classroom", classroom)
      .order("last_name", { ascending: true });
    return (data ?? []) as Student[];
  },

  async getDimensions() {
    const c = getGradingAdminClient();
    if (!c) return [];
    const { data } = await c.from("grade_dimensions").select("*");
    return (data ?? []) as GradeDimension[];
  },

  async getGrades(dimensionIds) {
    const c = getGradingAdminClient();
    if (!c || dimensionIds.length === 0) return [];
    const { data } = await c.from("grades").select("*").in("dimension_id", dimensionIds);
    return (data ?? []) as GradeRow[];
  },

  async ensureDimensions(subjectId, periodId) {
    const c = getGradingAdminClient();
    if (!c) return;
    const { data } = await c
      .from("grade_dimensions")
      .select("id,dimension")
      .eq("subject_id", subjectId)
      .eq("period_id", periodId);
    const existing = new Set((data ?? []).map((d) => d.dimension as Grade));
    const toCreate = (Object.keys(ENTRADAS) as Grade[]).filter((dim) => !existing.has(dim));
    if (toCreate.length > 0) {
      await c.from("grade_dimensions").insert(
        toCreate.map((dim) => ({
          subject_id: subjectId,
          period_id: periodId,
          dimension: dim,
          entregas_count: ENTRADAS[dim],
        }))
      );
    }
  },

  async saveGrades(rows) {
    const c = getGradingAdminClient();
    if (!c || rows.length === 0) return false;
    const { error } = await c.from("grades").upsert(
      rows.map((r) => ({
        student_id: r.student_id,
        dimension_id: r.dimension_id,
        entrega_index: r.entrega_index,
        value: r.value,
      })),
      { onConflict: "student_id,dimension_id,entrega_index" }
    );
    return !error;
  },

  async getSelfAssessmentNotes(grade, classroom) {
    const c = getGradingAdminClient();
    if (!c) return [];
    const { data } = await c
      .from("self_assessment_submissions")
      .select("first_name,last_name,nota")
      .eq("grade", grade)
      .eq("classroom", classroom);
    return (data ?? []) as { first_name: string; last_name: string; nota: number }[];
  },
};

// Cálculo: parcial Saber = avg n1..n4; Hacer = avg n1..n4; Ser = avg de 3;
// final = saber*.33 + hacer*.33 + ser*.34.
export function computeStudent(
  student: Student,
  dimensions: GradeDimension[],
  gradeRows: GradeRow[]
): StudentComputed {
  const valores: Record<Grade, (number | null)[]> = {
    saber: Array(ENTRADAS.saber).fill(null),
    hacer: Array(ENTRADAS.hacer).fill(null),
    ser: Array(ENTRADAS.ser).fill(null),
  };

  for (const dim of dimensions) {
    const rows = gradeRows.filter((g) => g.dimension_id === dim.id && g.student_id === student.id);
    for (const row of rows) {
      if (row.entrega_index >= 1 && row.entrega_index <= ENTRADAS[dim.dimension]) {
        valores[dim.dimension][row.entrega_index - 1] = row.value;
      }
    }
  }

  const avg = (arr: (number | null)[]) => {
    const filled = arr.filter((v): v is number => v !== null);
    if (filled.length === 0) return null;
    return filled.reduce((acc, v) => acc + v, 0) / filled.length;
  };

  const parcialSaber = avg(valores.saber);
  const parcialHacer = avg(valores.hacer);
  const parcialSer = avg(valores.ser);
  let notaFinal: number | null = null;
  if (parcialSaber !== null && parcialHacer !== null && parcialSer !== null) {
    notaFinal = parcialSaber * WEIGHTS.saber + parcialHacer * WEIGHTS.hacer + parcialSer * WEIGHTS.ser;
  }

  return {
    student,
    valores,
    parcialSaber,
    parcialHacer,
    parcialSer,
    notaFinal,
  };
}