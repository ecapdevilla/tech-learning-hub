# Tech Learning Hub — Referencia del proyecto

> Documento de contexto persistente. Antes de tocar código: lee este archivo y, si vas a modificar
> código Next.js, revisa también la guía en `node_modules/next/dist/docs/` (Next 16 tiene breaking
> changes respecto a versiones más antiguas — ver `AGENTS.md`).

## Propósito
Plataforma educativa (Español/Inglés) de tecnología y programación para grados **1ro a 11mo**.
Muestra grados, lecciones/guías, proyectos de estudiantes y una zona de gamificación con "live game".

## Stack y versiones (package.json)
- **Next.js 16.3.0** (App Router, Server Components) — `next` 16
- **React 19.2.8** / react-dom
- **TypeScript 5**, path alias `@/*` → `src/*`
- **Tailwind CSS v4** (via `@tailwindcss/postcss`) + `globals.css` (CSS custom por módulo)
- **Supabase** `@supabase/supabase-js` (solo live-game; respaldo local)
- **lucide-react**, **qrcode**, **clsx**, **tailwind-merge**
- Sin framework de tests configurado (no hay `test` script)

## Comandos
```bash
npm run dev       # Next dev (habilita /re escribe AGENTS.md)
npm run build
npm run start
npm run lint      # eslint
```

## Git
- Rama: `main` · Remote: `origin` = https://github.com/ecapdevilla/tech-learning-hub.git
- Los cambios se publican (ver "Flujo de fases" abajo) con commits `feat(gradeX): ...`

---

## ⚠️ IMPORTANTE — Carpetas `phase-*` en la raíz
Hay ~55 carpetas `phase-*` (p. ej. `phase-grade10-cycle5-...`, `phase-student-projects-...`,
`phase-gamification-zone-9-11-v2`). **NO son parte de la app en runtime.** Son paquetes de
"instalación"/staging, cada uno con un `*.ps1` (`install-*.ps1`, `fix-*.ps1`) y un `README.txt`
que describen qué copiar/parchear dentro de `src/` y `public/`. Están fuera de `src/`, por lo que
no se compilan. **No modificar el runtime editándolas**; se aplican vía su script.

## Estructura de la app (`src/`)
```
src/
  app/                    Rutas y composición de páginas (App Router)
    page.tsx              Home
    layout.tsx            Root layout (Geist fonts)
    globals.css           Estilos globales + clases de diseño del sitio
    explore/page.tsx      (placeholder)
    resources/page.tsx
    tutorials/page.tsx
    gamification/         page + live (host/join/play/[pin])
    grades/[grade]/page.tsx
    students/             page + grade/[grade]/[classroom] + grade/[grade]
    lessons/[lessonId]/   SOLO .gitkeep — NO implementado
    labs/[labId]/         SOLO .gitkeep — NO implementado
  content/                Datos fuente en TypeScript (capa de "datos locales")
    grades/grades.ts      Catálogo de 11 grados (primary 1-5, secondary 6-11)
    catalog/lessons.ts    ~516 líneas de resúmenes de lecciones (en/es)
  modules/                Módulos de dominio (features)
    grades/  lessons/  labs/  resources/  search/  progress/  gamification/
    live-game/            "Code Battle" en tiempo real (Supabase realtime)
    student-projects/     Proyectos de estudiantes
  shared/                 UI reutilizable, hooks, utils, i18n
    components/layout/    Navbar, SiteLayout, HomeFeatures
    components/gamification/  FrenchPassport, TechPassport, GameCard, etc.
    components/student-projects/
    components/ui/LanguageSwitcher.tsx
  infrastructure/         Adaptadores de datos
    repositories/gradeRepositoryLocal.ts, lessonRepositoryLocal.ts, index.ts
    supabase/  storage/
```

## Rutas públicas (App Router) y estáticos
- Rutas Next: `/`, `/resources`, `/tutorials`, `/explore`, `/grades/[grade]`,
  `/students`, `/students/grade/[grade]`, `/students/grade/[grade]/[classroom]`,
  `/gamification`, `/gamification/live`, `/gamification/live/host`,
  `/gamification/live/join`, `/gamification/live/play/[pin]`.
- Estáticos servidos desde `public/`:
  - `public/guides/grade-XX/*.html` — guías didácticas HTML estáticas (enlazadas por `guidePath`).
  - `public/student-projects/grade-XX/...` — evidencias/proyectos de alumnos (HTML, JS, imágenes).
  - `public/evidence/grade-XX/{blue,white,red}/...` — evidencias de clase.
  - `public/gamification/{cyber,data,iot,logic,web}.html`, `play.html`, `debug.html`.

## Flujo de datos
`src/content/*` (datos TS) → `src/infrastructure/repositories/*` (adaptadores)
→ `src/modules/*/services/*` (servicios, ej. createGradeService) → páginas `src/app/*`.

Los repositorios locales (patrón Repository/Service, listos para migrar a Supabase) exponen getters
(`getGradeById`, `getLessonsByGrade`, etc.). Las páginas los crean a nivel de módulo:
`const service = createLessonService(lessonRepositoryLocal);`.

## Módulo student-projects (el más activo)
- Tipos: `StudentProject { id, slug, studentName, grade, classroom: blue|white|red, period, cycle, title, objective, description, skills[], technologies[], projectPath?, evidenceUrl?, coverImage?, reflection?, published }`.
- Datos: `src/modules/student-projects/data/projects.ts` (800 líneas, ~49 publicados),
  `data/classrooms.ts` (salones por grado: 6-7 blue/white/red; 8-9-11 blue/white; 10 los tres).
- Servicios: `services/studentProjectService.ts` — `getPublishedProjects`, `getProjectsByGrade`,
  `getProjectsByClassroom`, `isValidClassroom`.
- Agregar contenido = añadir objetos a `projects.ts`, o crear un paquete `phase-*`.

## Módulo live-game (gamificación en tiempo real)
- `lib/supabaseClient.ts`: crea cliente Supabase con realtime si existen
  `NEXT_PUBLIC_SUPABASE_URL` y `NEXT_PUBLIC_SUPABASE_ANON_KEY` (env, ignorado por git).
  `isLiveGameConfigured` indica disponibilidad.
- Datos: `data/questionBanks.ts` + `grade6..grade11Questions.ts`.
- Páginas host/join/play en `app/gamification/live/*`.
- `supabase/code-battle-live.sql` — esquema SQL para la sala en vivo.

## i18n
- `src/shared/types/i18n.ts`: `Locale = "en" | "es"`, `LocalizedText { en, es }`.
- Títulos/objetivos de lecciones y componentos usan `{ en, es }`; `LanguageSwitcher` en navbar.
- Texto de páginas está mayormente en inglés con algunos bloques en español (mezcla actual).

## Convenciones y gotchas
- Next 16: lee `node_modules/next/dist/docs/*` antes de escribir código (rompe con lo aprendido).
- Props de páginas dinámicas usan `params: Promise<{...}>` y `await params` (Next 15/16).
- `lessons/[lessonId]` y `labs/[labId]` NO están implementados (solo `.gitkeep`).
- Casos especiales hardcodeados en `grades/[grade]/page.tsx`: grado 10 muestra "Didactic sequences",
  grado 6 incluye tarjetas estáticas de Scratch/Ciclo 4.
- Estilos en `globals.css` (no Tailwind utilities por componente en su mayoría).
- `ARCHITECTURE.md` está desactualizado (dice "6th through 11th"; ya hay grados 1-5 primaria).
- Env files ignorados; configura `.env.local` para Supabase si se usa live game.

## Scripts PowerShell en la raíz (no runtime)
`setup-home-tech-learning-hub.ps1`(+v2/v3), `publish-tech-learning-hub.ps1`,
`fix-grade3-grade5-catalog.ps1`(+v2) y dentro de cada `phase-*` su `install-*.ps1`.
Sirven para aplicar fases y publicar; no se compilan en la app.