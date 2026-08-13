$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){
  throw "Ejecuta este script dentro de tech-learning-hub."
}

$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$source=Join-Path $root "guides\grade-06-cycle-4-interactive-project-lab-pro.html"
$target="public\guides\grade-06\cycle-4-interactive-project-lab.html"

Write-Host ""
Write-Host "1/3 - Instalando version PRO de Cycle 4..." -ForegroundColor Cyan
Copy-Item -LiteralPath $source -Destination $target -Force

Write-Host "2/3 - Ejecutando lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){
  throw "Lint fallo. No hagas push."
}

Write-Host "3/3 - Ejecutando build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){
  throw "Build fallo. No hagas push."
}

Write-Host ""
Write-Host "CYCLE 4 PRO ACTUALIZADO CORRECTAMENTE" -ForegroundColor Green
Write-Host ""
Write-Host "Revisa:"
Write-Host "  http://localhost:3000/grades/6"
Write-Host ""
Write-Host "Luego:"
Write-Host "  git add ."
Write-Host '  git commit -m "feat: upgrade sixth grade cycle 4 evidence experience"'
Write-Host "  git push"
