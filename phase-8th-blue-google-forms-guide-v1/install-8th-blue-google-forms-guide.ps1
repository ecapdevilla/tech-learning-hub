$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
if(-not(Test-Path "package.json")){throw "Ejecuta desde la raiz de tech-learning-hub."}
$root=Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "1/5 - Instalando manual Google Forms + IA..." -ForegroundColor Cyan
$guideDst=Join-Path (Get-Location) "public\guides\grade-08"
[IO.Directory]::CreateDirectory($guideDst)|Out-Null
[IO.File]::Copy((Join-Path $root "public\guides\grade-08\google-forms-data-collection-lab.html"),(Join-Path $guideDst "google-forms-data-collection-lab.html"),$true)

Write-Host "2/5 - Integrando acceso en proyectos de 8th Blue..." -ForegroundColor Cyan
$blueRoot=Join-Path (Get-Location) "public\student-projects\grade-08\blue"
if(-not(Test-Path $blueRoot)){throw "No existe la carpeta de proyectos de 8th Blue."}
$files=Get-ChildItem -Path $blueRoot -Filter "index.html" -File -Recurse
foreach($f in $files){
  $c=[IO.File]::ReadAllText($f.FullName)
  if($c.Contains("TLH-8BLUE-SURVEY-GUIDE")){continue}
  $banner=@'

<!-- TLH-8BLUE-SURVEY-GUIDE -->
<style>
.tlh-survey-guide{max-width:1100px;margin:12px auto;padding:0 14px;font-family:system-ui,-apple-system,"Segoe UI",sans-serif}
.tlh-survey-guide-inner{display:flex;gap:12px;align-items:center;justify-content:space-between;flex-wrap:wrap;background:linear-gradient(135deg,#eef7ff,#edfff8);border:1px solid #cfe4ef;border-radius:16px;padding:14px 16px;box-shadow:0 8px 24px rgba(16,43,70,.08)}
.tlh-survey-guide strong{color:#102b46}.tlh-survey-guide span{font-size:13px;color:#536b7d}
.tlh-survey-guide a{background:#102b46;color:white!important;text-decoration:none!important;font-weight:900;padding:10px 14px;border-radius:11px;white-space:nowrap}
</style>
<div class="tlh-survey-guide"><div class="tlh-survey-guide-inner"><div><strong>📊 Next Step · Build your real survey</strong><br><span>Google Forms + AI guide → collect data, analyze it and improve your project.</span></div><a href="/guides/grade-08/google-forms-data-collection-lab.html">OPEN GUIDE →</a></div></div>
'@
  if($c -match '(?i)<body[^>]*>'){
    $c=[regex]::Replace($c,'(?i)(<body[^>]*>)','$1'+$banner,1)
  } else { $c=$banner+$c }
  [IO.File]::WriteAllText($f.FullName,$c,(New-Object Text.UTF8Encoding($false)))
}
Write-Host "   Manual enlazado en $($files.Count) proyectos." -ForegroundColor Green

Write-Host "3/5 - Validando archivos..." -ForegroundColor Cyan
if(-not(Test-Path (Join-Path $guideDst "google-forms-data-collection-lab.html"))){throw "No se creo la guia."}

Write-Host "4/5 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE -ne 0){throw "Lint fallo. No hagas push."}

Write-Host "5/5 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE -ne 0){throw "Build fallo. No hagas push."}

Write-Host ""
Write-Host "8TH BLUE · GOOGLE FORMS + AI GUIDE INSTALADA" -ForegroundColor Green
Write-Host "http://localhost:3000/guides/grade-08/google-forms-data-collection-lab.html"
Write-Host "http://localhost:3000/students/grade/8/blue"
