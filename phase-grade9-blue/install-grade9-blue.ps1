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
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($full, $Content, $utf8)
}

if (-not (Test-Path "package.json")) {
    throw "Ejecuta este script dentro de la carpeta tech-learning-hub."
}

$packRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Step "1/5 - Copiando guía 9th Blue"

$source = Join-Path $packRoot "guides\grade-09-blue-web-thinking-lab.html"
$target = Join-Path (Get-Location) "public\guides\grade-09\web-thinking-lab-blue.html"

New-Item -ItemType Directory -Force (Split-Path -Parent $target) | Out-Null
Copy-Item -LiteralPath $source -Destination $target -Force

Step "2/5 - Actualizando catálogo sin tocar la guía existente"

$lessonPath = "src/content/catalog/lessons.ts"
$lessonText = Get-Content -LiteralPath $lessonPath -Raw

$lessonId = "grade-09-cycle-3-web-thinking-lab-blue"

if ($lessonText -notmatch [regex]::Escape($lessonId)) {

$block = @'
  {
    id: "grade-09-cycle-3-web-thinking-lab-blue",
    grade: 9,
    cycle: 3,
    title: {
      en: "Web Thinking Lab · 9th Blue",
      es: "Laboratorio de Pensamiento Web · 9th Blue",
    },
    objective: {
      en: "Understand how a web page is created from scratch using HTML for structure, CSS for design and JavaScript for interaction.",
      es: "Comprender cómo se crea una página web desde cero usando HTML para la estructura, CSS para el diseño y JavaScript para la interacción.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-09/web-thinking-lab-blue.html",
    tags: ["HTML", "CSS", "JavaScript", "Classroom", "Paper Programming"],
  },
'@

    $anchor = "export const lessons: LessonSummary[] = ["
    $index = $lessonText.IndexOf($anchor)

    if ($index -lt 0) {
        throw "No encontré el inicio del catálogo de lecciones."
    }

    $insertAt = $index + $anchor.Length
    $lessonText = $lessonText.Insert($insertAt, "`r`n" + $block)
    Write-Utf8 $lessonPath $lessonText

    Write-Host "Nueva lección agregada al catálogo." -ForegroundColor Green
}
else {
    Write-Host "La lección ya existe. No se duplicó." -ForegroundColor Yellow
}

Step "3/5 - Verificando que la guía anterior siga intacta"

$oldGuide = "public\guides\grade-09\my-first-web-page-cycle-3.html"

if (Test-Path -LiteralPath $oldGuide) {
    Write-Host "Guía anterior de 9th encontrada y conservada." -ForegroundColor Green
}
else {
    Write-Host "Aviso: no encontré la guía anterior en la ruta esperada, pero este script no la elimina." -ForegroundColor Yellow
}

Step "4/5 - Ejecutando lint"

npm run lint
if ($LASTEXITCODE -ne 0) {
    throw "Lint falló. No hagas git push todavía."
}

Step "5/5 - Ejecutando build"

npm run build
if ($LASTEXITCODE -ne 0) {
    throw "Build falló. No hagas git push todavía."
}

Write-Host ""
Write-Host "9TH BLUE INTEGRADO CORRECTAMENTE" -ForegroundColor Green
Write-Host ""
Write-Host "Revisa:" -ForegroundColor Yellow
Write-Host "  http://localhost:3000/grades/9" -ForegroundColor White
Write-Host "  http://localhost:3000/guides/grade-09/web-thinking-lab-blue.html" -ForegroundColor White
Write-Host ""
Write-Host "Luego publica:" -ForegroundColor Yellow
Write-Host "  git add ." -ForegroundColor White
Write-Host '  git commit -m "feat: add 9th blue classroom web thinking lab"' -ForegroundColor White
Write-Host "  git push" -ForegroundColor White
