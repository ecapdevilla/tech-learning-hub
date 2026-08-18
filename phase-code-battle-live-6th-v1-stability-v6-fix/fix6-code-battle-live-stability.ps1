$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){
  throw "Ejecuta este parche desde la raiz de tech-learning-hub."
}

$root=Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "1/6 - Limpiando fase V5 anterior del analisis..." -ForegroundColor Cyan
$old=Join-Path (Get-Location) "phase-code-battle-live-6th-v1-stability-v5"
if(Test-Path -LiteralPath $old){
  Remove-Item -LiteralPath $old -Recurse -Force
  Write-Host "   Eliminado: phase-code-battle-live-6th-v1-stability-v5" -ForegroundColor DarkGray
}

Write-Host "2/6 - Aplicando correccion React Hook..." -ForegroundColor Cyan
$source=Join-Path $root "src\app\gamification\live\play\[pin]\page.tsx"
$target=Join-Path (Get-Location) "src\app\gamification\live\play\[pin]\page.tsx"
[IO.File]::Copy($source,$target,$true)

Write-Host "3/6 - Validando que no quede setConnection sincronico..." -ForegroundColor Cyan
$content=[IO.File]::ReadAllText($target)
$bad='    setConnection("connecting");'
if($content.Contains($bad)){
  throw "Todavia existe setConnection sincronico dentro del efecto."
}
foreach($required in @(
  "restorePlayerSession",
  "FALLBACK_POLL_MS",
  "visibilitychange",
  "safePlayGameSound",
  "live-connection"
)){
  if(-not $content.Contains($required)){
    throw "Falta caracteristica de estabilidad: $required"
  }
}
Write-Host "   V5 resiliente conservada y hook corregido." -ForegroundColor Green

Write-Host "4/6 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE-ne 0){
  throw "Lint fallo. No hagas push."
}

Write-Host "5/6 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE-ne 0){
  throw "Build fallo. No hagas push."
}

Write-Host "6/6 - Verificacion final..." -ForegroundColor Cyan
Write-Host ""
Write-Host "CODE BATTLE LIVE · STABILITY V6 FIX READY" -ForegroundColor Green
Write-Host "Reconexión, recuperación, polling fallback y safe audio siguen activos."
Write-Host "Ya puedes desplegar y probar los celulares que se caian."
