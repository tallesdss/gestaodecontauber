# UberControl — Guia de Implementação Backend Supabase
**Versão 2.0 · Implementação via IA**

---

## Sobre o App

O UberControl é um aplicativo Flutter de controle financeiro voltado a motoristas de aplicativo (Uber, 99, inDrive etc.). Ele permite registrar ganhos por corrida, controlar despesas operacionais e acompanhar o lucro líquido ao longo do tempo, com metas mensais personalizadas.

As três entidades centrais do sistema são:

- **Driver** — perfil único do motorista, com nome, meta mensal e data de início.
- **Earning** — registro de ganhos: data, valor, plataforma, número de corridas, horas trabalhadas e observações.
- **Expense** — registro de despesas: data, categoria, valor, descrição, litros de combustível, comprovante de recibo e observações.

---

## Informações do Projeto

| Item | Valor |
|------|-------|
| URL do projeto Supabase | `https://mkyftoqllkvemzyxcnes.supabase.co` |
| Aplicativo | UberControl — controle financeiro para motoristas |
| Entidades principais | Driver (perfil), Earning (ganhos), Expense (gastos) |
| Framework | Flutter (Dart) |
| Backend | Supabase (PostgreSQL + Auth + Storage + RPC) |

---

## Regra — Dados do Frontend

O frontend do UberControl possui dados mockup (listas estáticas, valores hardcoded, exemplos fictícios). Durante a integração com o Supabase, estas são as regras a seguir:

- Todos os dados falsos devem ser substituídos por dados vindos do Supabase — drivers, earnings, expenses, totais e resumos.
- Nenhuma tela ou fluxo pode depender de dados locais fictícios após a integração.
- Nenhuma alteração no Supabase deve ser feita antes de seguir este guia na ordem documentada.

---

## Sequência de Implementação

Seguir obrigatoriamente nesta ordem. Cada passo depende do anterior para funcionar corretamente.

> ⚠️ **A autenticação (Passo 11) é obrigatória antes de qualquer CRUD.** Sem `auth.uid()` o RLS bloqueia todas as linhas. Em produção, não existe modo sem autenticação.

| Passo | Descrição | Seção | Status |
|-------|-----------|-------|--------|
| 1 | Pré-requisitos: conta Supabase, URL e anon key, variáveis de ambiente, adicionar `supabase_flutter` | § 1 | [x] |
| 2 | Supabase: criar tabelas `drivers`, `earnings`, `expenses` via SQL Editor | § 2.1 | [x] |
| 3 | Supabase: habilitar RLS e criar políticas por tabela | § 2.2 | [x] |
| 4 | Supabase: criar triggers para `updated_at` e CHECK constraints (opcionais, mas recomendados) | § 2.3, § 2.4 | |
| 5 | Supabase: criar bucket no Storage para comprovantes e configurar políticas | § 2.5 | |
| 6 | Supabase (opcional): criar RPC `get_period_totals`; revogar `execute` de `public` e conceder apenas a `authenticated` | § 6.5 | |
| 7 | Consultar mapeamento snake_case ↔ camelCase para os modelos Dart | § 3 | |
| 8 | Flutter: inicializar Supabase no `main.dart` e configurar o cliente | § 7.1, § 7.2 | |
| 9 | Flutter: ajustar modelos Dart (`id`, `userId`, datas, `createdAt`/`updatedAt`) | § 7.6 | |
| 10 | Flutter: implementar camada de conversão (`toSupabaseMap` / `fromSupabaseMap`) | § 7.3 | |
| 11 | Autenticação: habilitar providers no Supabase; implementar registro, login e logout no app | § 8 | |
| 12 | Flutter: CRUD de Drivers no serviço e nas telas (upsert para perfil único por usuário) | § 4, § 7.4 | |
| 13 | Flutter: CRUD de Earnings no serviço e nas telas (com paginação e filtro por período) | § 5, § 7.4 | |
| 14 | Flutter: CRUD de Expenses no serviço e nas telas (com paginação, filtro por período e categoria) | § 6, § 7.4 | |
| 15 | Flutter: integrar upload/download de comprovantes via Supabase Storage | § 6.6 | |
| 16 | Flutter: funções de cálculo — total ganhos, total gastos, lucro líquido por período | § 6.5 | |
| 17 | Flutter: tratamento de erros (mapear códigos Postgrest) e estados de loading em todas as operações | § 7.5 | |
| 18 | Validar com o checklist final e executar testes | § 9 | |

---

## 1. Pré-requisitos

- [x] Conta ativa no Supabase (supabase.com).
- [x] Acesso ao projeto `mkyftoqllkvemzyxcnes`.
- [x] Anotar **Project URL** e **anon key** em: *Project Settings → API*.
- [x] Flutter: adicionar dependência `supabase_flutter` no `pubspec.yaml`.
- [x] Configurar variáveis de ambiente para URL e anon key (não commitar em produção).

**Opções para variáveis de ambiente:**

- **`--dart-define`:** passar `SUPABASE_URL` e `SUPABASE_ANON_KEY` na build e ler com `String.fromEnvironment`.
- **`flutter_dotenv`:** arquivo `.env` no projeto (adicionado ao `.gitignore`) carregado com `dotenv.env['SUPABASE_ANON_KEY']`.
- **Flavors:** configurações por ambiente (dev/staging/prod) com suas próprias keys.

---

## 2. Configuração no Supabase

### 2.1 Criar Tabelas

- [x] **Concluído** (tabelas `drivers`, `earnings`, `expenses` criadas via migração).

Executar no **SQL Editor** do Supabase, na ordem abaixo.

#### Tabela `drivers` (perfil do motorista)
```sql
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

> ℹ️ O campo `category` é texto livre por padrão. Caso queira filtros e relatórios consistentes, considere criar uma tabela de categorias com FK — mas defina isso antes de ir para produção, pois alterar depois exige migração mais trabalhosa.
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

---

### 2.2 Row Level Security (RLS)

- [x] **Concluído** (RLS habilitado e políticas por tabela aplicadas).

Garante que cada usuário acesse apenas seus próprios dados.
```sql
-- Habilitar RLS em todas as tabelas
alter table public.drivers enable row level security;
alter table public.earnings enable row level security;
alter table public.expenses enable row level security;

-- Políticas: drivers
create policy "drivers_select_own" on public.drivers for select using (auth.uid() = user_id);
create policy "drivers_insert_own" on public.drivers for insert with check (auth.uid() = user_id);
create policy "drivers_update_own" on public.drivers for update using (auth.uid() = user_id);
create policy "drivers_delete_own" on public.drivers for delete using (auth.uid() = user_id);

-- Políticas: earnings
create policy "earnings_select_own" on public.earnings for select using (auth.uid() = user_id);
create policy "earnings_insert_own" on public.earnings for insert with check (auth.uid() = user_id);
create policy "earnings_update_own" on public.earnings for update using (auth.uid() = user_id);
create policy "earnings_delete_own" on public.earnings for delete using (auth.uid() = user_id);

-- Políticas: expenses
create policy "expenses_select_own" on public.expenses for select using (auth.uid() = user_id);
create policy "expenses_insert_own" on public.expenses for insert with check (auth.uid() = user_id);
create policy "expenses_update_own" on public.expenses for update using (auth.uid() = user_id);
create policy "expenses_delete_own" on public.expenses for delete using (auth.uid() = user_id);
```

---

### 2.3 Trigger para `updated_at`

> ℹ️ Recomendado. Garante que o campo `updated_at` seja atualizado automaticamente pelo banco, sem depender do Flutter.
```sql
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
```

---

### 2.4 CHECK Constraints (opcional, recomendado para produção)

Protege o banco de valores inválidos mesmo que o app envie dados incorretos.
```sql
alter table public.earnings add constraint earnings_value_non_negative check (value >= 0);
alter table public.earnings add constraint earnings_rides_non_negative check (number_of_rides is null or number_of_rides >= 0);
alter table public.earnings add constraint earnings_hours_non_negative check (hours_worked is null or hours_worked >= 0);

alter table public.expenses add constraint expenses_value_non_negative check (value >= 0);
alter table public.expenses add constraint expenses_liters_non_negative check (liters is null or liters >= 0);

alter table public.drivers add constraint drivers_goal_non_negative check (monthly_goal >= 0);
```

---

### 2.5 Supabase Storage — Comprovantes de Despesas

> ⚠️ Esta seção é necessária para o campo `receipt_image_path` funcionar corretamente.

O campo `receipt_image_path` em `expenses` armazena o caminho do arquivo no bucket. O upload e download real são feitos via Supabase Storage.

**Criar o bucket:**
1. No Supabase, acesse **Storage → New Bucket**.
2. Nome: `receipts`. Marcar como **Private** (acesso somente via políticas).

**Políticas de Storage:**
```sql
-- Usuário pode fazer upload na própria pasta
create policy "receipts_upload_own"
  on storage.objects for insert
  with check (bucket_id = 'receipts' and auth.uid()::text = (storage.foldername(name))[1]);

-- Usuário pode visualizar os próprios arquivos
create policy "receipts_select_own"
  on storage.objects for select
  using (bucket_id = 'receipts' and auth.uid()::text = (storage.foldername(name))[1]);

-- Usuário pode deletar os próprios arquivos
create policy "receipts_delete_own"
  on storage.objects for delete
  using (bucket_id = 'receipts' and auth.uid()::text = (storage.foldername(name))[1]);
```

**Convenção de caminho dos arquivos:** `{user_id}/expenses/{expense_id}.jpg`

> ℹ️ Usar o ID da despesa como nome do arquivo garante unicidade e facilita a substituição ao editar.

---

### 2.6 Migrações Versionadas (recomendado)

Em vez de executar SQL solto no Editor, usar migrações versionadas do Supabase CLI (arquivos em `supabase/migrations/`) para histórico, rollback e aplicação consistente em outros ambientes. Ver [documentação Supabase CLI](https://supabase.com/docs/guides/cli/local-development).

---

## 3. Mapeamento: Supabase ↔ Dart

Todas as colunas do banco seguem `snake_case`. Os campos nos modelos Dart seguem `camelCase`. A conversão deve ser centralizada na camada de serviço.

> ℹ️ Para `date` (earnings e expenses): usar apenas a data do dia, sem hora (`YYYY-MM-DD`). Para `created_at` e `updated_at`: usar `timestamptz`; decidir na UI se a exibição será em UTC ou timezone local.

#### Tabela `drivers`

| Coluna Supabase | Campo Dart |
|-----------------|------------|
| `id` | `id` (novo no model) |
| `user_id` | `userId` (uso interno) |
| `name` | `name` |
| `monthly_goal` | `monthlyGoal` |
| `member_since` | `memberSince` |
| `created_at` | `createdAt` |
| `updated_at` | `updatedAt` |

#### Tabela `earnings`

| Coluna Supabase | Campo Dart |
|-----------------|------------|
| `id` | `id` |
| `date` | `date` (somente data — `YYYY-MM-DD`) |
| `value` | `value` |
| `platform` | `platform` |
| `number_of_rides` | `numberOfRides` |
| `hours_worked` | `hoursWorked` |
| `notes` | `notes` |
| `created_at` | `createdAt` |
| `updated_at` | `updatedAt` |

#### Tabela `expenses`

| Coluna Supabase | Campo Dart |
|-----------------|------------|
| `id` | `id` |
| `date` | `date` (somente data — `YYYY-MM-DD`) |
| `category` | `category` |
| `value` | `value` |
| `description` | `description` |
| `liters` | `liters` |
| `receipt_image_path` | `receiptImagePath` |
| `notes` | `notes` |
| `created_at` | `createdAt` |
| `updated_at` | `updatedAt` |

---

## 4. CRUD — Drivers

### 4.1 Create (criar perfil)

- **Quando:** logo após o primeiro login, se o perfil ainda não existir.
- Usar **upsert** com `onConflict` em `user_id` para evitar duplicatas em race conditions ou reabertura do app.
```dart
// Payload de insert (após conversão para snake_case)
// { "user_id": "<uid>", "name": "...", "monthly_goal": 0, "member_since": "..." }
```

> ℹ️ **Alternativa:** criar o registro `drivers` automaticamente via trigger no banco (`on insert on auth.users`) em vez de depender do Flutter. Isso garante consistência mesmo em múltiplos pontos de entrada.

### 4.2 Read (obter perfil)

- **Quando:** ao abrir a home ou a tela de perfil.
- Supabase: `select().eq('user_id', uid).maybeSingle()`.
- Flutter: `Driver.fromMap()` com conversão `snake_case → camelCase`.

### 4.3 Update (atualizar perfil)

- **Quando:** usuário edita nome, meta mensal ou data de cadastro.
- Supabase: `update({...}).eq('user_id', uid)`.

### 4.4 Delete

- Normalmente não se deleta o perfil. Se necessário: `delete().eq('user_id', uid)`.
- A cláusula `on delete cascade` nas tabelas `earnings` e `expenses` garante limpeza automática dos dados ao deletar o driver.

---

## 5. CRUD — Earnings (Ganhos)

### 5.1 Create

- Supabase: `insert` em `earnings` com `user_id = auth.uid()` e campos em `snake_case`.
- Gerar `id` no banco (`default gen_random_uuid()`) ou no client (pacote `uuid` no Flutter).

### 5.2 Read

- **Listar todos:** `select().eq('user_id', uid).order('date', ascending: false)`.
- **Por período:** adicionar `.gte('date', start).lte('date', end)`.
- **Paginação:** usar `.range(from, to)` — ex.: 0–49, 50–99. Carregar mais na UI para não trazer todos os registros de uma vez.
- **Um por id:** `select().eq('id', id).maybeSingle()`.

> ⚠️ Definir e padronizar o modo de paginação (cursor-based vs offset) para Earnings e Expenses desde o início, para garantir consistência entre as duas listagens.

### 5.3 Update

- Supabase: `update({...}).eq('id', id).eq('user_id', uid)`.
- Não enviar `id` no corpo do update, apenas na condição.

### 5.4 Delete

- Supabase: `delete().eq('id', id).eq('user_id', uid)`.

---

## 6. CRUD — Expenses (Gastos)

### 6.1 Create

- Supabase: `insert` em `expenses` com `user_id = auth.uid()` e campos em `snake_case`.
- Se houver comprovante, fazer **upload no Storage antes do insert** e salvar o path retornado em `receipt_image_path`.

### 6.2 Read

- **Listar todos:** `select().eq('user_id', uid).order('date', ascending: false)`.
- **Por período:** `.gte('date', start).lte('date', end)`.
- **Por categoria:** `.eq('category', category)` combinado com `.eq('user_id', uid)`.
- **Paginação:** `.range(from, to)` com o mesmo padrão adotado em Earnings.
- **Um por id:** `select().eq('id', id).maybeSingle()`.

### 6.3 Update

- Supabase: `update({...}).eq('id', id).eq('user_id', uid)`.
- Se o comprovante foi trocado: fazer upload do novo arquivo, atualizar `receipt_image_path` e deletar o arquivo antigo do bucket.

### 6.4 Delete

- Supabase: `delete().eq('id', id).eq('user_id', uid)`.
- Se a expense possuir comprovante (`receipt_image_path` não nulo), deletar o arquivo do Storage antes de remover o registro.

---

### 6.5 Funções e Cálculos — Totais e Lucro Líquido

O app precisa de totais por período para dashboard, metas e resumos financeiros.

| Cálculo | Descrição |
|---------|-----------|
| Total de ganhos | Soma de `earnings.value` no período filtrado |
| Total de gastos | Soma de `expenses.value` no período filtrado |
| Lucro líquido | Total de ganhos − total de gastos |

**Métodos no serviço Flutter:**

- `getTotalEarnings(userId, start, end)` — busca earnings do período e soma `value`.
- `getTotalExpenses(userId, start, end)` — busca expenses do período e soma `value`.
- `getNetProfit(userId, start, end)` — chama os dois acima em paralelo com `Future.wait` e subtrai.

**RPC no Supabase (preferencial para produção):**

Evita trazer todas as linhas para o Flutter e faz a soma diretamente no banco.

> ⚠️ Após criar a função, revogar o acesso de `public` e conceder apenas para `authenticated`.
```sql
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
```

No Flutter: `client.rpc('get_period_totals', params: {'p_start': '2025-01-01', 'p_end': '2025-01-31'})` e ler `total_earnings`, `total_expenses`, `net_profit`.

---

### 6.6 Storage — Upload e Download de Comprovantes

**Upload (ao criar ou editar uma expense):**
```dart
// 1. Definir o caminho
final path = '$userId/expenses/$expenseId.jpg';

// 2. Fazer upload
await supabase.storage.from('receipts').uploadBinary(
  path,
  bytes,
  fileOptions: FileOptions(contentType: 'image/jpeg', upsert: true),
);

// 3. Salvar o path no registro
expense.receiptImagePath = path;
```

**Download / exibição:**
```dart
// Gerar URL temporária (válida por 60 segundos)
final signedUrl = await supabase.storage
    .from('receipts')
    .createSignedUrl(receiptImagePath, 60);

// Exibir com Image.network(signedUrl)
```

**Deletar ao excluir a expense:**
```dart
if (expense.receiptImagePath != null) {
  await supabase.storage.from('receipts').remove([expense.receiptImagePath!]);
}
```

---

## 7. Implementação no Flutter

### 7.1 Dependência e Inicialização

- Adicionar no `pubspec.yaml`: `supabase_flutter: ^2.0.0` (ou versão mais recente).
- No `main.dart`, antes de `runApp`: `await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);`
- Guardar URL e anon key via variáveis de ambiente (ver § 1). Nunca commitar keys em produção.

### 7.2 Cliente Supabase

- Usar `Supabase.instance.client` para todas as operações.
- Garantir que o usuário está logado antes de qualquer operação com `client.auth.currentUser`.

### 7.3 Camada de Conversão (snake_case ↔ camelCase)

- Criar um `SupabaseMappers` centralizado com `toSupabaseMap` e `fromSupabaseMap`.
- Tratar tipos corretamente: `date` como string `YYYY-MM-DD`, `numeric` como `double`, `timestamptz` como `DateTime`.
- Usar essa camada em todos os pontos de leitura e escrita para manter os modelos Dart inalterados.

### 7.4 Serviços (SupabaseService)

Criar um `SupabaseService` com métodos por entidade:

- **Drivers:** `createDriver`, `getDriver`, `updateDriver`, `deleteDriver`.
- **Earnings:** `createEarning`, `getEarnings`, `getEarningById`, `updateEarning`, `deleteEarning`.
- **Expenses:** `createExpense`, `getExpenses`, `getExpenseById`, `updateExpense`, `deleteExpense`.
- **Storage:** `uploadReceipt`, `getReceiptUrl`, `deleteReceipt`.
- **Totais:** `getTotalEarnings`, `getTotalExpenses`, `getNetProfit` (ou `getPeriodTotals` via RPC).

> ℹ️ As operações de CRUD devem sempre incluir `.eq('user_id', uid)` como condição de segurança extra, mesmo com RLS ativo.

### 7.5 Tratamento de Erros e Loading

- Todas as chamadas ao Supabase dentro de `try/catch`.
- Mapear `PostgrestException` para mensagens amigáveis:
  - `23505` (unique_violation): "Já existe um perfil para este usuário."
  - `23503` (foreign_key_violation): "Registro em uso ou referência inválida."
  - Outros: mensagem genérica; em debug, logar `exception.message` e o código.
- Usar loading states nas telas (listas, formulários) enquanto as operações estão em andamento.
- Exibir feedback visual ao usuário em caso de erro (SnackBar, Dialog ou inline).

### 7.6 Atualização dos Modelos Dart

- **Driver:** adicionar `id` (String/UUID) e `userId`; opcionalmente `createdAt` e `updatedAt`.
- **Earning:** garantir que `date` seja enviado como ISO (`YYYY-MM-DD`) e convertido corretamente no `fromMap`. Incluir `createdAt` e `updatedAt` se for exibir datas de criação/edição.
- **Expense:** mesmo tratamento de Earning; incluir `receiptImagePath` como `String?` (nullable).

---

## 8. Autenticação

> ⚠️ Sem autenticação não há `auth.uid()` e o RLS bloqueará todas as linhas. Em produção, a autenticação é obrigatória antes de qualquer CRUD.

- Habilitar **Email** (e opcionalmente OAuth/Google) em **Authentication → Providers** no Supabase.
- No app: registro com `signUp`, login com `signInWithPassword`, logout com `signOut`.
- Após login bem-sucedido: verificar se já existe um registro em `drivers` para o uid. Se não existir, criar com upsert (ver § 4.1).
- Proteger todas as rotas e operações com verificação de sessão ativa.
- Implementar refresh de token e tratamento de sessão expirada.

---

## 9. Checklist Final de Implementação

### Supabase (banco e infraestrutura)

- [x] Criar tabelas `drivers`, `earnings`, `expenses` via SQL Editor.
- [x] Habilitar RLS e aplicar políticas em todas as tabelas.
- [ ] Criar triggers de `updated_at`.
- [ ] Adicionar CHECK constraints.
- [ ] Criar bucket `receipts` no Storage e configurar políticas.
- [ ] (Opcional) Criar RPC `get_period_totals` e revogar `execute` de `public`.

### Flutter (app)

- [ ] Adicionar `supabase_flutter` e inicializar no `main.dart` com variáveis de ambiente.
- [ ] Implementar camada de conversão `snake_case ↔ camelCase`.
- [ ] Ajustar modelos Dart (`id`, `userId`, datas, `receiptImagePath`).
- [ ] Implementar Auth (registro, login, logout, tratamento de sessão).
- [ ] Implementar CRUD de Drivers (upsert para perfil único).
- [ ] Implementar CRUD de Earnings (com paginação e filtro por período).
- [ ] Implementar CRUD de Expenses (com paginação, filtro por período e categoria).
- [ ] Integrar upload/download/delete de comprovantes via Storage.
- [ ] Implementar cálculos de totais e lucro líquido por período.
- [ ] Substituir todos os dados mock pelas chamadas reais ao Supabase.
- [ ] Tratamento de erros (mapear códigos Postgrest) e loading em todas as operações.

### Testes

- [ ] Testes manuais: criar, listar, editar e excluir em cada entidade.
- [ ] Validar totais e lucro líquido por período.
- [ ] Testar upload, visualização e exclusão de comprovantes.
- [ ] (Recomendado) Testes unitários dos serviços com mock do `SupabaseClient`.
- [ ] (Opcional) Testes de integração contra projeto Supabase de teste.

---

## 10. URLs de Referência

- **Projeto Supabase:** https://mkyftoqllkvemzyxcnes.supabase.co
- **Documentação Supabase Flutter:** https://supabase.com/docs/reference/dart
- **Row Level Security:** https://supabase.com/docs/guides/auth/row-level-security
- **Supabase Storage:** https://supabase.com/docs/guides/storage
- **Supabase CLI (migrações):** https://supabase.com/docs/guides/cli/local-development

---

## 11. Melhorias Futuras (Opcional)

- **Realtime:** subscriptions do Supabase para atualizar listas em tempo real em múltiplos dispositivos.
- **Offline:** estratégia de cache local e sincronização ao voltar online (ex.: persistência local + fila de escritas).
- **Categorias de despesas:** tabela dedicada com FK em `expenses` para relatórios e filtros mais consistentes.
- **Edge Functions:** lógica de negócio mais complexa (ex.: notificações de meta atingida) via Supabase Edge Functions.
- **Relatórios avançados:** views materializadas ou RPCs adicionais para gráficos de evolução mensal, top categorias de gastos e comparativos entre períodos.