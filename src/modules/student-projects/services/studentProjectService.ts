import { studentProjects } from "@/modules/student-projects/data/projects";
import { classroomsByGrade } from "@/modules/student-projects/data/classrooms";
import type { Classroom } from "@/modules/student-projects/types/studentProject";

export const getPublishedProjects = () =>
  studentProjects.filter((project) => project.published);

export const getProjectsByGrade = (grade: number) =>
  getPublishedProjects().filter((project) => project.grade === grade);

export const getProjectsByClassroom = (grade: number, classroom: Classroom) =>
  getProjectsByGrade(grade).filter((project) => project.classroom === classroom);

export function isValidClassroom(grade: number, classroom: string): classroom is Classroom {
  return classroomsByGrade[grade]?.includes(classroom as Classroom) ?? false;
}
