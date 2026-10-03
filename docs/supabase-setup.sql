-- Run once in Supabase: SQL Editor -> New query -> paste -> Run.
create table if not exists public.pw_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  json text not null,
  updated_at timestamptz not null default now()
);
alter table public.pw_state enable row level security;
create policy "own row only" on public.pw_state
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
