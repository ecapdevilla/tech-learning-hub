import type { LocalizedText } from "@/shared/types/i18n";

export type LessonSummary = {
  id: string;
  grade: number;
  cycle: number;
  title: LocalizedText;
  objective: LocalizedText;
  durationMinutes: number;
  guidePath?: string;
  tags: string[];
};
