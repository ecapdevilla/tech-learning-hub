import type { LessonSummary } from "@/modules/lessons/types/lesson";
import type { LessonRepository } from "@/modules/lessons/services/lessonRepository";

export type LessonService = {
  getLessons(): LessonSummary[];
  getLessonById(id: string): LessonSummary | undefined;
  getLessonsByGrade(grade: number): LessonSummary[];
};

export function createLessonService(repo: LessonRepository): LessonService {
  return {
    getLessons: () => repo.getLessons(),
    getLessonById: (id: string) => repo.getLessonById(id),
    getLessonsByGrade: (grade: number) => repo.getLessonsByGrade(grade),
  };
}
