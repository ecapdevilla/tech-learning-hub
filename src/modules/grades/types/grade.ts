export const gradeIds = [2, 6, 7, 8, 9, 10, 11] as const;
export type GradeId = (typeof gradeIds)[number];

export function isGradeId(value: unknown): value is GradeId {
  return typeof value === "number" && !Number.isNaN(value) && gradeIds.includes(value as GradeId);
}

export type SchoolLevel = "primary" | "secondary";

export type Grade = {
  id: GradeId;
  label: string;
  description: string;
  level: SchoolLevel;
};