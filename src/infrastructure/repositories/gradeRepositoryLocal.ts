import { grades } from "@/content/grades/grades";
import type { Grade, GradeId } from "@/modules/grades/types/grade";
import type { GradeRepository } from "@/modules/grades/services/gradeRepository";

export const gradeRepositoryLocal: GradeRepository = {
  getGrades: () => grades,
  getGradeById: (id: GradeId) => grades.find((grade) => grade.id === id),
};
