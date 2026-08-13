$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta este script dentro de tech-learning-hub."}

$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$source=Join-Path $root "guides\grade-02-cycle-4-smart-robot-delivery.html"
$target="public\guides\grade-02\cycle-4-smart-robot-delivery.html"
$catalog="src\content\catalog\lessons.ts"
$id="grade-02-cycle-4-smart-robot-delivery"

Write-Host "1/4 - Instalando 2nd Grade Cycle 4..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force "public\guides\grade-02"|Out-Null
Copy-Item $source $target -Force

Write-Host "2/4 - Integrando al catalogo..." -ForegroundColor Cyan
$text=[IO.File]::ReadAllText((Resolve-Path $catalog))
if(-not $text.Contains($id)){
 Copy-Item $catalog "$catalog.g2c4.backup" -Force
 $entry=@'
  {
    id: "grade-02-cycle-4-smart-robot-delivery",
    grade: 2,
    cycle: 4,
    title: {
      en: "Cycle 4 · Smart Robot Delivery",
      es: "Ciclo 4 · Entrega con Robot Inteligente",
    },
    objective: {
      en: "Create simple algorithms using sequences and loops and recognize how sensors help technology receive information.",
      es: "Crear algoritmos sencillos usando secuencias y ciclos y reconocer cómo los sensores ayudan a la tecnología a recibir información.",
    },
    durationMinutes: 60,
    guidePath: "/guides/grade-02/cycle-4-smart-robot-delivery.html",
    tags: ["Cycle 4", "Algorithms", "Sequences", "Loops", "Sensors", "Game"],
  },
'@
 $m=[regex]::Match($text,'export\s+const\s+\w+\s*(?::[^=]+)?=\s*\[')
 if(-not $m.Success){throw "No pude detectar el arreglo principal de lessons.ts."}
 $text=$text.Insert($m.Index+$m.Length,"`r`n"+$entry)
 [IO.File]::WriteAllText((Resolve-Path $catalog),$text,(New-Object Text.UTF8Encoding($false)))
}

Write-Host "3/4 - npm run lint" -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){if(Test-Path "$catalog.g2c4.backup"){Copy-Item "$catalog.g2c4.backup" $catalog -Force};throw "Lint fallo. No hagas push."}

Write-Host "4/4 - npm run build" -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){if(Test-Path "$catalog.g2c4.backup"){Copy-Item "$catalog.g2c4.backup" $catalog -Force};throw "Build fallo. No hagas push."}

if(Test-Path "$catalog.g2c4.backup"){Remove-Item "$catalog.g2c4.backup" -Force}
Write-Host ""
Write-Host "2ND GRADE CYCLE 4 INSTALADO Y VALIDADO" -ForegroundColor Green
Write-Host "Revisa: http://localhost:3000/grades/2"
Write-Host ""
Write-Host "git add ."
Write-Host 'git commit -m "feat: add second grade cycle 4 smart robot delivery"'
Write-Host "git push"
