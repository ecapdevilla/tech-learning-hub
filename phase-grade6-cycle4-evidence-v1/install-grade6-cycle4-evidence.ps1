$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "1/4 - Publicando evidencias de 6th Blue, Red y White..." -ForegroundColor Cyan
$dst=Join-Path (Get-Location) "public\evidence\grade-06";[IO.Directory]::CreateDirectory($dst)|Out-Null
Copy-Item (Join-Path $root "public\evidence\grade-06\*") $dst -Recurse -Force
Write-Host "2/4 - Agregando accesos visibles a Cycle 4 + Learning Evidence..." -ForegroundColor Cyan
$cp=Join-Path (Get-Location) "src\modules\student-projects\data\projects.ts";if(-not(Test-Path $cp)){throw "No existe projects.ts"}
$c=[IO.File]::ReadAllText($cp);$e=[IO.File]::ReadAllText((Join-Path $root "project-entries.txt"));$m='export const studentProjects: StudentProject[] = [';$p=$c.IndexOf($m);if($p-lt 0){throw "No encontre studentProjects"}
$bs=[regex]::Matches($e,'(?s)  \{\r?\n    id: "([^"]+)".*?\r?\n  \},');$ins=""
foreach($b in $bs){$id=$b.Groups[1].Value;if(-not$c.Contains($id)){$ins+="`r`n"+$b.Value}else{Write-Host "   $id ya existe; no se duplica." -ForegroundColor DarkGray}}
if($ins.Length-gt 0){$c=$c.Insert($p+$m.Length,$ins+"`r`n");[IO.File]::WriteAllText($cp,$c,(New-Object Text.UTF8Encoding($false)))}
Write-Host "3/4 - Lint..." -ForegroundColor Cyan
npm run lint;if($LASTEXITCODE-ne 0){throw "Lint fallo. No hagas push."}
Write-Host "4/4 - Build..." -ForegroundColor Cyan
npm run build;if($LASTEXITCODE-ne 0){throw "Build fallo. No hagas push."}
Write-Host ""
Write-Host "6TH BLUE + RED + WHITE · EVIDENCE READY" -ForegroundColor Green
Write-Host "http://localhost:3000/students/grade/6/blue"
Write-Host "http://localhost:3000/students/grade/6/red"
Write-Host "http://localhost:3000/students/grade/6/white"
