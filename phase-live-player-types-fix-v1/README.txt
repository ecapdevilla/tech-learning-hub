LIVE PLAYER TYPES FIX V1

Purpose:
Fix the two no-explicit-any lint errors in:
src/app/gamification/live/play/[pin]/page.tsx

The join flow remains functionally identical:
- avatar insert is attempted first
- if Supabase reports that the avatar column does not exist, it retries without avatar
- player recovery/realtime/scoring are untouched

Also removes obsolete phase-code-battle-live-* installer folders so ESLint does not
report stale duplicate errors.

Run from repository root:
.\phase-live-player-types-fix-v1\fix-live-player-types.ps1
