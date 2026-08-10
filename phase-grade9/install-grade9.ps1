$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor DarkCyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor DarkCyan
}

function Write-Utf8File {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Content
    )
    process {
        $fullPath = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $Path))
        $directory = [System.IO.Path]::GetDirectoryName($fullPath)

        if (-not [System.IO.Directory]::Exists($directory)) {
            [System.IO.Directory]::CreateDirectory($directory) | Out-Null
        }

        $utf8 = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($fullPath, $Content, $utf8)
    }
}

if (-not (Test-Path "package.json")) {
    throw "Ejecuta este script dentro de la carpeta tech-learning-hub."
}

$packRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Step "1/5 - Copiando guía de 9th Grade"

$sourceGuide = Join-Path $packRoot "guides\grade-09-cycle-3-my-first-web-page.html"
$targetGuide = Join-Path (Get-Location) "public/guides/grade-09/my-first-web-page-cycle-3.html"

New-Item -ItemType Directory -Force (Split-Path -Parent $targetGuide) | Out-Null
Copy-Item -LiteralPath $sourceGuide -Destination $targetGuide -Force

Step "2/5 - Actualizando catálogo de lecciones"

@'
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
'@ | Write-Utf8File -Path "src/content/catalog/lessons.ts"

Step "3/5 - Mejorando descripción de 9th Grade"

@'
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
'@ | Write-Utf8File -Path "src/content/grades/grades.ts"

Step "4/5 - Verificando contenido"

if (-not (Test-Path "public/guides/grade-09/my-first-web-page-cycle-3.html")) {
    throw "La guía de 9th Grade no fue copiada correctamente."
}

Write-Host "Guía de 9th Grade integrada." -ForegroundColor Green

Step "5/5 - Ejecutando lint y build"

npm run lint
npm run build

Write-Host ""
Write-Host "9TH GRADE INTEGRADO CORRECTAMENTE" -ForegroundColor Green
Write-Host ""
Write-Host "Disponible en:" -ForegroundColor Yellow
Write-Host "  /grades/9" -ForegroundColor White
Write-Host "  /guides/grade-09/my-first-web-page-cycle-3.html" -ForegroundColor White
Write-Host ""
Write-Host "Revisa localhost:3000/grades/9" -ForegroundColor Cyan
Write-Host ""
Write-Host "Si todo se ve bien, publica con:" -ForegroundColor Yellow
Write-Host "  git add ." -ForegroundColor White
Write-Host '  git commit -m "feat: add ninth grade web development guide"' -ForegroundColor White
Write-Host "  git push" -ForegroundColor White
