import type { Grade } from "@/modules/grades/types/grade";

export const mathGrades: Grade[] = [
  {
    id: 1,
    label: "1st Grade",
    description: "Counting, addition and early algebraic thinking",
    level: "primary",
  },
  {
    id: 2,
    label: "2nd Grade",
    description: "Number sense, place value and problem solving",
    level: "primary",
  },
  {
    id: 3,
    label: "3rd Grade",
    description: "Multiplication, division and spatial reasoning",
    level: "primary",
  },
  {
    id: 4,
    label: "4th Grade",
    description: "Fractions, geometry and measurement concepts",
    level: "primary",
  },
  {
    id: 5,
    label: "5th Grade",
    description: "Decimals, area and data interpretation",
    level: "primary",
  },
  {
    id: 6,
    label: "6th Grade",
    description: "Ratios, expressions and number systems",
    level: "secondary",
  },
  {
    id: 7,
    label: "7th Grade",
    description: "Proportional reasoning and linear equations",
    level: "secondary",
  },
  {
    id: 8,
    label: "8th Grade",
    description: "Functions, exponents and the Pythagorean theorem",
    level: "secondary",
  },
  {
    id: 9,
    label: "9th Grade",
    description: "Algebra, graphing and quadratic thinking",
    level: "secondary",
  },
  {
    id: 10,
    label: "10th Grade",
    description: "Trigonometry, statistics and advanced algebra",
    level: "secondary",
  },
  {
    id: 11,
    label: "11th Grade",
    description: "Calculus foundations, vectors and modeling",
    level: "secondary",
  },
];

export const mathPrimaryGrades = mathGrades.filter(
  (grade) => grade.level === "primary"
);

export const mathSecondaryGrades = mathGrades.filter(
  (grade) => grade.level === "secondary"
);