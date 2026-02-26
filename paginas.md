# 📋 Verificador de Páginas e Funcionalidades - UberControl

Este documento serve como um checklist para garantir que todas as páginas do aplicativo estejam funcionando perfeitamente, com dados dinâmicos e ações corretas nos botões.

---

## 🏗️ FASE 1: Infraestrutura e Acesso [CONCLUÍDO]

### [x] 1.1. Splash Screen
*   **Funções Necessárias:**
    *   Verificação de estado de autenticação (logado ou não).
    *   Redirecionamento automático.
*   **Dados Dinâmicos:**
    *   `Session State`: Verifica se há um token JWT válido para pular o login.
*   **Ações de Botões:** (Nenhum - Automático)

### [x] 1.2. Onboarding Screen
*   **Funções Necessárias:**
    *   Controle de páginas (PageController).
    *   Sinalização de "primeiro acesso concluído".
*   **Dados Dinâmicos:**
    *   `Slides Content`: Textos e imagens de introdução.
*   **Ações de Botões:**
    *   **Próximo:** Avança para os próximos slides.
    *   **Pular:** Vai direto para a última página ou tela de Login.
    *   **Começar:** Redireciona para a Login Screen.

### [x] 1.3. Login Screen
*   **Funções Necessárias:**
    *   Validação de formulário.
    *   Autenticação via Supabase (`AuthService.signIn`).
*   **Dados Dinâmicos:**
    *   `Email/Senha`: Autenticação direta com tabelas de usuários do projeto.
*   **Ações de Botões:**
    *   **Entrar:** Executa o login.
    *   **Cadastre-se:** Navega para Register Screen.
    *   **Esqueci a senha:** Adicionado placeholder funcional.

### [x] 1.4. Register Screen
*   **Funções Necessárias:**
    *   Validação de formulário (nome, email, senha).
    *   Criação de conta no Supabase (`AuthService.signUp`).
    *   Criação automática do perfil do motorista na tabela `drivers` (via sync no primeiro login).
*   **Dados Dinâmicos:**
    *   `Auth UID`: Gerado pelo Supabase e vinculado ao novo Driver.
*   **Ações de Botões:**
    *   **Criar Conta:** Executa o cadastro.
    *   **Voltar para Login:** Navega para Login Screen.


---

## 🏗️ FASE 2: Núcleo e Identidade [CONCLUÍDO]

### [x] 2.1. Home Screen (Dashboard)
*   **Funções Necessárias:**
    *   `_loadDriverData()`: Busca nome e dados do motorista.
    *   `_loadTotals()`: Busca totais dos últimos 7 dias (Ganhos, Gastos, Lucro) via RPC.
    *   `_loadRecentActivities()`: Busca os 5 registros mais recentes (Ganhos + Gastos).
    *   `_setupRealtimeSubscriptions()`: Atualiza os dados automaticamente quando houver mudanças no banco (Tempo Real).
*   **Dados Dinâmicos:**
    *   `Saudação`: "Bom dia/tarde/noite, [Nome]" carregado de `drivers.name`.
    *   `Cards de Resumo`: Ganhos, Gastos e Lucro dos últimos 7 dias (resultados reais e em tempo real).
    *   `Atividade Recente`: Lista mista com ícones dinâmicos, atualizada em tempo real.
    *   `Avatar`: Iniciais baseadas no nome do motorista vindo do banco.
*   **Ações de Botões:**
    *   **Avatar:** Navega para Perfil.
    *   **Sininho:** Abre a lista de notificações (com badge de não lidas).
    *   **Card Ganhos:** Navega para Meus Ganhos.
    *   **Card Gastos:** Navega para Meus Gastos.
    *   **Card Lucro:** Navega para Relatórios.
    *   **Ação "Adicionar Ganho":** Navega para Add Earning Form.
    *   **Ação "Adicionar Gasto":** Navega para Add Expense Form.
    *   **Ação "Relatórios":** Navega para Relatórios.
    *   **Item de Atividade Recente:** Navega para os Detalhes do registro.
    *   **Bottom Nav:** Navegação entre Home, Ganhos, Gastos, Relatórios e Perfil.

### [x] 2.2. Profile Screen
*   **Funções Necessárias:**
    *   `_loadDriverData()`: Dados do perfil.
    *   Resumo de estatísticas globais (Total Vida).
*   **Dados Dinâmicos:**
    *   `Info Pessoal`: Nome Completo e data de cadastro reais.
    *   `Estatísticas de Vida`: Ganhos, Gastos e Lucro totais calculados desde o primeiro registro.
*   **Ações de Botões:**
    *   **Editar Perfil:** Navega para Edit Profile.
    *   **Metas:** Navega para Goals Screen.
    *   **Categorias:** Navega para Categorias.
    *   **Backup/Exportar:** Navega para respectivas telas.
    *   **Tema:** Alternar entre Claro/Escuro (A implementar).
    *   **Sair:** Logout completo.

### [x] 2.3. Edit Profile Screen
*   **Funções Necessárias:**
    *   Atualização de nome e meta mensal.
    *   Alteração de foto (Storage).
*   **Dados Dinâmicos:**
    *   `Meta Mensal`: Exibe a meta atual para edição.
    *   `Nome`: Permite alteração no registro do Driver.
*   **Ações de Botões:**
    *   **Salvar:** Atualiza `drivers` no banco.

---

## 💰 FASE 3: Gestão de Ganhos [CONCLUÍDO]

### [x] 3.1. Earnings List Screen
*   **Funções Necessárias:**
    *   `_loadEarnings(period)`: Lista ganhos filtrados por período.
    *   Cálculo dinâmico do Total e Média Diária do período filtrado.
    *   Agrupamento por data.
*   **Dados Dinâmicos:**
    *   `Total de Ganhos`: Soma total dos registros exibidos.
    *   `Lista Agrupada`: Cabeçalhos de data com o total ganho naquele dia específico.
    *   `Cards Individuais`: Exibem Valor, Plataforma (Uber/99), Horas e Corridas reais.
    *   `Média Diária`: Calculada dividindo o total pelo número de dias trabalhados no período.
*   **Ações de Botões:**
    *   **Voltar:** Retorna à Home.
    *   **Adicionar (+):** Navega para formulário de adicionar.
    *   **Chips de Filtro (Hoje/Semana/Mês):** Atualiza a lista.
    *   **Card de Ganho:** Abre tela de detalhes.
    *   **Botão "Três Pontinhos":** Abre Menu de Ações (Ver, Editar, Excluir).
    *   **Excluir (Dialog):** Chama `SupabaseService.deleteEarning`.

### [x] 3.2. Add Earning Screen
*   **Funções Necessárias:**
    *   Suporte a Modo Criação e Modo Edição.
    *   Formatação de moeda em tempo real.
    *   `_selectDate()`: Seletor de data.
    *   `_saveEarning()`: Persiste no Supabase (`createEarning` ou `updateEarning`).
*   **Dados Dinâmicos:**
    *   `Valores Preenchidos`: Se em modo edição, carrega os dados do objeto `Earning` recebido.
*   **Ações de Botões:**
    *   **Check (V):** Salva o registro.
    *   **Voltar/Cancelar:** Descarta alterações.
    *   **Campo Data:** Abre `DatePicker`.
    *   **Campo Plataforma:** Abre `BottomSheet` de seleção.

---

## 🏗️ FASE 4: Gestão de Gastos e Arquivos [CONCLUÍDO]

### [x] 4.1. Expenses List Screen
*   **Funções Necessárias:**
    *   `_loadExpenses(period, category)`: Lista gastos com filtros duplos.
    *   Gráfico de pizza dinâmico por categoria.
*   **Dados Dinâmicos:**
    *   `Total de Gastos`: Valor acumulado no período/categoria selecionado.
    *   `Gráfico de Pizza`: Distribuição percentual das categorias (ex: quanto % foi Combustível).
    *   `Gasto Médio`: Valor médio por transação de despesa.
    *   `Timeline`: Agrupamento cronológico dos gastos.
*   **Ações de Botões:**
    *   **Voltar:** Retorna à Home.
    *   **Adicionar (+):** Navega para formulário de adicionar.
    *   **Chips de Período:** Atualiza lista.
    *   **Chips de Categoria:** Atualiza lista.
    *   **Card de Gasto:** Abre tela de detalhes.

### [x] 4.2. Add Expense Screen
*   **Funções Necessárias:**
    *   Upload de imagem para Supabase Storage (Recibos).
    *   Gerenciamento de campos condicionais (ex: Litros apenas para Combustível).
    *   `_pickReceiptImage()`: Seleção de câmera/galeria.
*   **Dados Dinâmicos:**
    *   `Categorias`: Lista de categorias (Combustível, Manutenção, etc) fixas ou carregadas se houver tabela própria.
    *   `Preview de Imagem`: Exibe a imagem local selecionada ou a imagem do Storage (via URL temporária) se estiver editando.
*   **Ações de Botões:**
    *   **Check (V):** Salva dados e faz upload da imagem se houver.
    *   **Chips de Categoria:** Seleção rápida.
    *   **Anexar Recibo:** Abre modal de seleção de imagem.
    *   **Remover Imagem (x):** Limpa a imagem selecionada.

---

## 🔍 FASE 5: Inteligência e Detalhes [CONCLUÍDO]

### [x] 5.1. Detail Screen (Geral)
*   **Funções Necessárias:**
    *   Exibição de todos os campos do modelo (Earning ou Expense).
    *   `_loadSignedUrl()`: Gera URL temporária para ver o recibo.
*   **Dados Dinâmicos:**
    *   `Conteúdo Contextual`: Cores e textos mudam se for um Ganho (Verde) ou Gasto (Vermelho).
    *   `Recibo`: Imagem carregada de forma segura do Storage usando URL assinada de curta duração.
    *   `Metadados`: Exibe data de criação e detalhes técnicos (ex: litros consumidos se for posto).
*   **Ações de Botões:**
    *   **Ícone Editar:** Abre formulário em modo edição.
    *   **Ícone Excluir:** Abre confirmação de exclusão.
    *   **Botão Primário Editar:** Mesma função do ícone.
    *   **Botão Secundário Excluir:** Mesma função do ícone.

### [x] 5.2. Reports Screen
*   **Funções Necessárias:**
    *   Integração com `fl_chart` para gráficos de linha e pizza.
    *   Métricas: Média/Dia, Gasto/Dia, Dias Ativos, Melhor Dia.
*   **Dados Dinâmicos:**
    *   `Evolução Mensal`: Gráfico de linha comparando Ganhos vs Gastos ao longo de 30 dias.
    *   `Métricas de Performance`: Melhores e piores dias calculados do histórico real.
    *   `Resumo Financeiro`: Totais absolutos (Lucro Líquido total desde o início).
*   **Ações de Botões:**
    *   **Dropdown Período:** Filtra todos os gráficos e métricas.
    *   **Exportar:** Abre menu para PDF/Excel (Placeholders).

---

## 📅 FASE 7: Histórico Financeiro

Esta fase contempla a **Tela de Histórico**, que oferece ao motorista uma visão panorâmica do seu desempenho financeiro ao longo do tempo, permitindo análises por ano e mês com visual limpo e informativo.

> A fase 7 está dividida em **duas etapas**:
> - **Etapa A** → Construção completa do frontend com dados mockup (estáticos).
> - **Etapa B** → Substituição de todos os dados mockup por dados reais vindos do backend Supabase.

---

## 📅 FASE 7 — ETAPA A: Frontend com Dados Mockup

### [x] 7.A.1. History Screen — Estrutura Visual (UI com dados estáticos)

#### 🎯 Objetivo
Construir toda a estrutura visual da Tela de Histórico com dados **hardcoded / mockup**, garantindo que o layout, componentes e navegação estejam 100% funcionais antes de conectar qualquer fonte de dados real.

---

#### 🔽 Filtro Superior (Barra de Período) — Mockup
*   **Componentes de UI:**
    *   **Seletor de Ano:** Botões de seta (← Ano →) — navegar entre anos mockup (`[2023, 2024, 2025]`).
    *   **Seletor de Mês:** Row horizontal com chips scrolláveis (Jan, Fev, Mar... Dez) — o mês atual selecionado fica destacado.
    *   **Botão "Limpar Filtro" / "Ver Tudo":** Reseta para exibir o consolidado anual.
*   **Dados Mockup:**
    *   Anos disponíveis fixos: `[2023, 2024, 2025]`.
    *   Mês inicial padrão: mês atual (`DateTime.now().month`).
*   **Comportamento esperado (sem backend):**
    *   Ao alterar Ano ou Mês, os cards abaixo devem atualizar com valores mockup correspondentes.
    *   Transições suaves entre estados (loading → dados).

---

#### 📊 Cards de Resumo Financeiro — Mockup
Três cards em destaque exibindo o panorama do período selecionado:

| Card | Cor | Dado Mockup |
|------|-----|-------------|
| 💚 Ganhos | Verde | R$ 3.250,00 |
| 🔴 Gastos | Vermelho | R$ 980,00 |
| 🔵 Lucro | Azul/Roxo | R$ 2.270,00 |

*   **Dados Mockup:**
    *   Valores fixos por período selecionado (podem ser constantes ou um `Map<String, double>` mockup por mês).
    *   `Variação (%)`: Exibir valor fixo, ex: `+12%` para todos os períodos mockup.
    *   Lucro: `ganhos - gastos` calculado no front com os valores mockup.

---

#### 📋 Lista de Meses / Breakdown — Mockup

**Visão Anual (nenhum mês selecionado):**
*   Lista com 12 meses fixos, cada um exibindo:
    *   Nome do mês + ano mockup.
    *   Mini-bar horizontal proporcional ao lucro (usar valores mockup).
    *   Valores compactos mockup: `Ganho | Gasto | Lucro`.

**Visão Mensal (mês selecionado):**
*   Breakdown por semana (Semana 1 a 4/5) com valores mockup.
*   Lista mockup com 5 transações recentes agrupadas por data.

---

#### 📤 Seção de Exportação — UI Apenas
*   Exibir os botões de exportação **como placeholders visuais** (sem funcionalidade real nesta etapa):
    *   **Botão "Exportar PDF":** Exibe um `SnackBar` com `"Funcionalidade em breve"`.
    *   **Botão "Exportar Excel":** Exibe um `SnackBar` com `"Funcionalidade em breve"`.
    *   **Botão "Compartilhar":** Exibe um `SnackBar` com `"Funcionalidade em breve"`.

---

#### 🎬 Ações de Botões (Etapa A)
*   **Setas de Ano (← →):** Navega pelos anos mockup e atualiza os cards/lista com dados estáticos.
*   **Chip de Mês:** Seleciona o mês e exibe o breakdown mockup correspondente.
*   **"Ver Tudo" / Limpar Mês:** Volta para a visão anual com lista mockup de 12 meses.
*   **Item de Mês (visão anual):** Tap seleciona o mês, exibindo o breakdown semanal mockup.
*   **Botões de Exportação:** Exibem `SnackBar` placeholder.
*   **Voltar (AppBar):** Retorna à tela anterior (Home ou Profile).

---

#### 🧩 Navegação (Etapa A)
*   Acessível a partir da **Home Screen** (botão no menu rápido ou via Card de Lucro).
*   Acessível a partir da **Profile Screen** (botão "Histórico").
*   Rota sugerida: `/history` no `app_router.dart`.

---

## 📅 FASE 7 — ETAPA B: Substituição por Dados Reais (Supabase)

### [x] 7.B.1. History Screen — Integração com Backend Real

#### 🎯 Objetivo
Substituir **todos os dados mockup** da Etapa A por dados reais vindos do Supabase, implementando as funções de busca via RPCs, ativando as exportações reais e garantindo que a tela se comporte de forma dinâmica e responsiva.

---

#### 🔧 Funções a Implementar

*   `_loadAvailableYears()`:
    *   Substitui a lista mockup `[2023, 2024, 2025]` por uma query real:
        ```sql
        SELECT DISTINCT EXTRACT(YEAR FROM date)::int AS year
        FROM earnings WHERE driver_id = auth.uid()
        UNION
        SELECT DISTINCT EXTRACT(YEAR FROM date)::int AS year
        FROM expenses WHERE driver_id = auth.uid()
        ORDER BY year DESC;
        ```
    *   Popular o seletor de Ano com os anos reais retornados.

*   `_loadHistorySummary(year, month?)`:
    *   Chama as RPCs `get_earnings_summary(driver_id, year, month)` e `get_expenses_summary(driver_id, year, month)`.
    *   Parâmetro `month` opcional: se `null`, retorna o consolidado anual.
    *   Substitui os valores mockup nos Cards de Resumo.
    *   Calcula `Lucro = ganhos - gastos` no front.
    *   Calcula a variação `%` em relação ao período anterior chamando a mesma RPC com `year/month - 1`.

*   `_loadMonthlyBreakdown(year)`:
    *   Chama a RPC `get_monthly_breakdown(driver_id, year)`.
    *   Retorna array com resumo por mês → substitui a lista mockup de 12 meses na visão anual.
    *   Estrutura esperada: `[{ month: 1, earnings: X, expenses: Y, profit: Z }, ...]`.

*   `_loadWeeklyBreakdown(year, month)`:
    *   Chama a RPC `get_weekly_breakdown(driver_id, year, month)`.
    *   Retorna array com resumo por semana → substitui o breakdown mockup na visão mensal.
    *   Estrutura esperada: `[{ week: 1, earnings: X, expenses: Y, profit: Z }, ...]`.

*   `_loadRecentTransactions(year, month)`:
    *   Busca os últimos 5 registros reais (Ganhos + Gastos) do período selecionado.
    *   Exibidos na lista de transações recentes da visão mensal.

---

#### 💾 Fontes de Dados Reais (Supabase)

| Dado | Fonte |
|------|-------|
| Anos disponíveis | Query SQL com `DISTINCT EXTRACT(YEAR FROM date)` |
| Totais por período | RPCs `get_earnings_summary` e `get_expenses_summary` |
| Breakdown mensal | RPC `get_monthly_breakdown(driver_id, year)` |
| Breakdown semanal | RPC `get_weekly_breakdown(driver_id, year, month)` |
| Transações recentes | Query direta em `earnings` + `expenses` com filtro de período |
| Variação (%) | Comparação entre período atual e anterior via mesmas RPCs |

> **RPCs a criar no Supabase (se não existirem):**
> - `get_earnings_summary(p_driver_id, p_year, p_month?)` → `{ total: double }`
> - `get_expenses_summary(p_driver_id, p_year, p_month?)` → `{ total: double }`
> - `get_monthly_breakdown(p_driver_id, p_year)` → `[{ month, earnings, expenses, profit }]`
> - `get_weekly_breakdown(p_driver_id, p_year, p_month)` → `[{ week, earnings, expenses, profit }]`

---

#### 📤 Exportação Real

**Exportar como PDF:**
*   Substituir o `SnackBar` placeholder por geração real do PDF usando `pdf` + `printing`.
*   Conteúdo do PDF:
    *   Cabeçalho: Nome do Motorista, Período (Mês/Ano ou Ano).
    *   Cards de resumo (Ganhos, Gastos, Lucro reais).
    *   Tabela com todas as transações reais do período (Data, Tipo, Valor, Descrição/Plataforma).
    *   Rodapé: Data de geração do relatório.
*   Abrir visualizador nativo ou compartilhar via `printing`.

**Exportar como Excel (.xlsx):**
*   Substituir o `SnackBar` placeholder por geração real do `.xlsx` usando `syncfusion_flutter_xlsio` ou `excel`.
*   Abas:
    *   **"Resumo":** Cards reais (Ganhos, Gastos, Lucro, Variação).
    *   **"Ganhos":** Todas as linhas reais (Date, Platform, Hours, Trips, Value).
    *   **"Gastos":** Todas as linhas reais (Date, Category, Description, Value).
*   Salvar nos Downloads e exibir `SnackBar` com opção "Abrir".

**Compartilhar:**
*   Usar `share_plus` para enviar o arquivo gerado (PDF ou Excel) via apps instalados.

---

#### 🎬 Ações de Botões (Etapa B)
*   **Setas de Ano (← →):** Recarrega anos reais e atualiza todos os dados dinamicamente.
*   **Chip de Mês:** Dispara `_loadHistorySummary` e `_loadWeeklyBreakdown` com os dados reais.
*   **"Ver Tudo" / Limpar Mês:** Dispara `_loadMonthlyBreakdown` real para a visão anual.
*   **Item de Mês (visão anual):** Tap carrega o breakdown real daquele mês.
*   **Botão "Exportar PDF":** Gera e abre/compartilha o PDF com dados reais do período.
*   **Botão "Exportar Excel":** Gera e salva o `.xlsx` com dados reais do período.
*   **Botão "Compartilhar":** Compartilha o arquivo real gerado.
*   **Voltar (AppBar):** Retorna à tela anterior (Home ou Profile).

---

#### 🧩 Navegação (Etapa B — sem mudanças)
*   Acessível a partir da **Home Screen**.
*   Acessível a partir da **Profile Screen**.
*   Rota: `/history` no `app_router.dart`.

---

## ⚙️ FASE 6: Configurações e Extras

### [ ] 6.1. Metas (Goals Screen)
*   **Funções:** Definição de meta mensal de faturamento.
*   **Dados Dinâmicos:** Meta atual lida da tabela `drivers`.

### [ ] 6.2. Categorias (Categories Screen)
*   **Funções:** Gerenciamento de tipos de gastos personalizados.

### [ ] 6.3. Backup & Export
*   **Funções:** Sincronização manual e geração de arquivos CSV/PDF.

### [ ] 6.4. Notificações & Ajuda
*   **Funções:** Alertas de manutenção e guia de uso.
