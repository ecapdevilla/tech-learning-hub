MULTIGRADE V7 BUILD FIX

The V7 installer copied the real multigrade files correctly into src/.

The build failed because Next.js/TypeScript also scanned the installer folder:
phase-code-battle-live-multigrade-v7/

That installer folder intentionally did not contain the complete dependency tree
(types/liveGame.ts and grade6Questions.ts), so TypeScript reported false build
errors there.

This fix:
1. removes the obsolete V7 installer folder,
2. verifies the real installed files,
3. runs lint,
4. runs build.

Run:
.\phase-code-battle-live-multigrade-v7-fix\fix-multigrade-v7-build.ps1
