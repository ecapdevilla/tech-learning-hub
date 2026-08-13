$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){
  throw "Ejecuta este script dentro de tech-learning-hub."
}

$root=Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "1/3 - Instalando Robot Rescue corregido..." -ForegroundColor Cyan

$source=Join-Path $root "guides\grade-01-robot-rescue-fixed.html"

Copy-Item -LiteralPath $source `
  -Destination "public\guides\grade-01\quick-games.html" -Force

Copy-Item -LiteralPath $source `
  -Destination "public\guides\grade-01\quick-games-es.html" -Force

Write-Host "2/3 - Ejecutando lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){
  throw "Lint fallo. No hagas git push."
}

Write-Host "3/3 - Ejecutando build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){
  throw "Build fallo. No hagas git push."
}

Write-Host ""
Write-Host "ROBOT RESCUE CORREGIDO E INSTALADO" -ForegroundColor Green
Write-Host ""
Write-Host "Revisa:"
Write-Host "  http://localhost:3000/grades/1"
Write-Host ""
Write-Host "Luego:"
Write-Host "  git add ."
Write-Host '  git commit -m "fix: redesign first grade robot rescue progression"'
Write-Host "  git push"
