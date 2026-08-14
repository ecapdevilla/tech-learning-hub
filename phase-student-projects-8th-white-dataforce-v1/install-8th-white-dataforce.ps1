$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){
  throw "Ejecuta este instalador desde la raiz de tech-learning-hub."
}

$installerRoot=Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "1/4 - Publicando Code for Change · DataForce..." -ForegroundColor Cyan
$destDir=Join-Path (Get-Location) "public\student-projects\grade-08\white\code-for-change-dataforce"
[System.IO.Directory]::CreateDirectory($destDir) | Out-Null
[System.IO.File]::Copy(
  (Join-Path $installerRoot "public\student-projects\grade-08\white\code-for-change-dataforce\index.html"),
  (Join-Path $destDir "index.html"),
  $true
)

Write-Host "2/4 - Registrando proyecto en 8th White..." -ForegroundColor Cyan
$catalogPath=Join-Path (Get-Location) "src\modules\student-projects\data\projects.ts"
if(-not(Test-Path $catalogPath)){
  throw "No existe projects.ts. Primero debe estar instalada Student Projects View."
}

$catalog=[System.IO.File]::ReadAllText($catalogPath)
$id='grade-08-white-code-for-change-dataforce'

if(-not $catalog.Contains($id)){
  $entry=[System.IO.File]::ReadAllText((Join-Path $installerRoot "project-entry.txt"))
  $marker='export const studentProjects: StudentProject[] = ['
  $pos=$catalog.IndexOf($marker)
  if($pos -lt 0){throw "No encontre studentProjects en projects.ts."}

  $insertPos=$pos+$marker.Length
  $catalog=$catalog.Insert($insertPos,"`r`n"+$entry+"`r`n")
  [System.IO.File]::WriteAllText(
    $catalogPath,
    $catalog,
    (New-Object Text.UTF8Encoding($false))
  )
}else{
  Write-Host "   El proyecto ya estaba registrado; no se duplica." -ForegroundColor DarkGray
}

Write-Host "3/4 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){
  throw "Lint fallo. No hagas push."
}

Write-Host "4/4 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){
  throw "Build fallo. No hagas push."
}

Write-Host ""
Write-Host "8TH WHITE · CODE FOR CHANGE PUBLICADO Y VALIDADO" -ForegroundColor Green
Write-Host ""
Write-Host "Revisa:"
Write-Host " http://localhost:3000/students/grade/8/white"
Write-Host " http://localhost:3000/student-projects/grade-08/white/code-for-change-dataforce/index.html"
