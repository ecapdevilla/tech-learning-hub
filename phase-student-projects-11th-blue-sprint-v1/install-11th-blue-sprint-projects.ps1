$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "1/5 - Publicando guia y proyectos 11th Blue..." -ForegroundColor Cyan
$guideDst=Join-Path (Get-Location) "public\guides\grade-11"
[IO.Directory]::CreateDirectory($guideDst)|Out-Null
[IO.File]::Copy((Join-Path $root "public\guides\grade-11\blue-engineering-sprint.html"),(Join-Path $guideDst "blue-engineering-sprint.html"),$true)

$srcProjects=Join-Path $root "public\student-projects\grade-11\blue"
$dstProjects=Join-Path (Get-Location) "public\student-projects\grade-11\blue"
[IO.Directory]::CreateDirectory($dstProjects)|Out-Null
Get-ChildItem -Path $srcProjects -Directory | ForEach-Object {
  $sourceDir=$_.FullName
  $targetDir=Join-Path $dstProjects $_.Name
  [IO.Directory]::CreateDirectory($targetDir)|Out-Null
  Copy-Item -Path (Join-Path $sourceDir "*") -Destination $targetDir -Recurse -Force
}

Write-Host "2/5 - Registrando 11th Blue en Student Projects..." -ForegroundColor Cyan
$cpath=Join-Path (Get-Location) "src\modules\student-projects\data\projects.ts"
if(-not(Test-Path $cpath)){throw "No existe projects.ts."}
$c=[IO.File]::ReadAllText($cpath)
$entries=[IO.File]::ReadAllText((Join-Path $root "project-entries.txt"))
$marker='export const studentProjects: StudentProject[] = ['
$p=$c.IndexOf($marker)
if($p -lt 0){throw "No encontre studentProjects."}
$blocks=[regex]::Matches($entries,'(?s)  \{\r?\n    id: "([^"]+)".*?\r?\n  \},')
$insert=""
foreach($b in $blocks){
  $id=$b.Groups[1].Value
  if(-not $c.Contains($id)){ $insert+="`r`n"+$b.Value }
  else{Write-Host "   $id ya existe; no se duplica." -ForegroundColor DarkGray}
}
if($insert.Length -gt 0){
  $c=$c.Insert($p+$marker.Length,$insert+"`r`n")
  [IO.File]::WriteAllText($cpath,$c,(New-Object Text.UTF8Encoding($false)))
}

Write-Host "3/5 - Agregando enlace Sprint Guide a todos los proyectos 11th Blue..." -ForegroundColor Cyan
$htmlFiles=Get-ChildItem -Path $dstProjects -Filter "index.html" -File -Recurse
foreach($f in $htmlFiles){
  $content=[IO.File]::ReadAllText($f.FullName)
  if($content.Contains("TLH-11BLUE-SPRINT-LINK")){continue}
  $widget=@'
<!-- TLH-11BLUE-SPRINT-LINK -->
<a href="/guides/grade-11/blue-engineering-sprint.html" style="position:fixed;right:14px;bottom:14px;z-index:99999;padding:10px 13px;border-radius:999px;background:#0d253f;color:white;text-decoration:none;font:800 12px Segoe UI,Arial;box-shadow:0 8px 24px rgba(0,0,0,.25)">📘 Sprint Guide</a>
'@
  if($content -match '(?i)</body>'){$content=[regex]::Replace($content,'(?i)</body>',$widget+"`r`n</body>",1)}
  else{$content+=$widget}
  [IO.File]::WriteAllText($f.FullName,$content,(New-Object Text.UTF8Encoding($false)))
}

Write-Host "4/5 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){throw "Lint fallo. No hagas push."}

Write-Host "5/5 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){throw "Build fallo. No hagas push."}

Write-Host ""
Write-Host "11TH BLUE · SPRINT GUIDE + PROJECT PROGRESS HUB PUBLICADOS" -ForegroundColor Green
Write-Host "Galeria: http://localhost:3000/students/grade/11/blue"
Write-Host "Guia:    http://localhost:3000/guides/grade-11/blue-engineering-sprint.html"
