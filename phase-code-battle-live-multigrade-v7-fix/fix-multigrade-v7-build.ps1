$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){
  throw "Ejecuta este fix desde la raiz de tech-learning-hub."
}

Write-Host "1/4 - Eliminando paquete V7 que Next estaba compilando..." -ForegroundColor Cyan
$old=Join-Path (Get-Location) "phase-code-battle-live-multigrade-v7"

if(Test-Path -LiteralPath $old){
  Remove-Item -LiteralPath $old -Recurse -Force
  Write-Host "   Eliminado: phase-code-battle-live-multigrade-v7" -ForegroundColor DarkGray
}else{
  Write-Host "   La carpeta V7 ya no existe." -ForegroundColor DarkGray
}

Write-Host "2/4 - Verificando archivos instalados reales..." -ForegroundColor Cyan

$required=@(
  "src\modules\live-game\data\grade6Questions.ts",
  "src\modules\live-game\data\grade7Questions.ts",
  "src\modules\live-game\data\grade8Questions.ts",
  "src\modules\live-game\data\grade9Questions.ts",
  "src\modules\live-game\data\grade10Questions.ts",
  "src\modules\live-game\data\grade11Questions.ts",
  "src\modules\live-game\data\questionBanks.ts",
  "src\modules\live-game\types\liveGame.ts",
  "src\app\gamification\live\host\page.tsx",
  "src\app\gamification\live\play\[pin]\page.tsx"
)

foreach($file in $required){
  if(-not(Test-Path -LiteralPath $file)){
    throw "Falta archivo instalado: $file"
  }
}

Write-Host "   Motor multigrado y tipos encontrados correctamente." -ForegroundColor Green

Write-Host "3/4 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE-ne 0){
  throw "Lint fallo. No hagas push."
}

Write-Host "4/4 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE-ne 0){
  throw "Build fallo. No hagas push."
}

Write-Host ""
Write-Host "MULTIGRADE V7 · BUILD FIX READY" -ForegroundColor Green
Write-Host "El motor 6th-11th permanece instalado en src."
