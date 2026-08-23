$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){
  throw "Ejecuta este instalador dentro de la raiz de tech-learning-hub."
}

$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$source=Join-Path $root "guides\grade-06-cycle-5-final-build-documentation.html"
$target="public\guides\grade-06\cycle-5-final-build-documentation.html"
$catalog="src\content\catalog\lessons.ts"
$id="grade-06-cycle-5-final-build-documentation"

Write-Host ""
Write-Host "1/5 - Instalando 6th Grade Cycle 5..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force "public\guides\grade-06"|Out-Null
Copy-Item -LiteralPath $source -Destination $target -Force

Write-Host "2/5 - Integrando Cycle 5 al catalogo de 6th..." -ForegroundColor Cyan
$text=[IO.File]::ReadAllText((Resolve-Path $catalog))

if(-not $text.Contains($id)){
  Copy-Item $catalog "$catalog.cycle5.backup" -Force

  $entry=@'
  {
    id: "grade-06-cycle-5-final-build-documentation",
    grade: 6,
    cycle: 5,
    title: {
      en: "Cycle 5 · Final Build & Documentation Lab",
      es: "Ciclo 5 · Laboratorio Final de Construcción y Documentación",
    },
    objective: {
      en: "Complete, test, debug and document an interactive project using variables, conditionals, loops and arrays/lists/data collections in an approved development environment.",
      es: "Completar, probar, depurar y documentar un proyecto interactivo utilizando variables, condicionales, ciclos y arreglos/listas/colecciones de datos en un entorno de desarrollo aprobado.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-06/cycle-5-final-build-documentation.html",
    tags: ["Cycle 5", "Final Build", "Testing", "Debugging", "Documentation", "HTML", "JavaScript", "Scratch", "Project"],
  },
'@

  $m=[regex]::Match($text,'export\s+const\s+\w+\s*(?::[^=]+)?=\s*\[')
  if(-not $m.Success){
    throw "No pude detectar automaticamente el arreglo principal de lessons.ts."
  }

  $text=$text.Insert($m.Index+$m.Length,"`r`n"+$entry)
  [IO.File]::WriteAllText((Resolve-Path $catalog),$text,(New-Object Text.UTF8Encoding($false)))
}else{
  Write-Host "   Cycle 5 ya existe en lessons.ts; no se duplica." -ForegroundColor DarkGray
}

Write-Host "3/5 - Verificando archivo publicado..." -ForegroundColor Cyan
if(-not(Test-Path -LiteralPath $target)){
  if(Test-Path "$catalog.cycle5.backup"){Copy-Item "$catalog.cycle5.backup" $catalog -Force}
  throw "No se encontro la guia instalada."
}
Write-Host "   Guia Cycle 5 OK." -ForegroundColor Green

Write-Host "4/5 - npm run lint" -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE-ne 0){
  if(Test-Path "$catalog.cycle5.backup"){Copy-Item "$catalog.cycle5.backup" $catalog -Force}
  throw "Lint fallo. No hagas push."
}

Write-Host "5/5 - npm run build" -ForegroundColor Cyan
npm run build
if($LASTEXITCODE-ne 0){
  if(Test-Path "$catalog.cycle5.backup"){Copy-Item "$catalog.cycle5.backup" $catalog -Force}
  throw "Build fallo. No hagas push."
}

if(Test-Path "$catalog.cycle5.backup"){Remove-Item "$catalog.cycle5.backup" -Force}

Write-Host ""
Write-Host "6TH GRADE · CYCLE 5 INSTALADO Y VALIDADO" -ForegroundColor Green
Write-Host ""
Write-Host "Revisa:"
Write-Host "  http://localhost:3000/grades/6"
Write-Host "  http://localhost:3000/guides/grade-06/cycle-5-final-build-documentation.html"
Write-Host ""
Write-Host "La guia incluye:"
Write-Host "- Code Battle Live como warm-up"
Write-Host "- HTML/CSS/JS, Scratch u otra plataforma aprobada"
Write-Host "- checklist de cierre"
Write-Host "- testing y debugging"
Write-Host "- documentacion"
Write-Host "- rubrica rapida"
Write-Host "- exit ticket"
Write-Host "- ajuste del planeador"
