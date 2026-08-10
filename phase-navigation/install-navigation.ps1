$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Write-Utf8File {
    param([string]$Path,[Parameter(ValueFromPipeline=$true)][string]$Content)
    process {
        $full = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $Path))
        $dir = [System.IO.Path]::GetDirectoryName($full)
        if (-not [System.IO.Directory]::Exists($dir)) {
            [System.IO.Directory]::CreateDirectory($dir) | Out-Null
        }
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($full,$Content,$utf8)
    }
}

if (-not (Test-Path "package.json")) {
    throw "Ejecuta este script dentro de tech-learning-hub."
}

Write-Host "1/4 Creando navegación..." -ForegroundColor Cyan

@'
"use client";

import { useRouter } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, House } from "lucide-react";

export function PageNavigation() {
  const router = useRouter();

  return (
    <div className="page-navigation">
      <button onClick={() => router.back()} className="nav-action">
        <ArrowLeft size={17} />
        Back
      </button>

      <Link href="/" className="nav-action">
        <House size={17} />
        Home
      </Link>
    </div>
  );
}
'@ | Write-Utf8File -Path "src/shared/components/navigation/PageNavigation.tsx"

Write-Host "2/4 Integrando navegación global..." -ForegroundColor Cyan

@'
import { Navbar } from "@/shared/components/layout/Navbar";
import { PageNavigation } from "@/shared/components/navigation/PageNavigation";

type Props = {
  children: React.ReactNode;
};

export function SiteLayout({ children }: Props) {
  return (
    <>
      <Navbar />
      <PageNavigation />
      <main>{children}</main>
    </>
  );
}
'@ | Write-Utf8File -Path "src/shared/components/layout/SiteLayout.tsx"

Write-Host "3/4 Aplicando diseño..." -ForegroundColor Cyan

@'

.page-navigation {
  width: min(1180px, calc(100% - 32px));
  margin: 14px auto 0;
  display: flex;
  gap: 8px;
}

.nav-action {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  min-height: 38px;
  padding: 8px 13px;
  border: 1px solid var(--line);
  border-radius: 999px;
  background: white;
  color: var(--navy);
  font: inherit;
  font-size: 13px;
  font-weight: 800;
  cursor: pointer;
  box-shadow: 0 4px 12px #0f27400a;
  transition: transform .18s ease, box-shadow .18s ease;
}

.nav-action:hover {
  transform: translateY(-1px);
  box-shadow: 0 7px 16px #0f274014;
}

@media (max-width: 650px) {
  .page-navigation {
    margin-top: 10px;
  }
}
'@ | Add-Content "src/app/globals.css"

Write-Host "4/4 Verificando..." -ForegroundColor Cyan
npm run lint
npm run build

Write-Host ""
Write-Host "NAVEGACION GLOBAL COMPLETADA" -ForegroundColor Green
Write-Host "Ahora todas las páginas internas tienen Back + Home." -ForegroundColor Green
Write-Host ""
Write-Host "Publicar:" -ForegroundColor Yellow
Write-Host "git add ." -ForegroundColor White
Write-Host 'git commit -m "feat: add global back and home navigation"' -ForegroundColor White
Write-Host "git push" -ForegroundColor White
