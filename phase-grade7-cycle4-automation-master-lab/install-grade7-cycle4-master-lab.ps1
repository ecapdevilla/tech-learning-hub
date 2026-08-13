$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){ throw "Ejecuta este script dentro de tech-learning-hub." }

$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$source=Join-Path $root "guides\grade-07-cycle-4-automation-simulation-master-lab.html"
$target="public\guides\grade-07\cycle-4-automation-simulation-master-lab.html"
$catalog="src\content\catalog\lessons.ts"
$id="grade-07-cycle-4-automation-simulation"

Write-Host ""
Write-Host "1/4 - Instalando 7th Grade Cycle 4 Master Lab..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force "public\guides\grade-07"|Out-Null
Copy-Item -LiteralPath $source -Destination $target -Force

Write-Host "2/4 - Verificando catalogo..." -ForegroundColor Cyan
$text=[IO.File]::ReadAllText((Resolve-Path $catalog))
if(-not $text.Contains($id)){
  Copy-Item $catalog "$catalog.g7c4.backup" -Force
  $entry=@'
  {
    id: "grade-07-cycle-4-automation-simulation",
    grade: 7,
    cycle: 4,
    title: {
      en: "Cycle 4 · Automation Simulation Master Lab",
      es: "Ciclo 4 · Laboratorio Maestro de Simulación y Automatización",
    },
    objective: {
      en: "Simulate an automated system using Wokwi or Tinkercad and document the engineering process.",
      es: "Simular un sistema automatizado usando Wokwi o Tinkercad y documentar el proceso de ingeniería.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-07/cycle-4-automation-simulation-master-lab.html",
    tags: ["Cycle 4", "Automation", "Simulation", "Wokwi", "Tinkercad", "PIR", "Arduino"],
  },
'@
  $m=[regex]::Match($text,'export\s+const\s+\w+\s*(?::[^=]+)?=\s*\[')
  if(-not $m.Success){ throw "No pude detectar automaticamente el arreglo principal de lessons.ts." }
  $text=$text.Insert($m.Index+$m.Length,"`r`n"+$entry)
  [IO.File]::WriteAllText((Resolve-Path $catalog),$text,(New-Object Text.UTF8Encoding($false)))
}

Write-Host "3/4 - npm run lint" -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){
  if(Test-Path "$catalog.g7c4.backup"){Copy-Item "$catalog.g7c4.backup" $catalog -Force}
  throw "Lint fallo. No hagas push."
}

Write-Host "4/4 - npm run build" -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){
  if(Test-Path "$catalog.g7c4.backup"){Copy-Item "$catalog.g7c4.backup" $catalog -Force}
  throw "Build fallo. No hagas push."
}

if(Test-Path "$catalog.g7c4.backup"){Remove-Item "$catalog.g7c4.backup" -Force}

Write-Host ""
Write-Host "7TH GRADE CYCLE 4 MASTER LAB INSTALADO Y VALIDADO" -ForegroundColor Green
Write-Host ""
Write-Host "Revisa: http://localhost:3000/grades/7"
Write-Host ""
Write-Host "Luego:"
Write-Host "  git add ."
Write-Host '  git commit -m "feat: add seventh grade cycle 4 automation simulation master lab"'
Write-Host "  git push"
