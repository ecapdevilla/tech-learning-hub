-- CYCLE 6 · SELF-ASSESSMENT · Grades 6–11
-- Autoevaluación de 11 preguntas, escala 1-4, total+nota+nivel calculados en la BD.
-- This file is the source of truth. Run in Supabase SQL Editor.

create extension if not exists pgcrypto;

-- =====================================================
-- 1. PREGUNTAS
-- =====================================================
create table if not exists public.self_assessment_questions (
  id integer primary key,
  question text not null
);

insert into public.self_assessment_questions (id, question) values
  (1, 'Cumplí con las actividades y responsabilidades académicas a tiempo.'),
  (2, 'Participé activamente en clase, aportando ideas y preguntas.'),
  (3, 'Mostré disposición y actitud positiva frente a las actividades.'),
  (4, 'Trabajé en equipo de manera colaborativa y respetuosa.'),
  (5, 'Fui creativo/a en mis producciones y propuse nuevas ideas.'),
  (6, 'Apliqué lo aprendido en actividades o proyectos prácticos.'),
  (7, 'Busqué ayuda cuando tuve dificultades y traté de mejorar.'),
  (8, 'Asumí con responsabilidad las observaciones de mis docentes.'),
  (9, 'Mantuve buena relación con mis compañeros y profesores.'),
  (10, 'Me siento satisfecho/a con mi desempeño en este periodo.'),
  (11, 'Asumí la responsabilidad y el compromiso de mantener el salón limpio y libre de basura.')
on conflict (id) do update set question = excluded.question;

-- =====================================================
-- 2. ESCALA (total 11..44 -> nota 1.3..5.0 -> nivel)
-- =====================================================
create table if not exists public.self_assessment_scale (
  total integer primary key check (total between 11 and 44),
  nota numeric(3,1) not null check (nota between 1.0 and 5.0),
  nivel text not null check (nivel in ('Bajo','Básico','Alto','Superior'))
);

insert into public.self_assessment_scale (total, nota, nivel) values
  (11, 1.3, 'Bajo'), (12, 1.4, 'Bajo'), (13, 1.5, 'Bajo'), (14, 1.6, 'Bajo'),
  (15, 1.7, 'Bajo'), (16, 1.8, 'Bajo'), (17, 1.9, 'Bajo'), (18, 2.0, 'Bajo'),
  (19, 2.2, 'Bajo'), (20, 2.3, 'Bajo'), (21, 2.4, 'Bajo'), (22, 2.5, 'Bajo'),
  (23, 2.6, 'Bajo'), (24, 2.7, 'Bajo'), (25, 2.8, 'Bajo'), (26, 3.0, 'Bajo'),
  (27, 3.1, 'Bajo'), (28, 3.2, 'Bajo'), (29, 3.3, 'Bajo'), (30, 3.4, 'Bajo'),
  (31, 3.5, 'Básico'), (32, 3.6, 'Básico'), (33, 3.8, 'Básico'), (34, 3.9, 'Básico'),
  (35, 4.0, 'Alto'), (36, 4.1, 'Alto'), (37, 4.2, 'Alto'), (38, 4.3, 'Alto'),
  (39, 4.4, 'Alto'), (40, 4.5, 'Alto'), (41, 4.7, 'Superior'), (42, 4.8, 'Superior'),
  (43, 4.9, 'Superior'), (44, 5.0, 'Superior')
on conflict (total) do update set nota = excluded.nota, nivel = excluded.nivel;

-- =====================================================
-- 3. AUTOEVALUACIONES
-- =====================================================
create table if not exists public.self_assessment_submissions (
  id uuid primary key default gen_random_uuid(),
  academic_year integer not null default 2026,
  cycle integer not null default 6 check (cycle between 1 and 10),
  grade integer not null check (grade between 6 and 11),
  classroom text not null check (classroom in ('blue','white','red')),
  first_name text not null,
  last_name text not null,
  p1 integer not null check (p1 between 1 and 4),
  p2 integer not null check (p2 between 1 and 4),
  p3 integer not null check (p3 between 1 and 4),
  p4 integer not null check (p4 between 1 and 4),
  p5 integer not null check (p5 between 1 and 4),
  p6 integer not null check (p6 between 1 and 4),
  p7 integer not null check (p7 between 1 and 4),
  p8 integer not null check (p8 between 1 and 4),
  p9 integer not null check (p9 between 1 and 4),
  p10 integer not null check (p10 between 1 and 4),
  p11 integer not null check (p11 between 1 and 4),
  total integer not null check (total between 11 and 44),
  nota numeric(3,1) not null check (nota between 1.0 and 5.0),
  nivel text not null check (nivel in ('Bajo','Básico','Alto','Superior')),
  created_at timestamptz not null default now()
);

-- =====================================================
-- 4. TRIGGER: calcular total + nota + nivel en la BD
-- =====================================================
create or replace function public.calculate_self_assessment()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_nota numeric(3,1);
  v_nivel text;
begin
  new.total :=
      new.p1 + new.p2 + new.p3 + new.p4 + new.p5 + new.p6
    + new.p7 + new.p8 + new.p9 + new.p10 + new.p11;

  select nota, nivel into v_nota, v_nivel
  from public.self_assessment_scale
  where total = new.total;

  if v_nota is null then
    raise exception 'No existe escala para total %', new.total;
  end if;

  new.nota := v_nota;
  new.nivel := v_nivel;
  return new;
end;
$$;

drop trigger if exists trg_calculate_self_assessment
  on public.self_assessment_submissions;
create trigger trg_calculate_self_assessment
  before insert or update
  on public.self_assessment_submissions
  for each row
  execute function public.calculate_self_assessment();

-- =====================================================
-- 5. ÍNDICES
-- =====================================================
create index if not exists idx_sa_submissions_grade_classroom
  on public.self_assessment_submissions(academic_year, cycle, grade, classroom);

create index if not exists idx_sa_submissions_student
  on public.self_assessment_submissions(lower(last_name), lower(first_name));

-- =====================================================
-- 6. ROW LEVEL SECURITY
-- =====================================================
alter table public.self_assessment_questions enable row level security;
alter table public.self_assessment_scale enable row level security;
alter table public.self_assessment_submissions enable row level security;

-- Preguntas: lectura pública
drop policy if exists "sa_questions_read" on public.self_assessment_questions;
create policy "sa_questions_read"
  on public.self_assessment_questions
  for select to anon, authenticated using (true);

-- Escala: lectura pública
drop policy if exists "sa_scale_read" on public.self_assessment_scale;
create policy "sa_scale_read"
  on public.self_assessment_scale
  for select to anon, authenticated using (true);

-- Los estudiantes pueden ENVIAR su autoevaluación
drop policy if exists "sa_submissions_insert" on public.self_assessment_submissions;
create policy "sa_submissions_insert"
  on public.self_assessment_submissions
  for insert to anon, authenticated
  with check (
    grade between 6 and 11
    and classroom in ('blue','white','red')
  );

-- Lectura de resultados: habilitada para que el docente/app pueda pasar el listado.
-- NOTA: acceso abierto a quien tenga la key anónima. Para restringir a docente,
-- reemplazar por Supabase Auth (fase de acceso docente).
drop policy if exists "self_assessment_submissions_read" on public.self_assessment_submissions;
create policy "self_assessment_submissions_read"
  on public.self_assessment_submissions
  for select to anon, authenticated using (true);