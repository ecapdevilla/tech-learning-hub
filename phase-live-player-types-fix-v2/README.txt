Fix V2:
- Uses absolute repository paths based on Get-Location.
- Uses LiteralPath where PowerShell could interpret [pin] as a wildcard.
- Removes only stale phase-code-battle-live-* folders.
- Keeps the Live join behavior unchanged while removing explicit any types.

Run:
.\phase-live-player-types-fix-v2\fix-live-player-types-v2.ps1
