export type Grade = "saber" | "hacer" | "ser";

export type Subject = { id: string; name: string; teacher: string };
export type Period = { id: string; academic_year: number; period: number };
export type Student = {
  id: string;
  first_name: string;
  last_name: string;
  grade: number;
  classroom: "blue" | "white" | "red";
};
export type GradeDimension = {
  id: string;
  subject_id: string;
  period_id: string;
  dimension: Grade;
  entregas_count: number;
};
export type GradeRow = {
  id: string;
  student_id: string;
  dimension_id: string;
  entrega_index: number;
  value: number | null;
};

// Pesos fijos para la nota final (33/33/34).
export const WEIGHTS: Record<Grade, number> = { saber: 0.33, hacer: 0.33, ser: 0.34 };
export const ENTRADAS: Record<Grade, number> = { saber: 4, hacer: 4, ser: 3 };

export type StudentComputed = {
  student: Student;
  valores: Record<Grade, (number | null)[]>;
  parcialSaber: number | null;
  parcialHacer: number | null;
  parcialSer: number | null;
  notaFinal: number | null;
};