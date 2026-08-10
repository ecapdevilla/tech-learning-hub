$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor DarkCyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor DarkCyan
}

if (-not (Test-Path "package.json")) {
    throw "Ejecuta este script dentro de la carpeta tech-learning-hub."
}

Write-Step "1/5 - Creando componentes reutilizables"

New-Item -ItemType Directory -Force "src/shared/components/layout" | Out-Null
New-Item -ItemType Directory -Force "src/shared/components/ui" | Out-Null
New-Item -ItemType Directory -Force "src/modules/grades/components" | Out-Null

@'
"use client";

import { useState } from "react";

export function LanguageSwitcher() {
  const [lang, setLang] = useState<"en" | "es">("en");

  function changeLanguage(value: "en" | "es") {
    setLang(value);
    document.documentElement.lang = value;
    document.body.dataset.lang = value;
  }

  return (
    <div className="flex gap-2">
      <button
        onClick={() => changeLanguage("en")}
        className={lang === "en" ? "lang-active" : "lang-button"}
      >
        🇺🇸 EN
      </button>
      <button
        onClick={() => changeLanguage("es")}
        className={lang === "es" ? "lang-active" : "lang-button"}
      >
        🇨🇴 ES
      </button>
    </div>
  );
}
'@ | Set-Content -Encoding UTF8 "src/shared/components/ui/LanguageSwitcher.tsx"

@'
import Link from "next/link";
import { LanguageSwitcher } from "@/shared/components/ui/LanguageSwitcher";

export function Navbar() {
  return (
    <header className="site-header">
      <div className="page-shell nav-inner">
        <Link href="/" className="brand">
          <span className="brand-mark">⚡</span>
          <span>Tech Learning Hub</span>
        </Link>

        <nav className="nav-links">
          <Link href="/explore">Explore</Link>
          <Link href="/resources">Resources</Link>
          <LanguageSwitcher />
        </nav>
      </div>
    </header>
  );
}
'@ | Set-Content -Encoding UTF8 "src/shared/components/layout/Navbar.tsx"

@'
import { Navbar } from "@/shared/components/layout/Navbar";

type Props = {
  children: React.ReactNode;
};

export function SiteLayout({ children }: Props) {
  return (
    <>
      <Navbar />
      <main>{children}</main>
    </>
  );
}
'@ | Set-Content -Encoding UTF8 "src/shared/components/layout/SiteLayout.tsx"

@'
import Link from "next/link";
import type { Grade } from "@/modules/grades/types/grade";

type Props = {
  grade: Grade;
};

export function GradeCard({ grade }: Props) {
  return (
    <Link href={`/grades/${grade.id}`} className="grade-card">
      <div className="grade-number">{grade.id}</div>
      <div>
        <p className="grade-label">{grade.label}</p>
        <p className="grade-description">{grade.description}</p>
      </div>
      <span className="grade-arrow">→</span>
    </Link>
  );
}
'@ | Set-Content -Encoding UTF8 "src/modules/grades/components/GradeCard.tsx"

Write-Step "2/5 - Creando Home"

@'
import Link from "next/link";
import { grades } from "@/content/grades/grades";
import { GradeCard } from "@/modules/grades/components/GradeCard";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";

export default function Home() {
  return (
    <SiteLayout>
      <section className="hero-section">
        <div className="page-shell hero-grid">
          <div>
            <span className="eyebrow">Technology · Programming · Innovation</span>

            <h1>
              Learn.
              <br />
              Practice.
              <br />
              <span>Create.</span>
            </h1>

            <p className="hero-copy">
              A learning space for guides, interactive activities,
              programming challenges and digital resources.
            </p>

            <div className="hero-actions">
              <a href="#grades" className="primary-button">
                Choose your grade
              </a>

              <Link href="/explore" className="secondary-button">
                Explore resources
              </Link>
            </div>
          </div>

          <div className="hero-visual">
            <div className="visual-card visual-one">💻</div>
            <div className="visual-card visual-two">🤖</div>
            <div className="visual-card visual-three">🌐</div>
            <div className="visual-card visual-four">📡</div>
          </div>
        </div>
      </section>

      <section id="grades" className="page-shell section-block">
        <div className="section-heading">
          <div>
            <span className="section-kicker">Learning paths</span>
            <h2>Select your grade</h2>
          </div>

          <p>
            Review your current lessons or explore another grade to reinforce
            concepts and discover new topics.
          </p>
        </div>

        <div className="grades-grid">
          {grades.map((grade) => (
            <GradeCard key={grade.id} grade={grade} />
          ))}
        </div>
      </section>

      <section className="page-shell feature-grid">
        <Link href="/explore" className="feature-card">
          <span className="feature-icon">🔎</span>
          <div>
            <span className="section-kicker">Explore</span>
            <h3>Learn beyond your grade</h3>
            <p>
              Search lessons, labs and concepts from different grade levels.
            </p>
          </div>
        </Link>

        <Link href="/resources" className="feature-card">
          <span className="feature-icon">📚</span>
          <div>
            <span className="section-kicker">Resources</span>
            <h3>Guides and materials</h3>
            <p>
              Access class guides, downloadable resources and support material.
            </p>
          </div>
        </Link>

        <div className="feature-card sdg-card">
          <span className="feature-icon">🌎</span>
          <div>
            <span className="section-kicker">Global Goals</span>
            <h3>Sustainable Development Goals</h3>
            <p>
              Connect technology projects with real-world challenges.
            </p>
          </div>
        </div>
      </section>

      <footer className="site-footer">
        <div className="page-shell">
          Tech Learning Hub · Technology & Programming
        </div>
      </footer>
    </SiteLayout>
  );
}
'@ | Set-Content -Encoding UTF8 "src/app/page.tsx"

Write-Step "3/5 - Creando rutas por grado"

@'
import Link from "next/link";
import { notFound } from "next/navigation";
import { grades } from "@/content/grades/grades";
import { lessons } from "@/content/catalog/lessons";
import { SiteLayout } from "@/shared/components/layout/SiteLayout";

type Props = {
  params: Promise<{ grade: string }>;
};

export default async function GradePage({ params }: Props) {
  const { grade } = await params;
  const gradeNumber = Number(grade);
  const gradeData = grades.find((item) => item.id === gradeNumber);

  if (!gradeData) notFound();

  const gradeLessons = lessons.filter(
    (lesson) => lesson.grade === gradeNumber
  );

  return (
    <SiteLayout>
      <section className="page-shell grade-page">
        <Link href="/" className="back-link">
          ← Back to grades
        </Link>

        <div className="grade-page-header">
          <div className="grade-big-number">{gradeData.id}</div>

          <div>
            <span className="section-kicker">Grade</span>
            <h1>{gradeData.label}</h1>
            <p>{gradeData.description}</p>
          </div>
        </div>

        <section className="lesson-list">
          <div className="section-heading compact">
            <div>
              <span className="section-kicker">Current content</span>
              <h2>Lessons & guides</h2>
            </div>
          </div>

          {gradeLessons.length === 0 ? (
            <div className="empty-card">
              <span>🚧</span>
              <h3>Content coming soon</h3>
              <p>This grade is ready to receive new guides and activities.</p>
            </div>
          ) : (
            <div className="lesson-grid">
              {gradeLessons.map((lesson) => (
                <article key={lesson.id} className="lesson-card">
                  <div className="lesson-top">
                    <span className="cycle-badge">
                      Cycle {lesson.cycle}
                    </span>
                    <span>{lesson.durationMinutes} min</span>
                  </div>

                  <h3>{lesson.title.en}</h3>
                  <p>{lesson.objective.en}</p>

                  <div className="tags">
                    {lesson.tags.map((tag) => (
                      <span key={tag}>{tag}</span>
                    ))}
                  </div>

                  {lesson.guidePath && (
                    <a
                      href={lesson.guidePath}
                      className="primary-button lesson-button"
                    >
                      Open guide
                    </a>
                  )}
                </article>
              ))}
            </div>
          )}
        </section>
      </section>
    </SiteLayout>
  );
}
'@ | Set-Content -Encoding UTF8 "src/app/grades/[grade]/page.tsx"

@'
import { SiteLayout } from "@/shared/components/layout/SiteLayout";

export default function ExplorePage() {
  return (
    <SiteLayout>
      <section className="page-shell simple-page">
        <span className="section-kicker">Explore</span>
        <h1>Explore all learning resources</h1>
        <p>
          Search and cross-grade discovery will be enabled in the next phase.
        </p>
      </section>
    </SiteLayout>
  );
}
'@ | Set-Content -Encoding UTF8 "src/app/explore/page.tsx"

@'
import { SiteLayout } from "@/shared/components/layout/SiteLayout";

export default function ResourcesPage() {
  return (
    <SiteLayout>
      <section className="page-shell simple-page">
        <span className="section-kicker">Resources</span>
        <h1>Guides and support material</h1>
        <p>
          This area will centralize guides, images, downloads and class support.
        </p>
      </section>
    </SiteLayout>
  );
}
'@ | Set-Content -Encoding UTF8 "src/app/resources/page.tsx"

Write-Step "4/5 - Aplicando diseño"

@'
@import "tailwindcss";

:root {
  --navy: #0f2740;
  --blue: #246bce;
  --sky: #edf6ff;
  --yellow: #f5c84c;
  --green: #22a56a;
  --ink: #21364a;
  --muted: #6b7d8e;
  --line: #d9e4ee;
}

* {
  box-sizing: border-box;
}

html {
  scroll-behavior: smooth;
}

body {
  margin: 0;
  background:
    radial-gradient(circle at 90% 0%, #ddecff 0%, transparent 24%),
    #f5f8fb;
  color: var(--ink);
  font-family: Arial, Helvetica, sans-serif;
}

a {
  color: inherit;
  text-decoration: none;
}

.page-shell {
  width: min(1180px, calc(100% - 32px));
  margin-inline: auto;
}

.site-header {
  position: sticky;
  top: 0;
  z-index: 50;
  background: rgba(15, 39, 64, 0.96);
  color: white;
  backdrop-filter: blur(10px);
}

.nav-inner {
  min-height: 70px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
}

.brand {
  display: flex;
  align-items: center;
  gap: 10px;
  font-weight: 900;
}

.brand-mark {
  width: 40px;
  height: 40px;
  display: grid;
  place-items: center;
  border-radius: 13px;
  background: linear-gradient(135deg, var(--yellow), #ff7e67);
}

.nav-links {
  display: flex;
  align-items: center;
  gap: 18px;
  font-weight: 700;
}

.lang-button,
.lang-active {
  border: 0;
  border-radius: 999px;
  padding: 7px 10px;
  font-weight: 800;
  cursor: pointer;
}

.lang-button {
  background: #d9e5f1;
}

.lang-active {
  background: var(--yellow);
}

.hero-section {
  padding: 72px 0 64px;
  background:
    radial-gradient(circle at 75% 30%, #2a6dac 0%, transparent 26%),
    linear-gradient(135deg, #0f2740, #173f62 70%, #1d6fa5);
  color: white;
}

.hero-grid {
  display: grid;
  grid-template-columns: 1.2fr 0.8fr;
  align-items: center;
  gap: 48px;
}

.eyebrow,
.section-kicker {
  display: inline-block;
  text-transform: uppercase;
  letter-spacing: 0.11em;
  font-size: 12px;
  font-weight: 900;
}

.eyebrow {
  color: #b9def6;
}

.hero-section h1 {
  margin: 14px 0;
  font-size: clamp(52px, 7vw, 88px);
  line-height: 0.94;
}

.hero-section h1 span {
  color: var(--yellow);
}

.hero-copy {
  max-width: 650px;
  color: #d8ebf8;
  font-size: 19px;
}

.hero-actions {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  margin-top: 26px;
}

.primary-button,
.secondary-button {
  display: inline-flex;
  justify-content: center;
  border-radius: 999px;
  padding: 12px 20px;
  font-weight: 900;
}

.primary-button {
  background: var(--yellow);
  color: var(--navy);
}

.secondary-button {
  border: 1px solid #ffffff55;
  color: white;
}

.hero-visual {
  position: relative;
  min-height: 330px;
}

.visual-card {
  position: absolute;
  width: 140px;
  height: 140px;
  display: grid;
  place-items: center;
  font-size: 58px;
  border: 1px solid #ffffff33;
  border-radius: 28px;
  background: #ffffff12;
  backdrop-filter: blur(8px);
}

.visual-one { top: 0; left: 55px; }
.visual-two { top: 55px; right: 25px; }
.visual-three { bottom: 10px; left: 0; }
.visual-four { bottom: 0; right: 75px; }

.section-block {
  padding: 70px 0 30px;
}

.section-heading {
  display: flex;
  justify-content: space-between;
  gap: 30px;
  align-items: end;
  margin-bottom: 28px;
}

.section-heading.compact {
  margin-bottom: 18px;
}

.section-heading h2,
.simple-page h1 {
  margin: 6px 0 0;
  color: var(--navy);
  font-size: clamp(32px, 4vw, 46px);
}

.section-heading > p {
  max-width: 520px;
  color: var(--muted);
}

.grades-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 14px;
}

.grade-card {
  min-height: 150px;
  display: grid;
  grid-template-columns: auto 1fr auto;
  gap: 16px;
  align-items: center;
  padding: 20px;
  background: white;
  border: 1px solid var(--line);
  border-radius: 20px;
  transition: 0.2s;
}

.grade-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 14px 30px #0f274014;
}

.grade-number {
  width: 70px;
  height: 70px;
  display: grid;
  place-items: center;
  background: var(--sky);
  border-radius: 20px;
  color: var(--blue);
  font-size: 32px;
  font-weight: 950;
}

.grade-label {
  margin: 0;
  color: var(--navy);
  font-size: 20px;
  font-weight: 900;
}

.grade-description {
  margin: 5px 0 0;
  color: var(--muted);
  font-size: 14px;
}

.grade-arrow {
  color: var(--blue);
  font-size: 24px;
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 14px;
  padding: 30px 0 70px;
}

.feature-card {
  display: flex;
  gap: 16px;
  padding: 24px;
  background: white;
  border: 1px solid var(--line);
  border-radius: 22px;
}

.feature-icon {
  font-size: 38px;
}

.feature-card h3 {
  margin: 4px 0;
  color: var(--navy);
}

.feature-card p {
  margin: 0;
  color: var(--muted);
}

.sdg-card {
  background: linear-gradient(135deg, #fff9dc, #ffffff);
}

.grade-page,
.simple-page {
  padding: 60px 0;
}

.back-link {
  color: var(--blue);
  font-weight: 800;
}

.grade-page-header {
  display: flex;
  align-items: center;
  gap: 20px;
  margin: 30px 0 50px;
}

.grade-big-number {
  width: 105px;
  height: 105px;
  display: grid;
  place-items: center;
  border-radius: 28px;
  background: var(--navy);
  color: white;
  font-size: 48px;
  font-weight: 950;
}

.grade-page-header h1 {
  margin: 4px 0;
  color: var(--navy);
  font-size: 44px;
}

.grade-page-header p {
  margin: 0;
  color: var(--muted);
}

.lesson-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.lesson-card,
.empty-card {
  padding: 24px;
  background: white;
  border: 1px solid var(--line);
  border-radius: 20px;
}

.lesson-top {
  display: flex;
  justify-content: space-between;
  color: var(--muted);
  font-size: 13px;
}

.cycle-badge {
  padding: 4px 10px;
  background: var(--sky);
  border-radius: 999px;
  color: var(--blue);
  font-weight: 900;
}

.lesson-card h3 {
  color: var(--navy);
  font-size: 24px;
}

.lesson-card p {
  color: var(--muted);
}

.tags {
  display: flex;
  gap: 7px;
  flex-wrap: wrap;
  margin: 18px 0;
}

.tags span {
  padding: 5px 9px;
  border-radius: 999px;
  background: #f0f4f7;
  font-size: 12px;
  font-weight: 800;
}

.lesson-button {
  width: 100%;
}

.empty-card {
  text-align: center;
  color: var(--muted);
}

.empty-card span {
  font-size: 48px;
}

.site-footer {
  padding: 30px 0;
  background: var(--navy);
  color: #bad0e2;
  text-align: center;
}

@media (max-width: 850px) {
  .hero-grid,
  .grades-grid,
  .feature-grid {
    grid-template-columns: 1fr 1fr;
  }

  .hero-visual {
    min-height: 280px;
  }

  .lesson-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 650px) {
  .nav-inner,
  .nav-links,
  .section-heading {
    align-items: flex-start;
    flex-direction: column;
  }

  .hero-grid,
  .grades-grid,
  .feature-grid {
    grid-template-columns: 1fr;
  }

  .hero-visual {
    display: none;
  }

  .grade-page-header {
    align-items: flex-start;
    flex-direction: column;
  }
}
'@ | Set-Content -Encoding UTF8 "src/app/globals.css"

Write-Step "5/5 - Verificando"

npm run lint
npm run build

Write-Host ""
Write-Host "HOME creado correctamente." -ForegroundColor Green
Write-Host ""
Write-Host "Si npm run dev sigue ejecutándose, vuelve al navegador y actualiza." -ForegroundColor Yellow
Write-Host "Si lo cerraste, ejecuta:" -ForegroundColor Yellow
Write-Host "  npm run dev" -ForegroundColor White