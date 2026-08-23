$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

if(-not(Test-Path "package.json")){
  throw "Ejecuta este fix desde la raiz de tech-learning-hub."
}

$playerPath = "src\app\gamification\live\play\[pin]\page.tsx"

if(-not(Test-Path -LiteralPath $playerPath)){
  throw "No encuentro $playerPath"
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
    (Resolve-Path -LiteralPath $playerPath),
    $text,
    (New-Object Text.UTF8Encoding($false))
  )
}else{
  if($text -match 'let\s+data:\s*any' -or $text -match 'let\s+error:\s*any'){
    throw "Encontre los any, pero el bloque cambio. No lo modifico automaticamente."
  }
  Write-Host "   El archivo activo ya no contiene esos any." -ForegroundColor DarkGray
}

Write-Host "2/5 - Limpiando copias antiguas de Code Battle phase-*..." -ForegroundColor Cyan
Get-ChildItem -Directory -Filter "phase-code-battle-live-*" -ErrorAction SilentlyContinue | ForEach-Object {
  Remove-Item -LiteralPath $_.FullName -Recurse -Force
  Write-Host "   Eliminado: $($_.Name)" -ForegroundColor DarkGray
}

Write-Host "3/5 - Validando que no queden any explicitos en el bloque Live..." -ForegroundColor Cyan
$check=[IO.File]::ReadAllText($playerPath)
if($check -match 'let\s+data:\s*any' -or $check -match 'let\s+error:\s*any'){
  throw "Todavia quedan tipos any en Player Live."
}
Write-Host "   Tipos Player Live OK." -ForegroundColor Green

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
Write-Host "LIVE PLAYER TYPES FIX COMPLETADO" -ForegroundColor Green
Write-Host "Ahora vuelve a ejecutar el instalador de Cycle 5 si lessons.ts fue restaurado."
