-- Passo 4 — Triggers para updated_at e CHECK constraints
-- Backend.md § 2.3 e § 2.4

-- 2.3 — Função e triggers para updated_at
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger drivers_updated_at
  before update on public.drivers for each row execute function public.set_updated_at();
create trigger earnings_updated_at
  before update on public.earnings for each row execute function public.set_updated_at();
create trigger expenses_updated_at
  before update on public.expenses for each row execute function public.set_updated_at();

-- 2.4 — CHECK constraints
alter table public.earnings add constraint earnings_value_non_negative check (value >= 0);
alter table public.earnings add constraint earnings_rides_non_negative check (number_of_rides is null or number_of_rides >= 0);
alter table public.earnings add constraint earnings_hours_non_negative check (hours_worked is null or hours_worked >= 0);

alter table public.expenses add constraint expenses_value_non_negative check (value >= 0);
alter table public.expenses add constraint expenses_liters_non_negative check (liters is null or liters >= 0);

alter table public.drivers add constraint drivers_goal_non_negative check (monthly_goal >= 0);
