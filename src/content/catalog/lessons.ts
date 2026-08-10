import type { LessonSummary } from "@/modules/lessons/types/lesson";

export const lessons: LessonSummary[] = [
  {
    id: "grade-02-cycle-3-algorithms",
    grade: 2,
    cycle: 3,
    title: {
      en: "Little Programmers",
      es: "Pequeños Programadores",
    },
    objective: {
      en: "Understand algorithms through ordered steps, routes and games.",
      es: "Comprender algoritmos mediante pasos ordenados, rutas y juegos.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-02/algorithms-games.html",
    tags: ["Algorithms", "Games", "Sequences", "Arrows"],
  },
  {
    id: "grade-06-cycle-3-code-creators",
    grade: 6,
    cycle: 3,
    title: {
      en: "Code Creators",
      es: "Creadores de Código",
    },
    objective: {
      en: "Design an interactive solution through algorithms and programming concepts.",
      es: "Diseñar una solución interactiva mediante algoritmos y conceptos de programación.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-06/code-creators-cycle-3.html",
    tags: ["Algorithms", "Scratch", "Prototype", "Teamwork"],
  },
  {
    id: "grade-08-cycle-3-data-ai-community",
    grade: 8,
    cycle: 3,
    title: {
      en: "Data Science & AI for Community Change",
      es: "Ciencia de Datos e Inteligencia Artificial para Transformar mi Comunidad",
    },
    objective: {
      en: "Build a data analysis project that uses spreadsheets, visualization and AI to solve a real school or community problem.",
      es: "Desarrollar un proyecto de análisis de datos que use hojas de cálculo, visualizaciones e IA para resolver un problema real en la escuela o comunidad.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-08/data-ai-community.html",
    tags: ["Data", "AI", "Spreadsheets", "Sustainability"],
  },
  {
    id: "grade-09-cycle-3-my-first-web-page",
    grade: 9,
    cycle: 3,
    title: {
      en: "My First Web Page",
      es: "Mi Primera Página Web",
    },
    objective: {
      en: "Create a web page from scratch using HTML for structure, CSS for design and JavaScript for interaction.",
      es: "Crear una página web desde cero usando HTML para la estructura, CSS para el diseño y JavaScript para la interacción.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-09/my-first-web-page-cycle-3.html",
    tags: ["HTML", "CSS", "JavaScript", "VS Code"],
  },
  {
    id: "grade-10-cycle-3-loops-arrays",
    grade: 10,
    cycle: 3,
    title: {
      en: "Loops & Arrays",
      es: "Bucles y Arreglos",
    },
    objective: {
      en: "Apply loops and arrays to create a dice simulator or interactive table.",
      es: "Aplicar bucles y arreglos para crear un simulador de dados o una tabla interactiva.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-10/loops-arrays-mvc.html",
    tags: ["HTML", "CSS", "JavaScript", "MVC"],
  },
  {
    id: "grade-10-cycle-3-code-for-change",
    grade: 10,
    cycle: 3,
    title: {
      en: "Code for Change",
      es: "Code for Change",
    },
    objective: {
      en: "Design and present an interactive web app that solves a real school or community problem using JavaScript, HTML, and CSS.",
      es: "Diseñar, desarrollar y presentar una aplicación web interactiva que resuelva un problema real de la escuela o comunidad usando JavaScript, HTML y CSS.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-10/code-for-change.html",
    tags: ["HTML", "CSS", "JavaScript", "ODS", "STEM"],
  },
  {
    id: "grade-11-cycle-3-esp32-wifi",
    grade: 11,
    cycle: 3,
    title: {
      en: "ESP32 WiFi Communication",
      es: "Comunicación WiFi con ESP32",
    },
    objective: {
      en: "Implement wireless communication with Wokwi and send/receive data.",
      es: "Implementar comunicación inalámbrica con Wokwi y enviar/recibir datos.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-11/esp32-wifi-wokwi.html",
    tags: ["ESP32", "Wokwi", "WiFi", "IoT"],
  },
];