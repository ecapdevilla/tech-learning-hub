import type { Grade } from "@/modules/grades/types/grade";

export const grades: Grade[] = [
  {
    id: 2,
    label: "2nd Grade",
    description: "Algorithms through movement, games and sequences",
    level: "primary",
  },
  {
    id: 6,
    label: "6th Grade",
    description: "Technology and programming foundations",
    level: "secondary",
  },
  {
    id: 7,
    label: "7th Grade",
    description: "Digital creation and problem solving",
    level: "secondary",
  },
  {
    id: 8,
    label: "8th Grade",
    description: "Web and computational thinking",
    level: "secondary",
  },
  {
    id: 9,
    label: "9th Grade",
    description: "HTML, CSS and JavaScript web development",
    level: "secondary",
  },
  {
    id: 10,
    label: "10th Grade",
    description: "JavaScript, loops and arrays",
    level: "secondary",
  },
  {
    id: 11,
    label: "11th Grade",
    description: "IoT, ESP32 and wireless communication",
    level: "secondary",
  },
];

export const primaryGrades = grades.filter(
  (grade) => grade.level === "primary"
);

export const secondaryGrades = grades.filter(
  (grade) => grade.level === "secondary"
);