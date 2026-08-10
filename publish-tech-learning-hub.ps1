param(
    [string]$RepoName = "tech-learning-hub",
    [ValidateSet("public","private")]
    [string]$Visibility = "public"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor DarkCyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor DarkCyan
}

function Has-Command {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

if (-not (Test-Path "package.json")) {
    throw "Ejecuta este script dentro de la carpeta tech-learning-hub."
}

Write-Step "1/7 - Verificando proyecto"

npm run lint
npm run build

Write-Host "Lint y build correctos." -ForegroundColor Green

Write-Step "2/7 - Preparando Git"

if (-not (Test-Path ".git")) {
    git init
}

git add .

$hasChanges = git status --porcelain

if ($hasChanges) {
    git commit -m "feat: initial Tech Learning Hub platform"
} else {
    Write-Host "No hay cambios pendientes para commit." -ForegroundColor Yellow
}

git branch -M main

Write-Step "3/7 - Verificando GitHub CLI"

if (-not (Has-Command "gh")) {
    Write-Host "GitHub CLI no está instalado." -ForegroundColor Yellow

    if (Has-Command "winget") {
        Write-Host "Instalando GitHub CLI con winget..." -ForegroundColor Cyan
        winget install --id GitHub.cli -e --source winget `
            --accept-package-agreements `
            --accept-source-agreements

        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                    [System.Environment]::GetEnvironmentVariable("Path","User")
    }
}

if (-not (Has-Command "gh")) {
    Write-Host ""
    Write-Host "No pude detectar 'gh' todavía." -ForegroundColor Red
    Write-Host "Cierra PowerShell, vuelve a abrirlo y ejecuta otra vez este script." -ForegroundColor Yellow
    exit 10
}

Write-Step "4/7 - Verificando sesión de GitHub"

$ghAuthenticated = $true

try {
    gh auth status 2>$null | Out-Null
} catch {
    $ghAuthenticated = $false
}

if (-not $ghAuthenticated) {
    Write-Host "Necesitas iniciar sesión en GitHub una sola vez." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Ejecuta:" -ForegroundColor Cyan
    Write-Host "  gh auth login" -ForegroundColor White
    Write-Host ""
    Write-Host "Luego vuelve a ejecutar:" -ForegroundColor Cyan
    Write-Host "  .\publish-tech-learning-hub.ps1" -ForegroundColor White
    exit 20
}

Write-Step "5/7 - Creando/conectando repositorio GitHub"

$originExists = $false

try {
    git remote get-url origin 2>$null | Out-Null
    $originExists = $true
} catch {
    $originExists = $false
}

if (-not $originExists) {
    if ($Visibility -eq "private") {
        gh repo create $RepoName --private --source=. --remote=origin --push
    } else {
        gh repo create $RepoName --public --source=. --remote=origin --push
    }
} else {
    Write-Host "Remote origin ya existe:" -ForegroundColor Yellow
    git remote get-url origin

    git push -u origin main
}

Write-Host ""
Write-Host "Repositorio GitHub listo:" -ForegroundColor Green
gh repo view --web 2>$null | Out-Null

Write-Step "6/7 - Verificando Vercel CLI"

if (-not (Has-Command "vercel")) {
    Write-Host "Instalando Vercel CLI..." -ForegroundColor Cyan
    npm install -g vercel
}

if (-not (Has-Command "vercel")) {
    Write-Host "Vercel CLI no quedó disponible en esta sesión." -ForegroundColor Red
    Write-Host "Cierra PowerShell, ábrelo otra vez y ejecuta:" -ForegroundColor Yellow
    Write-Host "  vercel login" -ForegroundColor White
    exit 30
}

Write-Step "7/7 - Preparando despliegue en Vercel"

Write-Host ""
Write-Host "Primero verificaremos si Vercel reconoce tu sesión." -ForegroundColor Cyan

$vercelAuthenticated = $true

try {
    vercel whoami 2>$null | Out-Null
} catch {
    $vercelAuthenticated = $false
}

if (-not $vercelAuthenticated) {
    Write-Host ""
    Write-Host "Necesitas iniciar sesión en Vercel." -ForegroundColor Yellow
    Write-Host "Ejecuta:" -ForegroundColor Cyan
    Write-Host "  vercel login" -ForegroundColor White
    Write-Host ""
    Write-Host "Cuando termine, ejecuta:" -ForegroundColor Cyan
    Write-Host "  vercel link" -ForegroundColor White
    Write-Host "  vercel git connect --yes" -ForegroundColor White
    Write-Host "  vercel --prod" -ForegroundColor White
    exit 40
}

Write-Host "Sesión Vercel detectada." -ForegroundColor Green
Write-Host ""
Write-Host "Ahora se enlazará el proyecto. Si Vercel pregunta algo," -ForegroundColor Yellow
Write-Host "acepta los valores sugeridos para este proyecto." -ForegroundColor Yellow
Write-Host ""

vercel link
vercel git connect --yes
vercel --prod

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "PUBLICACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "GitHub conectado." -ForegroundColor Green
Write-Host "Vercel conectado." -ForegroundColor Green
Write-Host "Producción desplegada." -ForegroundColor Green
Write-Host ""
Write-Host "A partir de ahora el flujo normal será:" -ForegroundColor Cyan
Write-Host "  git add ." -ForegroundColor White
Write-Host '  git commit -m "descripcion del cambio"' -ForegroundColor White
Write-Host "  git push" -ForegroundColor White
Write-Host ""
Write-Host "Vercel desplegará automáticamente los pushes a main." -ForegroundColor Cyan