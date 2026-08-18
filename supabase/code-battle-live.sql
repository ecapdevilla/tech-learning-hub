-- CODE BATTLE LIVE · MVP V1
-- Run this in Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.live_games (
  id uuid primary key default gen_random_uuid(),
  pin text not null unique check (pin ~ '^[0-9]{6}$'),
  grade integer not null default 6,
  title text not null,
  status text not null default 'lobby'
    check (status in ('lobby','question','reveal','finished')),
  current_question_index integer not null default 0,
  question_started_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.live_players (
  id uuid primary key default gen_random_uuid(),
  game_id uuid not null references public.live_games(id) on delete cascade,
  name text not null check (char_length(name) between 2 and 24),
  avatar text default '👾' check (char_length(avatar) between 1 and 4),
  score integer not null default 0,
  streak integer not null default 0,
  joined_at timestamptz not null default now()
);

alter table public.live_players
  add column if not exists avatar text default '👾';

alter table public.live_players
  alter column avatar set default '👾';

create table if not exists public.live_answers (
  id uuid primary key default gen_random_uuid(),
  game_id uuid not null references public.live_games(id) on delete cascade,
  player_id uuid not null references public.live_players(id) on delete cascade,
  question_index integer not null,
  answer_index integer not null check (answer_index between 0 and 3),
  is_correct boolean not null,
  response_ms integer not null default 0,
  points integer not null default 0,
  created_at timestamptz not null default now(),
  unique (game_id, player_id, question_index)
);

create index if not exists idx_live_players_game on public.live_players(game_id);
create index if not exists idx_live_answers_game_question
  on public.live_answers(game_id, question_index);

alter table public.live_games enable row level security;
alter table public.live_players enable row level security;
alter table public.live_answers enable row level security;

-- Classroom MVP policies:
-- anonymous clients may create/read/update live classroom records.
-- No email, surname, phone or school ID is stored.
drop policy if exists "live_games_public_read" on public.live_games;
create policy "live_games_public_read"
on public.live_games for select to anon using (true);

drop policy if exists "live_games_public_insert" on public.live_games;
create policy "live_games_public_insert"
on public.live_games for insert to anon with check (true);

drop policy if exists "live_games_public_update" on public.live_games;
create policy "live_games_public_update"
on public.live_games for update to anon using (true) with check (true);

drop policy if exists "live_players_public_read" on public.live_players;
create policy "live_players_public_read"
on public.live_players for select to anon using (true);

drop policy if exists "live_players_public_insert" on public.live_players;
create policy "live_players_public_insert"
on public.live_players for insert to anon with check (true);

drop policy if exists "live_players_public_update" on public.live_players;
create policy "live_players_public_update"
on public.live_players for update to anon using (true) with check (true);

drop policy if exists "live_answers_public_read" on public.live_answers;
create policy "live_answers_public_read"
on public.live_answers for select to anon using (true);

drop policy if exists "live_answers_public_insert" on public.live_answers;
create policy "live_answers_public_insert"
on public.live_answers for insert to anon with check (true);

-- Realtime
alter publication supabase_realtime add table public.live_games;
alter publication supabase_realtime add table public.live_players;
alter publication supabase_realtime add table public.live_answers;
