$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta este instalador desde la raiz de tech-learning-hub."}
$installerRoot=Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "1/4 - Publicando Analitica Educativa..." -ForegroundColor Cyan
$destDir=Join-Path (Get-Location) "public\student-projects\grade-08\white\analitica-educativa"
[System.IO.Directory]::CreateDirectory($destDir)|Out-Null
[System.IO.File]::Copy(
 (Join-Path $installerRoot "public\student-projects\grade-08\white\analitica-educativa\index.html"),
 (Join-Path $destDir "index.html"),$true)

Write-Host "2/4 - Registrando proyecto en 8th White..." -ForegroundColor Cyan
$catalogPath=Join-Path (Get-Location) "src\modules\student-projects\data\projects.ts"
if(-not(Test-Path $catalogPath)){throw "No existe projects.ts."}
$catalog=[System.IO.File]::ReadAllText($catalogPath)
$id='grade-08-white-analitica-educativa'
if(-not $catalog.Contains($id)){
 $entry=[System.IO.File]::ReadAllText((Join-Path $installerRoot "project-entry.txt"))
 $marker='export const studentProjects: StudentProject[] = ['
 $pos=$catalog.IndexOf($marker)
 if($pos -lt 0){throw "No encontre studentProjects en projects.ts."}
 $catalog=$catalog.Insert($pos+$marker.Length,"`r`n"+$entry+"`r`n")
 [System.IO.File]::WriteAllText($catalogPath,$catalog,(New-Object Text.UTF8Encoding($false)))
}else{Write-Host "   Ya estaba registrado; no se duplica." -ForegroundColor DarkGray}

Write-Host "3/4 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){throw "Lint fallo. No hagas push."}

Write-Host "4/4 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){throw "Build fallo. No hagas push."}

Write-Host ""
Write-Host "8TH WHITE · ANALITICA EDUCATIVA PUBLICADO Y VALIDADO" -ForegroundColor Green
Write-Host " http://localhost:3000/students/grade/8/white"
Write-Host " http://localhost:3000/student-projects/grade-08/white/analitica-educativa/index.html"
