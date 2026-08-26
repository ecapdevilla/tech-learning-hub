-- CYCLE 6 · SELF-ASSESSMENT  · Grades 6–11
-- Autoevaluación de 11 preguntas, escala 1-4, promedio -> nota/nivel.
-- Run this in Supabase SQL Editor.

create extension if not exists pgcrypto;

-- 1) Las 11 preguntas de autoevaluación.
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

-- 2) Escala de conversión: puntaje total (11..44) -> nota (1.3..5.0) -> nivel.
create table if not exists public.self_assessment_scale (
  total integer primary key check (total between 11 and 44),
  nota numeric(3,1) not null,
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

-- 3) Envíos: una fila por estudiante con su resultado.
create table if not exists public.self_assessment_submissions (
  id uuid primary key default gen_random_uuid(),
  grade integer not null check (grade between 6 and 11),
  classroom text not null check (classroom in ('blue','white','red')),
  first_name text not null,
  last_name text not null,
  p1 integer not null, p2 integer not null, p3 integer not null,
  p4 integer not null, p5 integer not null, p6 integer not null,
  p7 integer not null, p8 integer not null, p9 integer not null,
  p10 integer not null, p11 integer not null,
  total integer not null check (total between 11 and 44),
  nota numeric(3,1) not null,
  nivel text not null,
  created_at timestamptz not null default now()
);

create index if not exists idx_sa_submissions_grade
  on public.self_assessment_submissions(grade, classroom);
create index if not exists idx_sa_submissions_last_name
  on public.self_assessment_submissions(lower(last_name), first_name);

alter table public.self_assessment_submissions enable row level security;

-- Políticas públicas (igual que live-game): lecturas e inserciones de anónimos.
drop policy if exists "self_assessment_submissions_read" on public.self_assessment_submissions;
create policy "self_assessment_submissions_read"
  on public.self_assessment_submissions for select to anon using (true);

drop policy if exists "self_assessment_submissions_insert" on public.self_assessment_submissions;
create policy "self_assessment_submissions_insert"
  on public.self_assessment_submissions for insert to anon with check (true);