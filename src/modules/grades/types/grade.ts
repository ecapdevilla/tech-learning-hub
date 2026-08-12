export type GradeId = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11;

export type SchoolLevel = "primary" | "secondary";

export type Grade = {
  id: GradeId;
  label: string;
  description: string;
  level: SchoolLevel;
};

const validGradeIds: GradeId[] = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
];

export function isGradeId(value: number): value is GradeId {
  return validGradeIds.includes(value as GradeId);
}
