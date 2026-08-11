$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
function W([string]$Path,[string]$Content){$f=[IO.Path]::GetFullPath((Join-Path (Get-Location) $Path));$d=[IO.Path]::GetDirectoryName($f);if(-not [IO.Directory]::Exists($d)){[IO.Directory]::CreateDirectory($d)|Out-Null};$u=New-Object Text.UTF8Encoding($false);[IO.File]::WriteAllText($f,$Content,$u)}
if(-not(Test-Path "package.json")){throw "Ejecuta dentro de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "1/5 Copiando guías..." -ForegroundColor Cyan
$files=@{"guides\grade-03-smart-animal-maze.html"="public\guides\grade-03\smart-animal-maze.html";"guides\grade-05-robolab-functions.html"="public\guides\grade-05\robolab-functions.html"}
foreach($k in $files.Keys){$s=Join-Path $root $k;$d=Join-Path (Get-Location) $files[$k];New-Item -ItemType Directory -Force (Split-Path -Parent $d)|Out-Null;Copy-Item -LiteralPath $s -Destination $d -Force}
Write-Host "2/5 Actualizando GradeId..." -ForegroundColor Cyan
$p="src/modules/grades/types/grade.ts";$x=Get-Content -LiteralPath $p -Raw
if($x -match 'export type GradeId\s*=\s*([^;]+);'){$n=[regex]::Matches($matches[1],'\d+')|%{[int]$_.Value};$n=@($n+3+5|Sort-Object -Unique);$r="export type GradeId = "+($n -join " | ")+";";$x=[regex]::Replace($x,'export type GradeId\s*=\s*[^;]+;',$r,1);W $p $x}else{throw "No encontré GradeId."}
Write-Host "3/5 Agregando grados..." -ForegroundColor Cyan
$p="src/content/grades/grades.ts";$x=Get-Content -LiteralPath $p -Raw
$g3=@'
  {
    id: 3,
    label: "3rd Grade",
    description: "Sensors, conditionals and loops through interactive missions",
    level: "primary",
  },
'@
$g5=@'
  {
    id: 5,
    label: "5th Grade",
    description: "Functions, parameters and reusable programming logic",
    level: "primary",
  },
'@
if($x -notmatch 'id:\s*3,'){$x=$x -replace '(export const grades[^[]*\[\s*)',('$1'+"`r`n"+$g3)}
if($x -notmatch 'id:\s*5,'){if($x -match '(\{\s*id:\s*6,)'){$x=[regex]::Replace($x,'(\s*\{\s*id:\s*6,)',"`r`n$g5`$1",1)}else{$x=$x -replace '(\];)',($g5+"`r`n`$1")}}
W $p $x
Write-Host "4/5 Agregando lecciones..." -ForegroundColor Cyan
$p="src/content/catalog/lessons.ts";$x=Get-Content -LiteralPath $p -Raw
$l3=@'
  {
    id: "grade-03-cycle-3-smart-animal-maze",
    grade: 3,
    cycle: 3,
    title: { en: "Smart Animal Maze", es: "Laberinto del Animal Inteligente" },
    objective: {
      en: "Use sensors, conditionals and loops to solve step-by-step challenges in an interactive maze.",
      es: "Usar sensores, condicionales y ciclos para resolver retos paso a paso en un laberinto interactivo."
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-03/smart-animal-maze.html",
    tags: ["Sensors", "Conditionals", "Loops", "Game"],
  },
'@
$l5=@'
  {
    id: "grade-05-cycle-3-robolab-functions",
    grade: 5,
    cycle: 3,
    title: { en: "RoboLab: Function Factory", es: "RoboLab: Fábrica de Funciones" },
    objective: {
      en: "Create and reuse functions, use simple parameters and understand returned results.",
      es: "Crear y reutilizar funciones, usar parámetros sencillos y comprender resultados retornados."
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-05/robolab-functions.html",
    tags: ["Functions", "Parameters", "Return", "Robotics"],
  },
'@
if($x -notmatch 'grade-03-cycle-3-smart-animal-maze'){$x=$x -replace '(export const lessons[^[]*\[\s*)',('$1'+"`r`n"+$l3)}
if($x -notmatch 'grade-05-cycle-3-robolab-functions'){$x=$x -replace '(\];\s*$)',($l5+"`r`n`$1")}
W $p $x
Write-Host "5/5 Verificando..." -ForegroundColor Cyan
npm run lint
npm run build
Write-Host ""
Write-Host "3RD + 5TH GRADE INTEGRADOS CORRECTAMENTE" -ForegroundColor Green
Write-Host "Revisa: http://localhost:3000/grades/3" -ForegroundColor Yellow
Write-Host "Revisa: http://localhost:3000/grades/5" -ForegroundColor Yellow
Write-Host ""
Write-Host "git add ." -ForegroundColor White
Write-Host 'git commit -m "feat: add third and fifth grade interactive lessons"' -ForegroundColor White
Write-Host "git push" -ForegroundColor White
