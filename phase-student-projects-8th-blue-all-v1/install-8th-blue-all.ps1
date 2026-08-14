$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "1/4 - Publicando 5 proyectos de 8th Blue..." -ForegroundColor Cyan
$srcRoot=Join-Path $root "public\student-projects\grade-08\blue"
$dstRoot=Join-Path (Get-Location) "public\student-projects\grade-08\blue"
[IO.Directory]::CreateDirectory($dstRoot)|Out-Null
Get-ChildItem -Path $srcRoot -Directory | ForEach-Object {
  $dst=Join-Path $dstRoot $_.Name
  [IO.Directory]::CreateDirectory($dst)|Out-Null
  Get-ChildItem -Path $_.FullName -File | ForEach-Object {
    [IO.File]::Copy($_.FullName,(Join-Path $dst $_.Name),$true)
  }
}

Write-Host "2/4 - Registrando proyectos en la galeria..." -ForegroundColor Cyan
$cpath=Join-Path (Get-Location) "src\modules\student-projects\data\projects.ts"
if(-not(Test-Path $cpath)){throw "No existe projects.ts. Instala primero Student Projects View."}
$c=[IO.File]::ReadAllText($cpath)
$entries=[IO.File]::ReadAllText((Join-Path $root "project-entries.txt"))
$marker='export const studentProjects: StudentProject[] = ['
$p=$c.IndexOf($marker)
if($p -lt 0){throw "No encontre studentProjects en projects.ts."}

# Insert only entries not already present.
$blocks=[regex]::Matches($entries,'(?s)  \{\r?\n    id: "([^"]+)".*?\r?\n  \},')
$insert=""
foreach($b in $blocks){
  $id=$b.Groups[1].Value
  if(-not $c.Contains($id)){ $insert += "`r`n" + $b.Value }
  else{ Write-Host "   $id ya existe; no se duplica." -ForegroundColor DarkGray }
}
if($insert.Length -gt 0){
  $c=$c.Insert($p+$marker.Length,$insert+"`r`n")
  [IO.File]::WriteAllText($cpath,$c,(New-Object Text.UTF8Encoding($false)))
}

Write-Host "3/4 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){throw "Lint fallo. No hagas push."}

Write-Host "4/4 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){throw "Build fallo. No hagas push."}

Write-Host ""
Write-Host "8TH BLUE · 5 PROYECTOS PUBLICADOS Y VALIDADOS" -ForegroundColor Green
Write-Host "Galeria: http://localhost:3000/students/grade/8/blue"
