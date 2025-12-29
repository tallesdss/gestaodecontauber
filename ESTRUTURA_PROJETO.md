# 📁 Estrutura do Projeto UberControl

## ✅ Estrutura Criada

```
gestaodecontauber/
├── lib/
│   ├── core/                          # Funcionalidades core do app
│   │   ├── constants/
│   │   │   └── app_constants.dart      # Constantes do app
│   │   ├── theme/                       # Sistema de design
│   │   ├── app_colors.dart            # Paleta de cores
│   │   ├── app_typography.dart         # Tipografia
│   │   ├── app_spacing.dart           # Espaçamentos
│   │   ├── app_radius.dart             # Border radius
│   │   └── app_theme.dart              # Tema do app
│   ├── utils/                          # Utilitários
│   │   ├── date_formatter.dart        # Formatação de datas
│   │   └── currency_formatter.dart    # Formatação de moeda
│   ├── widgets/                        # Widgets base reutilizáveis
│   │   ├── app_button.dart            # Botão customizado
│   │   ├── app_card.dart              # Card customizado
│   │   └── app_text_field.dart        # Campo de texto customizado
│   │
│   ├── features/                       # Features organizadas por funcionalidade
│   │   ├── splash/
│   │   │   └── splash_screen.dart     # Tela de splash (placeholder)
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart # Tela de onboarding (placeholder)
│   │   ├── home/
│   │   │   └── home_screen.dart       # Tela home/dashboard (placeholder)
│   │   ├── earnings/
│   │   │   ├── earnings_list_screen.dart    # Lista de ganhos (placeholder)
│   │   │   └── add_earning_screen.dart     # Adicionar ganho (placeholder)
│   │   ├── expenses/
│   │   │   ├── expenses_list_screen.dart    # Lista de gastos (placeholder)
│   │   │   └── add_expense_screen.dart      # Adicionar gasto (placeholder)
│   │   ├── reports/
│   │   │   └── reports_screen.dart    # Relatórios (placeholder)
│   │   └── profile/
│   │       └── profile_screen.dart    # Perfil (placeholder)
│   │
│   ├── shared/                         # Componentes compartilhados
│   │   ├── models/
│   │   │   ├── driver.dart            # Modelo do motorista
│   │   │   ├── earning.dart           # Modelo de ganho
│   │   │   └── expense.dart           # Modelo de gasto
│   │   └── services/
│   │       ├── database_service.dart  # Serviço de banco (placeholder)
│   │       └── storage_service.dart   # Serviço de storage (placeholder)
│   │
│   ├── routes/
│   │   └── app_router.dart           # Configuração de rotas
│   │
│   └── main.dart                      # Entry point do app
│
├── pubspec.yaml                       # Dependências do projeto
├── analysis_options.yaml              # Configurações do linter
├── .gitignore                         # Arquivos ignorados pelo git
├── README.md                          # Documentação do projeto
└── ESTRUTURA_PROJETO.md               # Este arquivo
```

## 📦 Dependências Configuradas

### Principais
- **provider**: Gerenciamento de estado
- **go_router**: Navegação
- **sqflite**: Banco de dados local
- **shared_preferences**: Armazenamento de preferências
- **intl**: Formatação de datas e moedas
- **google_fonts**: Fontes personalizadas
- **fl_chart**: Gráficos
- **image_picker**: Seleção de imagens
- **pdf/excel**: Exportação de relatórios

### UI e Animações
- **shimmer**: Efeitos de loading
- **flutter_staggered_animations**: Animações
- **cached_network_image**: Cache de imagens

## 🎨 Sistema de Design

### Cores
- **Primary**: Verde (#10B981) - Ganhos/Lucro
- **Secondary**: Vermelho (#EF4444) - Gastos/Despesas
- **Accent**: Azul (#3B82F6) - Neutro/Info
- **Background**: Escuro (#0A1128)
- **Surface**: Cards (#1E293B)

### Tipografia
- Fonte: Inter (via Google Fonts)
- Hierarquia: h1, h2, h3, h4, h5, body, label, button, caption

### Espaçamentos
- xs: 4px
- sm: 8px
- md: 12px
- lg: 16px
- xl: 20px
- xxl: 24px
- xxxl: 32px

## 📱 Features (Placeholders Criados)

Todas as telas foram criadas como placeholders com comentários TODO:
- ✅ Splash Screen
- ✅ Onboarding
- ✅ Home/Dashboard
- ✅ Ganhos (Lista e Adicionar)
- ✅ Gastos (Lista e Adicionar)
- ✅ Relatórios
- ✅ Perfil

## 🗄️ Modelos de Dados

### Earning (Ganho)
- id, date, value, platform, numberOfRides, hoursWorked, notes

### Expense (Gasto)
- id, date, category, value, description, liters, receiptImagePath, notes

### Driver (Motorista)
- name, monthlyGoal, memberSince

## 🚀 Próximos Passos

1. **Instalar dependências:**
   ```bash
   flutter pub get
   ```

2. **Implementar telas conforme roadmap:**
   - Começar pela Splash e Onboarding
   - Depois Home/Dashboard
   - Em seguida, formulários de Ganhos e Gastos

3. **Implementar serviços:**
   - DatabaseService para SQLite
   - StorageService para SharedPreferences

4. **Criar componentes reutilizáveis:**
   - Bottom Navigation
   - Charts
   - Empty States
   - Loading States

## 📝 Notas

- Todos os arquivos de telas estão como placeholders com comentários TODO
- A estrutura está pronta para receber a implementação das telas
- O sistema de design está completo e pronto para uso
- Os modelos de dados estão definidos e prontos para uso

