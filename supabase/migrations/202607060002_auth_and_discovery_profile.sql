create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null unique,
  full_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.discovery_profile (
  user_id uuid primary key references public.users(id) on delete cascade,
  activities text[] not null default '{}',
  budget_tier text not null default 'medium',
  companions text[] not null default '{}',
  priorities text[] not null default '{}',
  walking_preference text not null default 'moderate',
  trip_pace text not null default 'balanced',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.users enable row level security;
alter table public.discovery_profile enable row level security;

create policy "users_select_own"
  on public.users for select
  using (auth.uid() = id);

create policy "users_insert_own"
  on public.users for insert
  with check (auth.uid() = id);

create policy "users_update_own"
  on public.users for update
  using (auth.uid() = id);

create policy "users_delete_own"
  on public.users for delete
  using (auth.uid() = id);

create policy "discovery_profile_select_own"
  on public.discovery_profile for select
  using (auth.uid() = user_id);

create policy "discovery_profile_insert_own"
  on public.discovery_profile for insert
  with check (auth.uid() = user_id);

create policy "discovery_profile_update_own"
  on public.discovery_profile for update
  using (auth.uid() = user_id);

create policy "discovery_profile_delete_own"
  on public.discovery_profile for delete
  using (auth.uid() = user_id);

create or replace function public.handle_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger users_set_updated_at
before update on public.users
for each row
execute function public.handle_updated_at();

create trigger discovery_profile_set_updated_at
before update on public.discovery_profile
for each row
execute function public.handle_updated_at();

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, email, full_name, avatar_url)
  values (
    new.id,
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do update
    set email = excluded.email,
        full_name = excluded.full_name,
        avatar_url = excluded.avatar_url;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
after insert on auth.users
for each row
execute function public.handle_new_auth_user();
