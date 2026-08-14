$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "1/3 - Publicando guia Cycle 4 de 10th Grade..." -ForegroundColor Cyan
$dst=Join-Path (Get-Location) "public\guides\grade-10"
[IO.Directory]::CreateDirectory($dst)|Out-Null
[IO.File]::Copy((Join-Path $root "public\guides\grade-10\cycle-4-stem-project-accelerator.html"),(Join-Path $dst "cycle-4-stem-project-accelerator.html"),$true)
Write-Host "2/3 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE-ne 0){throw "Lint fallo. No hagas push."}
Write-Host "3/3 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE-ne 0){throw "Build fallo. No hagas push."}
Write-Host ""
Write-Host "10TH GRADE · CYCLE 4 STEM PROJECT ACCELERATOR READY" -ForegroundColor Green
Write-Host "http://localhost:3000/guides/grade-10/cycle-4-stem-project-accelerator.html"
