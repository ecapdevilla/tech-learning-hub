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
    throw "Ejecuta este script dentro de tech-learning-hub."
}

$packRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Step "1/8 - Integrando Grade 2"

$sourceGuide = Join-Path $packRoot "guides\grade-02-algorithms-games.html"
$targetGuide = Join-Path (Get-Location) "public/guides/grade-02/algorithms-games.html"

New-Item -ItemType Directory -Force (Split-Path -Parent $targetGuide) | Out-Null
Copy-Item -LiteralPath $sourceGuide -Destination $targetGuide -Force

Step "2/8 - Actualizando tipos de grados"

@'
export type GradeId = 2 | 6 | 7 | 8 | 9 | 10 | 11;

export type SchoolLevel = "primary" | "secondary";

export type Grade = {
  id: GradeId;
  label: string;
  description: string;
  level: SchoolLevel;
};
'@ | Write-Utf8File -Path "src/modules/grades/types/grade.ts"

Step "3/8 - Actualizando catálogo de grados"

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
    description: "Programming and interactive systems",
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

Step "4/8 - Actualizando catálogo de lecciones"

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

Step "5/8 - Creando componentes pequeños del Home"

@'
type Props = {
  eyebrow: string;
  title: string;
  description: string;
};

export function HeroCopy({ eyebrow, title, description }: Props) {
  return (
    <div>
      <span className="eyebrow">{eyebrow}</span>
      <h1>
        Learn.
        <br />
        Practice.
        <br />
        <span>{title}</span>
      </h1>
      <p className="hero-copy">{description}</p>
    </div>
  );
}
'@ | Write-Utf8File -Path "src/modules/grades/components/HeroCopy.tsx"

@'
export function HeroVisual() {
  return (
    <div className="hero-visual" aria-hidden="true">
      <div className="visual-orbit orbit-main">⚡</div>
      <div className="visual-orbit orbit-one">💻</div>
      <div className="visual-orbit orbit-two">🤖</div>
      <div className="visual-orbit orbit-three">🌎</div>
      <div className="visual-orbit orbit-four">📡</div>
    </div>
  );
}
'@ | Write-Utf8File -Path "src/modules/grades/components/HeroVisual.tsx"

@'
import { GradeCard } from "@/modules/grades/components/GradeCard";
import type { Grade } from "@/modules/grades/types/grade";

type Props = {
  title: string;
  kicker: string;
  description: string;
  grades: Grade[];
};

export function GradeSection({
  title,
  kicker,
  description,
  grades,
}: Props) {
  return (
    <section className="school-section">
      <div className="school-heading">
        <div>
          <span className="section-kicker">{kicker}</span>
          <h2>{title}</h2>
        </div>
        <p>{description}</p>
      </div>

      <div className="grades-grid">
        {grades.map((grade) => (
          <GradeCard key={grade.id} grade={grade} />
        ))}
      </div>
    </section>
  );
}
'@ | Write-Utf8File -Path "src/modules/grades/components/GradeSection.tsx"

@'
import Link from "next/link";

export function HomeFeatures() {
  return (
    <section className="feature-grid">
      <Link href="/explore" className="feature-card">
        <span className="feature-icon">🔎</span>
        <div>
          <span className="section-kicker">Explore</span>
          <h3>Learn beyond your grade</h3>
          <p>Review concepts from different learning levels.</p>
        </div>
      </Link>

      <Link href="/resources" className="feature-card">
        <span className="feature-icon">📚</span>
        <div>
          <span className="section-kicker">Library</span>
          <h3>Guides & resources</h3>
          <p>Access materials, activities and class support.</p>
        </div>
      </Link>

      <Link href="/resources" className="feature-card sdg-card">
        <span className="feature-icon">🌎</span>
        <div>
          <span className="section-kicker">Global Goals</span>
          <h3>Technology with purpose</h3>
          <p>Connect projects with Sustainable Development Goals.</p>
        </div>
      </Link>
    </section>
  );
}
'@ | Write-Utf8File -Path "src/shared/components/layout/HomeFeatures.tsx"

Step "6/8 - Rediseñando página principal"

@'
import Link from "next/link";
import {
  primaryGrades,
  secondaryGrades,
} from "@/content/grades/grades";
import { GradeSection } from "@/modules/grades/components/GradeSection";
import { HeroCopy } from "@/modules/grades/components/HeroCopy";
import { HeroVisual } from "@/modules/grades/components/HeroVisual";
import { HomeFeatures } from "@/shared/components/layout/HomeFeatures";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";

export default function Home() {
  return (
    <SiteLayout>
      <section className="hero-section">
        <div className="page-shell hero-grid">
          <div>
            <HeroCopy
              eyebrow="Technology · Programming · Innovation"
              title="Create."
              description="A digital learning space where students can explore, build, practice and connect technology with real-world challenges."
            />

            <div className="hero-actions">
              <a href="#learning-levels" className="primary-button">
                Start learning
              </a>
              <Link href="/resources" className="secondary-button">
                Open resource library
              </Link>
            </div>
          </div>

          <HeroVisual />
        </div>
      </section>

      <section
        id="learning-levels"
        className="page-shell learning-levels"
      >
        <div className="welcome-strip">
          <span>🚀</span>
          <div>
            <strong>Choose your path</strong>
            <p>
              Start with your grade or explore another level to reinforce
              previous concepts and discover what comes next.
            </p>
          </div>
        </div>

        <GradeSection
          kicker="Primary School"
          title="Learn by playing and creating"
          description="Visual, interactive and age-appropriate experiences that introduce computational thinking."
          grades={primaryGrades}
        />

        <GradeSection
          kicker="Secondary School"
          title="Build, code and solve"
          description="Progressive learning paths in programming, web development, digital systems and IoT."
          grades={secondaryGrades}
        />

        <HomeFeatures />
      </section>

      <footer className="site-footer">
        <div className="page-shell">
          Tech Learning Hub · Learn · Practice · Create
        </div>
      </footer>
    </SiteLayout>
  );
}
'@ | Write-Utf8File -Path "src/app/page.tsx"

Step "7/8 - Mejorando diseño principal"

@'

.learning-levels {
  padding: 42px 0 70px;
}

.welcome-strip {
  display: flex;
  gap: 16px;
  align-items: center;
  padding: 20px 22px;
  background: linear-gradient(90deg, #edf7ff, #fffaf0);
  border: 1px solid var(--line);
  border-radius: 22px;
  margin-bottom: 42px;
}

.welcome-strip > span {
  font-size: 40px;
}

.welcome-strip strong {
  color: var(--navy);
  font-size: 20px;
}

.welcome-strip p {
  margin: 3px 0 0;
  color: var(--muted);
}

.school-section {
  padding: 28px 0;
}

.school-heading {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 28px;
  margin-bottom: 22px;
}

.school-heading h2 {
  margin: 5px 0 0;
  color: var(--navy);
  font-size: clamp(30px, 4vw, 42px);
}

.school-heading > p {
  max-width: 520px;
  margin: 0;
  color: var(--muted);
}

.hero-visual {
  position: relative;
  min-height: 350px;
}

.visual-orbit {
  position: absolute;
  display: grid;
  place-items: center;
  border: 1px solid #ffffff35;
  background: #ffffff12;
  backdrop-filter: blur(10px);
  box-shadow: 0 18px 30px #0002;
}

.orbit-main {
  width: 165px;
  height: 165px;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  font-size: 72px;
  background: linear-gradient(135deg, #ffffff22, #f5c84c33);
}

.orbit-one,
.orbit-two,
.orbit-three,
.orbit-four {
  width: 94px;
  height: 94px;
  border-radius: 24px;
  font-size: 39px;
}

.orbit-one {
  top: 8px;
  left: 20px;
}

.orbit-two {
  top: 18px;
  right: 15px;
}

.orbit-three {
  bottom: 4px;
  left: 25px;
}

.orbit-four {
  bottom: 16px;
  right: 20px;
}

@media (max-width: 750px) {
  .school-heading {
    align-items: flex-start;
    flex-direction: column;
  }

  .welcome-strip {
    align-items: flex-start;
  }
}
'@ | Add-Content "src/app/globals.css"

Step "8/8 - Verificando"

npm run lint
npm run build

Write-Host ""
Write-Host "FASE PRIMARY + SECONDARY COMPLETADA" -ForegroundColor Green
Write-Host ""
Write-Host "Integrado:" -ForegroundColor Yellow
Write-Host "  Primary School" -ForegroundColor White
Write-Host "  Grade 2 - Little Programmers" -ForegroundColor White
Write-Host "  Secondary School - Grades 6 to 11" -ForegroundColor White
Write-Host "  Nuevo Home" -ForegroundColor White
Write-Host ""
Write-Host "Revisa localhost:3000" -ForegroundColor Cyan
Write-Host ""
Write-Host "Luego publica con:" -ForegroundColor Yellow
Write-Host "  git add ." -ForegroundColor White
Write-Host '  git commit -m "feat: add primary and secondary learning paths"' -ForegroundColor White
Write-Host "  git push" -ForegroundColor White
