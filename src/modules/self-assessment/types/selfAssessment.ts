export type SelfAssessmentQuestion = {
  id: number;
  question: string;
};

export type SelfAssessmentScaleRow = {
  total: number;
  nota: number;
  nivel: string;
};

export type SelfAssessmentResult = {
  total: number;
  nota: number;
  nivel: string;
};

export type SelfAssessmentSubmission = {
  grade: number;
  classroom: "blue" | "white" | "red";
  first_name: string;
  last_name: string;
  p1: number;
  p2: number;
  p3: number;
  p4: number;
  p5: number;
  p6: number;
  p7: number;
  p8: number;
  p9: number;
  p10: number;
  p11: number;
  total: number;
  nota: number;
  nivel: string;
  created_at?: string;
};

export const SELF_ASSESSMENT_MIN = 11;
export const SELF_ASSESSMENT_MAX = 44;