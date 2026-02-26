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

### [ ] 7.1. History Screen (Tela de Histórico)

#### 🎯 Objetivo
Proporcionar uma visão consolidada e navegável do histórico financeiro do motorista, exibindo Ganhos, Gastos e Lucro de forma organizada por período (ano/mês), permitindo identificar tendências e comparar desempenho ao longo do tempo.

---

#### 🔽 Filtro Superior (Barra de Período)
*   **Componentes de UI:**
    *   **Seletor de Ano:** Dropdown ou botões de seta (← Ano →) para navegar entre anos disponíveis.
    *   **Seletor de Mês:** Row horizontal com chips scrolláveis (Jan, Fev, Mar... Dez) — o mês atual selecionado fica destacado.
    *   **Botão "Limpar Filtro" / "Ver Tudo":** Reseta para exibir o consolidado anual.
*   **Comportamento:**
    *   Ao alterar o Ano, os chips de Mês são recarregados e os cards abaixo são atualizados.
    *   Ao selecionar um Mês específico, os cards e a lista exibem os dados daquele mês/ano.
    *   Se nenhum mês for selecionado, exibe o consolidado anual.

---

#### 📊 Cards de Resumo Financeiro (Logo abaixo dos filtros)
Três cards em destaque exibindo o panorama do período selecionado:

| Card | Cor | Dado exibido |
|------|-----|-------------|
| 💚 Ganhos | Verde | Total de recebimentos no período |
| 🔴 Gastos | Vermelho | Total de despesas no período |
| 🔵 Lucro | Azul/Roxo | Ganhos − Gastos (pode ser negativo) |

*   **Dados Dinâmicos:**
    *   `Total de Ganhos do Período`: Soma de todos os registros de ganhos no mês/ano filtrado, via RPC `get_earnings_summary(year, month)`.
    *   `Total de Gastos do Período`: Soma de todos os registros de despesas no mês/ano filtrado, via RPC `get_expenses_summary(year, month)`.
    *   `Lucro Líquido`: Calculado no front como `ganhos - gastos`; exibido em verde se positivo, vermelho se negativo.
    *   `Variação (%)`: Comparação opcional com o período anterior (ex: +12% em relação ao mês passado), exibida abaixo de cada valor principal.

---

#### 📋 Lista de Meses / Breakdown Anual
Quando **nenhum mês** estiver selecionado (visão anual), exibir uma lista com todos os meses do ano, mostrando para cada mês:
*   Mês e Ano (ex: "Janeiro 2025")
*   Mini-bar horizontal proporcional ao Lucro
*   Valores compactos: Ganho | Gasto | Lucro

Quando um **mês específico** estiver selecionado, exibir:
*   Breakdown por semana do mês (Semana 1, Semana 2, etc.)
*   Cada semana exibe o consolidado de Ganhos, Gastos e Lucro.
*   Lista de transações recentes do período (últimos 5 registros, agrupados por data).

---

#### 🔧 Funções Necessárias
*   `_loadHistorySummary(year, month?)`: Busca os totais de Ganhos, Gastos e Lucro via RPCs existentes filtradas por período.
    *   Parâmetro `month` opcional: se `null`, retorna o consolidado anual.
*   `_loadAvailableYears()`: Busca os anos distintos em que o motorista possui registros para popular o seletor de ano.
*   `_loadMonthlyBreakdown(year)`: Para a visão anual, busca o resumo mês a mês do ano selecionado.
*   `_loadWeeklyBreakdown(year, month)`: Para a visão mensal, busca o resumo semana a semana.
*   `_calculateVariation(current, previous)`: Calcula a variação percentual em relação ao período anterior.

---

#### 💾 Dados Dinâmicos (Fontes de Dados)
*   `Anos disponíveis`: Query `SELECT DISTINCT EXTRACT(YEAR FROM date) FROM earnings UNION SELECT DISTINCT EXTRACT(YEAR FROM date) FROM expenses ORDER BY 1 DESC`.
*   `Totais por período`: RPCs `get_earnings_summary` e `get_expenses_summary` (já existentes ou a criar), recebendo `(driver_id, year, month?)`.
*   `Breakdown mensal`: RPC `get_monthly_breakdown(driver_id, year)` retornando array com resumo por mês.
*   `Breakdown semanal`: RPC `get_weekly_breakdown(driver_id, year, month)` retornando array com resumo por semana.

---

#### 📤 Seção de Exportação
Localizada no final da tela (ou via botão flutuante / ícone no AppBar):

**Exportar como PDF:**
*   Gera um relatório formatado do período selecionado contendo:
    *   Cabeçalho: Logo do app, Nome do Motorista, Período (Mês/Ano ou Ano).
    *   Cards de resumo (Ganhos, Gastos, Lucro).
    *   Tabela com todas as transações do período (Data, Tipo, Valor, Descrição/Plataforma).
    *   Rodapé: Data de geração do relatório.
*   **Lib sugerida:** `pdf` + `printing` (já possível usar `printing` para compartilhar).

**Exportar como Excel (.xlsx):**
*   Gera uma planilha com abas separadas:
    *   **Aba "Resumo":** Cards de Ganhos, Gastos, Lucro e variação.
    *   **Aba "Ganhos":** Todas as linhas de ganhos no período (Date, Platform, Hours, Trips, Value).
    *   **Aba "Gastos":** Todas as linhas de gastos no período (Date, Category, Description, Value).
*   **Lib sugerida:** `syncfusion_flutter_xlsio` ou `excel` (pub.dev).

**Botões de Acção:**
*   **Exportar PDF:** Abre `Share` ou salva localmente e abre visualizador de PDF nativo.
*   **Exportar Excel:** Salva o arquivo `.xlsx` nos Downloads e exibe snackbar de confirmação com opção "Abrir".
*   **Compartilhar:** Usa `share_plus` para enviar o arquivo gerado (PDF ou Excel) via apps instalados (WhatsApp, e-mail, etc.).

---

#### 🎬 Ações de Botões
*   **Setas de Ano (← →):** Decrementa/incrementa o ano e recarrega todos os dados.
*   **Chip de Mês:** Seleciona o mês; nova consulta dispara automaticamente.
*   **"Ver Tudo" / Limpar Mês:** Remove o filtro de mês, volta para visão anual.
*   **Item de Mês (visão anual):** Tap seleciona aquele mês, entrando na visão mensal.
*   **Botão "Exportar PDF":** Gera e abre/compartilha o PDF do período selecionado.
*   **Botão "Exportar Excel":** Gera e salva o arquivo `.xlsx` do período selecionado.
*   **Botão "Compartilhar":** Usa share_plus para permitir compartilhamento do arquivo.
*   **Voltar (AppBar):** Retorna à tela anterior (Home ou Profile).

---

#### 🧩 Navegação
*   Acessível a partir da **Home Screen** (botão no menu rápido ou Card de Lucro com opção "Ver Histórico").
*   Acessível a partir da **Profile Screen** (botão "Histórico" próximo às estatísticas de vida).
*   Rota sugerida: `/history` no `app_router.dart`.

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
