-- Migration 7 — RPCs para a Tela de Histórico Financeiro (Fase 7 Etapa B)
-- Cria as 4 funções necessárias para o histórico: anos disponíveis,
-- resumo por período, breakdown mensal e breakdown semanal.

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. get_available_years
--    Retorna os anos distintos em que o motorista tem registros (ganhos ou gastos).
-- ─────────────────────────────────────────────────────────────────────────────
create or replace function public.get_available_years()
returns table (year int)
language sql
security definer
set search_path = public
as $$
  select distinct extract(year from date)::int as year
  from public.earnings
  where user_id = auth.uid()
  union
  select distinct extract(year from date)::int as year
  from public.expenses
  where user_id = auth.uid()
  order by year desc;
$$;

revoke execute on function public.get_available_years() from public;
grant  execute on function public.get_available_years() to authenticated;

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. get_history_summary
--    Retorna total de ganhos e gastos para o período informado.
--    Se p_month for NULL, consolida o ano inteiro.
-- ─────────────────────────────────────────────────────────────────────────────
create or replace function public.get_history_summary(
  p_year  int,
  p_month int default null
)
returns table (total_earnings numeric, total_expenses numeric)
language sql
security definer
set search_path = public
as $$
  with
    te as (
      select coalesce(sum(value), 0) as v
      from   public.earnings
      where  user_id = auth.uid()
        and  extract(year  from date)::int = p_year
        and  (p_month is null or extract(month from date)::int = p_month)
    ),
    tx as (
      select coalesce(sum(value), 0) as v
      from   public.expenses
      where  user_id = auth.uid()
        and  extract(year  from date)::int = p_year
        and  (p_month is null or extract(month from date)::int = p_month)
    )
  select te.v, tx.v from te, tx;
$$;

revoke execute on function public.get_history_summary(int, int) from public;
grant  execute on function public.get_history_summary(int, int) to authenticated;

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. get_monthly_breakdown
--    Retorna um resumo (ganhos, gastos, lucro) para cada mês de um dado ano.
-- ─────────────────────────────────────────────────────────────────────────────
create or replace function public.get_monthly_breakdown(p_year int)
returns table (month int, earnings numeric, expenses numeric, profit numeric)
language sql
security definer
set search_path = public
as $$
  with
    months  as (select generate_series(1, 12) as m),
    earn_by as (
      select extract(month from date)::int as m,
             coalesce(sum(value), 0)        as v
      from   public.earnings
      where  user_id = auth.uid()
        and  extract(year from date)::int = p_year
      group  by 1
    ),
    exp_by  as (
      select extract(month from date)::int as m,
             coalesce(sum(value), 0)        as v
      from   public.expenses
      where  user_id = auth.uid()
        and  extract(year from date)::int = p_year
      group  by 1
    )
  select
    months.m                                     as month,
    coalesce(earn_by.v, 0)                       as earnings,
    coalesce(exp_by.v,  0)                       as expenses,
    coalesce(earn_by.v, 0) - coalesce(exp_by.v, 0) as profit
  from      months
  left join earn_by on earn_by.m = months.m
  left join exp_by  on exp_by.m  = months.m
  order by  months.m;
$$;

revoke execute on function public.get_monthly_breakdown(int) from public;
grant  execute on function public.get_monthly_breakdown(int) to authenticated;

-- ─────────────────────────────────────────────────────────────────────────────
-- 4. get_weekly_breakdown
--    Retorna um resumo (ganhos, gastos, lucro) por semana de um dado mês/ano.
--    Semana calculada com base no dia do mês: S1=1-7, S2=8-14, S3=15-21, S4=22+.
-- ─────────────────────────────────────────────────────────────────────────────
create or replace function public.get_weekly_breakdown(p_year int, p_month int)
returns table (week int, earnings numeric, expenses numeric, profit numeric)
language sql
security definer
set search_path = public
as $$
  with
    earn_wk as (
      select
        least(ceil(extract(day from date) / 7.0)::int, 4) as wk,
        coalesce(sum(value), 0) as v
      from   public.earnings
      where  user_id = auth.uid()
        and  extract(year  from date)::int = p_year
        and  extract(month from date)::int = p_month
      group  by 1
    ),
    exp_wk  as (
      select
        least(ceil(extract(day from date) / 7.0)::int, 4) as wk,
        coalesce(sum(value), 0) as v
      from   public.expenses
      where  user_id = auth.uid()
        and  extract(year  from date)::int = p_year
        and  extract(month from date)::int = p_month
      group  by 1
    ),
    weeks   as (select generate_series(1, 4) as wk)
  select
    weeks.wk                                          as week,
    coalesce(earn_wk.v, 0)                            as earnings,
    coalesce(exp_wk.v,  0)                            as expenses,
    coalesce(earn_wk.v, 0) - coalesce(exp_wk.v, 0)   as profit
  from      weeks
  left join earn_wk on earn_wk.wk = weeks.wk
  left join exp_wk  on exp_wk.wk  = weeks.wk
  order by  weeks.wk;
$$;

revoke execute on function public.get_weekly_breakdown(int, int) from public;
grant  execute on function public.get_weekly_breakdown(int, int) to authenticated;
