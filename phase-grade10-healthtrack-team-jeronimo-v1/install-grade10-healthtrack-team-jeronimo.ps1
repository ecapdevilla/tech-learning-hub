$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
$repo=(Get-Location).Path
if(-not(Test-Path -LiteralPath (Join-Path $repo "package.json"))){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$target=Join-Path $repo "public\student-projects\grade-10\updated-sequences"
$guideDir=Join-Path $repo "public\guides\grade-10"
[IO.Directory]::CreateDirectory($target)|Out-Null
[IO.Directory]::CreateDirectory($guideDir)|Out-Null

# Mantiene/copía las evidencias ya curadas del paquete base y agrega HealthTrack completo.
Copy-Item -LiteralPath (Join-Path $root "projects\red") -Destination $target -Recurse -Force
Copy-Item -LiteralPath (Join-Path $root "projects\white") -Destination $target -Recurse -Force
$additional=Join-Path $target "additional"
[IO.Directory]::CreateDirectory($additional)|Out-Null
$healthDst=Join-Path $additional "team-jeronimo-healthtrack"
if(Test-Path -LiteralPath $healthDst){Remove-Item -LiteralPath $healthDst -Recurse -Force}
Copy-Item -LiteralPath (Join-Path $root "projects\additional\team-jeronimo-healthtrack") -Destination $additional -Recurse -Force
Copy-Item -LiteralPath (Join-Path $root "updated-sequences.html") -Destination (Join-Path $guideDir "updated-class-sequences.html") -Force

Write-Host "HealthTrack de Team Jeronimo agregado a 10th Updated Class Sequences." -ForegroundColor Green
Write-Host "http://localhost:3000/guides/grade-10/updated-class-sequences.html"
Write-Host "Proyecto: http://localhost:3000/student-projects/grade-10/updated-sequences/additional/team-jeronimo-healthtrack/index.html"
Write-Host "Luego ejecuta npm run lint y npm run build antes del push." -ForegroundColor Yellow
