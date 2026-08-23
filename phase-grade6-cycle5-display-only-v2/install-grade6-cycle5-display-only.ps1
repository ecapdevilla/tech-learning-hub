$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$repoRoot=(Get-Location).Path
$package=Join-Path $repoRoot "package.json"

if(-not(Test-Path -LiteralPath $package)){
  throw "Ejecuta este instalador desde la raiz de tech-learning-hub."
}

$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$source=Join-Path $root "guides\grade-06-cycle-5-final-build-documentation.html"
$targetDir=Join-Path $repoRoot "public\guides\grade-06"
$target=Join-Path $targetDir "cycle-5-final-build-documentation.html"
$catalog=Join-Path $repoRoot "src\content\catalog\lessons.ts"
$id="grade-06-cycle-5-final-build-documentation"

Write-Host ""
Write-Host "1/4 - Publicando guia Cycle 5 de 6th..." -ForegroundColor Cyan
[IO.Directory]::CreateDirectory($targetDir)|Out-Null
[IO.File]::Copy($source,$target,$true)

Write-Host "2/4 - Integrando Cycle 5 al catalogo..." -ForegroundColor Cyan
$text=[IO.File]::ReadAllText($catalog)

if(-not $text.Contains($id)){

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

  $match=[regex]::Match($text,'export\s+const\s+\w+\s*(?::[^=]+)?=\s*\[')

  if(-not $match.Success){
    throw "No pude localizar automaticamente el arreglo principal de lessons.ts."
  }

  $text=$text.Insert($match.Index+$match.Length,"`r`n"+$entry)
  [IO.File]::WriteAllText($catalog,$text,(New-Object Text.UTF8Encoding($false)))

  Write-Host "   Entrada Cycle 5 agregada." -ForegroundColor Green
}else{
  Write-Host "   Cycle 5 ya estaba registrado; no se duplica." -ForegroundColor DarkGray
}

Write-Host "3/4 - Verificando archivos..." -ForegroundColor Cyan

if(-not(Test-Path -LiteralPath $target)){
  throw "La guia no fue copiada correctamente."
}

$verifyCatalog=[IO.File]::ReadAllText($catalog)
if(-not $verifyCatalog.Contains($id)){
  throw "Cycle 5 no aparece en lessons.ts."
}

Write-Host "   Guia y catalogo OK." -ForegroundColor Green

Write-Host "4/4 - Instalacion terminada." -ForegroundColor Cyan
Write-Host ""
Write-Host "6TH GRADE · CYCLE 5 LISTO PARA VISUALIZAR" -ForegroundColor Green
Write-Host ""
Write-Host "Rutas:"
Write-Host "  http://localhost:3000/grades/6"
Write-Host "  http://localhost:3000/guides/grade-06/cycle-5-final-build-documentation.html"
Write-Host ""
Write-Host "Este instalador NO toca Supabase, Code Battle Live ni ejecuta lint/build global."
