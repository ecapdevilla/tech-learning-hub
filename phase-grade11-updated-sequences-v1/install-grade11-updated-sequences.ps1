$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
$repo=(Get-Location).Path
if(-not(Test-Path -LiteralPath (Join-Path $repo "package.json"))){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$target=Join-Path $repo "public\student-projects\grade-11\updated-sequences"
if(Test-Path -LiteralPath $target){Remove-Item -LiteralPath $target -Recurse -Force}
[IO.Directory]::CreateDirectory($target)|Out-Null
Copy-Item -LiteralPath (Join-Path $root "projects\recent") -Destination $target -Recurse -Force
Copy-Item -LiteralPath (Join-Path $root "projects\previous") -Destination $target -Recurse -Force
$guideDir=Join-Path $repo "public\guides\grade-11"
[IO.Directory]::CreateDirectory($guideDir)|Out-Null
Copy-Item -LiteralPath (Join-Path $root "updated-sequences.html") -Destination (Join-Path $guideDir "updated-class-sequences.html") -Force
@"
11TH GRADE · UPDATED CLASS SEQUENCES
URL: /guides/grade-11/updated-class-sequences.html

Agregar ARRIBA / ANTES de las secuencias existentes de Grade 11:
Title: Updated Class Sequences
Subtitle: Current engineering projects and previous classroom evidence.
Link: /guides/grade-11/updated-class-sequences.html

IMPORTANTE:
- No borrar ni reescribir las secuencias actuales.
- Los proyectos recientes del 21 de agosto aparecen primero.
- La evidencia del 5 de agosto queda separada como Research / Previous Evidence.
- Los DOCX de investigacion no se presentan falsamente como aplicaciones web.
- La entrega externa por acceso GitHub no se inventa ni se transforma.
"@ | Set-Content -LiteralPath (Join-Path $repo "GRADE11_UPDATED_SEQUENCES_INTEGRATION.txt") -Encoding UTF8
Write-Host "11th Updated Class Sequences publicado." -ForegroundColor Green
Write-Host "http://localhost:3000/guides/grade-11/updated-class-sequences.html"
Write-Host "Los proyectos recientes quedan arriba. No se reescribieron secuencias existentes."
