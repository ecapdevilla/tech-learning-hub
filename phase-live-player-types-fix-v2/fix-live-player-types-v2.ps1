$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path -LiteralPath (Join-Path (Get-Location) "package.json"))){
  throw "Ejecuta este fix desde la raiz de tech-learning-hub."
}

$repoRoot = (Get-Location).Path
$playerPath = Join-Path $repoRoot "src\app\gamification\live\play\[pin]\page.tsx"

if(-not(Test-Path -LiteralPath $playerPath)){
  throw "No encuentro el archivo real: $playerPath"
}

Write-Host "1/5 - Corrigiendo tipos del Player Live..." -ForegroundColor Cyan

$text=[IO.File]::ReadAllText($playerPath)

$old=@'
      let data: any = null;
      let error: any = null;

      const firstAttempt = await liveSupabase
        .from("live_players")
        .insert(playerPayload)
        .select()
        .single();

      data = firstAttempt.data;
      error = firstAttempt.error;

      if (error && /avatar.*column|column.*avatar/i.test(error.message ?? "")) {
        const fallback = await liveSupabase
          .from("live_players")
          .insert({
            game_id: game.id,
            name: cleanName,
          })
          .select()
          .single();

        data = fallback.data;
        error = fallback.error;
      }

      if (error || !data) {
        setMessage(error?.message ?? "Unable to join the room.");
        return;
      }

      const joinedPlayer = data as LivePlayer;
'@

$new=@'
      const firstAttempt = await liveSupabase
        .from("live_players")
        .insert(playerPayload)
        .select()
        .single();

      let joinedData = firstAttempt.data as LivePlayer | null;
      let joinError = firstAttempt.error;

      if (
        joinError &&
        /avatar.*column|column.*avatar/i.test(joinError.message ?? "")
      ) {
        const fallback = await liveSupabase
          .from("live_players")
          .insert({
            game_id: game.id,
            name: cleanName,
          })
          .select()
          .single();

        joinedData = fallback.data as LivePlayer | null;
        joinError = fallback.error;
      }

      if (joinError || !joinedData) {
        setMessage(joinError?.message ?? "Unable to join the room.");
        return;
      }

      const joinedPlayer = joinedData;
'@

if($text.Contains($old)){
  $text=$text.Replace($old,$new)
  [IO.File]::WriteAllText(
    $playerPath,
    $text,
    (New-Object Text.UTF8Encoding($false))
  )
  Write-Host "   Bloque any reemplazado correctamente." -ForegroundColor Green
}else{
  if($text -match 'let\s+data:\s*any' -or $text -match 'let\s+error:\s*any'){
    throw "Encontre los any, pero el bloque actual es diferente. Detengo para no alterar logica."
  }
  Write-Host "   El archivo activo ya no contiene esos any." -ForegroundColor DarkGray
}

Write-Host "2/5 - Limpiando fases antiguas Code Battle..." -ForegroundColor Cyan
Get-ChildItem -LiteralPath $repoRoot -Directory -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -like "phase-code-battle-live-*" } |
  ForEach-Object {
    Remove-Item -LiteralPath $_.FullName -Recurse -Force
    Write-Host "   Eliminado: $($_.Name)" -ForegroundColor DarkGray
  }

Write-Host "3/5 - Verificando tipos..." -ForegroundColor Cyan
$check=[IO.File]::ReadAllText($playerPath)
if($check -match 'let\s+data:\s*any' -or $check -match 'let\s+error:\s*any'){
  throw "Todavia quedan los any explicitos."
}
Write-Host "   Player Live sin any explicitos en el join." -ForegroundColor Green

Write-Host "4/5 - Lint..." -ForegroundColor Cyan
npm run lint
if($LASTEXITCODE-ne 0){
  throw "Lint todavia tiene errores. No hagas push."
}

Write-Host "5/5 - Build..." -ForegroundColor Cyan
npm run build
if($LASTEXITCODE-ne 0){
  throw "Build fallo. No hagas push."
}

Write-Host ""
Write-Host "LIVE PLAYER TYPES FIX V2 COMPLETADO" -ForegroundColor Green
Write-Host "Ahora vuelve a ejecutar install-grade6-cycle5.ps1."
