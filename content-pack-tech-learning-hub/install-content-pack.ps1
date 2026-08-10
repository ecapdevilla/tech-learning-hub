$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Write-Step {
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
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($fullPath, $Content, $utf8NoBom)
    }
}

if (-not (Test-Path "package.json")) {
    throw "Ejecuta este script dentro de la carpeta tech-learning-hub."
}

$packRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Step "1/5 - Copiando guías reales"

$guideTargets = @{
    "grade-06-cycle-3-code-creators.html" = "public/guides/grade-06/code-creators-cycle-3.html"
    "grade-10-cycle-3-loops-arrays.html"   = "public/guides/grade-10/loops-arrays-mvc.html"
    "grade-11-cycle-3-esp32-wifi.html"     = "public/guides/grade-11/esp32-wifi-wokwi.html"
}

foreach ($name in $guideTargets.Keys) {
    $source = Join-Path $packRoot "guides\$name"
    $target = Join-Path (Get-Location) $guideTargets[$name]
    $targetDir = Split-Path -Parent $target
    New-Item -ItemType Directory -Force $targetDir | Out-Null
    Copy-Item -LiteralPath $source -Destination $target -Force
}

Write-Step "2/5 - Copiando imagen ODS"

$odsSource = Join-Path $packRoot "images\sustainable-development-goals.png"
$odsTarget = Join-Path (Get-Location) "public/images/ods/sustainable-development-goals.png"
New-Item -ItemType Directory -Force (Split-Path -Parent $odsTarget) | Out-Null
Copy-Item -LiteralPath $odsSource -Destination $odsTarget -Force

Write-Step "3/5 - Actualizando catálogo"

@'
import type { LessonSummary } from "@/modules/lessons/types/lesson";

export const lessons: LessonSummary[] = [
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

Write-Step "4/5 - Mejorando Resources"

@'
import Image from "next/image";
import Link from "next/link";
import { lessons } from "@/content/catalog/lessons";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";

export default function ResourcesPage() {
  return (
    <SiteLayout>
      <section className="page-shell simple-page">
        <span className="section-kicker">Resources</span>
        <h1>Learning Resources</h1>
        <p className="resource-intro">
          Review current class guides and connect technology projects
          with the Sustainable Development Goals.
        </p>

        <section className="resources-layout">
          <article className="ods-panel">
            <div>
              <span className="section-kicker">Global Goals</span>
              <h2>Sustainable Development Goals</h2>
              <p>
                Use the SDGs as inspiration for technology projects
                that respond to real-world challenges.
              </p>
            </div>

            <Image
              src="/images/ods/sustainable-development-goals.png"
              alt="Sustainable Development Goals"
              width={1024}
              height={1024}
              className="ods-image"
              priority
            />
          </article>

          <div>
            <div className="section-heading compact">
              <div>
                <span className="section-kicker">Available now</span>
                <h2>Class Guides</h2>
              </div>
            </div>

            <div className="resource-guide-grid">
              {lessons.map((lesson) => (
                <article key={lesson.id} className="resource-guide-card">
                  <span className="cycle-badge">
                    Grade {lesson.grade} · Cycle {lesson.cycle}
                  </span>

                  <h3>{lesson.title.en}</h3>
                  <p>{lesson.objective.en}</p>

                  {lesson.guidePath && (
                    <a
                      className="primary-button resource-open"
                      href={lesson.guidePath}
                    >
                      Open guide
                    </a>
                  )}
                </article>
              ))}
            </div>

            <Link href="/" className="back-link resource-home">
              ← Back home
            </Link>
          </div>
        </section>
      </section>
    </SiteLayout>
  );
}
'@ | Write-Utf8File -Path "src/app/resources/page.tsx"

@'

.resource-intro {
  max-width: 720px;
  color: var(--muted);
  font-size: 17px;
}

.resources-layout {
  display: grid;
  grid-template-columns: minmax(300px, 0.9fr) minmax(0, 1.1fr);
  gap: 24px;
  margin-top: 34px;
  align-items: start;
}

.ods-panel {
  position: sticky;
  top: 94px;
  padding: 22px;
  background: linear-gradient(145deg, #fff9dd, #ffffff);
  border: 1px solid var(--line);
  border-radius: 24px;
}

.ods-panel h2 {
  margin: 6px 0;
  color: var(--navy);
  font-size: 28px;
}

.ods-panel p {
  color: var(--muted);
}

.ods-image {
  width: 100%;
  height: auto;
  margin-top: 16px;
  border-radius: 18px;
  border: 1px solid var(--line);
}

.resource-guide-grid {
  display: grid;
  gap: 13px;
}

.resource-guide-card {
  padding: 20px;
  background: white;
  border: 1px solid var(--line);
  border-radius: 19px;
}

.resource-guide-card h3 {
  margin: 14px 0 5px;
  color: var(--navy);
  font-size: 22px;
}

.resource-guide-card p {
  color: var(--muted);
}

.resource-open {
  margin-top: 8px;
}

.resource-home {
  display: inline-block;
  margin-top: 22px;
}

@media (max-width: 850px) {
  .resources-layout {
    grid-template-columns: 1fr;
  }

  .ods-panel {
    position: static;
  }
}
'@ | Add-Content "src/app/globals.css"

Write-Step "5/5 - Verificando plataforma"

npm run lint
npm run build

Write-Host ""
Write-Host "Contenido integrado correctamente." -ForegroundColor Green
Write-Host ""
Write-Host "Disponibles:" -ForegroundColor Yellow
Write-Host "  Grade 6  - Code Creators" -ForegroundColor White
Write-Host "  Grade 10 - Loops & Arrays" -ForegroundColor White
Write-Host "  Grade 11 - ESP32 WiFi" -ForegroundColor White
Write-Host "  Resources - ODS + guías" -ForegroundColor White
Write-Host ""
Write-Host "Actualiza http://localhost:3000" -ForegroundColor Cyan
