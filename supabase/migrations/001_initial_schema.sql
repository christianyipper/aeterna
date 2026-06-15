-- ============================================================
-- AETERNA — Initial Schema
-- ============================================================

-- ── Profiles ────────────────────────────────────────────────
create table profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  username   text unique,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ── Body Regions (reference) ─────────────────────────────────
create table body_regions (
  region_key text primary key,
  label      text not null,
  side       text check (side in ('left', 'right', 'center')),
  category   text not null check (category in ('upper_body', 'core', 'lower_body'))
);

-- ── Body Map Sessions ────────────────────────────────────────
-- One session per user per day; captures friction state before workout
create table body_map_sessions (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users(id) on delete cascade,
  session_date date not null default current_date,
  created_at   timestamptz not null default now(),
  unique (user_id, session_date)
);

-- ── Body Map Entries ─────────────────────────────────────────
-- One row per region per session; only stores non-zero friction to keep reads lean
create table body_map_entries (
  id            uuid primary key default gen_random_uuid(),
  session_id    uuid not null references body_map_sessions(id) on delete cascade,
  region_key    text not null references body_regions(region_key),
  friction_level smallint not null default 0 check (friction_level in (0, 1, 2)),
  unique (session_id, region_key)
);

-- ── Exercise Library ─────────────────────────────────────────
create table exercises (
  id               uuid primary key default gen_random_uuid(),
  name             text not null,
  category         text not null check (category in ('strength', 'mobility', 'stability', 'prep')),
  muscle_groups    text[] not null default '{}',
  is_prep_protocol boolean not null default false,
  default_sets     smallint not null default 3,
  default_reps     smallint not null default 10,
  default_weight_kg numeric(6,2),
  created_at       timestamptz not null default now()
);

-- ── Friction Rules (rule engine config) ──────────────────────
-- Maps body region × friction level → action (inject exercise or cap load)
create table friction_rules (
  id                 serial primary key,
  region_key         text not null references body_regions(region_key),
  friction_threshold smallint not null check (friction_threshold in (1, 2)),
  action_type        text not null check (action_type in ('inject_exercise', 'load_ceiling')),
  exercise_id        uuid references exercises(id) on delete set null,
  load_ceiling_pct   numeric(3,2),
  constraint valid_action check (
    (action_type = 'inject_exercise' and exercise_id is not null and load_ceiling_pct is null) or
    (action_type = 'load_ceiling'    and load_ceiling_pct is not null and exercise_id is null)
  )
);

-- ── Workouts ─────────────────────────────────────────────────
create table workouts (
  id                  uuid primary key default gen_random_uuid(),
  user_id             uuid not null references auth.users(id) on delete cascade,
  body_map_session_id uuid references body_map_sessions(id) on delete set null,
  workout_date        date not null default current_date,
  status              text not null default 'planned' check (status in ('planned', 'in_progress', 'completed', 'skipped')),
  created_at          timestamptz not null default now(),
  unique (user_id, workout_date)
);

-- ── Workout Exercises ────────────────────────────────────────
create table workout_exercises (
  id                   uuid primary key default gen_random_uuid(),
  workout_id           uuid not null references workouts(id) on delete cascade,
  exercise_id          uuid not null references exercises(id),
  order_index          smallint not null,
  suggested_sets       smallint not null,
  suggested_reps       smallint not null,
  suggested_weight_kg  numeric(6,2),
  load_ceiling_applied boolean not null default false,
  is_injected          boolean not null default false,
  completed            boolean not null default false,
  unique (workout_id, order_index)
);

-- ── Exercise Sets (logged performance) ───────────────────────
create table exercise_sets (
  id                  uuid primary key default gen_random_uuid(),
  workout_exercise_id uuid not null references workout_exercises(id) on delete cascade,
  set_number          smallint not null,
  actual_reps         smallint,
  actual_weight_kg    numeric(6,2),
  completed_at        timestamptz default now(),
  unique (workout_exercise_id, set_number)
);

-- ── User Streaks ─────────────────────────────────────────────
create table user_streaks (
  user_id              uuid primary key references auth.users(id) on delete cascade,
  current_streak       integer not null default 0,
  longest_streak       integer not null default 0,
  last_activity_date   date,
  rest_shield_tokens   smallint not null default 0,
  updated_at           timestamptz not null default now()
);

-- ── Streak Events (audit log) ────────────────────────────────
create table streak_events (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users(id) on delete cascade,
  event_type text not null check (event_type in ('workout_completed', 'rest_shield_earned', 'rest_shield_used', 'streak_broken')),
  event_date date not null default current_date,
  created_at timestamptz not null default now()
);

-- ============================================================
-- INDEXES
-- ============================================================

create index on body_map_sessions (user_id, session_date desc);
create index on body_map_entries  (session_id);
create index on workouts          (user_id, workout_date desc);
create index on workout_exercises (workout_id, order_index);
create index on exercise_sets     (workout_exercise_id, set_number);
create index on streak_events     (user_id, event_date desc);
create index on friction_rules    (region_key, friction_threshold);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

alter table profiles          enable row level security;
alter table body_map_sessions enable row level security;
alter table body_map_entries  enable row level security;
alter table workouts          enable row level security;
alter table workout_exercises enable row level security;
alter table exercise_sets     enable row level security;
alter table user_streaks      enable row level security;
alter table streak_events     enable row level security;

-- Reference tables are public read-only
alter table body_regions  enable row level security;
alter table exercises     enable row level security;
alter table friction_rules enable row level security;

create policy "public read body_regions"   on body_regions   for select using (true);
create policy "public read exercises"      on exercises       for select using (true);
create policy "public read friction_rules" on friction_rules  for select using (true);

-- User-scoped policies
create policy "own profile"
  on profiles for all using (auth.uid() = id) with check (auth.uid() = id);

create policy "own body_map_sessions"
  on body_map_sessions for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own body_map_entries"
  on body_map_entries for all
  using (session_id in (select id from body_map_sessions where user_id = auth.uid()))
  with check (session_id in (select id from body_map_sessions where user_id = auth.uid()));

create policy "own workouts"
  on workouts for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own workout_exercises"
  on workout_exercises for all
  using (workout_id in (select id from workouts where user_id = auth.uid()))
  with check (workout_id in (select id from workouts where user_id = auth.uid()));

create policy "own exercise_sets"
  on exercise_sets for all
  using (
    workout_exercise_id in (
      select we.id from workout_exercises we
      join workouts w on w.id = we.workout_id
      where w.user_id = auth.uid()
    )
  )
  with check (
    workout_exercise_id in (
      select we.id from workout_exercises we
      join workouts w on w.id = we.workout_id
      where w.user_id = auth.uid()
    )
  );

create policy "own user_streaks"
  on user_streaks for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own streak_events"
  on streak_events for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ============================================================
-- TRIGGERS
-- ============================================================

-- Auto-update profiles.updated_at
create or replace function update_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger trg_profiles_updated_at
  before update on profiles
  for each row execute function update_updated_at();

create trigger trg_user_streaks_updated_at
  before update on user_streaks
  for each row execute function update_updated_at();

-- Auto-create profile and streak row on new user signup
create or replace function handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into profiles (id) values (new.id);
  insert into user_streaks (user_id) values (new.id);
  return new;
end;
$$;

create trigger trg_on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_user();
