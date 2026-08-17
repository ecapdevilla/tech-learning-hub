$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "1/5 - Publicando guia Cycle 4 de 7th..." -ForegroundColor Cyan
$gd=Join-Path (Get-Location) "public\guides\grade-07";[IO.Directory]::CreateDirectory($gd)|Out-Null
Copy-Item (Join-Path $root "public\guides\grade-07\*") $gd -Recurse -Force
Write-Host "2/5 - Publicando evidencias 7th Red + White..." -ForegroundColor Cyan
$ed=Join-Path (Get-Location) "public\evidence\grade-07";[IO.Directory]::CreateDirectory($ed)|Out-Null
Copy-Item (Join-Path $root "public\evidence\grade-07\*") $ed -Recurse -Force
Write-Host "3/5 - Agregando accesos visibles..." -ForegroundColor Cyan
$cp=Join-Path (Get-Location) "src\modules\student-projects\data\projects.ts";if(-not(Test-Path $cp)){throw "No existe projects.ts"}
$c=[IO.File]::ReadAllText($cp);$e=[IO.File]::ReadAllText((Join-Path $root "project-entries.txt"));$m='export const studentProjects: StudentProject[] = [';$p=$c.IndexOf($m);if($p-lt 0){throw "No encontre studentProjects"}
$bs=[regex]::Matches($e,'(?s)  \{\r?\n    id: "([^"]+)".*?\r?\n  \},');$ins=""
foreach($b in $bs){$id=$b.Groups[1].Value;if(-not$c.Contains($id)){$ins+="`r`n"+$b.Value}else{Write-Host "   $id ya existe; no se duplica." -ForegroundColor DarkGray}}
if($ins.Length-gt 0){$c=$c.Insert($p+$m.Length,$ins+"`r`n");[IO.File]::WriteAllText($cp,$c,(New-Object Text.UTF8Encoding($false)))}
Write-Host "4/5 - Lint..." -ForegroundColor Cyan
npm run lint;if($LASTEXITCODE-ne 0){throw "Lint fallo. No hagas push."}
Write-Host "5/5 - Build..." -ForegroundColor Cyan
npm run build;if($LASTEXITCODE-ne 0){throw "Build fallo. No hagas push."}
Write-Host ""
Write-Host "7TH RED + WHITE · CYCLE 4 + EVIDENCE READY" -ForegroundColor Green
Write-Host "http://localhost:3000/students/grade/7/red"
Write-Host "http://localhost:3000/students/grade/7/white"
