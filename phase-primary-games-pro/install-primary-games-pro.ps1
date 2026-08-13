$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Step([string]$Message){
  Write-Host ""
  Write-Host "============================================================" -ForegroundColor DarkCyan
  Write-Host $Message -ForegroundColor Cyan
  Write-Host "============================================================" -ForegroundColor DarkCyan
}

if(-not(Test-Path "package.json")){
  throw "Ejecuta este script dentro de tech-learning-hub."
}

$root=Split-Path -Parent $MyInvocation.MyCommand.Path

Step "1/4 - Reemplazando juego de 1st Grade"
Copy-Item -LiteralPath (Join-Path $root "guides\grade-01-quick-games-pro.html") `
  -Destination "public\guides\grade-01\quick-games.html" -Force
Copy-Item -LiteralPath (Join-Path $root "guides\grade-01-quick-games-pro.html") `
  -Destination "public\guides\grade-01\quick-games-es.html" -Force

Step "2/4 - Reemplazando juego de 4th Grade"
Copy-Item -LiteralPath (Join-Path $root "guides\grade-04-quick-games-pro.html") `
  -Destination "public\guides\grade-04\quick-games.html" -Force
Copy-Item -LiteralPath (Join-Path $root "guides\grade-04-quick-games-pro.html") `
  -Destination "public\guides\grade-04\quick-games-es.html" -Force

Step "3/4 - Ejecutando lint"
npm run lint
if($LASTEXITCODE -ne 0){throw "Lint fallo. No hagas push."}

Step "4/4 - Ejecutando build"
npm run build
if($LASTEXITCODE -ne 0){throw "Build fallo. No hagas push."}

Write-Host ""
Write-Host "JUEGOS PRO DE 1ST Y 4TH INSTALADOS" -ForegroundColor Green
Write-Host ""
Write-Host "Revisa:" -ForegroundColor Yellow
Write-Host "  http://localhost:3000/grades/1"
Write-Host "  http://localhost:3000/grades/4"
Write-Host ""
Write-Host "Luego publica:" -ForegroundColor Yellow
Write-Host "  git add ."
Write-Host '  git commit -m "feat: upgrade first and fourth grade learning games"'
Write-Host "  git push"
