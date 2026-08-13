$ErrorActionPreference="Stop"
if(-not(Test-Path "package.json")){throw "Ejecuta este instalador desde la raiz de tech-learning-hub."}
$here=Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "1/5 - Copiando Gamification Zone..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force "src\app\gamification"|Out-Null
New-Item -ItemType Directory -Force "public\gamification"|Out-Null
Copy-Item "$here\src\app\gamification\page.tsx" "src\app\gamification\page.tsx" -Force
Copy-Item "$here\public\gamification\*" "public\gamification\" -Force

Write-Host "2/5 - Integrando estilos..." -ForegroundColor Cyan
$cssTarget="src\app\globals.css";$css=[IO.File]::ReadAllText("$here\gamification-zone.css");$current=[IO.File]::ReadAllText((Resolve-Path $cssTarget))
if(-not $current.Contains("/* GAMIFICATION ZONE 9–11 */")){[IO.File]::AppendAllText((Resolve-Path $cssTarget),"`r`n"+$css,(New-Object Text.UTF8Encoding($false)))}

Write-Host "3/5 - Agregando acceso abajo en Home..." -ForegroundColor Cyan
$home="src\app\page.tsx";$h=[IO.File]::ReadAllText((Resolve-Path $home))
if(-not $h.Contains('href="/gamification"')){
  $block=@'
        <section style={{ marginTop: "28px", marginBottom: "28px" }}>
          <a href="/gamification" className="feature-card" style={{ display: "block" }}>
            <span className="feature-icon">🎮</span>
            <div>
              <span className="section-kicker">Grades 9–11 · Gamification</span>
              <h3>Gamification Zone</h3>
              <p>Challenge your logic, debugging, data, web, cybersecurity and IoT skills. English · Español · French immersion.</p>
            </div>
          </a>
        </section>
'@
  $pos=$h.LastIndexOf("</")
  $mainClose=$h.LastIndexOf("</main>")
  if($mainClose -ge 0){$h=$h.Insert($mainClose,$block)}
  else {
    $footer=$h.LastIndexOf("<footer")
    if($footer -ge 0){$h=$h.Insert($footer,$block)}
    else {Write-Warning "No pude ubicar main/footer para insertar tarjeta Home. La ruta /gamification sí quedó instalada."}
  }
  [IO.File]::WriteAllText((Resolve-Path $home),$h,(New-Object Text.UTF8Encoding($false)))
}
Write-Host "4/5 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){throw "Lint fallo. No hagas push."}
Write-Host "5/5 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){throw "Build fallo. No hagas push."}
Write-Host "`nGAMIFICATION ZONE 9-11 INSTALADA Y VALIDADA" -ForegroundColor Green
Write-Host "Revisa: http://localhost:3000/gamification"
Write-Host 'Luego: git add .'
Write-Host 'git commit -m "feat: add gamification zone for grades 9 to 11"'
Write-Host 'git push'
