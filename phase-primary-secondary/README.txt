PHASE PRIMARY + SECONDARY

Incluye:
- Grade 2 Little Programmers
- Primary School section
- Secondary School section
- New homepage composition
- Reusable GradeSection
- Reusable HeroCopy
- Reusable HeroVisual
- Reusable HomeFeatures

USO:
1. Descomprime el ZIP.
2. Copia la carpeta phase-primary-secondary dentro de tech-learning-hub.
3. Desde PowerShell en tech-learning-hub:
   Set-ExecutionPolicy -Scope Process Bypass
   .\phase-primary-secondary\install-primary-secondary.ps1
4. Revisa localhost:3000
5. Publica:
   git add .
   git commit -m "feat: add primary and secondary learning paths"
   git push
