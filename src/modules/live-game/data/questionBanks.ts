import { grade6Questions } from "./grade6Questions";
import { grade7Questions } from "./grade7Questions";
import { grade8Questions } from "./grade8Questions";
import { grade9Questions } from "./grade9Questions";
import { grade10Questions } from "./grade10Questions";
import { grade11Questions } from "./grade11Questions";
import type { LiveQuestion } from "../types/liveGame";

export const supportedLiveGrades = [6, 7, 8, 9, 10, 11] as const;

export type SupportedLiveGrade = (typeof supportedLiveGrades)[number];

const banks: Record<SupportedLiveGrade, LiveQuestion[]> = {
  6: grade6Questions,
  7: grade7Questions,
  8: grade8Questions,
  9: grade9Questions,
  10: grade10Questions,
  11: grade11Questions,
};

export function getQuestionBank(grade: number): LiveQuestion[] {
  if (supportedLiveGrades.includes(grade as SupportedLiveGrade)) {
    return banks[grade as SupportedLiveGrade];
  }
  return grade6Questions;
}

export const liveGradeMeta: Record<
  SupportedLiveGrade,
  { title: string; subtitle: string; topics: string[] }
> = {
  6: {
    title: "Code Foundations Battle",
    subtitle: "Algorithms · Variables · Conditions · Loops · Debugging",
    topics: ["Algorithms", "Variables", "Conditionals", "Loops", "Debugging"],
  },
  7: {
    title: "Automation Arena",
    subtitle: "Sensors · Actuators · Wokwi · IF/THEN · Testing",
    topics: ["Automation", "Sensors", "Actuators", "Simulation", "Testing"],
  },
  8: {
    title: "Data Battle",
    subtitle: "Data · Charts · Dashboards · Statistics · Insights",
    topics: ["Data", "Charts", "Dashboards", "Statistics", "Data Storytelling"],
  },
  9: {
    title: "MVC Challenge",
    subtitle: "Model · View · Controller · CRUD · Testing",
    topics: ["MVC", "Model", "View", "Controller", "Testing"],
  },
  10: {
    title: "JavaScript Code Arena",
    subtitle: "JavaScript · Arrays · Functions · DOM · MVC · Debugging",
    topics: ["JavaScript", "Arrays", "Functions", "DOM", "MVC", "Debugging"],
  },
  11: {
    title: "IoT Engineering Battle",
    subtitle: "ESP32 · Sensors · WiFi · IoT · Dashboard · Testing",
    topics: ["ESP32", "Sensors", "IoT", "WiFi", "Web Dashboard", "Testing"],
  },
};
