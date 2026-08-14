$ErrorActionPreference="Stop"
$script = Get-Content ".\phase-student-projects-view-v2\install-student-projects-v2.ps1" -Raw
if($script -match '(?i)\$home\b'){
  Write-Host "ERROR: Todavia existe `$home en el instalador." -ForegroundColor Red
  exit 1
}
Write-Host "OK: No hay referencias a la variable reservada `$HOME." -ForegroundColor Green
