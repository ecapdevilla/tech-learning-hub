$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "1/4 - Actualizando proyectos 6th Red..." -ForegroundColor Cyan
$src=Join-Path $root "public\evidence\grade-06\red"
$dst=Join-Path (Get-Location) "public\evidence\grade-06\red"
[IO.Directory]::CreateDirectory($dst)|Out-Null

foreach($folder in @("01-la-leyenda-de-basourius","02-cycle4-engineering-evidence")){
  $s=Join-Path $src $folder
  $d=Join-Path $dst $folder
  [IO.Directory]::CreateDirectory($d)|Out-Null
  Copy-Item (Join-Path $s "*") $d -Recurse -Force
}

Write-Host "2/4 - Verificando rutas publicadas..." -ForegroundColor Cyan
foreach($path in @(
  "public\evidence\grade-06\red\01-la-leyenda-de-basourius\index.html",
  "public\evidence\grade-06\red\02-cycle4-engineering-evidence\index.html"
)){
  if(-not(Test-Path -LiteralPath $path)){throw "Falta archivo: $path"}
}

Write-Host "3/4 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE-ne 0){throw "Lint fallo. No hagas push."}

Write-Host "4/4 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE-ne 0){throw "Build fallo. No hagas push."}

Write-Host ""
Write-Host "6TH RED · PROYECTOS ACTUALIZADOS" -ForegroundColor Green
Write-Host "http://localhost:3000/evidence/grade-06/red/01-la-leyenda-de-basourius/index.html"
Write-Host "http://localhost:3000/evidence/grade-06/red/02-cycle4-engineering-evidence/index.html"
