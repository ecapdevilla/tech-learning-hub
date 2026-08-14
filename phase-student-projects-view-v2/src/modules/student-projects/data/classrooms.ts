import type { Classroom } from "@/modules/student-projects/types/studentProject";

export const classroomsByGrade: Record<number, Classroom[]> = {
  6: ["blue", "white", "red"],
  7: ["blue", "white", "red"],
  8: ["blue", "white"],
  9: ["blue", "white"],
  10: ["blue", "white", "red"],
  11: ["blue", "white"],
};

export const gradeLabels: Record<number, string> = {
  6: "6th Grade",
  7: "7th Grade",
  8: "8th Grade",
  9: "9th Grade",
  10: "10th Grade",
  11: "11th Grade",
};
