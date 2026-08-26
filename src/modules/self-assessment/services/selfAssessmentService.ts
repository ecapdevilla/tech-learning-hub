import type {
  SelfAssessmentResult,
  SelfAssessmentScaleRow,
} from "@/modules/self-assessment/types/selfAssessment";
import { SELF_ASSESSMENT_MAX, SELF_ASSESSMENT_MIN } from "@/modules/self-assessment/types/selfAssessment";

export function sumAnswers(p: number[]): number {
  return p.reduce((acc, value) => acc + value, 0);
}

export function toResult(total: number, scale: SelfAssessmentScaleRow[]): SelfAssessmentResult | null {
  if (total < SELF_ASSESSMENT_MIN || total > SELF_ASSESSMENT_MAX) return null;
  const row = scale.find((s) => s.total === total);
  if (!row) return null;
  return { total: row.total, nota: Number(row.nota), nivel: row.nivel };
}