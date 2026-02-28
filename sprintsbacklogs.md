# 🏃 Scrum Board: Projeto UberControl

Este documento centraliza o **Product Backlog**, organizado em **Épicos** e distribuído em **Sprints**, seguindo as metodologias ágeis do Scrum. Ele reflete todo o desenvolvimento do aplicativo (Frontend e Integração com Backend Supabase) com base nos requisitos arquiteturais, de design e funcionais documentados.

---

## 🏔️ Épicos (Grandes Entregas)

Aqui estão os pilares de desenvolvimento do aplicativo (Product Backlog de alto nível):

- **Épico 1:** Arquitetura Base e Setup Inicial (Estrutura, Tema, Supabase)
- **Épico 2:** Fluxo do Usuário e Identidade (Autenticação, Perfil, Navegação)
- **Épico 3:** Operacional — Controle de Caixa Diário (Lançamento de Ganhos/Despesas)
- **Épico 4:** Inteligência e Visualização Financeira (Relatórios, Histórico Anual, Gráficos)
- **Épico 5:** Funcionalidades Avançadas e Qualidade (Comprovantes, Exportação, Testes Finos)

---

## 📦 Sprints e Backlog

Abaixo, a divisão tática das tarefas (Sprint Backlogs). Cada Sprint agrupa atividades que geram valor para o Usuário Final (Motoristas) e incrementos testáveis.

> **Status e Legenda:**
> ✅ Concluído (Done)
> 🟡 Em Andamento (In Progress)
> ⚪ Pendente (To Do / Backlog)

---

### 🏃 Sprint 1: Fundação do App e Sistema de Design
**Meta da Sprint:** Configurar o projeto base, conectar o Supabase e estruturar o ecossistema visual (Cores e Widgets customizados).
**Duração Estimada:** 1 Semana | **Status:** ✅ Concluído

| ID | Tarefa (User Story / Task) | Épico | Pontos | Status |
|----|---------------------------|-------|--------|--------|
| UB-1 | Inicializar app Flutter `gestaodecontauber` e pastas (`lib/core`, `features`, `shared`). | Épico 1 | 3 | ✅ |
| UB-2 | Adicionar dependências core (`provider`, `supabase_flutter`, `go_router`, `fl_chart`). | Épico 1 | 2 | ✅ |
| UB-3 | Implementar Tokens do Design System (`AppColors`, `AppTypography`, `AppSpacing`). | Épico 1 | 3 | ✅ |
| UB-4 | Construir Widgets Universais UI (`AppButton`, `AppCard`, `AppTextField`). | Épico 1 | 5 | ✅ |
| UB-5 | Setup Supabase: Banco criado (Tabelas Drivers, Earnings, Expenses), Auth ativado e RLS. | Épico 1 | 5 | ✅ |
| UB-6 | Conectar supabase no `main.dart` e mapear Modelos (snake_case para camelCase). | Épico 1 | 3 | ✅ |

---

### 🏃 Sprint 2: Onboarding, Acesso Seguro e Perfil
**Meta da Sprint:** Garantir que o usuário consiga entender o app, criar conta, realizar login seguro e editar as preferências do seu perfil.
**Duração Estimada:** 1 Semana | **Status:** ✅ Concluído

| ID | Tarefa (User Story / Task) | Épico | Pontos | Status |
|----|---------------------------|-------|--------|--------|
| UB-7 | Montar Splash Screen com lógica de redirecionamento (Pular Onboarding/Login direto). | Épico 2 | 2 | ✅ |
| UB-8 | Montar Onboarding Screen (Paginação com features e CTA). | Épico 2 | 3 | ✅ |
| UB-9 | Formulários de Autenticação Supabase: UI Login Screen e Register Screen. | Épico 2 | 5 | ✅ |
| UB-10 | Criar Home Screen (Dashboard Empty State) com saudações e barra de Navegação. | Épico 2 | 5 | ✅ |
| UB-11 | UI Profile Screen (Estatísticas globais e ações) + Edit Profile Screen. | Épico 2 | 5 | ✅ |
| UB-12 | Lógica de `upsert` na tabela Drivers (Sincronizar dados logo pós o Registro do auth). | Épico 2 | 3 | ✅ |

---

### 🏃 Sprint 3: O Coração do App (Registro de Operações)
**Meta da Sprint:** Permitir o registro completo (CRUD), listagem e cálculos simples de ganhos do dia a dia e dos boletos/despesas da operação do veículo.
**Duração Estimada:** 2 Semanas | **Status:** ✅ Concluído

| ID | Tarefa (User Story / Task) | Épico | Pontos | Status |
|----|---------------------------|-------|--------|--------|
| UB-13 | Desenvolver Serviços (SupabaseService) CRUD Earnings e Expenses. | Épico 3 | 5 | ✅ |
| UB-14 | UI Add Earning Form (Plataformas, Horas, Corridas) com cálculos em tempo real. | Épico 3 | 5 | ✅ |
| UB-15 | UI Add Expense Form (Categorias, Litros) com condicionais de tela. | Épico 3 | 5 | ✅ |
| UB-16 | UI Earnings List: Agrupamento por dia, paginação e Filtros (Hoje, Semana, Mês). | Épico 3 | 8 | ✅ |
| UB-17 | UI Expenses List: Gráfico de Pizza por Categoria, Filtros, Listagem Dinâmica. | Épico 3 | 8 | ✅ |
| UB-18 | Lógica na Home: Resumo Financeiro 7 dias (RPC Supabase `get_period_totals`). | Épico 3 | 3 | ✅ |

---

### 🏃 Sprint 4: Inteligência, Panoramas e Histórico 
**Meta da Sprint:** Construir relatórios visuais densos para aprofundamento das informações financeiras, integrando UI com cálculos pesados de banco de dados.
**Duração Estimada:** 2 Semanas | **Status:** ✅ Concluído

| ID | Tarefa (User Story / Task) | Épico | Pontos | Status |
|----|---------------------------|-------|--------|--------|
| UB-19 | UI Detail Screen (Contexto Verde/Vermelho dinâmico ao clicar num card da lista). | Épico 4 | 3 | ✅ |
| UB-20 | Construir e integrar The Reports Screen (Evolução mensal com `fl_chart`). | Épico 4 | 8 | ✅ |
| UB-21 | [Etapa A] Mockup UI Histórico Financeiro: Seletores de Ano/Mês, Cards, Transições. | Épico 4 | 5 | ✅ |
| UB-22 | Implementar Supabase RPCs para Histórico (`get_monthly_breakdown` e outros). | Épico 4 | 5 | ✅ |
| UB-23 | [Etapa B] Substituir Mockups do Histórico (Fase 7) pelas RPCs Reais de Banco. | Épico 4 | 5 | ✅ |
| UB-24 | Inserir estado Loading Feedback e tratamento de erros Postgrest Global (+ SnackBar). | Épico 4 | 5 | ✅ |

---

### 🏃 Sprint 5: Qualidade, Arquivos Físicos e Ajustes Finais
**Meta da Sprint:** Lidar com Storage de recibos, permitir exportações para contabilidade (PDF/Excel), além de ajustes de configuração exigidos recentemente (Backlog Remanescente do projeto).
**Duração Estimada:** 2 Semanas | **Status:** 🟡 Andamento

| ID | Tarefa (User Story / Task) | Épico | Pontos | Status |
|----|---------------------------|-------|--------|--------|
| UB-25 | Integrar Upload Imagens e Avatar (Supabase Storage: Bucket `receipts` e `avatars`). | Épico 5 | 8 | ✅ |
| UB-26 | Baixar imagens via Signed URLs temporárias na Detail Screen e no Perfil. | Épico 5 | 3 | ✅ |
| UB-27 | Realizar bateria Testes Manuais Finais de Crud Duplo e Integrações. | Épico 5 | 8 | ⚪ |
| UB-28 | [Fase 6.1] Criar "Goals Screen" (UI e Backend para update da tabela `drivers`). | Épico 5 | 5 | ⚪ |
| UB-29 | [Fase 6.2] Criar "Categories Screen" (Setup para personalizar tabelas/lista de Gastos). | Épico 5 | 3 | ⚪ |
| UB-30 | [Fase 6.3] Ferramenta Real de Exportação em Tabela Excel `.xlsx` e PDF de Extrato. | Épico 5 | 13| ⚪ |
| UB-31 | [Fase 6.4] Tela de Help/Ajuda Mockada e Setup de UI Notificações (Sininho Home). | Épico 5 | 5 | ⚪ |

---

## 📈 Próximos Passos (Next Actions)

De acordo com o quadro do Product Backlog e Sprints vigentes, o foco da equipe técnica atual (onde as mãos no código vão atuar) é encerrar os **itens pendentes (⚪) da Sprint 5**.

**Foco imediato da Iteração (Desenvolvimento):**

1. Finalizar TDD e Refinamento de bugs não previstos (Testes Manuais).
2. Criar UI/UX da Meta Mensal de motoristas e plugar o update de meta no serviço existente.
3. Desenvolver as lógicas visuais e a montagem real dos relatórios com as bibliotecas `pdf/printing` e `excel`.
