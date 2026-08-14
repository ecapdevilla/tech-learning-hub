$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "1/4 - Publicando 11th White..." -ForegroundColor Cyan
$gd=Join-Path (Get-Location) "public\guides\grade-11"; [IO.Directory]::CreateDirectory($gd)|Out-Null
[IO.File]::Copy((Join-Path $root "public\guides\grade-11\white-engineering-sprint.html"),(Join-Path $gd "white-engineering-sprint.html"),$true)
$src=Join-Path $root "public\student-projects\grade-11\white"; $dst=Join-Path (Get-Location) "public\student-projects\grade-11\white"; [IO.Directory]::CreateDirectory($dst)|Out-Null
Get-ChildItem $src -Directory|ForEach-Object{$td=Join-Path $dst $_.Name;[IO.Directory]::CreateDirectory($td)|Out-Null;Copy-Item (Join-Path $_.FullName "*") $td -Recurse -Force}
Write-Host "2/4 - Registrando proyectos..." -ForegroundColor Cyan
$cp=Join-Path (Get-Location) "src\modules\student-projects\data\projects.ts"; if(-not(Test-Path $cp)){throw "No existe projects.ts"}
$c=[IO.File]::ReadAllText($cp);$e=[IO.File]::ReadAllText((Join-Path $root "project-entries.txt"));$m='export const studentProjects: StudentProject[] = [';$p=$c.IndexOf($m);if($p -lt 0){throw "No encontre studentProjects"}
$bs=[regex]::Matches($e,'(?s)  \{\r?\n    id: "([^"]+)".*?\r?\n  \},');$ins=""
foreach($b in $bs){$id=$b.Groups[1].Value;if(-not$c.Contains($id)){$ins+="`r`n"+$b.Value}}
if($ins.Length -gt 0){$c=$c.Insert($p+$m.Length,$ins+"`r`n");[IO.File]::WriteAllText($cp,$c,(New-Object Text.UTF8Encoding($false)))}
Write-Host "3/4 - Lint..." -ForegroundColor Cyan
npm run lint;if($LASTEXITCODE-ne 0){throw "Lint fallo. No hagas push."}
Write-Host "4/4 - Build..." -ForegroundColor Cyan
npm run build;if($LASTEXITCODE-ne 0){throw "Build fallo. No hagas push."}
Write-Host "";Write-Host "11TH WHITE · PROJECT HUB + ACCELERATION SPRINT READY" -ForegroundColor Green
Write-Host "http://localhost:3000/students/grade/11/white"
Write-Host "http://localhost:3000/guides/grade-11/white-engineering-sprint.html"
