import type { Grade, GradeId } from "@/modules/grades/types/grade";
import type { GradeRepository } from "@/modules/grades/services/gradeRepository";

export type GradeService = {
  getGrades(): Grade[];
  getGradeById(id: GradeId): Grade | undefined;
};

export function createGradeService(repo: GradeRepository): GradeService {
  return {
    getGrades: () => repo.getGrades(),
    getGradeById: (id: GradeId) => repo.getGradeById(id),
  };
}
