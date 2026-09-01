export type Classroom = "blue" | "white" | "red";

export type StudentProject = {
  id: string;
  slug: string;
  studentName: string;
  grade: number;
  classroom: Classroom;
  period: number;
  cycle: number;
  title: string;
  objective: string;
  description: string;
  skills: string[];
  technologies: string[];
  projectPath?: string;
  evidenceUrl?: string;
  coverImage?: string;
  reflection?: string;
  published: boolean;
  gradeScale?: { min: number; max: number; feedback: string };
};
