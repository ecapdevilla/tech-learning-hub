$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Step([string]$Message) {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor DarkCyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor DarkCyan
}

function Write-Utf8([string]$Path, [string]$Content) {
    $full = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $Path))
    $dir = [System.IO.Path]::GetDirectoryName($full)

    if (-not [System.IO.Directory]::Exists($dir)) {
        [System.IO.Directory]::CreateDirectory($dir) | Out-Null
    }

    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($full, $Content, $utf8)
}

if (-not (Test-Path "package.json")) {
    throw "Ejecuta este script dentro de tech-learning-hub."
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

Step "1/6 - Copiando Secuencia STEM MVC de 9th"

$sequenceSource = Join-Path $root "guides\grade-09-stem-mvc-project-sequence.html"
$sequenceTarget = Join-Path (Get-Location) "public\guides\grade-09\stem-mvc-project-sequence.html"

New-Item -ItemType Directory -Force (Split-Path -Parent $sequenceTarget) | Out-Null
Copy-Item -LiteralPath $sequenceSource -Destination $sequenceTarget -Force

Step "2/6 - Actualizando guía 9th Blue con acceso a la secuencia"

$blueSource = Join-Path $root "guides\grade-09-blue-web-thinking-lab.html"
$blueTarget = Join-Path (Get-Location) "public\guides\grade-09\web-thinking-lab-blue.html"

if (-not (Test-Path -LiteralPath $blueTarget)) {
    throw "No encontré la guía 9th Blue instalada en public/guides/grade-09."
}

Copy-Item -LiteralPath $blueSource -Destination $blueTarget -Force

Step "3/6 - Agregando la secuencia como tercera clase de Grade 9"

$lessonPath = "src/content/catalog/lessons.ts"
$lessonText = Get-Content -LiteralPath $lessonPath -Raw
$lessonId = "grade-09-cycle-3-stem-mvc-project-sequence"

if ($lessonText -notmatch [regex]::Escape($lessonId)) {

$block = @'
  {
    id: "grade-09-cycle-3-stem-mvc-project-sequence",
    grade: 9,
    cycle: 3,
    title: {
      en: "STEM · MVC Project Sequence",
      es: "Secuencia de Proyecto STEM · MVC",
    },
    objective: {
      en: "Plan and develop a STEM project using MVC architecture, JavaScript, testing, documentation, SDGs and prompt engineering.",
      es: "Planear y desarrollar un proyecto STEM usando arquitectura MVC, JavaScript, pruebas, documentación, ODS e ingeniería de prompts.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-09/stem-mvc-project-sequence.html",
    tags: ["STEM", "MVC", "JavaScript", "AI", "SDGs"],
  },
'@

    $anchor = "export const lessons: LessonSummary[] = ["
    $index = $lessonText.IndexOf($anchor)

    if ($index -lt 0) {
        throw "No encontré el inicio del catálogo lessons.ts."
    }

    $insertAt = $index + $anchor.Length
    $lessonText = $lessonText.Insert($insertAt, "`r`n" + $block)
    Write-Utf8 $lessonPath $lessonText

    Write-Host "Secuencia agregada al catálogo." -ForegroundColor Green
}
else {
    Write-Host "La secuencia ya estaba registrada. No se duplicó." -ForegroundColor Yellow
}

Step "4/6 - Verificando las tres guías de 9th"

$files = @(
    "public\guides\grade-09\my-first-web-page-cycle-3.html",
    "public\guides\grade-09\web-thinking-lab-blue.html",
    "public\guides\grade-09\stem-mvc-project-sequence.html"
)

foreach ($file in $files) {
    if (Test-Path -LiteralPath $file) {
        Write-Host "OK  $file" -ForegroundColor Green
    }
    else {
        Write-Host "Aviso: no encontré $file" -ForegroundColor Yellow
    }
}

Step "5/6 - Ejecutando lint"

npm run lint
if ($LASTEXITCODE -ne 0) {
    throw "Lint falló. No hagas git push."
}

Step "6/6 - Ejecutando build"

npm run build
if ($LASTEXITCODE -ne 0) {
    throw "Build falló. No hagas git push."
}

Write-Host ""
Write-Host "SECUENCIA DE 9TH INTEGRADA CORRECTAMENTE" -ForegroundColor Green
Write-Host ""
Write-Host "Grade 9 ahora debe mostrar tres recursos:" -ForegroundColor Yellow
Write-Host "  1. My First Web Page" -ForegroundColor White
Write-Host "  2. Web Thinking Lab - 9th Blue" -ForegroundColor White
Write-Host "  3. STEM MVC Project Sequence" -ForegroundColor White
Write-Host ""
Write-Host "La guía 9th Blue ahora tiene arriba:" -ForegroundColor Yellow
Write-Host "  Open Project Sequence / Abrir secuencia del proyecto" -ForegroundColor White
Write-Host ""
Write-Host "Revisa:" -ForegroundColor Cyan
Write-Host "  http://localhost:3000/grades/9" -ForegroundColor White
Write-Host "  http://localhost:3000/guides/grade-09/web-thinking-lab-blue.html" -ForegroundColor White
Write-Host ""
Write-Host "Luego publica:" -ForegroundColor Yellow
Write-Host "  git add ." -ForegroundColor White
Write-Host '  git commit -m "feat: add ninth grade STEM MVC project sequence"' -ForegroundColor White
Write-Host "  git push" -ForegroundColor White
