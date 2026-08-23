$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$repo=(Get-Location).Path
if(-not(Test-Path -LiteralPath (Join-Path $repo "package.json"))){
  throw "Ejecuta este instalador desde la raiz de tech-learning-hub."
}

$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$source=Join-Path $root "guides\grade-07-cycle-5-automation-engineering.html"
$targetDir=Join-Path $repo "public\guides\grade-07"
$target=Join-Path $targetDir "cycle-5-automation-engineering-sprint.html"
$catalog=Join-Path $repo "src\content\catalog\lessons.ts"
$id="grade-07-cycle-5-automation-engineering"

Write-Host ""
Write-Host "1/4 - Publicando Cycle 5 de 7th..." -ForegroundColor Cyan
[IO.Directory]::CreateDirectory($targetDir)|Out-Null
[IO.File]::Copy($source,$target,$true)

Write-Host "2/4 - Agregando Cycle 5 al catalogo de 7th..." -ForegroundColor Cyan
$text=[IO.File]::ReadAllText($catalog)

if(-not $text.Contains($id)){
$entry=@'
  {
    id: "grade-07-cycle-5-automation-engineering",
    grade: 7,
    cycle: 5,
    title: {
      en: "Cycle 5 · Automated System Final Engineering Sprint",
      es: "Ciclo 5 · Sprint Final de Ingeniería de Sistemas Automatizados",
    },
    objective: {
      en: "Complete and refine the automated system design, simulation or prototype, and technical documentation by applying inputs/sensors, logical decisions, outputs/actuators, testing and debugging.",
      es: "Completar y refinar el diseño del sistema automatizado, su simulación o prototipo y la documentación técnica aplicando entradas/sensores, decisiones lógicas, salidas/actuadores, pruebas y depuración.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-07/cycle-5-automation-engineering-sprint.html",
    tags: ["Cycle 5", "Automation", "Sensors", "Actuators", "Testing", "Debugging", "HTML", "JavaScript", "Wokwi", "Tinkercad", "AI Prompting"],
  },
'@

  $match=[regex]::Match($text,'export\s+const\s+\w+\s*(?::[^=]+)?=\s*\[')
  if(-not $match.Success){
    throw "No pude localizar el arreglo principal de lessons.ts."
  }

  $text=$text.Insert($match.Index+$match.Length,"`r`n"+$entry)
  [IO.File]::WriteAllText($catalog,$text,(New-Object Text.UTF8Encoding($false)))
  Write-Host "   Entrada agregada al catalogo." -ForegroundColor Green
}else{
  Write-Host "   Cycle 5 ya estaba registrado; no se duplica." -ForegroundColor DarkGray
}

Write-Host "3/4 - Verificando instalacion..." -ForegroundColor Cyan
if(-not(Test-Path -LiteralPath $target)){throw "No se publico el HTML."}
$verify=[IO.File]::ReadAllText($catalog)
if(-not $verify.Contains($id)){throw "No se registro Cycle 5 en lessons.ts."}
Write-Host "   Guia + catalogo OK." -ForegroundColor Green

Write-Host "4/4 - Listo." -ForegroundColor Cyan
Write-Host ""
Write-Host "7TH GRADE · CYCLE 5 LISTO PARA VISUALIZAR" -ForegroundColor Green
Write-Host ""
Write-Host "Revisa:"
Write-Host "  http://localhost:3000/grades/7"
Write-Host "  http://localhost:3000/guides/grade-07/cycle-5-automation-engineering-sprint.html"
Write-Host ""
Write-Host "No toca Supabase, Code Battle Live ni ejecuta lint/build global."
