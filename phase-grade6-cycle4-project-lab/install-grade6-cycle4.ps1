$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta este script dentro de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$src=Join-Path $root "guides\grade-06-cycle-4-interactive-project-lab.html"
$dir="public\guides\grade-06"
$dst=Join-Path $dir "cycle-4-interactive-project-lab.html"
$catalog="src\content\catalog\lessons.ts"
Write-Host "1/4 - Copiando guia Cycle 4..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $dir|Out-Null
Copy-Item -LiteralPath $src -Destination $dst -Force
Write-Host "2/4 - Integrando al catalogo..." -ForegroundColor Cyan
$text=[IO.File]::ReadAllText((Resolve-Path $catalog))
$id="grade-06-cycle-4-interactive-project"
if(-not $text.Contains($id)){
 Copy-Item $catalog "$catalog.cycle4.backup" -Force
 $entry=@'
  {
    id: "grade-06-cycle-4-interactive-project",
    grade: 6,
    cycle: 4,
    period: 3,
    title: "Cycle 4 · Interactive Project Lab",
    description: "Plan, build, test and document an interactive project using variables, conditionals and loops.",
    guidePath: "/guides/grade-06/cycle-4-interactive-project-lab.html",
    tags: ["Cycle 4", "Variables", "Conditionals", "Loops", "Project", "Evidence"],
  },
'@
 $m=[regex]::Match($text,'export\s+const\s+\w+\s*(?::[^=]+)?=\s*\[')
 if(-not $m.Success){throw "No pude identificar el arreglo de lessons.ts. La guia fue copiada, pero el catalogo no fue modificado."}
 $text=$text.Insert($m.Index+$m.Length,"`r`n"+$entry)
 [IO.File]::WriteAllText((Resolve-Path $catalog),$text,(New-Object Text.UTF8Encoding($false)))
}
Write-Host "3/4 - npm run lint" -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){if(Test-Path "$catalog.cycle4.backup"){Copy-Item "$catalog.cycle4.backup" $catalog -Force};throw "Lint fallo. lessons.ts fue restaurado. No hagas push."}
Write-Host "4/4 - npm run build" -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){if(Test-Path "$catalog.cycle4.backup"){Copy-Item "$catalog.cycle4.backup" $catalog -Force};throw "Build fallo. lessons.ts fue restaurado. No hagas push."}
if(Test-Path "$catalog.cycle4.backup"){Remove-Item "$catalog.cycle4.backup" -Force}
Write-Host ""
Write-Host "CYCLE 4 INSTALADO Y VALIDADO" -ForegroundColor Green
Write-Host "Revisa: http://localhost:3000/grades/6"
Write-Host "Luego:"
Write-Host "git add ."
Write-Host 'git commit -m "feat: add sixth grade cycle 4 interactive project lab"'
Write-Host "git push"
