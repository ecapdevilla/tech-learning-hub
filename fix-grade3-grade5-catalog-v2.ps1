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

function Insert-AfterAnchor(
    [string]$Text,
    [string]$Anchor,
    [string]$Block
) {
    $index = $Text.IndexOf($Anchor)

    if ($index -lt 0) {
        throw "No se encontró el ancla: $Anchor"
    }

    $insertAt = $index + $Anchor.Length
    return $Text.Insert($insertAt, "`r`n" + $Block)
}

if (-not (Test-Path "package.json")) {
    throw "Ejecuta este script dentro de tech-learning-hub."
}

Step "1/6 - Creando respaldo de los archivos dañados"

Copy-Item -LiteralPath "src/content/grades/grades.ts" `
    -Destination "src/content/grades/grades.broken.backup.ts" -Force

Copy-Item -LiteralPath "src/content/catalog/lessons.ts" `
    -Destination "src/content/catalog/lessons.broken.backup.ts" -Force

Step "2/6 - Restaurando versiones correctas desde el commit anterior"

$gradesOriginal = git show HEAD^:src/content/grades/grades.ts
if ($LASTEXITCODE -ne 0) {
    throw "No pude recuperar grades.ts desde HEAD^."
}

$lessonsOriginal = git show HEAD^:src/content/catalog/lessons.ts
if ($LASTEXITCODE -ne 0) {
    throw "No pude recuperar lessons.ts desde HEAD^."
}

$gradesText = ($gradesOriginal -join "`n")
$lessonsText = ($lessonsOriginal -join "`n")

Write-Utf8 "src/content/grades/grades.ts" $gradesText
Write-Utf8 "src/content/catalog/lessons.ts" $lessonsText

Step "3/6 - Insertando 3rd y 5th Grade"

$gradesPath = "src/content/grades/grades.ts"
$gradesText = Get-Content -LiteralPath $gradesPath -Raw

$grade3 = @'
  {
    id: 3,
    label: "3rd Grade",
    description: "Sensors, conditionals and loops through interactive missions",
    level: "primary",
  },
'@

$grade5 = @'
  {
    id: 5,
    label: "5th Grade",
    description: "Functions, parameters and reusable programming logic",
    level: "primary",
  },
'@

$gradesAnchor = 'export const grades: Grade[] = ['

if ($gradesText -notmatch 'id:\s*3,') {
    $gradesText = Insert-AfterAnchor $gradesText $gradesAnchor $grade3
}

if ($gradesText -notmatch 'id:\s*5,') {
    $gradesText = Insert-AfterAnchor $gradesText $gradesAnchor $grade5
}

Write-Utf8 $gradesPath $gradesText

Step "4/6 - Insertando lecciones de 3rd y 5th"

$lessonsPath = "src/content/catalog/lessons.ts"
$lessonsText = Get-Content -LiteralPath $lessonsPath -Raw

$lesson3 = @'
  {
    id: "grade-03-cycle-3-smart-animal-maze",
    grade: 3,
    cycle: 3,
    title: {
      en: "Smart Animal Maze",
      es: "Laberinto del Animal Inteligente",
    },
    objective: {
      en: "Use sensors, conditionals and loops to solve step-by-step challenges in an interactive maze.",
      es: "Usar sensores, condicionales y ciclos para resolver retos paso a paso en un laberinto interactivo.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-03/smart-animal-maze.html",
    tags: ["Sensors", "Conditionals", "Loops", "Game"],
  },
'@

$lesson5 = @'
  {
    id: "grade-05-cycle-3-robolab-functions",
    grade: 5,
    cycle: 3,
    title: {
      en: "RoboLab: Function Factory",
      es: "RoboLab: Fábrica de Funciones",
    },
    objective: {
      en: "Create and reuse functions, use simple parameters and understand returned results.",
      es: "Crear y reutilizar funciones, usar parámetros sencillos y comprender resultados retornados.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-05/robolab-functions.html",
    tags: ["Functions", "Parameters", "Return", "Robotics"],
  },
'@

$lessonsAnchor = 'export const lessons: LessonSummary[] = ['

if ($lessonsText -notmatch 'grade-03-cycle-3-smart-animal-maze') {
    $lessonsText = Insert-AfterAnchor $lessonsText $lessonsAnchor $lesson3
}

if ($lessonsText -notmatch 'grade-05-cycle-3-robolab-functions') {
    $lessonsText = Insert-AfterAnchor $lessonsText $lessonsAnchor $lesson5
}

Write-Utf8 $lessonsPath $lessonsText

Step "5/6 - Validando sintaxis y tipos"

npm run lint
if ($LASTEXITCODE -ne 0) {
    throw "ESLint falló. No continúes con git push."
}

npm run build
if ($LASTEXITCODE -ne 0) {
    throw "Build falló. No continúes con git push."
}

Step "6/6 - Limpiando respaldos temporales"

Remove-Item -LiteralPath "src/content/grades/grades.broken.backup.ts" -Force
Remove-Item -LiteralPath "src/content/catalog/lessons.broken.backup.ts" -Force

Write-Host ""
Write-Host "CORRECCION V2 COMPLETADA" -ForegroundColor Green
Write-Host ""
Write-Host "Ahora ejecuta:" -ForegroundColor Yellow
Write-Host "  git add ." -ForegroundColor White
Write-Host '  git commit -m "fix: repair grade 3 and grade 5 catalog integration"' -ForegroundColor White
Write-Host "  git push" -ForegroundColor White