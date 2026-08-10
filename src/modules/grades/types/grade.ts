export type GradeId = 2 | 6 | 7 | 8 | 9 | 10 | 11;

export type SchoolLevel = "primary" | "secondary";

export type Grade = {
  id: GradeId;
  label: string;
  description: string;
  level: SchoolLevel;
};