$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "1/4 - Publicando Grupo 2..." -ForegroundColor Cyan
$d=Join-Path (Get-Location) "public\student-projects\grade-08\white\grupo-2-datos-ods"
[IO.Directory]::CreateDirectory($d)|Out-Null
[IO.File]::Copy((Join-Path $root "public\student-projects\grade-08\white\grupo-2-datos-ods\index.html"),(Join-Path $d "index.html"),$true)

Write-Host "2/4 - Registrando en galeria..." -ForegroundColor Cyan
$cpath=Join-Path (Get-Location) "src\modules\student-projects\data\projects.ts"
$c=[IO.File]::ReadAllText($cpath)
$id='grade-08-white-grupo2-datos-ods'
if(-not $c.Contains($id)){
 $e=[IO.File]::ReadAllText((Join-Path $root "project-entry.txt"))
 $m='export const studentProjects: StudentProject[] = ['
 $p=$c.IndexOf($m); if($p -lt 0){throw "No encontre studentProjects."}
 $c=$c.Insert($p+$m.Length,"`r`n"+$e+"`r`n")
 [IO.File]::WriteAllText($cpath,$c,(New-Object Text.UTF8Encoding($false)))
}
Write-Host "3/4 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){throw "Lint fallo. No hagas push."}
Write-Host "4/4 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){throw "Build fallo. No hagas push."}
Write-Host ""
Write-Host "8TH WHITE · GRUPO 2 PUBLICADO Y VALIDADO" -ForegroundColor Green
Write-Host "http://localhost:3000/students/grade/8/white"
Write-Host "http://localhost:3000/student-projects/grade-08/white/grupo-2-datos-ods/index.html"
