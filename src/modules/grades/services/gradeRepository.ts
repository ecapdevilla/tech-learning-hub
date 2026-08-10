import type { Grade, GradeId } from "@/modules/grades/types/grade";

export interface GradeRepository {
  getGrades(): Grade[];
  getGradeById(id: GradeId): Grade | undefined;
}
