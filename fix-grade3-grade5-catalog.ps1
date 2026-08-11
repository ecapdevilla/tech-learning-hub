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
        [Parameter(Mandatory = $true)]
        [string]$Content
    )

    $fullPath = [System.IO.Path]::GetFullPath(
        (Join-Path (Get-Location) $Path)
    )

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($fullPath, $Content, $utf8NoBom)
}

if (-not (Test-Path "package.json")) {
    throw "Ejecuta este script dentro de la carpeta tech-learning-hub."
}

Write-Step "1/4 - Corrigiendo grades.ts"

$gradesPath = "src/content/grades/grades.ts"
$grades = Get-Content -LiteralPath $gradesPath -Raw

$grades = $grades -replace '\},\]\s*=\s*\[', '},'
$grades = $grades -replace 'export const grades\s*:\s*Grade\[\]\s*,', 'export const grades: Grade[] = ['

if ($grades -notmatch 'export const grades\s*:\s*Grade\[\]\s*=\s*\[') {
    throw "No pude reconstruir correctamente el inicio de grades.ts."
}

Write-Utf8File $gradesPath $grades

Write-Step "2/4 - Corrigiendo lessons.ts"

$lessonsPath = "src/content/catalog/lessons.ts"
$lessons = Get-Content -LiteralPath $lessonsPath -Raw

$lessons = $lessons -replace '\},\]\s*=\s*\[', '},'
$lessons = $lessons -replace 'export const lessons\s*:\s*LessonSummary\[\]\s*,', 'export const lessons: LessonSummary[] = ['

if ($lessons -notmatch 'export const lessons\s*:\s*LessonSummary\[\]\s*=\s*\[') {
    throw "No pude reconstruir correctamente el inicio de lessons.ts."
}

Write-Utf8File $lessonsPath $lessons

Write-Step "3/4 - Ejecutando lint"

npm run lint

Write-Step "4/4 - Ejecutando build"

npm run build

Write-Host ""
Write-Host "CORRECCION COMPLETADA" -ForegroundColor Green
Write-Host ""
Write-Host "Ahora publica:" -ForegroundColor Yellow
Write-Host "  git add ." -ForegroundColor White
Write-Host '  git commit -m "fix: repair grade and lesson catalogs"' -ForegroundColor White
Write-Host "  git push" -ForegroundColor White