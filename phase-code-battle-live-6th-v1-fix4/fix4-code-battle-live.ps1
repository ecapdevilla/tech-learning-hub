$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){
  throw "Ejecuta desde la raiz de tech-learning-hub."
}

$root=Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "1/6 - Limpiando fixes antiguos del analisis de TypeScript..." -ForegroundColor Cyan
$oldFolders=@(
  "phase-code-battle-live-6th-v1-fix2",
  "phase-code-battle-live-6th-v1-fix3"
)

foreach($folder in $oldFolders){
  $path=Join-Path (Get-Location) $folder
  if(Test-Path -LiteralPath $path){
    Remove-Item -LiteralPath $path -Recurse -Force
    Write-Host "   Eliminado: $folder" -ForegroundColor DarkGray
  }
}

Write-Host "2/6 - Corrigiendo nullabilidad de Supabase en Host..." -ForegroundColor Cyan
$hostSource=Join-Path $root "src\app\gamification\live\host\page.tsx"
$hostTarget=Join-Path (Get-Location) "src\app\gamification\live\host\page.tsx"
[IO.File]::Copy($hostSource,$hostTarget,$true)

Write-Host "3/6 - Corrigiendo nullabilidad de Supabase en Player [pin]..." -ForegroundColor Cyan
$playerSource=Join-Path $root "src\app\gamification\live\play\[pin]\page.tsx"
$playerTarget=Join-Path (Get-Location) "src\app\gamification\live\play\[pin]\page.tsx"
[IO.File]::Copy($playerSource,$playerTarget,$true)

Write-Host "4/6 - Validando archivos..." -ForegroundColor Cyan
$hostText=[IO.File]::ReadAllText($hostTarget)
$playerText=[IO.File]::ReadAllText($playerTarget)

if(-not $hostText.Contains("const supabase = liveSupabase;")){
  throw "Host no contiene la correccion de Supabase."
}
if(-not $playerText.Contains("const supabase = liveSupabase;")){
  throw "Player no contiene la correccion de Supabase."
}
if($hostText.Contains("void liveSupabase.removeChannel(channel);")){
  throw "Host todavia usa liveSupabase nullable en cleanup."
}
if($playerText.Contains("void liveSupabase.removeChannel(channel);")){
  throw "Player todavia usa liveSupabase nullable en cleanup."
}

Write-Host "   Archivos validados." -ForegroundColor Green

Write-Host "5/6 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE-ne 0){
  throw "Lint fallo. No hagas push."
}

Write-Host "6/6 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE-ne 0){
  throw "Build fallo. No hagas push."
}

Write-Host ""
Write-Host "CODE BATTLE LIVE · FIX 4 COMPLETADO" -ForegroundColor Green
Write-Host "Lint y build pasaron. Ya podemos continuar con Supabase."
