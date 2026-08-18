CODE BATTLE LIVE · STABILITY V6 FIX

Fixes the React 19 lint error caused by calling:
setConnection("connecting")
synchronously inside the Realtime subscription effect.

All V5 resilience features remain:
- localStorage player recovery
- Realtime connection status
- automatic reconnect
- polling fallback
- online / visibility resync
- safe audio
- duplicate-answer tolerance
- manual resync

Also removes the obsolete V5 phase folder before lint/build so ESLint does not
report the same old error twice.

Run:
.\phase-code-battle-live-6th-v1-stability-v6-fix\fix6-code-battle-live-stability.ps1
