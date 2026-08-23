$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
$repo=(Get-Location).Path
if(-not(Test-Path -LiteralPath (Join-Path $repo "package.json"))){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$src=Join-Path $root "guides\grade-09-cycle-5-mvc-connection.html"
$dir=Join-Path $repo "public\guides\grade-09"
$dst=Join-Path $dir "cycle-5-mvc-connection.html"
[IO.Directory]::CreateDirectory($dir)|Out-Null
Copy-Item -LiteralPath $src -Destination $dst -Force

$instructions=Join-Path $repo "GRADE9_CYCLE5_INTEGRATION.txt"
@"
9TH GRADE · CYCLE 5
Title: Cycle 5 · MVC Connection Lab
Objective: Complete MVC implementation: Connect Controller with Model and View. Add functionality.
Guide: /guides/grade-09/cycle-5-mvc-connection.html

Integrar en las lecciones/secuencias de Grade 9 SIN reemplazar contenido existente.
Mantener Updated Class Sequences disponible antes de las secuencias.
Cycle 5 debe apuntar a la URL anterior.
"@ | Set-Content -LiteralPath $instructions -Encoding UTF8

Write-Host "9th Cycle 5 publicado." -ForegroundColor Green
Write-Host "http://localhost:3000/guides/grade-09/cycle-5-mvc-connection.html"
Write-Host "Se genero GRADE9_CYCLE5_INTEGRATION.txt para integrar sin adivinar la estructura actual."
Write-Host "No toca Supabase, Live Game ni reescribe secuencias existentes."
