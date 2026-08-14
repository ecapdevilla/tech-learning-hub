$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){
  throw "Ejecuta este instalador desde la raiz de tech-learning-hub."
}

$phaseRoot=Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "1/5 - Publicando Start From Zero..." -ForegroundColor Cyan
$guideDir=Join-Path (Get-Location) "public\guides\grade-11"
[IO.Directory]::CreateDirectory($guideDir)|Out-Null
[IO.File]::Copy(
  (Join-Path $phaseRoot "public\guides\grade-11\start-from-zero.html"),
  (Join-Path $guideDir "start-from-zero.html"),
  $true
)

function Add-StartCard {
  param(
    [string]$Classroom,
    [string]$Title
  )

  $projectsPath=Join-Path (Get-Location) "src\modules\student-projects\data\projects.ts"
  if(-not(Test-Path $projectsPath)){throw "No existe projects.ts"}

  $content=[IO.File]::ReadAllText($projectsPath)
  $id="grade-11-$Classroom-start-from-zero"

  if($content.Contains($id)){
    Write-Host "   $id ya existe; no se duplica." -ForegroundColor DarkGray
    return
  }

  $marker='export const studentProjects: StudentProject[] = ['
  $pos=$content.IndexOf($marker)
  if($pos -lt 0){throw "No encontre studentProjects."}

  $entry=@"

  {
    id: "$id",
    slug: "start-from-zero",
    studentName: "New / pending teams",
    grade: 11,
    classroom: "$Classroom",
    period: 3,
    cycle: 4,
    title: "$Title",
    objective: "Start the Cycle 4 engineering project from zero with a clear problem, ODS, architecture, ESP32 automation rule, Wokwi MVP plan and web dashboard blueprint.",
    description: "Start here if your team has not submitted usable evidence yet or needs a clear route from idea to functional robotics + web project.",
    skills: ["Problem Solving", "Robotics", "ESP32", "Systems Design", "Web Development", "Testing", "ODS"],
    technologies: ["Wokwi", "ESP32", "HTML", "CSS", "JavaScript"],
    projectPath: "/guides/grade-11/start-from-zero.html",
    published: true,
  },
"@

  $content=$content.Insert($pos+$marker.Length,$entry)
  [IO.File]::WriteAllText($projectsPath,$content,(New-Object Text.UTF8Encoding($false)))
}

Write-Host "2/5 - Agregando acceso SIN modificar proyectos existentes de 11th Blue..." -ForegroundColor Cyan
Add-StartCard -Classroom "blue" -Title "Start From Zero · Engineering Launchpad"

Write-Host "3/5 - Agregando acceso visible a 11th White..." -ForegroundColor Cyan
Add-StartCard -Classroom "white" -Title "Start From Zero · Engineering Launchpad"

Write-Host "4/5 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){throw "Lint fallo. No hagas push."}

Write-Host "5/5 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){throw "Build fallo. No hagas push."}

Write-Host ""
Write-Host "START FROM ZERO agregado a 11th Blue y 11th White." -ForegroundColor Green
Write-Host "No se modificaron los proyectos existentes de Blue." -ForegroundColor Green
Write-Host ""
Write-Host "Blue:  http://localhost:3000/students/grade/11/blue"
Write-Host "White: http://localhost:3000/students/grade/11/white"
Write-Host "Guide: http://localhost:3000/guides/grade-11/start-from-zero.html"
