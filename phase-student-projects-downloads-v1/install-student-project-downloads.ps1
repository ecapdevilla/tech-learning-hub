$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){
  throw "Ejecuta este instalador desde la raiz de tech-learning-hub."
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor DarkCyan
Write-Host "STUDENT PROJECTS · DOWNLOADABLE WORKING COPIES" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor DarkCyan

$projectCardPath = Join-Path (Get-Location) "src\shared\components\student-projects\ProjectCard.tsx"
$globalCssPath = Join-Path (Get-Location) "src\app\globals.css"
$projectsRoot = Join-Path (Get-Location) "public\student-projects"

if(-not(Test-Path $projectCardPath)){
  throw "No encuentro ProjectCard.tsx. Primero debe estar instalada Student Projects View."
}

if(-not(Test-Path $projectsRoot)){
  throw "No encuentro public\student-projects."
}

Write-Host "1/5 - Mejorando tarjetas de galeria..." -ForegroundColor Cyan

$projectCard = @'
import type { StudentProject } from "@/modules/student-projects/types/studentProject";

function getDownloadName(project: StudentProject) {
  const safeTitle = project.slug || `grade-${project.grade}-project`;
  return `${safeTitle}.html`;
}

export function ProjectCard({ project }: { project: StudentProject }) {
  return (
    <article className="student-project-card">
      <div className="student-project-cover">
        <span className="student-project-cover-icon">🚀</span>
        <div>
          <small>STUDENT CREATION</small>
          <strong>{project.grade}th Grade · {project.classroom.toUpperCase()}</strong>
        </div>
      </div>

      <div className="student-project-content">
        <div className="student-project-meta">
          <span>Cycle {project.cycle}</span>
          <span>Period {project.period}</span>
        </div>

        <small className="student-project-tech">{project.technologies.join(" · ")}</small>
        <h3>{project.title}</h3>
        <p>{project.description}</p>

        <div className="student-authors">
          <span>👩‍💻</span>
          <div>
            <small>CREATED BY</small>
            <b>{project.studentName}</b>
          </div>
        </div>

        <div className="project-skills">
          {project.skills.map((skill) => <span key={skill}>{skill}</span>)}
        </div>

        {project.projectPath && (
          <div className="student-project-actions">
            <a className="student-project-open" href={project.projectPath}>
              EXPLORE PROJECT <span>→</span>
            </a>

            <a
              className="student-project-download"
              href={project.projectPath}
              download={getDownloadName(project)}
              title="Download an editable HTML copy of this student project"
            >
              ⬇ DOWNLOAD HTML
            </a>
          </div>
        )}
      </div>
    </article>
  );
}
'@

[IO.File]::WriteAllText(
  $projectCardPath,
  $projectCard,
  (New-Object Text.UTF8Encoding($false))
)

Write-Host "2/5 - Agregando estilos de descarga..." -ForegroundColor Cyan

$marker = "/* STUDENT PROJECT DOWNLOADS V1 */"
$css = [IO.File]::ReadAllText($globalCssPath)

if(-not $css.Contains($marker)){
  $downloadCss = @'

/* STUDENT PROJECT DOWNLOADS V1 */
.student-project-card .student-project-content{
  padding-bottom: 22px !important;
}
.student-project-actions{
  display:grid;
  grid-template-columns:1fr;
  gap:9px;
  margin-top:auto;
  padding-top:14px;
}
.student-project-actions .student-project-open,
.student-project-actions .student-project-download{
  position:static !important;
  left:auto !important;
  right:auto !important;
  bottom:auto !important;
  width:100%;
  min-height:44px;
  display:flex !important;
  align-items:center;
  justify-content:space-between;
  padding:11px 14px;
  border-radius:12px;
  font-weight:900;
  text-decoration:none;
}
.student-project-actions .student-project-open{
  background:linear-gradient(90deg,#102b46,#185a84) !important;
  color:#fff;
}
.student-project-actions .student-project-download{
  background:#eef7ff;
  color:#174f7a;
  border:1px solid #cfe2f1;
}
.student-project-actions .student-project-download:hover{
  background:#dfefff;
}
.student-project-download-note{
  font-size:11px;
  color:#718397;
  margin-top:4px;
}
'@
  [IO.File]::AppendAllText(
    $globalCssPath,
    "`r`n" + $downloadCss,
    (New-Object Text.UTF8Encoding($false))
  )
}else{
  Write-Host "   Los estilos de descarga ya existen; no se duplican." -ForegroundColor DarkGray
}

Write-Host "3/5 - Agregando descarga dentro de cada proyecto publicado..." -ForegroundColor Cyan

$htmlFiles = Get-ChildItem -Path $projectsRoot -Filter "index.html" -File -Recurse
$count = 0

foreach($file in $htmlFiles){
  $content = [IO.File]::ReadAllText($file.FullName)

  if($content.Contains("TLH-DOWNLOAD-WORKING-COPY")){
    Write-Host "   Ya preparado: $($file.FullName)" -ForegroundColor DarkGray
    continue
  }

  $relative = $file.FullName.Substring($projectsRoot.Length).TrimStart('\')
  $parts = $relative -split '\\'
  $slug = if($parts.Length -ge 4){ $parts[$parts.Length - 2] } else { "student-project" }
  $downloadName = "$slug.html"

  $widget = @"

<!-- TLH-DOWNLOAD-WORKING-COPY -->
<style>
.tlh-download-working-copy{
  position:fixed;
  right:18px;
  bottom:18px;
  z-index:99999;
  display:flex;
  align-items:center;
  gap:9px;
  padding:11px 15px;
  border-radius:999px;
  background:linear-gradient(135deg,#102b46,#17628e);
  color:#fff !important;
  text-decoration:none !important;
  font:800 13px 'Segoe UI',Arial,sans-serif;
  box-shadow:0 10px 30px rgba(16,43,70,.28);
  border:1px solid rgba(255,255,255,.18);
}
.tlh-download-working-copy:hover{
  transform:translateY(-2px);
  box-shadow:0 14px 34px rgba(16,43,70,.34);
}
@media(max-width:600px){
  .tlh-download-working-copy{
    right:10px;
    bottom:10px;
    padding:10px 12px;
    font-size:12px;
  }
}
@media print{
  .tlh-download-working-copy{display:none !important}
}
</style>
<a
  class="tlh-download-working-copy"
  href="index.html"
  download="$downloadName"
  title="Download this editable HTML project"
>
  ⬇ Download HTML
</a>
"@

  if($content -match '(?i)</body>'){
    $content = [regex]::Replace(
      $content,
      '(?i)</body>',
      $widget + "`r`n</body>",
      1
    )
  }else{
    $content += $widget
  }

  [IO.File]::WriteAllText(
    $file.FullName,
    $content,
    (New-Object Text.UTF8Encoding($false))
  )

  $count++
}

Write-Host "   Proyectos actualizados: $count" -ForegroundColor Green

Write-Host "4/5 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){
  throw "Lint fallo. No hagas push."
}

Write-Host "5/5 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){
  throw "Build fallo. No hagas push."
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor DarkCyan
Write-Host "DESCARGAS HTML ACTIVADAS PARA STUDENT PROJECTS" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "Ahora cada proyecto tiene:"
Write-Host "  - EXPLORE PROJECT"
Write-Host "  - DOWNLOAD HTML"
Write-Host "  - Boton flotante de descarga dentro del proyecto"
Write-Host ""
Write-Host "Revisa:"
Write-Host "  http://localhost:3000/students"
Write-Host "  http://localhost:3000/students/grade/6/red"
Write-Host "  http://localhost:3000/students/grade/7/blue"
Write-Host "  http://localhost:3000/students/grade/8/white"
Write-Host "  http://localhost:3000/students/grade/8/blue"
