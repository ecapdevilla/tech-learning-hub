$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
$repo=(Get-Location).Path
if(-not(Test-Path -LiteralPath (Join-Path $repo "package.json"))){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$src=Join-Path $root "guides\grade-10-cycle-5-interactive-engineering.html"
$dir=Join-Path $repo "public\guides\grade-10"
$dst=Join-Path $dir "cycle-5-interactive-application-engineering.html"
[IO.Directory]::CreateDirectory($dir)|Out-Null
Copy-Item -LiteralPath $src -Destination $dst -Force
@"
10TH GRADE · CYCLE 5
Title: Cycle 5 · Interactive Application Engineering
Topic: From Prototype to Complete Game or Simulator
Official objective: Create a complete interactive application (game or simulator) integrating all structures.
Guide: /guides/grade-10/cycle-5-interactive-application-engineering.html

Integrar en las lecciones/secuencias de Grade 10 SIN reemplazar contenido existente.
Mantener Updated Class Sequences disponible para que los equipos abran su proyecto actual.
"@ | Set-Content -LiteralPath (Join-Path $repo "GRADE10_CYCLE5_INTEGRATION.txt") -Encoding UTF8
Write-Host "10th Cycle 5 publicado." -ForegroundColor Green
Write-Host "http://localhost:3000/guides/grade-10/cycle-5-interactive-application-engineering.html"
Write-Host "No toca Supabase, Live Game ni reescribe secuencias existentes."
Write-Host "Se genero GRADE10_CYCLE5_INTEGRATION.txt."
