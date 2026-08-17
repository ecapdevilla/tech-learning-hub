CODE BATTLE LIVE · FIX 4

Fixes TypeScript TS18047:
'liveSupabase' is possibly 'null'.

Why it happened:
TypeScript correctly narrowed liveSupabase before creating the Realtime
subscription, but that narrowing was not preserved inside the cleanup closure.

Solution:
- capture `const supabase = liveSupabase` after the null check,
- use the stable `supabase` local in subscribe/removeChannel,
- remove obsolete fix2/fix3 phase folders before lint/build so Next/TypeScript
  does not compile stale copies.

Run from tech-learning-hub root:
.\phase-code-battle-live-6th-v1-fix4\fix4-code-battle-live.ps1
