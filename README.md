# 🚗 UberControl

App de controle financeiro para motoristas com foco em:
- Registrar ganhos diários
- Registrar gastos
- Ver relatórios e análises

## 📱 Estrutura do Projeto

```
lib/
├── core/                    # Funcionalidades core do app
│   ├── theme/              # Tema e cores
│   ├── constants/          # Constantes do app
│   ├── utils/              # Utilitários
│   └── widgets/            # Widgets base reutilizáveis
├── features/               # Features organizadas por funcionalidade
│   ├── home/               # Tela home/dashboard
│   ├── earnings/           # Funcionalidades de ganhos
│   ├── expenses/           # Funcionalidades de gastos
│   ├── reports/            # Relatórios
│   ├── profile/            # Perfil e configurações
│   ├── onboarding/         # Onboarding
│   └── splash/             # Splash screen
├── shared/                 # Componentes compartilhados
│   ├── models/            # Modelos de dados
│   ├── widgets/           # Widgets compartilhados
│   └── services/          # Serviços compartilhados
├── routes/                 # Configuração de rotas
└── main.dart              # Entry point
```

## 🚀 Como executar

```bash
flutter pub get
flutter run
```

## 📚 Documentação

- [Roadmap Frontend](./ubercontrolfrontendroadmap.md)
- [Design System](./Designsystem.md)






