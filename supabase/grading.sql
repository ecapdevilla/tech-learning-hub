-- GRADING SYSTEM · Teacher notes (Saber/Hacer/Ser) + export
-- Run in Supabase SQL Editor.

create extension if not exists pgcrypto;

-- Catálogo de materias (escalable a multi-docente).
create table if not exists public.subjects (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  teacher text default ''
);

-- Periodos (año + periodo). Ej: 2026, 3
create table if not exists public.periods (
  id uuid primary key default gen_random_uuid(),
  academic_year integer not null,
  period integer not null,
  unique (academic_year, period)
);

-- Catálogo de estudiantes (carga única).
create table if not exists public.grading_students (
  id uuid primary key default gen_random_uuid(),
  first_name text not null,
  last_name text not null,
  grade integer not null check (grade between 6 and 11),
  classroom text not null check (classroom in ('blue','white','red'))
);
create index if not exists idx_grading_students_grade
  on public.grading_students(grade, classroom);

-- Dimensiones de un subject+periodo: saber/hacer/ser con nº de entregas.
create table if not exists public.grade_dimensions (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid not null references public.subjects(id) on delete cascade,
  period_id uuid not null references public.periods(id) on delete cascade,
  dimension text not null check (dimension in ('saber','hacer','ser')),
  entregas_count integer not null default 4,
  unique (subject_id, period_id, dimension)
);

-- Notas por estudiante/dimensión/entrega.
create table if not exists public.grades (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.grading_students(id) on delete cascade,
  dimension_id uuid not null references public.grade_dimensions(id) on delete cascade,
  entrega_index integer not null,
  value numeric(4,1),
  unique (student_id, dimension_id, entrega_index)
);
create index if not exists idx_grades_dim on public.grades(dimension_id);

-- RLS
alter table public.subjects enable row level security;
alter table public.periods enable row level security;
alter table public.grading_students enable row level security;
alter table public.grade_dimensions enable row level security;
alter table public.grades enable row level security;

-- Solo lectura/escritura del docente (servidor con service role). Anónimo no accede.
-- Por default sin políticas: el request del docente se hará desde el servidor con service role.