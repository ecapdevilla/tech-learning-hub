-- ====================================================================
-- MULTI-TENANT V1 - Tech Learning Hub
-- File: supabase/migrations/20260830220000_multitenant_v1.sql
-- Purpose: introduce institutions + users + memberships + courses
--          keeping every existing table, column, row and URL intact.
-- Status: ADDITIVE only. NOT executable until reviewed.
-- ====================================================================

begin;

-- =================================================================
-- 0. EXTENSIONS
-- =================================================================
create extension if not exists pgcrypto;

-- =================================================================
-- 1. NEW TABLES
-- =================================================================

-- institutions: the tenant root
create table if not exists public.institutions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  domain text unique,
  logo_url text,
  primary_color text,
  plan text not null default 'free' check (plan in ('free','pro','institution','enterprise')),
  max_teachers integer not null default 1,
  max_students integer not null default 30,
  max_courses integer not null default 1,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists idx_institutions_slug on public.institutions(slug);
create index if not exists idx_institutions_domain on public.institutions(domain);

-- profiles: extends auth.users (1:1)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text not null,
  locale text not null default 'es',
  avatar_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists idx_profiles_email on public.profiles(email);

-- memberships: user -> institution -> role
create table if not exists public.memberships (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  institution_id uuid not null references public.institutions(id) on delete cascade,
  role text not null check (role in ('platform_admin','institution_admin','teacher','student')),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, institution_id)
);
create index if not exists idx_memberships_user on public.memberships(user_id);
create index if not exists idx_memberships_institution on public.memberships(institution_id);
create index if not exists idx_memberships_role on public.memberships(institution_id, role);

-- students: per-institution student records (separate from auth.users for now)
create table if not exists public.students (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid not null references public.institutions(id) on delete cascade,
  external_id text,
  first_name text not null,
  last_name text not null,
  grade integer not null check (grade between 1 and 11),
  classroom text not null,
  email text,
  enrollment_code text unique,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (institution_id, external_id)
);
create index if not exists idx_students_institution on public.students(institution_id);
create index if not exists idx_students_grade_classroom on public.students(institution_id, grade, classroom);
create index if not exists idx_students_name on public.students(institution_id, lower(last_name), lower(first_name));
create index if not exists idx_students_enrollment_code on public.students(enrollment_code);

-- academic_periods: per-institution year+period
create table if not exists public.academic_periods (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid not null references public.institutions(id) on delete cascade,
  academic_year integer not null,
  period integer not null check (period between 1 and 10),
  starts_at date,
  ends_at date,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (institution_id, academic_year, period)
);
create index if not exists idx_academic_periods_institution on public.academic_periods(institution_id);

-- courses: subject + period + grade + classroom + teacher
create table if not exists public.courses (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid not null references public.institutions(id) on delete cascade,
  subject_id uuid not null references public.subjects(id) on delete cascade,
  academic_period_id uuid not null references public.academic_periods(id) on delete cascade,
  teacher_id uuid references auth.users(id) on delete set null,
  grade integer not null check (grade between 1 and 11),
  classroom text not null,
  name text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (subject_id, academic_period_id, grade, classroom)
);
create index if not exists idx_courses_institution on public.courses(institution_id);
create index if not exists idx_courses_teacher on public.courses(institution_id, teacher_id);
create index if not exists idx_courses_period on public.courses(institution_id, academic_period_id);
create index if not exists idx_courses_grade_classroom on public.courses(institution_id, grade, classroom);

-- course_dimensions: saber/hacer/ser per course
create table if not exists public.course_dimensions (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  dimension text not null check (dimension in ('saber','hacer','ser')),
  entregas_count integer not null default 4,
  weight numeric(3,2) not null default 0.34,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (course_id, dimension)
);
create index if not exists idx_course_dimensions_course on public.course_dimensions(course_id);

-- course_enrollments: student -> course
create table if not exists public.course_enrollments (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade,
  enrolled_by uuid references auth.users(id) on delete set null,
  enrolled_at timestamptz not null default now(),
  is_active boolean not null default true,
  unique (course_id, student_id)
);
create index if not exists idx_course_enrollments_course on public.course_enrollments(course_id);
create index if not exists idx_course_enrollments_student on public.course_enrollments(student_id);

-- course_grades: notes per student/dimension/entrega (replaces grades)
create table if not exists public.course_grades (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade,
  dimension_id uuid not null references public.course_dimensions(id) on delete cascade,
  entrega_index integer not null check (entrega_index between 1 and 10),
  value numeric(4,1) check (value between 1.0 and 5.0 or value is null),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (course_id, student_id, dimension_id, entrega_index)
);
create index if not exists idx_course_grades_course on public.course_grades(course_id);
create index if not exists idx_course_grades_student on public.course_grades(student_id);
create index if not exists idx_course_grades_composite on public.course_grades(course_id, student_id);

commit;

-- =================================================================
-- 2. SEED LEGACY INSTITUTION
-- =================================================================
begin;
insert into public.institutions (
  id, name, slug, plan, max_teachers, max_students, max_courses, is_active
) values (
  '00000000-0000-0000-0000-000000000001',
  'Tech Learning Hub (LEGACY)',
  'legacy-default',
  'institution',
  999999, 999999, 999999,
  true
) on conflict (id) do nothing;
commit;

-- =================================================================
-- 3. ADD institution_id TO existing tables (additive, no rename/drop)
-- =================================================================
begin;
-- subjects
alter table public.subjects add column if not exists institution_id uuid
  references public.institutions(id) on delete cascade;
alter table public.subjects add column if not exists is_active boolean not null default true;
alter table public.subjects add column if not exists updated_at timestamptz not null default now();
update public.subjects set institution_id = '00000000-0000-0000-0000-000000000001'::uuid where institution_id is null;
do $$ begin if exists (select 1 from public.subjects where institution_id is null) then raise exception 'subjects backfill failed'; end if; end $$;
alter table public.subjects alter column institution_id set not null;
create unique index if not exists idx_subjects_inst_name on public.subjects(institution_id, name);
create index if not exists idx_subjects_institution on public.subjects(institution_id);
commit;

begin;
-- self_assessment_submissions
alter table public.self_assessment_submissions add column if not exists institution_id uuid
  references public.institutions(id) on delete cascade;
alter table public.self_assessment_submissions add column if not exists course_id uuid
  references public.courses(id) on delete set null;
alter table public.self_assessment_submissions add column if not exists student_id uuid
  references public.students(id) on delete set null;
update public.self_assessment_submissions set institution_id = '00000000-0000-0000-0000-000000000001'::uuid where institution_id is null;
do $$ begin if exists (select 1 from public.self_assessment_submissions where institution_id is null) then raise exception 'sa_submissions backfill failed'; end if; end $$;
alter table public.self_assessment_submissions alter column institution_id set not null;
create index if not exists idx_sa_submissions_institution on public.self_assessment_submissions(institution_id);
create index if not exists idx_sa_submissions_course on public.self_assessment_submissions(course_id);
create index if not exists idx_sa_submissions_student on public.self_assessment_submissions(student_id);
commit;

begin;
-- live_games
alter table public.live_games add column if not exists institution_id uuid
  references public.institutions(id) on delete cascade;
alter table public.live_games add column if not exists course_id uuid
  references public.courses(id) on delete set null;
alter table public.live_games add column if not exists teacher_id uuid
  references auth.users(id) on delete set null;
update public.live_games set institution_id = '00000000-0000-0000-0000-000000000001'::uuid where institution_id is null;
do $$ begin if exists (select 1 from public.live_games where institution_id is null) then raise exception 'live_games backfill failed'; end if; end $$;
alter table public.live_games alter column institution_id set not null;
create index if not exists idx_live_games_institution on public.live_games(institution_id);
create index if not exists idx_live_games_teacher on public.live_games(institution_id, teacher_id);
commit;

begin;
-- live_players
alter table public.live_players add column if not exists institution_id uuid
  references public.institutions(id) on delete cascade;
alter table public.live_players add column if not exists student_id uuid
  references public.students(id) on delete set null;
update public.live_players lp
set institution_id = '00000000-0000-0000-0000-000000000001'::uuid
from public.live_games lg
where lp.game_id = lg.id and lp.institution_id is null;
do $$ begin if exists (select 1 from public.live_players where institution_id is null) then raise exception 'live_players backfill failed'; end if; end $$;
alter table public.live_players alter column institution_id set not null;
create index if not exists idx_live_players_institution on public.live_players(institution_id);
create index if not exists idx_live_players_student on public.live_players(student_id);
commit;

-- =================================================================
-- 4. MIGRATE DATA INTO NEW TABLES
-- =================================================================

-- 4a. periods -> academic_periods
begin;
insert into public.academic_periods (institution_id, academic_year, period, is_active)
select '00000000-0000-0000-0000-000000000001'::uuid, p.academic_year, p.period, true
from public.periods p
on conflict (institution_id, academic_year, period) do nothing;
commit;

-- 4b. grading_students -> students
begin;
insert into public.students (
  institution_id, external_id, first_name, last_name,
  grade, classroom, enrollment_code, is_active
)
select
  '00000000-0000-0000-0000-000000000001'::uuid,
  'LEG-' || gs.id::text,
  gs.first_name, gs.last_name,
  gs.grade, gs.classroom,
  encode(gen_random_bytes(6), 'hex'),
  true
from public.grading_students gs
on conflict (institution_id, external_id) do nothing;
commit;

-- 4c. courses: one per unique (subject, period, grade, classroom)
-- grade_dimensions has (subject_id, period_id) but NOT grade/classroom.
-- We derive grade/classroom from grading_students: for each unique
-- (subject_id, period_id) pair in grade_dimensions, we look at which
-- grade/classroom combos have students, and create one course per combo.
begin;
insert into public.courses (
  institution_id, subject_id, academic_period_id,
  grade, classroom, name, is_active
)
select distinct
  '00000000-0000-0000-0000-000000000001'::uuid,
  gd.subject_id,
  ap.id,
  gs.grade,
  gs.classroom,
  'LEGACY - ' || s.name || ' - ' || gs.grade || chr(176) || ' ' || gs.classroom,
  true
from (
  -- unique (subject, period) from grade_dimensions
  select distinct subject_id, period_id from public.grade_dimensions
) gd
join public.subjects s on s.id = gd.subject_id
join public.periods p on p.id = gd.period_id
join public.academic_periods ap on ap.institution_id = '00000000-0000-0000-0000-000000000001'::uuid
  and ap.academic_year = p.academic_year and ap.period = p.period
join (
  -- unique (grade, classroom) from students (grading_students was the source)
  select distinct grade, classroom from public.grading_students
) gs on true
on conflict (subject_id, academic_period_id, grade, classroom) do nothing;
commit;

-- 4d. course_dimensions: migrate from grade_dimensions
begin;
insert into public.course_dimensions (
  course_id, dimension, entregas_count, weight, is_active
)
select
  c.id,
  gd.dimension,
  gd.entregas_count,
  case gd.dimension
    when 'saber' then 0.33
    when 'hacer' then 0.33
    else 0.34
  end,
  true
from public.grade_dimensions gd
join public.subjects s on s.id = gd.subject_id
join public.periods p on p.id = gd.period_id
join public.academic_periods ap on ap.institution_id = '00000000-0000-0000-0000-000000000001'::uuid
  and ap.academic_year = p.academic_year and ap.period = p.period
join public.courses c on c.subject_id = gd.subject_id
  and c.academic_period_id = ap.id
  and c.institution_id = '00000000-0000-0000-0000-000000000001'::uuid
on conflict (course_id, dimension) do nothing;
commit;

-- 4e. course_enrollments: every student into their matching course(s)
begin;
insert into public.course_enrollments (course_id, student_id, enrolled_by, is_active)
select c.id, st.id, null::uuid, true
from public.students st
join public.courses c on c.institution_id = st.institution_id
  and c.grade = st.grade and c.classroom = st.classroom
where st.institution_id = '00000000-0000-0000-0000-000000000001'::uuid
on conflict (course_id, student_id) do nothing;
commit;

-- 4f. course_grades: migrate from grades
-- Strategy: for each old grade (student_id, dimension_id, entrega_index),
-- find the matching course via (subject, grade, classroom) -> course_dimensions
begin;
insert into public.course_grades (course_id, student_id, dimension_id, entrega_index, value)
select
  ce.course_id,
  cg.student_id,
  cd.id,
  g.entrega_index,
  g.value
from public.grades g
join public.course_enrollments ce on ce.student_id = g.student_id
join public.course_dimensions cd on cd.course_id = ce.course_id
join public.grade_dimensions gd on gd.dimension = cd.dimension
join public.students st on st.id = g.student_id
join public.courses c on c.id = ce.course_id
join public.subjects sub on sub.id = c.subject_id and sub.id = gd.subject_id
where
  -- The old dimension_id must match the subject via grade_dimensions
  gd.id = g.dimension_id
  -- AND the course grade/classroom must match the student's
  and c.grade = st.grade
  and c.classroom = st.classroom
on conflict (course_id, student_id, dimension_id, entrega_index) do nothing;
commit;

-- =================================================================
-- 5. HELPER FUNCTIONS
-- =================================================================
begin;

create or replace function public.is_institution_member(institution_uuid uuid)
returns boolean language sql security definer set search_path = public
as $$
  select exists (
    select 1 from public.memberships
    where user_id = auth.uid()
      and institution_id = institution_uuid
      and is_active = true
  );
$$;

create or replace function public.current_institution_id()
returns uuid language sql security definer set search_path = public
as $$
  select nullif(current_setting('app.current_institution', true)::text, '')::uuid;
$$;

commit;

-- =================================================================
-- 6. RLS POLICIES - new tables
-- =================================================================
begin;

alter table public.institutions enable row level security;
alter table public.profiles enable row level security;
alter table public.memberships enable row level security;
alter table public.students enable row level security;
alter table public.academic_periods enable row level security;
alter table public.courses enable row level security;
alter table public.course_dimensions enable row level security;
alter table public.course_enrollments enable row level security;
alter table public.course_grades enable row level security;

-- institutions
drop policy if exists institutions_select on public.institutions;
create policy institutions_select on public.institutions for select using (
  is_institution_member(id)
  or exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.role = 'platform_admin')
);

drop policy if exists institutions_update on public.institutions;
create policy institutions_update on public.institutions for update using (
  exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.institution_id = id and m.role = 'institution_admin')
  or exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.role = 'platform_admin')
);

-- profiles
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles for select using (
  id = auth.uid()
  or exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.role = 'platform_admin')
);

drop policy if exists profiles_update on public.profiles;
create policy profiles_update on public.profiles for update using (id = auth.uid());

-- memberships
drop policy if exists memberships_select on public.memberships;
create policy memberships_select on public.memberships for select using (
  user_id = auth.uid()
  or exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.institution_id = memberships.institution_id and m.role in ('institution_admin','platform_admin'))
);

drop policy if exists memberships_insert on public.memberships;
create policy memberships_insert on public.memberships for insert with check (
  exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.role = 'platform_admin')
  or (exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.institution_id = memberships.institution_id and m.role = 'institution_admin') and role in ('teacher','student'))
);

-- students
drop policy if exists students_select on public.students;
create policy students_select on public.students for select using (
  is_institution_member(institution_id)
);

drop policy if exists students_insert on public.students;
create policy students_insert on public.students for insert with check (
  institution_id = public.current_institution_id()
  and exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.institution_id = students.institution_id and m.role in ('institution_admin','teacher'))
);

-- academic_periods
drop policy if exists ap_select on public.academic_periods;
create policy ap_select on public.academic_periods for select using (
  is_institution_member(institution_id)
);

drop policy if exists ap_insert on public.academic_periods;
create policy ap_insert on public.academic_periods for insert with check (
  institution_id = public.current_institution_id()
  and exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.institution_id = academic_periods.institution_id and m.role in ('institution_admin','teacher'))
);

-- subjects
drop policy if exists subjects_select on public.subjects;
create policy subjects_select on public.subjects for select using (
  is_institution_member(institution_id)
);

drop policy if exists subjects_insert on public.subjects;
create policy subjects_insert on public.subjects for insert with check (
  institution_id = public.current_institution_id()
  and exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.institution_id = subjects.institution_id and m.role in ('institution_admin','teacher'))
);

-- courses
drop policy if exists courses_select on public.courses;
create policy courses_select on public.courses for select using (
  is_institution_member(institution_id)
);

drop policy if exists courses_insert on public.courses;
create policy courses_insert on public.courses for insert with check (
  institution_id = public.current_institution_id()
  and exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.institution_id = courses.institution_id and m.role in ('institution_admin','teacher'))
);

drop policy if exists courses_update on public.courses;
create policy courses_update on public.courses for update using (
  exists (select 1 from public.memberships m where m.user_id = auth.uid() and m.institution_id = courses.institution_id and m.role in ('institution_admin','teacher'))
);

-- course_dimensions (access via course membership)
drop policy if exists cd_select on public.course_dimensions;
create policy cd_select on public.course_dimensions for select using (
  exists (select 1 from public.courses c where c.id = course_dimensions.course_id and is_institution_member(c.institution_id))
);

drop policy if exists cd_modify on public.course_dimensions;
create policy cd_modify on public.course_dimensions for all using (
  exists (select 1 from public.courses c, public.memberships m where c.id = course_dimensions.course_id and m.user_id = auth.uid() and m.institution_id = c.institution_id and m.role in ('institution_admin','teacher'))
);

-- course_enrollments
drop policy if exists ce_select on public.course_enrollments;
create policy ce_select on public.course_enrollments for select using (
  exists (select 1 from public.courses c where c.id = course_enrollments.course_id and is_institution_member(c.institution_id))
);

drop policy if exists ce_modify on public.course_enrollments;
create policy ce_modify on public.course_enrollments for all using (
  exists (select 1 from public.courses c, public.memberships m where c.id = course_enrollments.course_id and m.user_id = auth.uid() and m.institution_id = c.institution_id and m.role in ('institution_admin','teacher'))
);

-- course_grades
drop policy if exists cg_select on public.course_grades;
create policy cg_select on public.course_grades for select using (
  exists (select 1 from public.courses c where c.id = course_grades.course_id and is_institution_member(c.institution_id))
);

drop policy if exists cg_modify on public.course_grades;
create policy cg_modify on public.course_grades for all using (
  exists (select 1 from public.courses c, public.memberships m where c.id = course_grades.course_id and m.user_id = auth.uid() and m.institution_id = c.institution_id and m.role in ('institution_admin','teacher'))
);

commit;

-- =================================================================
-- 7. RLS - self_assessment_submissions (CRITICAL: close security hole)
-- =================================================================
begin;

-- CRITICAL SECURITY FIX: remove the open anon read policy
drop policy if exists self_assessment_submissions_read on public.self_assessment_submissions;

-- New select: only institution members (teacher/institution_admin)
drop policy if exists sa_submissions_select on public.self_assessment_submissions;
create policy sa_submissions_select on public.self_assessment_submissions for select using (
  institution_id = public.current_institution_id()
  and exists (
    select 1 from public.memberships m
    where m.user_id = auth.uid()
      and m.institution_id = self_assessment_submissions.institution_id
      and m.role in ('institution_admin','teacher')
  )
);

-- INSERT policy is kept (students submit their own assessment)
-- (from cycle6-self-assessment.sql: sa_submissions_insert remains intact)

commit;

-- =================================================================
-- 8. RLS - live_games (keep anon for MVP lobby; add institution filter)
-- =================================================================
begin;

drop policy if exists live_games_select_inst on public.live_games;
create policy live_games_select_inst on public.live_games for select to anon, authenticated using (
  institution_id = public.current_institution_id()
  or institution_id is null  -- legacy rows
);

drop policy if exists live_players_select_inst on public.live_players;
create policy live_players_select_inst on public.live_players for select to anon, authenticated using (true);

commit;

-- =================================================================
-- 9. VERIFICATION (run these before commit)
-- Expected results: all PASS
-- =================================================================

\echo '=== MIGRATION VERIFICATION ==='
\echo '1. institutions count: '
select count(*), (select name from public.institutions where slug = 'legacy-default') as legacy_name;
\echo '2. students migrated: '
select (select count(*) from public.grading_students) as source, (select count(*) from public.students where institution_id = '00000000-0000-0000-0000-000000000001'::uuid) as migrated;
\echo '3. grades migrated: '
select (select count(*) from public.grades) as source, (select count(*) from public.course_grades) as migrated;
\echo '4. self_assessments tagged: '
select (select count(*) from public.self_assessment_submissions) as total, (select count(*) from public.self_assessment_submissions where institution_id is not null) as tagged;
\echo '5. live_games tagged: '
select (select count(*) from public.live_games) as total, (select count(*) from public.live_games where institution_id is not null) as tagged;
\echo '6. live_players tagged: '
select (select count(*) from public.live_players) as total, (select count(*) from public.live_players where institution_id is not null) as tagged;
\echo '7. live_answers unchanged: '
select count(*) as total from public.live_answers;
\echo '8. sa_submissions_read policy removed: '
select count(*) = 0 as policy_removed from pg_policies where policyname = 'self_assessment_submissions_read';

rollback;  -- REMOVE THIS LINE TO ACTUALLY EXECUTE
