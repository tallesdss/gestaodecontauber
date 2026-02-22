# Backend Supabase — Guia de Implementação CRUD

Documento com os passos para implementar o backend do **UberControl** usando Supabase.  
**Nenhuma alteração no Supabase deve ser feita até seguir este guia.**

---

## Informações do Projeto

| Item | Valor |
|------|--------|
| **URL do projeto** | `https://mkyftoqllkvemzyxcnes.supabase.co` |
| **App** | UberControl — controle financeiro para motoristas |
| **Entidades** | Driver (perfil), Earning (ganhos), Expense (gastos) |

---

## Sequência de implementação

Seguir **nesta ordem**. Cada passo usa o conteúdo das seções indicadas.

| Passo | Descrição | Referência |
|-------|-----------|------------|
| **Passo 1** | Pré-requisitos: conta Supabase, anotar URL e anon key, adicionar `supabase_flutter` no Flutter | § 1 |
| **Passo 2** | Configuração no Supabase: criar tabelas `drivers`, `earnings`, `expenses` (SQL do § 2.1) | § 2.1 |
| **Passo 3** | Configuração no Supabase: habilitar RLS e criar políticas por tabela | § 2.2 |
| **Passo 4** | Configuração no Supabase (opcional): triggers para `updated_at` | § 2.3 |
| **Passo 5** | Consultar mapeamento Supabase (snake_case) ↔ Dart (camelCase) para modelos | § 3 |
| **Passo 6** | Flutter: inicializar Supabase no `main.dart` e configurar cliente | § 7.1, § 7.2 |
| **Passo 7** | Flutter: implementar camada de conversão (toSupabaseMap / fromSupabaseMap) | § 7.3 |
| **Passo 8** | Autenticação: habilitar providers no Supabase e implementar registro/login no app | § 8 |
| **Passo 9** | Flutter: implementar CRUD de **Drivers** no serviço e nas telas | § 4, § 7.4 |
| **Passo 10** | Flutter: implementar CRUD de **Earnings** no serviço e nas telas | § 5, § 7.4 |
| **Passo 11** | Flutter: implementar CRUD de **Expenses** no serviço e nas telas | § 6, § 7.4 |
| **Passo 12** | Flutter: tratamento de erros e estados de loading em todas as operações | § 7.5 |
| **Passo 13** | Ajustar modelos Dart (id, userId, datas) se necessário | § 7.6 |
| **Passo 14** | Validar com o checklist final e testes manuais (criar, listar, editar, excluir) | § 9 |

**Ordem resumida:** 1 → 2 → 3 → (4) → 5 → 6 → 7 → 8 → 9 → 10 → 11 → 12 → 13 → 14.

---

## 1. Pré-requisitos

- [ ] Conta no [Supabase](https://supabase.com)
- [ ] Acesso ao projeto: `mkyftoqllkvemzyxcnes`
- [ ] Anotar **Project URL** e **anon key** em: *Project Settings → API*
- [ ] Flutter: adicionar dependência `supabase_flutter` no `pubspec.yaml`

---

## 2. Configuração no Supabase (a fazer depois)

### 2.1 Criar tabelas

Executar no **SQL Editor** do Supabase, na ordem abaixo.

#### Tabela `drivers` (perfil do motorista)

```sql
-- Perfil do motorista (1 por usuário, vinculado ao auth.uid)
create table public.drivers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  monthly_goal numeric(12, 2) not null default 0,
  member_since timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique(user_id)
);

-- Índice para buscar por usuário
create index idx_drivers_user_id on public.drivers(user_id);
```

#### Tabela `earnings` (ganhos)

```sql
create table public.earnings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  value numeric(12, 2) not null,
  platform text,
  number_of_rides int,
  hours_worked numeric(6, 2),
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index idx_earnings_user_id on public.earnings(user_id);
create index idx_earnings_date on public.earnings(date);
create index idx_earnings_user_date on public.earnings(user_id, date);
```

#### Tabela `expenses` (gastos)

```sql
create table public.expenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  category text not null,
  value numeric(12, 2) not null,
  description text not null,
  liters numeric(8, 2),
  receipt_image_path text,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index idx_expenses_user_id on public.expenses(user_id);
create index idx_expenses_date on public.expenses(date);
create index idx_expenses_user_date on public.expenses(user_id, date);
create index idx_expenses_category on public.expenses(user_id, category);
```

### 2.2 Row Level Security (RLS)

Garantir que cada usuário só acesse seus próprios dados.

```sql
-- Habilitar RLS em todas as tabelas
alter table public.drivers enable row level security;
alter table public.earnings enable row level security;
alter table public.expenses enable row level security;

-- Drivers: usuário só vê/edita o próprio registro
create policy "drivers_select_own" on public.drivers
  for select using (auth.uid() = user_id);
create policy "drivers_insert_own" on public.drivers
  for insert with check (auth.uid() = user_id);
create policy "drivers_update_own" on public.drivers
  for update using (auth.uid() = user_id);
create policy "drivers_delete_own" on public.drivers
  for delete using (auth.uid() = user_id);

-- Earnings: mesmo padrão
create policy "earnings_select_own" on public.earnings
  for select using (auth.uid() = user_id);
create policy "earnings_insert_own" on public.earnings
  for insert with check (auth.uid() = user_id);
create policy "earnings_update_own" on public.earnings
  for update using (auth.uid() = user_id);
create policy "earnings_delete_own" on public.earnings
  for delete using (auth.uid() = user_id);

-- Expenses: mesmo padrão
create policy "expenses_select_own" on public.expenses
  for select using (auth.uid() = user_id);
create policy "expenses_insert_own" on public.expenses
  for insert with check (auth.uid() = user_id);
create policy "expenses_update_own" on public.expenses
  for update using (auth.uid() = user_id);
create policy "expenses_delete_own" on public.expenses
  for delete using (auth.uid() = user_id);
```

### 2.3 Trigger para `updated_at` (opcional)

```sql
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger drivers_updated_at
  before update on public.drivers
  for each row execute function public.set_updated_at();
create trigger earnings_updated_at
  before update on public.earnings
  for each row execute function public.set_updated_at();
create trigger expenses_updated_at
  before update on public.expenses
  for each row execute function public.set_updated_at();
```

---

## 3. Mapeamento: Supabase (snake_case) ↔ Dart (camelCase)

| Tabela   | Coluna Supabase   | Campo Dart (modelo) |
|----------|-------------------|----------------------|
| drivers  | id                | (novo no model)      |
| drivers  | user_id           | (uso interno)        |
| drivers  | name              | name                 |
| drivers  | monthly_goal      | monthlyGoal          |
| drivers  | member_since      | memberSince          |
| earnings | id                | id                   |
| earnings | date              | date                 |
| earnings | value             | value                |
| earnings | platform          | platform             |
| earnings | number_of_rides   | numberOfRides        |
| earnings | hours_worked      | hoursWorked          |
| earnings | notes             | notes                |
| expenses | id                | id                   |
| expenses | date              | date                 |
| expenses | category          | category             |
| expenses | value             | value                |
| expenses | description       | description          |
| expenses | liters            | liters               |
| expenses | receipt_image_path| receiptImagePath     |
| expenses | notes             | notes                |

---

## 4. CRUD — Drivers

### 4.1 Create (criar perfil)

- **Quando:** após registro/login do usuário, se ainda não existir driver.
- **Supabase:** `insert` em `drivers` com `user_id = auth.uid()`.
- **Flutter:** converter `Driver.toMap()` para snake_case e incluir `user_id` no insert.

```dart
// Exemplo de payload (após toMap + conversão para snake_case)
// { "user_id": "<uid>", "name": "...", "monthly_goal": 0, "member_since": "..." }
```

### 4.2 Read (obter perfil)

- **Quando:** ao abrir perfil ou home.
- **Supabase:** `select().eq('user_id', uid).maybeSingle()`.
- **Flutter:** `Driver.fromMap()` com conversão de snake_case → camelCase.

### 4.3 Update (atualizar perfil)

- **Quando:** usuário edita nome, meta mensal ou data de cadastro.
- **Supabase:** `update({...}).eq('user_id', uid)`.
- **Flutter:** montar map em snake_case a partir do `Driver`.

### 4.4 Delete

- **Quando:** normalmente não se deleta perfil; se necessário, `delete().eq('user_id', uid)`.

---

## 5. CRUD — Earnings (ganhos)

### 5.1 Create

- **Quando:** usuário salva um novo ganho.
- **Supabase:** `insert` em `earnings` com `user_id = auth.uid()` e campos em snake_case.
- **Flutter:** `Earning.toMap()` → converter keys para snake_case; gerar `id` no client (uuid) ou deixar default no DB.

### 5.2 Read

- **Listar todos (do usuário):** `select().eq('user_id', uid).order('date', ascending: false)`.
- **Por período:** adicionar `.gte('date', start).lte('date', end)`.
- **Um por id:** `select().eq('id', id).maybeSingle()`.
- **Flutter:** cada row → `Earning.fromMap()` com conversão snake_case → camelCase (e `id` como String).

### 5.3 Update

- **Quando:** usuário edita um ganho existente.
- **Supabase:** `update({...}).eq('id', id).eq('user_id', uid)`.
- **Flutter:** map em snake_case a partir do `Earning` (sem enviar `id` no body de update, só na condição).

### 5.4 Delete

- **Quando:** usuário remove um ganho.
- **Supabase:** `delete().eq('id', id).eq('user_id', uid)`.

---

## 6. CRUD — Expenses (gastos)

### 6.1 Create

- **Quando:** usuário salva um novo gasto.
- **Supabase:** `insert` em `expenses` com `user_id = auth.uid()` e campos em snake_case.
- **Flutter:** `Expense.toMap()` → snake_case; definir `id` no client ou no DB.

### 6.2 Read

- **Listar todos:** `select().eq('user_id', uid).order('date', ascending: false)`.
- **Por período:** `.gte('date', start).lte('date', end)`.
- **Por categoria:** `.eq('category', category)` (com `user_id`).
- **Um por id:** `select().eq('id', id).maybeSingle()`.
- **Flutter:** cada row → `Expense.fromMap()` com conversão snake_case → camelCase.

### 6.3 Update

- **Quando:** usuário edita um gasto.
- **Supabase:** `update({...}).eq('id', id).eq('user_id', uid)`.
- **Flutter:** map em snake_case a partir do `Expense`.

### 6.4 Delete

- **Quando:** usuário remove um gasto.
- **Supabase:** `delete().eq('id', id).eq('user_id', uid)`.

---

## 7. Implementação no Flutter (passos)

### 7.1 Dependência e inicialização

1. Adicionar no `pubspec.yaml`:
   ```yaml
   dependencies:
     supabase_flutter: ^2.0.0  # ou versão atual
   ```
2. No `main.dart`, antes de `runApp`:
   - `await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);`
3. Guardar URL e anon key em variáveis de ambiente ou constants (nunca commitar keys sensíveis em produção; usar env).

### 7.2 Cliente Supabase

- Usar `Supabase.instance.client` para acessar:
  - `client.from('drivers')`
  - `client.from('earnings')`
  - `client.from('expenses')`
- Para operações autenticadas, garantir que o usuário está logado (`client.auth.currentUser`).

### 7.3 Camada de conversão (snake_case ↔ camelCase)

- Criar um `SupabaseMappers` (ou similar) com:
  - `toSupabaseMap(Map<String, dynamic> map)` → converte keys camelCase → snake_case.
  - `fromSupabaseMap(Map<String, dynamic> map)` → converte keys snake_case → camelCase (e trata tipos: date, numeric).
- Usar em todos os pontos que leem/escrevem no Supabase para manter modelos Dart inalterados (Earning, Expense, Driver).

### 7.4 Serviços (substituir placeholders)

- **DatabaseService** (ou renomear para `SupabaseService`):
  - Injetar/cliente Supabase e auth.
  - Métodos por entidade, por exemplo:
    - Drivers: `createDriver`, `getDriver`, `updateDriver`, `deleteDriver`.
    - Earnings: `createEarning`, `getEarnings`, `getEarningById`, `updateEarning`, `deleteEarning` (com filtros opcionais de data).
    - Expenses: `createExpense`, `getExpenses`, `getExpenseById`, `updateExpense`, `deleteExpense`.
  - Sempre passar `user_id` (ou usar RLS e não enviar user_id no body, apenas garantir que o usuário está logado; o RLS usa `auth.uid()`).
- Se o app ainda não usar Auth do Supabase:
  - Ou implementar login/registro (email/senha ou OAuth) e então usar `user_id` em todas as tabelas.
  - Ou, temporariamente, usar uma única “conta” (um user_id fixo) só para desenvolvimento; em produção, obrigatório usar auth.

### 7.5 Tratamento de erros e loading

- Todas as chamadas ao Supabase em try/catch.
- Mapear erros do Supabase (ex.: PostgrestException) para mensagens amigáveis.
- Usar loading states nas telas (lista, formulários) enquanto chama os serviços.

### 7.6 Atualização dos modelos Dart (se necessário)

- **Driver:** considerar adicionar `id` (String/UUID) e `userId` se quiser armazenar no model.
- **Earning / Expense:** já possuem `id` e `date`; garantir que `date` seja enviado como ISO (date ou timestamptz) e convertido corretamente no `fromMap` (incluindo timezone se usar timestamptz).

---

## 8. Autenticação (resumo)

- Sem auth, não há `auth.uid()` e o RLS bloqueará todas as linhas.
- Passos recomendados:
  1. Habilitar **Email** (e opcionalmente **OAuth**) em Authentication → Providers.
  2. No app: registro com `signUp`, login com `signInWithPassword`, logout com `signOut`.
  3. Após login, criar/atualizar registro em `drivers` (Create do Driver) se ainda não existir.
  4. Todas as operações de CRUD devem ser feitas com o usuário logado.

---

## 9. Checklist final de implementação

- [ ] Criar tabelas no Supabase (drivers, earnings, expenses).
- [ ] Aplicar RLS e políticas.
- [ ] (Opcional) Triggers `updated_at`.
- [ ] Adicionar `supabase_flutter` e inicializar no app.
- [ ] Implementar mapeamento snake_case ↔ camelCase.
- [ ] Implementar Auth (registro/login) se for multi-usuário.
- [ ] Implementar CRUD de Drivers no serviço e nas telas.
- [ ] Implementar CRUD de Earnings no serviço e nas telas.
- [ ] Implementar CRUD de Expenses no serviço e nas telas.
- [ ] Tratamento de erros e loading em todas as operações.
- [ ] Testes manuais: criar, listar, editar e excluir em cada entidade.

---

## 10. URL de referência

- **Projeto Supabase:** https://mkyftoqllkvemzyxcnes.supabase.co  
- **Documentação Supabase Flutter:** https://supabase.com/docs/reference/dart  
- **RLS:** https://supabase.com/docs/guides/auth/row-level-security  

Quando for implementar, seguir a **Sequência de implementação** (Passo 1 a Passo 14) no início deste documento.
