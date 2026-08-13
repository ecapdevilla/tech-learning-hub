$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){
  throw "Ejecuta este script dentro de tech-learning-hub."
}

$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$source=Join-Path $root "guides\grade-06-cycle-4-interactive-project-master-lab.html"
$target="public\guides\grade-06\cycle-4-interactive-project-lab.html"
$catalog="src\content\catalog\lessons.ts"
$id="grade-06-cycle-4-interactive-project"

Write-Host ""
Write-Host "1/4 - Instalando Cycle 4 Master Lab..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force "public\guides\grade-06"|Out-Null
Copy-Item -LiteralPath $source -Destination $target -Force

Write-Host "2/4 - Verificando catalogo..." -ForegroundColor Cyan
$text=[IO.File]::ReadAllText((Resolve-Path $catalog))

if(-not $text.Contains($id)){
  Copy-Item $catalog "$catalog.master.backup" -Force

  $entry=@'
  {
    id: "grade-06-cycle-4-interactive-project",
    grade: 6,
    cycle: 4,
    title: {
      en: "Cycle 4 · Interactive Project Master Lab",
      es: "Ciclo 4 · Laboratorio Maestro de Proyecto Interactivo",
    },
    objective: {
      en: "Create a complete interactive project integrating variables, user input, conditionals and loops, with arrays as an advanced challenge.",
      es: "Crear un proyecto interactivo completo integrando variables, entrada del usuario, condicionales y ciclos, con arreglos como desafío avanzado.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-06/cycle-4-interactive-project-lab.html",
    tags: ["Cycle 4", "Project", "Variables", "Conditionals", "Loops", "Arrays", "Evidence"],
  },
'@

  $m=[regex]::Match($text,'export\s+const\s+\w+\s*(?::[^=]+)?=\s*\[')
  if(-not $m.Success){
    throw "No pude detectar automaticamente el arreglo de lessons.ts."
  }

  $text=$text.Insert($m.Index+$m.Length,"`r`n"+$entry)
  [IO.File]::WriteAllText((Resolve-Path $catalog),$text,(New-Object Text.UTF8Encoding($false)))
}

Write-Host "3/4 - npm run lint" -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){
  if(Test-Path "$catalog.master.backup"){Copy-Item "$catalog.master.backup" $catalog -Force}
  throw "Lint fallo. Si el instalador modifico lessons.ts, fue restaurado."
}

Write-Host "4/4 - npm run build" -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){
  if(Test-Path "$catalog.master.backup"){Copy-Item "$catalog.master.backup" $catalog -Force}
  throw "Build fallo. Si el instalador modifico lessons.ts, fue restaurado."
}

if(Test-Path "$catalog.master.backup"){Remove-Item "$catalog.master.backup" -Force}

Write-Host ""
Write-Host "CYCLE 4 MASTER LAB INSTALADO Y VALIDADO" -ForegroundColor Green
Write-Host ""
Write-Host "Revisa:"
Write-Host "  http://localhost:3000/grades/6"
Write-Host ""
Write-Host "Luego:"
Write-Host "  git add ."
Write-Host '  git commit -m "feat: upgrade sixth grade cycle 4 to interactive project master lab"'
Write-Host "  git push"
