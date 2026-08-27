import { getSelfAssessmentAdminClient, getSelfAssessmentClient } from "@/modules/self-assessment/data/supabase";
import type {
  SelfAssessmentQuestion,
  SelfAssessmentScaleRow,
  SelfAssessmentSubmission,
} from "@/modules/self-assessment/types/selfAssessment";

export interface SelfAssessmentRepository {
  isConfigured(): boolean;
  isAdminConfigured(): boolean;
  getQuestions(): Promise<SelfAssessmentQuestion[]>;
  getScale(): Promise<SelfAssessmentScaleRow[]>;
  getSubmissions(grade: number, classroom: string): Promise<SelfAssessmentSubmission[]>;
  saveSubmission(
    submission: Omit<SelfAssessmentSubmission, "total" | "nota" | "nivel"> &
      Partial<Pick<SelfAssessmentSubmission, "total" | "nota" | "nivel">>
  ): Promise<boolean>;
}

export const selfAssessmentRepository: SelfAssessmentRepository = {
  isConfigured() {
    return getSelfAssessmentClient() !== null;
  },

  isAdminConfigured() {
    return getSelfAssessmentAdminClient() !== null;
  },

  async getQuestions() {
    const client = getSelfAssessmentClient();
    if (!client) return [];
    const { data, error } = await client
      .from("self_assessment_questions")
      .select("id, question")
      .order("id", { ascending: true });
    if (error || !data) return [];
    return data as SelfAssessmentQuestion[];
  },

  async getScale() {
    const client = getSelfAssessmentClient();
    if (!client) return [];
    const { data, error } = await client
      .from("self_assessment_scale")
      .select("total, nota, nivel")
      .order("total", { ascending: true });
    if (error || !data) return [];
    return data as SelfAssessmentScaleRow[];
  },

  async getSubmissions(grade: number, classroom: string) {
    // Usamos el cliente admin (service role) en el servidor para leer resultados.
    const client = getSelfAssessmentAdminClient() ?? getSelfAssessmentClient();
    if (!client) return [];
    const { data, error } = await client
      .from("self_assessment_submissions")
      .select("*")
      .eq("grade", grade)
      .eq("classroom", classroom)
      .order("last_name", { ascending: true });
    if (error || !data) return [];
    return data as SelfAssessmentSubmission[];
  },

  async saveSubmission(submission) {
    const client = getSelfAssessmentClient();
    if (!client) return false;
    const { error } = await client.from("self_assessment_submissions").insert(submission);
    return !error;
  },
};