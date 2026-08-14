$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta este instalador desde la raiz de tech-learning-hub."}
$installerRoot=Split-Path -Parent $MyInvocation.MyCommand.Path
$globalCssPath="src\app\globals.css";$homePagePath="src\app\page.tsx"

Write-Host "1/6 - Copiando Student Projects V2..." -ForegroundColor Cyan
$dirs=@(
  "src\app\students",
  "src\app\students\grade\[grade]",
  "src\app\students\grade\[grade]\[classroom]",
  "src\modules\student-projects\data",
  "src\modules\student-projects\types",
  "src\modules\student-projects\services",
  "src\shared\components\student-projects",
  "public\student-projects\grade-06\red\interactive-surveys"
)
foreach($d in $dirs){
  [System.IO.Directory]::CreateDirectory((Join-Path (Get-Location) $d)) | Out-Null
}
Copy-Item -LiteralPath "$installerRoot\src\app\students\page.tsx" -Destination "src\app\students\page.tsx" -Force
[System.IO.File]::Copy(
  (Join-Path $installerRoot "src\app\students\grade\[grade]\page.tsx"),
  (Join-Path (Get-Location) "src\app\students\grade\[grade]\page.tsx"),
  $true
)
[System.IO.File]::Copy(
  (Join-Path $installerRoot "src\app\students\grade\[grade]\[classroom]\page.tsx"),
  (Join-Path (Get-Location) "src\app\students\grade\[grade]\[classroom]\page.tsx"),
  $true
)
Copy-Item "$installerRoot\src\modules\student-projects\data\*" "src\modules\student-projects\data\" -Force
Copy-Item "$installerRoot\src\modules\student-projects\types\*" "src\modules\student-projects\types\" -Force
Copy-Item "$installerRoot\src\modules\student-projects\services\*" "src\modules\student-projects\services\" -Force
Copy-Item "$installerRoot\src\shared\components\student-projects\*" "src\shared\components\student-projects\" -Force
Copy-Item "$installerRoot\public\student-projects\grade-06\red\interactive-surveys\*" "public\student-projects\grade-06\red\interactive-surveys\" -Force

Write-Host "2/6 - Quitando estilos V1 si existen e integrando V2..." -ForegroundColor Cyan
$current=[IO.File]::ReadAllText((Resolve-Path $globalCssPath))
$start=$current.IndexOf("/* STUDENT PROJECTS VIEW V1 */")
if($start -ge 0){$current=$current.Substring(0,$start).TrimEnd()+"`r`n"}
if(-not $current.Contains("/* STUDENT PROJECTS VIEW V2 */")){
 $new=[IO.File]::ReadAllText("$installerRoot\student-projects-view-v2.css")
 $current=$current+"`r`n"+$new
}
[IO.File]::WriteAllText((Resolve-Path $globalCssPath),$current,(New-Object Text.UTF8Encoding($false)))

Write-Host "3/6 - Verificando acceso Home..." -ForegroundColor Cyan
$homeContent=[IO.File]::ReadAllText((Resolve-Path $homePagePath))
if(-not $homeContent.Contains('href="/students"')){
 $block=@'
        <section className="student-projects-home-entry" style={{ marginTop: "28px", marginBottom: "28px" }}>
          <a href="/students" className="feature-card" style={{ display: "block" }}>
            <span className="feature-icon">🌟</span>
            <div>
              <span className="section-kicker">Grades 6–11 · Student Portfolio</span>
              <h3>Student Projects & Learning Sequences</h3>
              <p>Created by our students. Shared with our families and community. Explore projects by grade and classroom.</p>
            </div>
          </a>
        </section>
'@
 $idx=$homeContent.IndexOf('href="/gamification"');$inserted=$false
 if($idx -ge 0){$s=$homeContent.LastIndexOf("<section",$idx);if($s -ge 0){$homeContent=$homeContent.Insert($s,$block);$inserted=$true}}
 if(-not $inserted){$m=$homeContent.LastIndexOf("</main>");if($m -ge 0){$homeContent=$homeContent.Insert($m,$block);$inserted=$true}}
 if($inserted){[IO.File]::WriteAllText((Resolve-Path $homePagePath),$homeContent,(New-Object Text.UTF8Encoding($false)))}
}

Write-Host "4/6 - Verificando contenido publicado..." -ForegroundColor Cyan
if(-not(Test-Path "public\student-projects\grade-06\red\interactive-surveys\index.html")){throw "No se copio el proyecto 6th Red."}

Write-Host "5/6 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){throw "Lint fallo. No hagas push."}

Write-Host "6/6 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){throw "Build fallo. No hagas push."}

Write-Host ""
Write-Host "STUDENT PROJECTS V3 PRIVACY + PREMIUM DESIGN INSTALADOS" -ForegroundColor Green
Write-Host "Revisa:"
Write-Host " http://localhost:3000/students"
Write-Host " http://localhost:3000/students/grade/6"
Write-Host " http://localhost:3000/students/grade/6/red"
Write-Host " http://localhost:3000/student-projects/grade-06/red/interactive-surveys/index.html"
