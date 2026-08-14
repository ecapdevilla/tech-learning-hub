$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta este instalador desde la raiz de tech-learning-hub."}

$installerRoot=Split-Path -Parent $MyInvocation.MyCommand.Path
$destDir=Join-Path (Get-Location) "public\student-projects\grade-07\blue\ods14-life-below-water"
[System.IO.Directory]::CreateDirectory($destDir) | Out-Null

Write-Host "1/4 - Publicando proyecto 7th Blue..." -ForegroundColor Cyan
[System.IO.File]::Copy(
  (Join-Path $installerRoot "public\student-projects\grade-07\blue\ods14-life-below-water\index.html"),
  (Join-Path $destDir "index.html"),
  $true
)

Write-Host "2/4 - Registrando proyecto en la galeria..." -ForegroundColor Cyan
$catalogPath=Join-Path (Get-Location) "src\modules\student-projects\data\projects.ts"
if(-not(Test-Path $catalogPath)){throw "No existe projects.ts. Primero debe estar instalada la Student Projects View."}

$catalog=[System.IO.File]::ReadAllText($catalogPath)
$projectId='grade-07-blue-ods14-life-below-water'
if(-not $catalog.Contains($projectId)){
  $entry=[System.IO.File]::ReadAllText((Join-Path $installerRoot "project-entry.txt"))
  $marker='export const studentProjects: StudentProject[] = ['
  $pos=$catalog.IndexOf($marker)
  if($pos -lt 0){throw "No encontre el inicio de studentProjects en projects.ts."}
  $insertPos=$pos+$marker.Length
  $catalog=$catalog.Insert($insertPos,"`r`n"+$entry+"`r`n")
  [System.IO.File]::WriteAllText($catalogPath,$catalog,(New-Object Text.UTF8Encoding($false)))
}else{
  Write-Host "   El proyecto ya estaba registrado; no se duplica." -ForegroundColor DarkGray
}

Write-Host "3/4 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){throw "Lint fallo. No hagas push."}

Write-Host "4/4 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){throw "Build fallo. No hagas push."}

Write-Host ""
Write-Host "7TH BLUE · ODS 14 PUBLICADO Y VALIDADO" -ForegroundColor Green
Write-Host "Revisa:"
Write-Host " http://localhost:3000/students/grade/7/blue"
Write-Host " http://localhost:3000/student-projects/grade-07/blue/ods14-life-below-water/index.html"
