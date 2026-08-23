$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
$repo=(Get-Location).Path
if(-not(Test-Path -LiteralPath (Join-Path $repo "package.json"))){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$target=Join-Path $repo "public\student-projects\grade-10\updated-sequences"
[IO.Directory]::CreateDirectory($target)|Out-Null
Copy-Item -LiteralPath (Join-Path $root "projects\white") -Destination $target -Recurse -Force
Copy-Item -LiteralPath (Join-Path $root "projects\red") -Destination $target -Recurse -Force
$guideDir=Join-Path $repo "public\guides\grade-10"
[IO.Directory]::CreateDirectory($guideDir)|Out-Null
Copy-Item -LiteralPath (Join-Path $root "updated-sequences.html") -Destination (Join-Path $guideDir "updated-class-sequences.html") -Force

@"
10TH GRADE · UPDATED CLASS SEQUENCES
URL: /guides/grade-10/updated-class-sequences.html

Agregar ANTES de las secuencias existentes de Grade 10, sin reemplazar contenido:
Title: Updated Class Sequences
Subtitle: Recent classroom projects and development evidence.
Link: /guides/grade-10/updated-class-sequences.html

Actualmente:
- 10th White
- 10th Red
- La seccion adicional de 10th se incorporara despues.

IMPORTANTE:
- No borrar ni reescribir las secuencias actuales.
- No presentar archivos de apoyo del docente como proyectos estudiantiles.
"@ | Set-Content -LiteralPath (Join-Path $repo "GRADE10_UPDATED_SEQUENCES_INTEGRATION.txt") -Encoding UTF8

Write-Host "10th Updated Class Sequences publicado." -ForegroundColor Green
Write-Host "http://localhost:3000/guides/grade-10/updated-class-sequences.html"
Write-Host "No se modificaron las secuencias existentes."
Write-Host "Usa GRADE10_UPDATED_SEQUENCES_INTEGRATION.txt para agregar el acceso antes de ellas."
