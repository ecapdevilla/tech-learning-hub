$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
$repo=(Get-Location).Path
if(-not(Test-Path -LiteralPath (Join-Path $repo "package.json"))){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$source=Join-Path $root "guides\grade-08-cycle-5-ai-patterns-trends.html"
$targetDir=Join-Path $repo "public\guides\grade-08"
$target=Join-Path $targetDir "cycle-5-ai-patterns-trends.html"
$catalog=Join-Path $repo "src\content\catalog\lessons.ts"
$id="grade-08-cycle-5-ai-patterns-trends"

Write-Host ""
Write-Host "1/4 - Publicando Cycle 5 de 8th..." -ForegroundColor Cyan
[IO.Directory]::CreateDirectory($targetDir)|Out-Null
[IO.File]::Copy($source,$target,$true)

Write-Host "2/4 - Integrando al catalogo de 8th..." -ForegroundColor Cyan
$text=[IO.File]::ReadAllText($catalog)
if(-not $text.Contains($id)){
$entry=@'
  {
    id: "grade-08-cycle-5-ai-patterns-trends",
    grade: 8,
    cycle: 5,
    title: {
      en: "Cycle 5 · AI Patterns & Trends Lab",
      es: "Ciclo 5 · Laboratorio de IA: Patrones y Tendencias",
    },
    objective: {
      en: "Explore basic AI applications to detect patterns and trends.",
      es: "Explorar aplicaciones básicas de IA para detectar patrones y tendencias.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-08/cycle-5-ai-patterns-trends.html",
    tags: ["Cycle 5", "AI", "Machine Learning", "Patterns", "Trends", "Data", "Survey", "Code for Change"],
  },
'@
$match=[regex]::Match($text,'export\s+const\s+\w+\s*(?::[^=]+)?=\s*\[')
if(-not $match.Success){throw "No pude localizar el arreglo principal de lessons.ts."}
$text=$text.Insert($match.Index+$match.Length,"`r`n"+$entry)
[IO.File]::WriteAllText($catalog,$text,(New-Object Text.UTF8Encoding($false)))
Write-Host "   Entrada agregada." -ForegroundColor Green
}else{Write-Host "   Cycle 5 ya estaba registrado; no se duplica." -ForegroundColor DarkGray}

Write-Host "3/4 - Verificando..." -ForegroundColor Cyan
if(-not(Test-Path -LiteralPath $target)){throw "No se publico el HTML."}
$verify=[IO.File]::ReadAllText($catalog)
if(-not $verify.Contains($id)){throw "No se registro Cycle 5 en lessons.ts."}
Write-Host "   Guia + catalogo OK." -ForegroundColor Green

Write-Host "4/4 - Listo." -ForegroundColor Cyan
Write-Host ""
Write-Host "8TH GRADE · CYCLE 5 LISTO" -ForegroundColor Green
Write-Host "  http://localhost:3000/grades/8"
Write-Host "  http://localhost:3000/guides/grade-08/cycle-5-ai-patterns-trends.html"
Write-Host ""
Write-Host "No toca Supabase, Code Battle Live ni ejecuta lint/build global."
