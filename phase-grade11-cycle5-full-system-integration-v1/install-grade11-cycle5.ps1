$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
$repo=(Get-Location).Path
if(-not(Test-Path -LiteralPath (Join-Path $repo "package.json"))){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$src=Join-Path $root "guides\grade-11-cycle-5-full-system-integration.html"
$dir=Join-Path $repo "public\guides\grade-11"
$dst=Join-Path $dir "cycle-5-full-system-integration.html"
[IO.Directory]::CreateDirectory($dir)|Out-Null
Copy-Item -LiteralPath $src -Destination $dst -Force

@"
11TH GRADE · CYCLE 5
Title: Cycle 5 · Full System Integration
Topic: Robot + Web + Data: From Components to a Complete IoT System
Official objective: Integrate the complete system: Robot + Web + Database with full functionality.
Guide: /guides/grade-11/cycle-5-full-system-integration.html

Integrar en Grade 11 SIN reemplazar contenido existente.
Mantener Updated Class Sequences visible antes de Cycle 5.
La guia incluye Catch-Up Fast Track para equipos que necesitan recuperar la secuencia,
pero no etiqueta publicamente ningun salon como atrasado.

Cierre esperado:
- sensor / simulacion
- ESP32 / Wokwi
- web state + control
- actuator/output
- localStorage history
- alert
- integration testing
- peer review
- final demonstrable version
"@ | Set-Content -LiteralPath (Join-Path $repo "GRADE11_CYCLE5_INTEGRATION.txt") -Encoding UTF8

Write-Host "11th Cycle 5 publicado." -ForegroundColor Green
Write-Host "http://localhost:3000/guides/grade-11/cycle-5-full-system-integration.html"
Write-Host "No toca Supabase, Live Game ni reescribe secuencias existentes."
Write-Host "Se genero GRADE11_CYCLE5_INTEGRATION.txt."
