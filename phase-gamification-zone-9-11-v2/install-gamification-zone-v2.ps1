$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

function Step([string]$Text){
  Write-Host ""
  Write-Host "============================================================" -ForegroundColor DarkCyan
  Write-Host $Text -ForegroundColor Cyan
  Write-Host "============================================================" -ForegroundColor DarkCyan
}

if(-not(Test-Path "package.json")){
  throw "Ejecuta este instalador desde la raiz de tech-learning-hub."
}

$installerRoot=Split-Path -Parent $MyInvocation.MyCommand.Path
$homePagePath="src\app\page.tsx"
$globalCssPath="src\app\globals.css"

Step "1/6 - Copiando arquitectura Gamification Zone V2"

$dirs=@(
  "src\app\gamification",
  "src\modules\gamification\data",
  "src\modules\gamification\types",
  "src\shared\components\gamification",
  "public\gamification"
)

foreach($dir in $dirs){
  New-Item -ItemType Directory -Force $dir | Out-Null
}

Copy-Item -LiteralPath "$installerRoot\src\app\gamification\page.tsx" `
  -Destination "src\app\gamification\page.tsx" -Force

Copy-Item -LiteralPath "$installerRoot\src\modules\gamification\data\games.ts" `
  -Destination "src\modules\gamification\data\games.ts" -Force

Copy-Item -LiteralPath "$installerRoot\src\modules\gamification\types\game.ts" `
  -Destination "src\modules\gamification\types\game.ts" -Force

Copy-Item "$installerRoot\src\shared\components\gamification\*" `
  "src\shared\components\gamification\" -Force

Copy-Item "$installerRoot\public\gamification\*" `
  "public\gamification\" -Force

Step "2/6 - Integrando estilos sin duplicarlos"

$marker="/* GAMIFICATION ZONE V2 */"
$currentCss=[IO.File]::ReadAllText((Resolve-Path $globalCssPath))

if(-not $currentCss.Contains($marker)){
  $newCss=[IO.File]::ReadAllText("$installerRoot\gamification-zone-v2.css")
  [IO.File]::AppendAllText(
    (Resolve-Path $globalCssPath),
    "`r`n"+$newCss,
    (New-Object Text.UTF8Encoding($false))
  )
}else{
  Write-Host "Los estilos V2 ya existen. No se duplican." -ForegroundColor Yellow
}

Step "3/6 - Agregando acceso a Gamification Zone en Home"

if(-not(Test-Path $homePagePath)){
  throw "No encuentro $homePagePath"
}

$homeContent=[IO.File]::ReadAllText((Resolve-Path $homePagePath))

if($homeContent.Contains('href="/gamification"')){
  Write-Host "Home ya tiene acceso a Gamification Zone." -ForegroundColor Yellow
}else{
  $homeBlock=@'
        <section className="gamification-home-entry">
          <a href="/gamification" className="feature-card">
            <span className="feature-icon">🎮</span>
            <div>
              <span className="section-kicker">Grades 9–11 · Gamification</span>
              <h3>Gamification Zone</h3>
              <p>
                Logic, debugging, data, web, cybersecurity, databases,
                AI and IoT. English · Español · French immersion.
              </p>
            </div>
          </a>
        </section>
'@

  $inserted=$false

  $footerIndex=$homeContent.LastIndexOf("<footer")
  if($footerIndex -ge 0){
    $homeContent=$homeContent.Insert($footerIndex,$homeBlock)
    $inserted=$true
  }

  if(-not $inserted){
    $mainCloseIndex=$homeContent.LastIndexOf("</main>")
    if($mainCloseIndex -ge 0){
      $homeContent=$homeContent.Insert($mainCloseIndex,$homeBlock)
      $inserted=$true
    }
  }

  if(-not $inserted){
    Write-Warning "No pude ubicar footer/main para insertar la tarjeta en Home."
    Write-Warning "La ruta /gamification si quedo instalada."
  }else{
    [IO.File]::WriteAllText(
      (Resolve-Path $homePagePath),
      $homeContent,
      (New-Object Text.UTF8Encoding($false))
    )
  }
}

Step "4/6 - Verificando TypeScript y ESLint"
npm run lint
if($LASTEXITCODE -ne 0){
  throw "Lint fallo. No hagas git push."
}

Step "5/6 - Construyendo aplicacion"
npm run build
if($LASTEXITCODE -ne 0){
  throw "Build fallo. No hagas git push."
}

Step "6/6 - Instalacion finalizada"

Write-Host ""
Write-Host "GAMIFICATION ZONE V2 INSTALADA Y VALIDADA" -ForegroundColor Green
Write-Host ""
Write-Host "Revisa:"
Write-Host "  http://localhost:3000/gamification"
Write-Host ""
Write-Host "Arenas:"
Write-Host "  Logic Reactor"
Write-Host "  Bug Hunter Arena"
Write-Host "  Cyber Defense Lab"
Write-Host "  Data Detective"
Write-Host "  Web Architect Challenge"
Write-Host "  IoT Mission Control"
Write-Host "  Database Quest"
Write-Host "  AI Decision Lab"
Write-Host ""
Write-Host "Si todo esta bien:"
Write-Host "  git add ."
Write-Host '  git commit -m "feat: upgrade gamification zone for grades 9 to 11"'
Write-Host "  git push"
