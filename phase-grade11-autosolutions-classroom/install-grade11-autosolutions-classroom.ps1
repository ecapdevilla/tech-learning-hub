$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Write-Utf8([string]$Path,[string]$Content) {
  $full=[IO.Path]::GetFullPath((Join-Path (Get-Location) $Path))
  $dir=[IO.Path]::GetDirectoryName($full)
  if(-not [IO.Directory]::Exists($dir)){[IO.Directory]::CreateDirectory($dir)|Out-Null}
  $utf8=New-Object Text.UTF8Encoding($false)
  [IO.File]::WriteAllText($full,$Content,$utf8)
}

if(-not(Test-Path "package.json")){throw "Ejecuta este script dentro de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "`n1/4 Copiando guias de 11th..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force "public\guides\grade-11" | Out-Null
Copy-Item -LiteralPath (Join-Path $root "guides\grade-11-autosolutions-engineering-design-lab.html") -Destination "public\guides\grade-11\autosolutions-engineering-design-lab.html" -Force
Copy-Item -LiteralPath (Join-Path $root "guides\grade-11-auto-solutions-project.html") -Destination "public\guides\grade-11\auto-solutions-project.html" -Force

Write-Host "2/4 Registrando nueva clase al lado de las existentes..." -ForegroundColor Cyan
$p="src/content/catalog/lessons.ts";$t=Get-Content -LiteralPath $p -Raw
$id="grade-11-cycle-3-autosolutions-engineering-design-lab"
if($t -notmatch [regex]::Escape($id)){
$block=@'
  {
    id: "grade-11-cycle-3-autosolutions-engineering-design-lab",
    grade: 11,
    cycle: 3,
    title: {
      en: "AUTO-SOLUTIONS · Engineering Design Lab",
      es: "AUTO-SOLUTIONS · Laboratorio de Diseño de Ingeniería",
    },
    objective: {
      en: "Design the initial proposal for a smart automated system integrating sensors, actuators, WiFi, a web interface and SDGs.",
      es: "Diseñar la propuesta inicial de un sistema automatizado inteligente integrando sensores, actuadores, WiFi, interfaz web y ODS.",
    },
    durationMinutes: 120,
    guidePath: "/guides/grade-11/autosolutions-engineering-design-lab.html",
    tags: ["AUTO-SOLUTIONS", "Sensors", "ESP32", "WiFi", "Web", "SDGs", "Notebook"],
  },
'@
$anchor="export const lessons: LessonSummary[] = ["
$i=$t.IndexOf($anchor);if($i -lt 0){throw "No encontre el catalogo de lecciones."}
$t=$t.Insert($i+$anchor.Length,"`r`n"+$block);Write-Utf8 $p $t
}else{Write-Host "La clase ya estaba registrada; no se duplico." -ForegroundColor Yellow}

Write-Host "3/4 Ejecutando lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){throw "Lint fallo. No hagas push."}

Write-Host "4/4 Ejecutando build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){throw "Build fallo. No hagas push."}

Write-Host "`nAUTO-SOLUTIONS CLASSROOM LISTO" -ForegroundColor Green
Write-Host "Revisa http://localhost:3000/grades/11"
Write-Host "Luego: git add ."
Write-Host 'git commit -m "feat: add 11th AUTO-SOLUTIONS classroom engineering lab"'
Write-Host "git push"
