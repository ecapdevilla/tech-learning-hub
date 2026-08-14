import type { StudentProject } from "@/modules/student-projects/types/studentProject";

export const studentProjects: StudentProject[] = [
  {
    id: "grade-06-red-interactive-surveys",
    slug: "interactive-surveys",
    studentName: "Elisany · Sofía · María Margarita",
    grade: 6,
    classroom: "red",
    period: 3,
    cycle: 4,
    title: "Interactive Surveys",
    objective: "Create interactive web surveys using forms, events, validation and dynamic feedback.",
    description: "A two-part web project with a scored quiz and a preference survey built with HTML, CSS and JavaScript.",
    skills: ["Forms", "DOM", "Events", "Validation", "Conditionals", "Responsive Design"],
    technologies: ["HTML", "CSS", "JavaScript"],
    projectPath: "/student-projects/grade-06/red/interactive-surveys/index.html",
    published: true,
  },
];
