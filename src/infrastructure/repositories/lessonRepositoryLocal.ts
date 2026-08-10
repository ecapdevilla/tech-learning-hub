import { lessons } from "@/content/catalog/lessons";
import type { LessonSummary } from "@/modules/lessons/types/lesson";
import type { LessonRepository } from "@/modules/lessons/services/lessonRepository";

export const lessonRepositoryLocal: LessonRepository = {
  getLessons: () => lessons,
  getLessonById: (id: string) => lessons.find((lesson) => lesson.id === id),
  getLessonsByGrade: (grade: number) => lessons.filter((lesson) => lesson.grade === grade),
};
