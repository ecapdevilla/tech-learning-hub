import type { LessonSummary } from "@/modules/lessons/types/lesson";

export interface LessonRepository {
  getLessons(): LessonSummary[];
  getLessonById(id: string): LessonSummary | undefined;
  getLessonsByGrade(grade: number): LessonSummary[];
}
