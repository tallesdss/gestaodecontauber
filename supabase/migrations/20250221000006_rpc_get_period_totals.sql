-- Passo 6 — RPC get_period_totals e permissões
-- Backend.md § 6.5

-- Função: totais de ganhos, gastos e lucro líquido por período (por usuário autenticado)
create or replace function public.get_period_totals(p_start date, p_end date)
returns table (total_earnings numeric, total_expenses numeric, net_profit numeric)
language sql
security definer
set search_path = public
as $$
  with
    te as (select coalesce(sum(value), 0) as v from public.earnings
           where user_id = auth.uid() and date >= p_start and date <= p_end),
    tx as (select coalesce(sum(value), 0) as v from public.expenses
           where user_id = auth.uid() and date >= p_start and date <= p_end)
  select te.v, tx.v, te.v - tx.v from te, tx;
$$;

-- Segurança: revogar de public e conceder apenas a authenticated
revoke execute on function public.get_period_totals(date, date) from public;
grant execute on function public.get_period_totals(date, date) to authenticated;
