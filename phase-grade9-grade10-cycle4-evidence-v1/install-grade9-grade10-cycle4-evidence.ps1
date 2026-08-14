$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "1/5 - Publicando guias de 9th y 10th..." -ForegroundColor Cyan
foreach($grade in @("grade-09","grade-10")){
  $s=Join-Path $root "public\guides\$grade"
  $d=Join-Path (Get-Location) "public\guides\$grade"
  [IO.Directory]::CreateDirectory($d)|Out-Null
  Copy-Item (Join-Path $s "*") $d -Recurse -Force
}

Write-Host "2/5 - Publicando Learning Evidence..." -ForegroundColor Cyan
$evSrc=Join-Path $root "public\evidence"
$evDst=Join-Path (Get-Location) "public\evidence"
[IO.Directory]::CreateDirectory($evDst)|Out-Null
Copy-Item (Join-Path $evSrc "*") $evDst -Recurse -Force

Write-Host "3/5 - Agregando accesos visibles en cada salon..." -ForegroundColor Cyan
$cp=Join-Path (Get-Location) "src\modules\student-projects\data\projects.ts"
if(-not(Test-Path $cp)){throw "No existe projects.ts."}
$c=[IO.File]::ReadAllText($cp)
$e=[IO.File]::ReadAllText((Join-Path $root "project-entries.txt"))
$m='export const studentProjects: StudentProject[] = ['
$p=$c.IndexOf($m)
if($p -lt 0){throw "No encontre studentProjects."}
$bs=[regex]::Matches($e,'(?s)  \{\r?\n    id: "([^"]+)".*?\r?\n  \},')
$ins=""
foreach($b in $bs){
  $id=$b.Groups[1].Value
  if(-not $c.Contains($id)){ $ins+="`r`n"+$b.Value }
  else{Write-Host "   $id ya existe; no se duplica." -ForegroundColor DarkGray}
}
if($ins.Length -gt 0){
  $c=$c.Insert($p+$m.Length,$ins+"`r`n")
  [IO.File]::WriteAllText($cp,$c,(New-Object Text.UTF8Encoding($false)))
}

Write-Host "4/5 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE-ne 0){throw "Lint fallo. No hagas push."}

Write-Host "5/5 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE-ne 0){throw "Build fallo. No hagas push."}

Write-Host ""
Write-Host "9TH + 10TH · CYCLE 4 + LEARNING EVIDENCE READY" -ForegroundColor Green
Write-Host ""
Write-Host "10 Blue:  http://localhost:3000/students/grade/10/blue"
Write-Host "10 Red:   http://localhost:3000/students/grade/10/red"
Write-Host "10 White: http://localhost:3000/students/grade/10/white"
Write-Host "9 Blue:   http://localhost:3000/students/grade/9/blue"
Write-Host "9 White:  http://localhost:3000/students/grade/9/white"
