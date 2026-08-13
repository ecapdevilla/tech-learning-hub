$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){throw "Ejecuta este script dentro de tech-learning-hub."}

$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$source=Join-Path $root "guides\grade-08-cycle-4-dashboard-data-storytelling-master-lab.html"
$target="public\guides\grade-08\cycle-4-dashboard-data-storytelling-master-lab.html"
$catalog="src\content\catalog\lessons.ts"
$id="grade-08-cycle-4-dashboard-data-storytelling"

Write-Host ""
Write-Host "1/4 - Instalando 8th Grade Cycle 4 Master Lab..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force "public\guides\grade-08"|Out-Null
Copy-Item -LiteralPath $source -Destination $target -Force

Write-Host "2/4 - Integrando al catalogo..." -ForegroundColor Cyan
$text=[IO.File]::ReadAllText((Resolve-Path $catalog))
if(-not $text.Contains($id)){
 Copy-Item $catalog "$catalog.g8c4.backup" -Force
 $entry=@'
  {
    id: "grade-08-cycle-4-dashboard-data-storytelling",
    grade: 8,
    cycle: 4,
    title: {
      en: "Cycle 4 · Dynamic Dashboard & Data Storytelling Master Lab",
      es: "Ciclo 4 · Laboratorio Maestro de Dashboards Dinámicos y Narrativa de Datos",
    },
    objective: {
      en: "Create dynamic dashboards and charts to visualize and interpret data effectively.",
      es: "Crear dashboards dinámicos y gráficos para visualizar e interpretar datos de manera efectiva.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-08/cycle-4-dashboard-data-storytelling-master-lab.html",
    tags: ["Cycle 4", "Data Analysis", "Dashboard", "Pivot Table", "Charts", "Excel", "Sheets"],
  },
'@
 $m=[regex]::Match($text,'export\s+const\s+\w+\s*(?::[^=]+)?=\s*\[')
 if(-not $m.Success){throw "No pude detectar el arreglo principal de lessons.ts."}
 $text=$text.Insert($m.Index+$m.Length,"`r`n"+$entry)
 [IO.File]::WriteAllText((Resolve-Path $catalog),$text,(New-Object Text.UTF8Encoding($false)))
}

Write-Host "3/4 - npm run lint" -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){if(Test-Path "$catalog.g8c4.backup"){Copy-Item "$catalog.g8c4.backup" $catalog -Force};throw "Lint fallo. No hagas push."}

Write-Host "4/4 - npm run build" -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){if(Test-Path "$catalog.g8c4.backup"){Copy-Item "$catalog.g8c4.backup" $catalog -Force};throw "Build fallo. No hagas push."}

if(Test-Path "$catalog.g8c4.backup"){Remove-Item "$catalog.g8c4.backup" -Force}
Write-Host ""
Write-Host "8TH GRADE CYCLE 4 MASTER LAB INSTALADO Y VALIDADO" -ForegroundColor Green
Write-Host "Revisa: http://localhost:3000/grades/8"
Write-Host ""
Write-Host "Luego:"
Write-Host "git add ."
Write-Host 'git commit -m "feat: add eighth grade cycle 4 dashboard data storytelling master lab"'
Write-Host "git push"
