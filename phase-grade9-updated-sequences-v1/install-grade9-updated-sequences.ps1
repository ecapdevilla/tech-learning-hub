$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
$repo=(Get-Location).Path
if(-not(Test-Path -LiteralPath (Join-Path $repo "package.json"))){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$target=Join-Path $repo "public\student-projects\grade-09\updated-sequences"
[IO.Directory]::CreateDirectory($target)|Out-Null
Copy-Item -LiteralPath (Join-Path $root "projects\white") -Destination $target -Recurse -Force
Copy-Item -LiteralPath (Join-Path $root "projects\blue") -Destination $target -Recurse -Force
$guideDir=Join-Path $repo "public\guides\grade-09"; [IO.Directory]::CreateDirectory($guideDir)|Out-Null
Copy-Item -LiteralPath (Join-Path $root "updated-sequences.html") -Destination (Join-Path $guideDir "updated-class-sequences.html") -Force
@"
UPDATED CLASS SEQUENCES
URL: /guides/grade-09/updated-class-sequences.html

Agregar este acceso ANTES de las secuencias existentes en /grades/9, sin borrar ni reescribir lo actual:
Title: Updated Class Sequences
Subtitle: Recent classroom projects and development evidence.
Link: /guides/grade-09/updated-class-sequences.html
"@ | Set-Content -LiteralPath (Join-Path $repo "GRADE9_UPDATED_SEQUENCES_INTEGRATION.txt") -Encoding UTF8
Write-Host "Proyectos y pagina publicados." -ForegroundColor Green
Write-Host "http://localhost:3000/guides/grade-09/updated-class-sequences.html"
Write-Host "No se reescribio ninguna secuencia existente. Revisa GRADE9_UPDATED_SEQUENCES_INTEGRATION.txt para integrar el acceso antes de ellas."
