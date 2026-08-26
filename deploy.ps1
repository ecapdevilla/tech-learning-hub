# Despliegue rapido y repetible: lint + build -> commit -> push (Vercel auto-deploy via git)
# Uso:
#   .\deploy.ps1                          -> commit auto con mensaje generico
#   .\deploy.ps1 -Message "feat(grade6): nueva guia"
#   .\deploy.ps1 -Message "...cambio..." -PushOnly   (sin lint/build ni commit, solo push)
#   .\deploy.ps1 -Message "...cambio..." -NoPush     (lint+build+commit, sin push)
param(
    [string]$Message = "",
    [switch]$PushOnly,
    [switch]$NoPush
)

$ErrorActionPreference = "Continue"
Set-StrictMode -Version Latest

# Para evitar que git escriba avisos (p. ej. LF/CRLF) a stderr y los trate como fallo fatal.
function Invoke-Git {
    param([string[]]$Args)
    & git @Args 2>$null
}

if (-not (Test-Path "package.json")) {
    throw "Ejecuta este script dentro de la carpeta tech-learning-hub."
}

function Write-Step {
    param([string]$M)
    Write-Host ""
    Write-Host "== $M" -ForegroundColor Cyan
}

if ($PushOnly) {
    Invoke-Git push
    exit 0
}

Write-Step "1/2 - Lint (aviso) y Build (gate)"
if (-not $NoPush) {
    Write-Host "Ejecutando lint (informativo, no bloquea):" -ForegroundColor DarkGray
    npm run lint 2>&1 | Out-Null
    Write-Host "  -> lint finalizado (revisa warnings por separado con 'npm run lint')." -ForegroundColor DarkGray
}
npm run build
if (-not $?) { throw "Build fallo. No se envia a produccion." }
Write-Host "Build correcto. Vercel usara este build para desplegar." -ForegroundColor Green

Write-Step "2/2 - Commit y Push"
Invoke-Git add .
if (-not $?) { throw "git add fallo." }
$hasChanges = git status --porcelain
if (-not $hasChanges) {
    Write-Host "No hay cambios pendientes. Nada que commitear." -ForegroundColor Yellow
    if (-not $NoPush) { Invoke-Git pull --ff-only; Invoke-Git push }
    exit 0
}

git update-index -q --refresh

$defaultMessage = "chore: update tech learning hub"
if ([string]::IsNullOrWhiteSpace($Message)) {
    $Message = $defaultMessage
} else {
    $Message = ($Message.Trim() -replace '^"|"$', '')
}

Invoke-Git commit -m $Message
if (-not $?) { throw "Commit fallo." }

if (-not $NoPush) {
    Invoke-Git pull --ff-only
    if ($?) { Invoke-Git push }
}

Write-Step "Listo"
Write-Host "Cambios enviados a origin/main. Vercel desplegara automaticamente si la integracion esta conectada." -ForegroundColor Green