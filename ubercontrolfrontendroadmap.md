# 🎨 UberControl - ROADMAP FRONTEND

## 📱 Visão Geral do Frontend

App de controle financeiro para motoristas com foco em:
1. **Registrar ganhos diários**
2. **Registrar gastos**
3. **Ver relatórios e análises**

---

## ✅ STATUS DE IMPLEMENTAÇÃO

### ✅ Concluído:
- **Design System**: Cores, Tipografia, Espaçamentos, Raio de bordas
- **Tela Splash**: Completa com animações
- **Onboarding**: 3 telas completas
- **Tela Home**: Estrutura básica implementada
- **Adicionar Ganho/Gasto**: Telas de formulário criadas
- **Listas de Ganhos/Gastos**: Telas criadas
- **Componentes Base**: SummaryCard, TransactionCard, AppButton, AppTextField, AppChip, AppCard, AppBottomNav, AppAvatar
- **Utilitários**: CurrencyFormatter, DateFormatter
- **Navegação**: Router configurado com GoRouter

### 🚧 Em Progresso/Pendente:
- Gráficos (semanal, mensal, por categoria)
- Tela de Detalhes
- Relatórios completos
- Editar Perfil
- Metas
- Dialogs e Modais
- Animações avançadas
- Responsividade
- Acessibilidade

---

## 🎨 ETAPA 1: DESIGN SYSTEM E CORES ✅

### 1.1 Paleta de Cores ✅
```dart
// Cores Principais
primary: #10B981        // Verde (Ganhos/Lucro)
secondary: #EF4444      // Vermelho (Gastos/Despesas)
accent: #3B82F6         // Azul (Neutro/Info)

// Backgrounds
backgroundDark: #0A1128
backgroundMedium: #1E293B
surface: #1E293B

// Categorias
earnings: #10B981       // Verde - Ganhos
expenses: #F59E0B       // Laranja - Gastos
fuel: #EC4899          // Rosa - Combustível
maintenance: #8B5CF6    // Roxo - Manutenção
profit: #10B981        // Verde - Lucro
loss: #EF4444          // Vermelho - Prejuízo
```

### 1.2 Ícones Principais
```dart
// Navegação
home: Icons.home
reports: Icons.bar_chart
settings: Icons.settings

// Ações
add: Icons.add_circle
edit: Icons.edit
delete: Icons.delete
save: Icons.check

// Categorias
earnings: Icons.attach_money
fuel: Icons.local_gas_station
maintenance: Icons.build
car_wash: Icons.local_car_wash
toll: Icons.toll
parking: Icons.local_parking
```

---

## 📱 ETAPA 2: TELA DE SPLASH

### Componentes
- [x] Logo do app (centro)
- [x] Nome do app "UberControl"
- [x] Loading indicator (circular)
- [x] Versão do app (rodapé)

### Animação
- [x] Fade in do logo (500ms)
- [x] Loading por 2 segundos
- [x] Transição para Home ou Onboarding

---

## 📱 ETAPA 3: ONBOARDING (PRIMEIRA VEZ)

### 3.1 Tela 1: Bem-vindo
**Componentes:**
- [x] Ilustração/Ícone grande
- [x] Título: "Bem-vindo ao UberControl"
- [x] Subtítulo: "Controle total dos seus ganhos e gastos"
- [x] Botão "Começar"
- [x] Indicador de página (1/3)

### 3.2 Tela 2: Recursos
**Componentes:**
- [x] Ilustração/Ícone
- [x] Título: "Registre seus Ganhos"
- [x] Lista de recursos:
  - ✓ Acompanhe ganhos diários
  - ✓ Registre todas as despesas
  - ✓ Veja relatórios detalhados
- [x] Botão "Próximo"
- [x] Link "Pular"
- [x] Indicador de página (2/3)

### 3.3 Tela 3: Começar
**Componentes:**
- [x] Ilustração/Ícone
- [x] Título: "Pronto para começar?"
- [x] Campo: Nome do motorista
- [x] Campo: Meta mensal (R$)
- [x] Botão "Iniciar"
- [x] Indicador de página (3/3)

---

## 📱 ETAPA 4: TELA HOME (DASHBOARD)

### 4.1 Header
**Componentes:**
- [x] Avatar do motorista (esquerda)
- [x] Saudação: "Olá, [Nome]" (centro)
- [ ] Ícone de notificações (direita)
- [x] Data de hoje (abaixo da saudação)

### 4.2 Card de Resumo do Dia
**Componentes:**
- [x] Título: "Hoje"
- [x] Data: "Sexta, 29 de Dezembro"
- [x] 3 Cards em linha:
  
  **Card 1 - Ganhos**
  - Ícone: attach_money (verde)
  - Label: "Ganhos"
  - Valor: "R$ 450,00"
  
  **Card 2 - Gastos**
  - Ícone: shopping_cart (laranja)
  - Label: "Gastos"
  - Valor: "R$ 80,00"
  
  **Card 3 - Lucro**
  - Ícone: trending_up (verde ou vermelho)
  - Label: "Lucro"
  - Valor: "R$ 370,00"

### 4.3 Botões de Ação Rápida
**Layout: 2x2 Grid**

- [x] **Botão 1: Adicionar Ganho**
  - Ícone: add_circle (verde)
  - Texto: "Adicionar Ganho"
  - Cor de fundo: Verde com opacidade

- [x] **Botão 2: Adicionar Gasto**
  - Ícone: remove_circle (laranja)
  - Texto: "Adicionar Gasto"
  - Cor de fundo: Laranja com opacidade

- [x] **Botão 3: Ver Relatórios**
  - Ícone: bar_chart (azul)
  - Texto: "Relatórios"
  - Cor de fundo: Azul com opacidade

- [x] **Botão 4: Histórico**
  - Ícone: history (roxo)
  - Texto: "Histórico"
  - Cor de fundo: Roxo com opacidade

### 4.4 Resumo Semanal (Gráfico)
**Componentes:**
- [ ] Título: "Últimos 7 dias"
- [ ] Gráfico de barras empilhadas:
  - Barra verde: Ganhos
  - Barra laranja: Gastos
- [ ] Eixo X: Dias da semana (Seg, Ter, Qua...)
- [ ] Eixo Y: Valores em R$
- [ ] Legenda:
  - ● Ganhos (verde)
  - ● Gastos (laranja)

### 4.5 Atividade Recente
**Componentes:**
- [x] Título: "Atividade Recente"
- [x] Lista de últimas 5 transações:
  
  **Cada item mostra:**
  - Ícone da categoria (esquerda)
  - Descrição da transação
  - Hora/Data
  - Valor (verde para ganho, laranja para gasto)

### 4.6 Bottom Navigation Bar
**5 Ícones:**
- [x] Home (selecionado)
- [x] Ganhos
- [x] Gastos
- [x] Relatórios
- [x] Perfil

---

## 📱 ETAPA 5: TELA ADICIONAR GANHO ✅

### 5.1 Header
**Componentes:**
- [x] Botão voltar (esquerda)
- [x] Título: "Adicionar Ganho"
- [x] Botão salvar/check (direita)

### 5.2 Formulário
**Campos:**

- [x] **Data**
  - Label: "Data"
  - Campo: DatePicker
  - Valor padrão: Hoje
  - Ícone: calendar_today

- [x] **Valor**
  - Label: "Valor ganho"
  - Campo: TextField numérico
  - Placeholder: "R$ 0,00"
  - Teclado: Numérico com vírgula
  - Ícone: attach_money

- [x] **Plataforma** (Opcional)
  - Label: "Plataforma"
  - Campo: Dropdown
  - Opções:
    - Uber
    - 99
    - InDrive
    - Outros
  - Ícone: directions_car

- [x] **Número de corridas** (Opcional)
  - Label: "Corridas realizadas"
  - Campo: TextField numérico
  - Placeholder: "0"
  - Ícone: pin_drop

- [x] **Horas trabalhadas** (Opcional)
  - Label: "Horas trabalhadas"
  - Campo: TextField numérico
  - Placeholder: "0.0"
  - Ícone: schedule

- [x] **Observações** (Opcional)
  - Label: "Observações"
  - Campo: TextArea
  - Placeholder: "Adicione uma nota..."
  - Ícone: note

### 5.3 Botões
- [x] **Botão Salvar** (no topo, ícone check)
- [x] **Botão Cancelar** (voltar)

### 5.4 Validações
- Valor deve ser maior que 0
- Data não pode ser futura
- Mostrar erro em vermelho abaixo do campo

---

## 📱 ETAPA 6: TELA ADICIONAR GASTO ✅

### 6.1 Header
**Componentes:**
- [x] Botão voltar (esquerda)
- [x] Título: "Adicionar Gasto"
- [x] Botão salvar/check (direita)

### 6.2 Formulário
**Campos:**

- [x] **Data**
  - Label: "Data"
  - Campo: DatePicker
  - Valor padrão: Hoje
  - Ícone: calendar_today

- [x] **Categoria**
  - Label: "Categoria"
  - Campo: Grid de chips selecionáveis
  - Opções:
    - 🔴 Combustível
    - 🔧 Manutenção
    - 💧 Lavagem
    - 🅿️ Estacionamento
    - 🛣️ Pedágio
    - 📋 Outros
  - Visual: Chip com ícone + texto
  - Selecionado: Background colorido

- [x] **Valor**
  - Label: "Valor gasto"
  - Campo: TextField numérico
  - Placeholder: "R$ 0,00"
  - Teclado: Numérico com vírgula
  - Ícone: attach_money

- [x] **Litros** (apenas se categoria = Combustível)
  - Label: "Litros abastecidos"
  - Campo: TextField numérico
  - Placeholder: "0.0"
  - Ícone: local_gas_station

- [x] **Descrição**
  - Label: "Descrição"
  - Campo: TextField
  - Placeholder: "Ex: Troca de óleo, Gasolina comum..."
  - Ícone: description

- [ ] **Foto do Recibo** (Opcional)
  - Label: "Anexar recibo"
  - Campo: Botão com ícone de câmera
  - Ação: Abrir câmera ou galeria
  - Preview: Miniatura da foto se anexada

- [x] **Observações** (Opcional)
  - Label: "Observações"
  - Campo: TextArea
  - Placeholder: "Adicione uma nota..."
  - Ícone: note

### 6.3 Botões
- [x] **Botão Salvar** (no topo, ícone check)
- [x] **Botão Cancelar** (voltar)

### 6.4 Validações
- Categoria deve ser selecionada
- Valor deve ser maior que 0
- Data não pode ser futura
- Descrição não pode estar vazia

---

## 📱 ETAPA 7: TELA LISTA DE GANHOS ✅

### 7.1 Header
**Componentes:**
- [x] Botão voltar
- [x] Título: "Meus Ganhos"
- [x] Botão adicionar (+)

### 7.2 Filtros
**Componentes:**
- [ ] Chips de filtro por período:
  - Hoje
  - Semana
  - Mês
  - Personalizado (abre DateRangePicker)

### 7.3 Resumo do Período
**Card com:**
- [ ] Total de ganhos no período: "R$ 2.450,00"
- [ ] Total de registros: "45 ganhos"
- [ ] Média por dia: "R$ 350,00/dia"

### 7.4 Lista de Ganhos
**Cada card mostra:**
- [x] Data (topo)
- [x] Ícone da plataforma (se tiver)
- [x] Valor (grande, verde, à direita)
- [x] Número de corridas (se tiver)
- [x] Horas trabalhadas (se tiver)
- [x] Observações (resumidas)
- [ ] Ícone de menu (3 pontos):
  - Editar
  - Excluir

**Agrupamento:**
- Agrupar por data
- Mostrar total do dia em cada grupo

### 7.5 Empty State
**Se não houver ganhos:**
- [x] Ilustração
- [x] Texto: "Nenhum ganho registrado"
- [x] Subtexto: "Comece adicionando seu primeiro ganho"
- [x] Botão: "Adicionar Ganho"

---

## 📱 ETAPA 8: TELA LISTA DE GASTOS ✅

### 8.1 Header
**Componentes:**
- [x] Botão voltar
- [x] Título: "Meus Gastos"
- [x] Botão adicionar (+)

### 8.2 Filtros
**Componentes:**
- [ ] Chips de filtro por período:
  - Hoje
  - Semana
  - Mês
  - Personalizado

- [ ] Chips de filtro por categoria:
  - Todos
  - Combustível
  - Manutenção
  - Lavagem
  - Outros

### 8.3 Resumo do Período
**Card com:**
- [ ] Total de gastos: "R$ 850,00"
- [ ] Total de registros: "23 gastos"
- [ ] Gasto médio: "R$ 37,00"

### 8.4 Gráfico de Gastos por Categoria
**Componentes:**
- [ ] Gráfico de pizza/donut
- [ ] Cores diferentes por categoria
- [ ] Percentual de cada categoria
- [ ] Legenda com valores

### 8.5 Lista de Gastos
**Cada card mostra:**
- [x] Ícone da categoria (colorido, esquerda)
- [x] Nome da categoria
- [x] Data
- [x] Descrição
- [x] Valor (laranja, à direita)
- [x] Badge da categoria
- [ ] Ícone de menu (3 pontos):
  - Ver detalhes
  - Editar
  - Excluir

**Agrupamento:**
- Agrupar por data
- Mostrar total do dia

### 8.6 Empty State
**Se não houver gastos:**
- [x] Ilustração
- [x] Texto: "Nenhum gasto registrado"
- [x] Subtexto: "Comece adicionando seu primeiro gasto"
- [x] Botão: "Adicionar Gasto"

---

## 📱 ETAPA 9: TELA DE DETALHES (GANHO/GASTO)

### 9.1 Header
**Componentes:**
- [ ] Botão voltar
- [ ] Título: "Detalhes"
- [ ] Botão editar (ícone)
- [ ] Botão excluir (ícone)

### 9.2 Card Principal
**Componentes:**
- [ ] Ícone grande da categoria/tipo
- [ ] Tipo: "Ganho" ou "Gasto"
- [ ] Valor (grande, colorido)
- [ ] Data e hora

### 9.3 Informações Detalhadas
**Lista de itens:**
- [ ] Data: "29/12/2024"
- [ ] Categoria: "Combustível" (se gasto)
- [ ] Plataforma: "Uber" (se ganho)
- [ ] Descrição: "Gasolina comum"
- [ ] Litros: "30L" (se combustível)
- [ ] Corridas: "12" (se ganho)
- [ ] Horas: "8h" (se ganho)
- [ ] Observações: "..."

### 9.4 Foto do Recibo (se houver)
**Componentes:**
- [ ] Imagem do recibo (clicável para ampliar)
- [ ] Botão para adicionar foto (se não tiver)

### 9.5 Botões de Ação
- [ ] **Botão Editar** (primário)
- [ ] **Botão Excluir** (secundário, vermelho)

---

## 📱 ETAPA 10: TELA DE RELATÓRIOS

### 10.1 Header
**Componentes:**
- [ ] Título: "Relatórios"
- [ ] Dropdown de período:
  - Hoje
  - Esta Semana
  - Este Mês
  - Personalizado

### 10.2 Cards de Resumo (3 cards horizontais)

**Card 1: Total de Ganhos**
- [ ] Ícone: trending_up (verde)
- [ ] Label: "Total de Ganhos"
- [ ] Valor: "R$ 2.450,00"
- [ ] Variação: "+15% vs mês anterior"

**Card 2: Total de Gastos**
- [ ] Ícone: trending_down (laranja)
- [ ] Label: "Total de Gastos"
- [ ] Valor: "R$ 850,00"
- [ ] Variação: "+5% vs mês anterior"

**Card 3: Lucro Líquido**
- [ ] Ícone: account_balance_wallet (verde/vermelho)
- [ ] Label: "Lucro Líquido"
- [ ] Valor: "R$ 1.600,00"
- [ ] Variação: "+25% vs mês anterior"

### 10.3 Gráfico Principal: Ganhos vs Gastos
**Componentes:**
- [ ] Título: "Evolução Mensal"
- [ ] Gráfico de linhas:
  - Linha verde: Ganhos
  - Linha laranja: Gastos
  - Linha azul: Lucro
- [ ] Eixo X: Dias do mês
- [ ] Eixo Y: Valores em R$
- [ ] Legenda
- [ ] Tooltip ao tocar

### 10.4 Métricas Adicionais (Grid 2x2)

**Card 1: Ganho Médio Diário**
- [ ] Ícone: calendar_today
- [ ] Label: "Média/Dia"
- [ ] Valor: "R$ 350,00"

**Card 2: Gasto Médio Diário**
- [ ] Ícone: shopping_cart
- [ ] Label: "Gasto/Dia"
- [ ] Valor: "R$ 85,00"

**Card 3: Dias Trabalhados**
- [ ] Ícone: work
- [ ] Label: "Dias Ativos"
- [ ] Valor: "22 dias"

**Card 4: Maior Ganho**
- [ ] Ícone: star
- [ ] Label: "Melhor Dia"
- [ ] Valor: "R$ 520,00"

### 10.5 Gastos por Categoria (Gráfico)
**Componentes:**
- [ ] Título: "Gastos por Categoria"
- [ ] Gráfico de pizza/donut
- [ ] Cores por categoria
- [ ] Legenda com valores e percentuais
- [ ] Lista detalhada abaixo:
  - Combustível: R$ 500,00 (58%)
  - Manutenção: R$ 200,00 (24%)
  - Lavagem: R$ 80,00 (9%)
  - Outros: R$ 70,00 (9%)

### 10.6 Botão de Exportar
**Componentes:**
- [ ] Botão flutuante (FAB)
- [ ] Ícone: download
- [ ] Ação: Abrir opções:
  - Exportar PDF
  - Exportar Excel
  - Compartilhar

---

## 📱 ETAPA 11: TELA RELATÓRIO DIÁRIO DETALHADO

### 11.1 Header
**Componentes:**
- [ ] Botão voltar
- [ ] Título: "Relatório do Dia"
- [ ] Data selecionada
- [ ] Setas para navegar entre dias (< >)

### 11.2 Resumo do Dia (Card grande)
**Componentes:**
- [ ] Data completa: "Sexta, 29 de Dezembro de 2024"
- [ ] 3 valores principais:
  - Ganhos: R$ 450,00 (verde)
  - Gastos: R$ 80,00 (laranja)
  - Lucro: R$ 370,00 (grande, centro)

### 11.3 Detalhes das Transações
**Duas seções:**

**Seção 1: Ganhos do Dia**
- [ ] Título: "Ganhos"
- [ ] Lista de todos os ganhos
- [ ] Total: "R$ 450,00"

**Seção 2: Gastos do Dia**
- [ ] Título: "Gastos"
- [ ] Lista de todos os gastos
- [ ] Total: "R$ 80,00"

### 11.4 Estatísticas do Dia (Cards)
- [ ] Horas trabalhadas: "8h"
- [ ] Ganho por hora: "R$ 56,25/h"
- [ ] Corridas realizadas: "15"
- [ ] Km rodados: "120 km"

---

## 📱 ETAPA 12: TELA RELATÓRIO MENSAL

### 12.1 Header
**Componentes:**
- [ ] Botão voltar
- [ ] Título: "Relatório Mensal"
- [ ] Mês/Ano selecionado
- [ ] Setas para navegar entre meses (< >)

### 12.2 Resumo do Mês (Card destacado)
**Componentes:**
- [ ] Mês: "Dezembro 2024"
- [ ] Total de Ganhos: "R$ 9.450,00"
- [ ] Total de Gastos: "R$ 2.850,00"
- [ ] Lucro Líquido: "R$ 6.600,00" (grande, centro)
- [ ] Badge: "🎉 Melhor mês!"

### 12.3 Gráfico de Barras
**Componentes:**
- [ ] Título: "Ganhos e Gastos Diários"
- [ ] Gráfico de barras agrupadas:
  - Barra verde: Ganhos
  - Barra laranja: Gastos
- [ ] Eixo X: Dias do mês (1-31)
- [ ] Eixo Y: Valores
- [ ] Scroll horizontal

### 12.4 Métricas do Mês (Grid)
**6 Cards:**

- [ ] **Dias Trabalhados**
  - Ícone: calendar_today
  - Valor: "22 dias"

- [ ] **Média Diária**
  - Ícone: trending_up
  - Valor: "R$ 429,00"

- [ ] **Total de Corridas**
  - Ícone: local_taxi
  - Valor: "380 corridas"

- [ ] **Média por Corrida**
  - Ícone: attach_money
  - Valor: "R$ 24,87"

- [ ] **Melhor Dia**
  - Ícone: star
  - Valor: "R$ 650,00"

- [ ] **Pior Dia**
  - Ícone: trending_down
  - Valor: "R$ 180,00"

### 12.5 Análise de Gastos
**Componentes:**
- [ ] Título: "Distribuição de Gastos"
- [ ] Gráfico de pizza
- [ ] Lista de categorias com valores

### 12.6 Comparação com Mês Anterior
**Card:**
- [ ] Título: "Comparação"
- [ ] Ganhos: +15% ↑ (verde)
- [ ] Gastos: -5% ↓ (verde)
- [ ] Lucro: +22% ↑ (verde)

---

## 📱 ETAPA 13: TELA DE PERFIL/CONFIGURAÇÕES

### 13.1 Header
**Componentes:**
- [ ] Botão voltar
- [ ] Título: "Perfil"

### 13.2 Card do Usuário
**Componentes:**
- [ ] Avatar grande (editável)
- [ ] Nome do motorista
- [ ] Membro desde: "Dezembro 2024"
- [ ] Botão "Editar Perfil"

### 13.3 Estatísticas Rápidas (3 cards)
- [ ] Total Ganho: "R$ 45.000,00"
- [ ] Total Gasto: "R$ 12.000,00"
- [ ] Lucro Total: "R$ 33.000,00"

### 13.4 Menu de Opções
**Lista de opções:**

- [ ] **Metas**
  - Ícone: flag
  - Subtítulo: "Definir metas mensais"
  - Ação: Navegar para tela de metas

- [ ] **Categorias**
  - Ícone: category
  - Subtítulo: "Gerenciar categorias de gastos"
  - Ação: Navegar para gerenciar categorias

- [ ] **Backup**
  - Ícone: cloud_upload
  - Subtítulo: "Fazer backup dos dados"
  - Ação: Fazer backup

- [ ] **Exportar Dados**
  - Ícone: download
  - Subtítulo: "Exportar relatórios"
  - Ação: Exportar

- [ ] **Tema**
  - Ícone: palette
  - Subtítulo: "Escuro"
  - Ação: Toggle tema

- [ ] **Notificações**
  - Ícone: notifications
  - Subtítulo: "Gerenciar notificações"
  - Ação: Configurações de notificação

- [ ] **Ajuda**
  - Ícone: help
  - Subtítulo: "Central de ajuda"
  - Ação: Mostrar ajuda

- [ ] **Sobre**
  - Ícone: info
  - Subtítulo: "Versão 1.0.0"
  - Ação: Mostrar informações do app

### 13.5 Botão Sair
- [ ] Botão vermelho: "Sair"
- [ ] Confirmar logout

---

## 📱 ETAPA 14: TELA DE EDITAR PERFIL

### 14.1 Header
**Componentes:**
- [ ] Botão voltar
- [ ] Título: "Editar Perfil"
- [ ] Botão salvar

### 14.2 Formulário
**Campos:**

- [ ] **Foto**
  - Avatar grande (centro)
  - Botão "Alterar Foto"
  - Ação: Câmera ou Galeria

- [ ] **Nome**
  - Label: "Nome completo"
  - Campo: TextField
  - Ícone: person

- [ ] **Email** (Opcional)
  - Label: "Email"
  - Campo: TextField
  - Ícone: email

- [ ] **Telefone** (Opcional)
  - Label: "Telefone"
  - Campo: TextField com máscara
  - Ícone: phone

- [ ] **Meta Mensal**
  - Label: "Meta de ganho mensal"
  - Campo: TextField numérico
  - Placeholder: "R$ 0,00"
  - Ícone: flag

### 14.3 Botões
- [ ] Salvar (primário)
- [ ] Cancelar (secundário)

---

## 📱 ETAPA 15: TELA DE METAS

### 15.1 Header
**Componentes:**
- [ ] Botão voltar
- [ ] Título: "Minhas Metas"

### 15.2 Card de Meta Mensal
**Componentes:**
- [ ] Título: "Meta de Dezembro"
- [ ] Valor da meta: "R$ 10.000,00"
- [ ] Progresso visual (barra)
- [ ] Valor atual: "R$ 6.600,00"
- [ ] Percentual: "66%"
- [ ] Dias restantes: "3 dias"
- [ ] Botão "Editar Meta"

### 15.3 Previsão
**Card:**
- [ ] Título: "Previsão de Atingimento"
- [ ] Texto: "Você precisa ganhar R$ 113,33 por dia"
- [ ] Ícone de status:
  - ✓ No caminho certo (verde)
  - ⚠ Atenção (amarelo)
  - ✗ Abaixo da meta (vermelho)

### 15.4 Histórico de Metas
**Lista:**
- [ ] Meses anteriores
- [ ] Status: Atingida/Não atingida
- [ ] Percentual atingido

---

## 📱 ETAPA 16: TELA DE FILTROS/BUSCA

### 16.1 Header
**Componentes:**
- [ ] Botão voltar
- [ ] Título: "Filtrar"
- [ ] Botão "Limpar"

### 16.2 Opções de Filtro
**Seções:**

- [ ] **Período**
  - Radio buttons:
    - Hoje
    - Esta semana
    - Este mês
    - Último mês
    - Personalizado (DateRange)

- [ ] **Tipo**
  - Checkboxes:
    - Ganhos
    - Gastos

- [ ] **Categoria** (para gastos)
  - Checkboxes:
    - Combustível
    - Manutenção
    - Lavagem
    - Estacionamento
    - Pedágio
    - Outros

- [ ] **Plataforma** (para ganhos)
  - Checkboxes:
    - Uber
    - 99
    - InDrive
    - Outros

- [ ] **Valor**
  - Slider com range:
    - Mínimo: R$ 0
    - Máximo: R$ 1000

### 16.3 Botões
- [ ] Aplicar Filtros (primário)
- [ ] Cancelar (secundário)

---

## 📱 ETAPA 17: DIALOGS E MODAIS

### 17.1 Dialog de Confirmação de Exclusão
**Componentes:**
- [ ] Ícone de alerta (vermelho)
- [ ] Título: "Excluir [Ganho/Gasto]?"
- [ ] Texto: "Esta ação não pode ser desfeita"
- [ ] Botão "Cancelar" (secundário)
- [ ] Botão "Excluir" (vermelho)

### 17.2 Modal de Sucesso
**Componentes:**
- [ ] Ícone de check (verde)
- [ ] Título: "Salvo com sucesso!"
- [ ] Botão "OK"
- [ ] Auto-fechar em 2s

### 17.3 Modal de Erro
**Componentes:**
- [ ] Ícone de erro (vermelho)
- [ ] Título: "Ops! Algo deu errado"
- [ ] Mensagem de erro
- [ ] Botão "Tentar novamente"
- [ ] Botão "Fechar"

### 17.4 Bottom Sheet de Opções
**Para ações em itens da lista:**
- [ ] Ver detalhes
- [ ] Editar
- [ ] Duplicar
- [ ] Excluir

### 17.5 Bottom Sheet de Exportar
**Opções:**
- [ ] PDF
- [ ] Excel
- [ ] Compartilhar

---

## 📱 ETAPA 18: COMPONENTES REUTILIZÁVEIS ✅

### 18.1 Cards Customizados

**SummaryCard** ✅
```dart
- Ícone (colorido)
- Label (texto)
- Valor (grande)
- Variação (opcional)
- OnTap
```

**TransactionCard** ✅
```dart
- Ícone da categoria
- Título
- Descrição
- Valor (colorido)
- Data
- Menu de ações
```

**StatCard**
```dart
- Ícone
- Label
- Valor
- Subtítulo (opcional)
```

**AppCard** ✅
```dart
- Container customizado
- Padding e bordas
- Background colorido
- Elevação
```

**AppBottomNav** ✅
```dart
- 5 ícones de navegação
- Estado selecionado
- Navegação entre telas
```

**AppAvatar** ✅
```dart
- Avatar circular
- Iniciais ou imagem
- Tamanhos variados
```

### 18.2 Botões Customizados

**PrimaryButton** ✅
```dart
- Texto
- Ícone (opcional)
- OnPressed
- Loading state
- Disabled state
```

**SecondaryButton** ✅
```dart
- Texto
- Ícone (opcional)
- OnPressed
- Outlined style
```

**IconButton**
```dart
- Ícone
- OnPressed
- Background circular
- Cor customizável
```

### 18.3 Input Fields

**AppTextField** ✅
```dart
- Label
- Hint
- Ícone prefix
- Ícone suffix
- Tipo de teclado
- Validação
- Máscara (opcional)
```

**AppDatePicker**
```dart
- Label
- Data selecionada
- OnDateSelected
- Data mínima/máxima
```

**AppDropdown**
```dart
- Label
- Opções (lista)
- Valor selecionado
- OnChanged
- Ícone
```

### 18.4 Chips e Tags

**SelectableChip** ✅ (AppChip)
```dart
- Label
- Ícone (opcional)
- IsSelected
- OnTap
- Cor quando selecionado
```

**CategoryChip**
```dart
- Categoria
- Cor da categoria
- Ícone
- OnTap
```

### 18.5 Gráficos

**LineChart**
```dart
- Dados (lista)
- Cor das linhas
- Título
- Legenda
- Tooltip
```

**BarChart**
```dart
- Dados (lista)
- Cores
- Título
- Eixos
```

**PieChart**
```dart
- Dados (lista)
- Cores
- Legenda
- Percentuais
```

### 18.6 Listas

**EmptyState**
```dart
- Ilustração
- Título
- Subtítulo
- Botão de ação
```

**LoadingState**
```dart
- Shimmer cards
- Loading indicator
```

**ErrorState**
```dart
- Ícone de erro
- Mensagem
- Botão "Tentar novamente"
```

---

## 📱 ETAPA 19: NAVEGAÇÃO E FLUXOS ✅

### 19.1 Bottom Navigation ✅
**5 Telas principais:**
1. ✅ Home → HomeScreen
2. ✅ Ganhos → EarningsListScreen
3. ✅ Gastos → ExpensesListScreen
4. ✅ Relatórios → ReportsScreen
5. ✅ Perfil → ProfileScreen

### 19.2 Fluxos de Navegação

**Fluxo 1: Adicionar Ganho** ✅
```
Home → Tap "Adicionar Ganho" → AddEarningScreen → Salvar → Home (atualizada)
```

**Fluxo 2: Adicionar Gasto** ✅
```
Home → Tap "Adicionar Gasto" → AddExpenseScreen → Salvar → Home (atualizada)
```

**Fluxo 3: Ver Detalhes**
```
Lista → Tap no item → DetailScreen → Editar → EditScreen → Salvar → Lista
```

**Fluxo 4: Ver Relatórios**
```
Home → Relatórios → Filtrar período → Ver gráficos → Exportar
```

### 19.3 Transições
- Slide from right (push)
- Slide from bottom (modal)
- Fade (dialogs)
- Scale (popups)

---

## 📱 ETAPA 20: ANIMAÇÕES

### 20.1 Animações de Entrada
- [ ] FadeIn nos cards
- [ ] SlideIn nos itens de lista
- [ ] Scale nos botões
- [ ] Staggered na lista inicial

### 20.2 Animações de Interação
- [ ] Ripple effect nos botões
- [ ] Bounce nos ícones
- [ ] Shake nos erros de validação
- [ ] Expand/Collapse em cards

### 20.3 Animações de Transição
- [ ] Hero animation em valores
- [ ] Shared element (imagens)
- [ ] Page transitions
- [ ] Bottom sheet slide up

### 20.4 Loading States
- [ ] Circular progress
- [ ] Linear progress
- [ ] Shimmer skeleton
- [ ] Pulse effect

---

## 📱 ETAPA 21: RESPONSIVIDADE

### 21.1 Breakpoints
```dart
Mobile: < 600px
Tablet: 600px - 900px
Desktop: > 900px
```

### 21.2 Adaptações
- [ ] Grid de 2 colunas em tablets
- [ ] Sidebar em desktop
- [ ] Floating action buttons em mobile
- [ ] App bar adaptável
- [ ] Font sizes responsivas

---

## 🎨 ETAPA 22: TEMAS

### 22.1 Tema Escuro (Padrão)
```dart
background: #0A1128
surface: #1E293B
text: #FFFFFF
```

### 22.2 Tema Claro (Opcional)
```dart
background: #F8FAFC
surface: #FFFFFF
text: #0F172A
```

### 22.3 Cores de Acento
- Verde: Sucesso/Ganhos
- Laranja: Atenção/Gastos
- Vermelho: Erro/Prejuízo
- Azul: Info/Neutro

---

## 📱 ETAPA 23: ACESSIBILIDADE

### 23.1 Contrast Ratio
- [ ] Textos com contraste mínimo de 4.5:1
- [ ] Ícones com contraste mínimo de 3:1

### 23.2 Tamanhos
- [ ] Touch targets mínimo de 48x48dp
- [ ] Fonte mínima de 12sp
- [ ] Espaçamento adequado entre elementos

### 23.3 Semantics
- [ ] Labels em todos os inputs
- [ ] Descrições em ícones
- [ ] Feedback sonoro (opcional)
- [ ] Screen reader support

---

## ✅ CHECKLIST FINAL DE TELAS

### Telas Obrigatórias
- [x] Splash Screen
- [x] Onboarding (3 telas)
- [x] Home/Dashboard
- [x] Adicionar Ganho
- [x] Adicionar Gasto
- [x] Lista de Ganhos
- [x] Lista de Gastos
- [ ] Detalhes (Ganho/Gasto)
- [ ] Relatórios Gerais
- [ ] Relatório Diário
- [ ] Relatório Mensal
- [x] Perfil/Configurações
- [ ] Editar Perfil
- [ ] Metas

### Telas Opcionais
- [ ] Busca/Filtros
- [ ] Categorias personalizadas
- [ ] Backup/Restore
- [ ] Tutorial/Ajuda
- [ ] Sobre o app

---

## 📊 RESUMO DE COMPONENTES POR TELA

### Home (15 componentes)
- Header (3)
- Cards de resumo (3)
- Botões de ação (4)
- Gráfico (1)
- Lista recente (1)
- Bottom nav (1)

### Add Earning/Expense (8 componentes)
- Header (2)
- Form fields (5-7)
- Botões (2)

### Lists (10 componentes)
- Header (2)
- Filtros (2)
- Resumo (1)
- Lista (1)
- Cards de item (vários)
- Empty state (1)

### Reports (12 componentes)
- Header (2)
- Cards de resumo (3)
- Gráficos (2-3)
- Métricas (4)
- Botão exportar (1)

---

## 🚀 ORDEM DE DESENVOLVIMENTO SUGERIDA

### Semana 1-2: Setup e Fundação ✅
1. ✅ Setup do projeto
2. ✅ Design system (cores, tipografia, espaçamentos)
3. ✅ Componentes base (botões, cards, inputs)
4. ✅ Bottom navigation
5. ✅ Splash e Onboarding

### Semana 3-4: Telas Principais ✅
6. ✅ Home/Dashboard (estrutura básica)
7. ✅ Adicionar Ganho (formulário)
8. ✅ Adicionar Gasto (formulário)
9. ✅ Lista de Ganhos (básica)
10. ✅ Lista de Gastos (básica)

### Semana 5-6: Refinamento
11. Detalhes de transação
12. Editar transação
13. Filtros e busca
14. Gráficos básicos
15. Relatório simples

### Semana 7-8: Avançado
16. Relatórios completos
17. Tela de perfil
18. Metas
19. Exportação
20. Animações

### Semana 9-10: Polimento
21. Estados de loading
22. Estados de erro
23. Empty states
24. Responsividade
25. Acessibilidade
26. Testes visuais

---

## 🎯 MÉTRICAS DE SUCESSO

### Performance
- Carregamento inicial < 2s
- Navegação fluida (60fps)
- Sem lags em scroll

### UX
- Máximo 3 taps para qualquer ação
- Feedback visual em todas as ações
- Validação em tempo real
- Mensagens de erro claras

---

**TOTAL DE TELAS:** 14 telas principais
**TOTAL DE COMPONENTES:** ~50 componentes reutilizáveis
**TEMPO ESTIMADO:** 8-10 semanas para frontend completo

