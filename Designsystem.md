# Design System - Travel Explorer App

## 📋 Índice
1. [Visão Geral](#visão-geral)
2. [Cores](#cores)
3. [Tipografia](#tipografia)
4. [Espaçamentos](#espaçamentos)
5. [Componentes](#componentes)
6. [Exemplos de Uso](#exemplos-de-uso)
7. [Boas Práticas](#boas-práticas)

---

## 🎨 Visão Geral

Este design system foi criado para manter consistência visual e facilitar o desenvolvimento de novas telas no app Travel Explorer. Todos os componentes seguem as mesmas diretrizes de design.

### Princípios do Design
- **Consistência**: Mesmos padrões visuais em todo o app
- **Reutilização**: Componentes prontos para uso
- **Flexibilidade**: Fácil personalização quando necessário
- **Acessibilidade**: Cores e contrastes adequados

---

## 🎨 Cores

### Como usar
```dart
import '../core/theme/app_theme.dart';

// Cores primárias
Container(color: AppColors.primary)
Container(color: AppColors.primaryLight)
Container(color: AppColors.primaryDark)

// Cores de fundo
Container(color: AppColors.backgroundDark)
Container(color: AppColors.surface)

// Cores de texto
Text('Hello', style: TextStyle(color: AppColors.textPrimary))
Text('Hello', style: TextStyle(color: AppColors.textSecondary))
```

### Paleta Completa

#### Primary Colors
- `AppColors.primary` - #2563EB (Azul principal)
- `AppColors.primaryLight` - #3B82F6
- `AppColors.primaryDark` - #1E40AF

#### Background Colors
- `AppColors.backgroundDark` - #0A1128 (Fundo escuro)
- `AppColors.backgroundMedium` - #1E293B
- `AppColors.surface` - #1E293B (Cards e superfícies)

#### Text Colors
- `AppColors.textPrimary` - #FFFFFF (100%)
- `AppColors.textSecondary` - #FFFFFF (70%)
- `AppColors.textTertiary` - #FFFFFF (50%)

#### Accent Colors
- `AppColors.accent` - #10B981 (Verde)
- `AppColors.warning` - #F59E0B (Amarelo)
- `AppColors.error` - #EF4444 (Vermelho)
- `AppColors.info` - #06B6D4 (Ciano)

### Gradientes

```dart
// Gradiente de fundo
Container(
  decoration: BoxDecoration(
    gradient: AppGradients.background,
  ),
)

// Gradiente em botões
Container(
  decoration: BoxDecoration(
    gradient: AppGradients.primary,
  ),
)
```

---

## ✍️ Tipografia

### Hierarquia de Textos

```dart
// Títulos grandes
Text('Welcome', style: AppTypography.h1) // 32px, bold
Text('Section', style: AppTypography.h2) // 28px, bold
Text('Title', style: AppTypography.h3)    // 24px, bold

// Corpo de texto
Text('Content', style: AppTypography.bodyLarge)  // 16px
Text('Content', style: AppTypography.bodyMedium) // 14px
Text('Content', style: AppTypography.bodySmall)  // 12px

// Labels e botões
Text('Label', style: AppTypography.labelLarge)  // 14px, semibold
Text('Button', style: AppTypography.button)     // 16px, semibold

// Legendas
Text('Caption', style: AppTypography.caption)   // 12px, tertiary
```

### Personalização

```dart
// Modificar cor
Text(
  'Custom text',
  style: AppTypography.h1.copyWith(
    color: AppColors.primary,
  ),
)

// Modificar peso
Text(
  'Bold text',
  style: AppTypography.bodyMedium.copyWith(
    fontWeight: FontWeight.bold,
  ),
)
```

---

## 📏 Espaçamentos

### Sistema de Espaçamento

```dart
// Tamanhos disponíveis
AppSpacing.xs    // 4px
AppSpacing.sm    // 8px
AppSpacing.md    // 12px
AppSpacing.lg    // 16px
AppSpacing.xl    // 20px
AppSpacing.xxl   // 24px
AppSpacing.xxxl  // 32px
```

### Padding Presets

```dart
// Padding em todos os lados
Container(padding: AppSpacing.paddingLG)  // 16px em todos os lados

// Padding horizontal
Container(padding: AppSpacing.horizontalLG)  // 16px esquerda/direita

// Padding vertical
Container(padding: AppSpacing.verticalLG)    // 16px topo/fundo
```

### Border Radius

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: AppRadius.radiusLG,  // 16px
  ),
)

// Opções disponíveis
AppRadius.radiusSM    // 8px
AppRadius.radiusMD    // 12px
AppRadius.radiusLG    // 16px
AppRadius.radiusXL    // 20px
AppRadius.radiusRound // 100px (circular)
```

---

## 🧩 Componentes

### 1. Botões

#### Botão Principal
```dart
AppButton(
  text: 'Search Flight',
  icon: Icons.flight_takeoff,
  onPressed: () {
    // Ação
  },
)
```

#### Botão com Loading
```dart
AppButton(
  text: 'Loading...',
  isLoading: true,
  onPressed: () {},
)
```

#### Botão Outline
```dart
AppButton(
  text: 'Cancel',
  isOutlined: true,
  onPressed: () {},
)
```

#### Tamanhos
```dart
AppButton(
  text: 'Large',
  size: ButtonSize.large,    // 56px altura
  onPressed: () {},
)

AppButton(
  text: 'Medium',
  size: ButtonSize.medium,   // 48px altura
  onPressed: () {},
)

AppButton(
  text: 'Small',
  size: ButtonSize.small,    // 40px altura
  onPressed: () {},
)
```

### 2. Cards

#### Card Básico
```dart
AppCard(
  child: Text('Content'),
  onTap: () {
    // Ação ao tocar
  },
)
```

#### Location Card
```dart
LocationCard(
  label: 'From',
  code: 'CDG',
  location: 'Paris, Charles de Gaulle',
  showSwapButton: true,
  onSwap: () {},
  onTap: () {},
)
```

#### Info Card
```dart
InfoCard(
  icon: Icons.calendar_today_outlined,
  title: 'Departure',
  subtitle: 'March 12, Sat',
  onTap: () {},
)
```

### 3. Chips/Tags

```dart
AppChip(
  label: 'One-Way',
  isSelected: true,
  onTap: () {},
)

// Com ícone
AppChip(
  label: 'Business',
  icon: Icons.business,
  isSelected: false,
  onTap: () {},
)
```

### 4. Text Fields

```dart
AppTextField(
  label: 'Email',
  hint: 'Enter your email',
  prefixIcon: Icons.email,
  onChanged: (value) {
    print(value);
  },
)
```

### 5. Avatar

```dart
// Com imagem
AppAvatar(
  imageUrl: 'https://example.com/avatar.jpg',
  size: 45,
  onTap: () {},
)

// Com iniciais
AppAvatar(
  initials: 'JP',
  size: 45,
)
```

### 6. App Bar

```dart
AppTopBar(
  title: 'Flights',
  showBackButton: true,
  actions: [
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () {},
    ),
  ],
)
```

### 7. Bottom Navigation

```dart
AppBottomNav(
  currentIndex: 0,
  onTap: (index) {
    // Mudar página
  },
  items: [
    AppBottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    AppBottomNavItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Search',
    ),
    AppBottomNavItem(
      icon: Icons.person_outlined,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ],
)
```

### 8. Loading

```dart
// Loading padrão
AppLoading()

// Loading customizado
AppLoading(
  size: 60,
  color: AppColors.accent,
)
```

### 9. Badge

```dart
AppBadge(
  label: 'New',
  backgroundColor: AppColors.error,
)
```

---

## 💡 Exemplos de Uso

### Exemplo 1: Tela de Lista de Voos

```dart
class FlightListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.background,
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppTopBar(
                title: 'Available Flights',
                showBackButton: true,
              ),
              Expanded(
                child: ListView.builder(
                  padding: AppSpacing.paddingXL,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.lg),
                      child: _buildFlightCard(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFlightCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('American Airlines', style: AppTypography.h5),
              AppBadge(label: 'Best Price'),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _buildTimeInfo('CDG', '10:30'),
              ),
              Icon(Icons.flight_takeoff, color: AppColors.primary),
              Expanded(
                child: _buildTimeInfo('JFK', '14:45'),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '4h 15min',
                style: AppTypography.caption,
              ),
              Text(
                '\$450',
                style: AppTypography.h4.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        // Ver detalhes do voo
      },
    );
  }
  
  Widget _buildTimeInfo(String code, String time) {
    return Column(
      children: [
        Text(code, style: AppTypography.h4),
        SizedBox(height: AppSpacing.xs),
        Text(time, style: AppTypography.caption),
      ],
    );
  }
}
```

### Exemplo 2: Tela de Perfil

```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.background,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingXL,
            child: Column(
              children: [
                AppTopBar(title: 'Profile'),
                SizedBox(height: AppSpacing.xxxl),
                
                // Avatar
                AppAvatar(
                  imageUrl: 'https://i.pravatar.cc/150',
                  size: 100,
                ),
                SizedBox(height: AppSpacing.lg),
                
                // Nome
                Text('John Doe', style: AppTypography.h2),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'john.doe@email.com',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.xxxl),
                
                // Opções
                _buildOptionCard(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () {},
                ),
                SizedBox(height: AppSpacing.lg),
                
                _buildOptionCard(
                  icon: Icons.favorite_outline,
                  title: 'Favorite Destinations',
                  onTap: () {},
                ),
                SizedBox(height: AppSpacing.lg),
                
                _buildOptionCard(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {},
                ),
                SizedBox(height: AppSpacing.xxxl),
                
                // Botão de logout
                AppButton(
                  text: 'Logout',
                  isOutlined: true,
                  onPressed: () {},
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: AppRadius.radiusMD,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              title,
              style: AppTypography.labelLarge,
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}
```

### Exemplo 3: Modal de Seleção

```dart
void showPassengerSelector(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
        ),
        padding: AppSpacing.paddingXXL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: AppRadius.radiusRound,
              ),
            ),
            SizedBox(height: AppSpacing.xxl),
            
            // Título
            Text(
              'Select Passengers',
              style: AppTypography.h3,
            ),
            SizedBox(height: AppSpacing.xxl),
            
            // Opções
            _buildPassengerOption('Adults', '12+ years', 1),
            AppDivider(),
            _buildPassengerOption('Children', '2-11 years', 0),
            AppDivider(),
            _buildPassengerOption('Infants', 'Under 2 years', 0),
            
            SizedBox(height: AppSpacing.xxl),
            
            // Botão confirmar
            AppButton(
              text: 'Confirm',
              onPressed: () {
                Navigator.pop(context);
              },
              width: double.infinity,
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildPassengerOption(String title, String subtitle, int count) {
  return Padding(
    padding: AppSpacing.verticalLG,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.labelLarge),
            SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTypography.caption,
            ),
          ],
        ),
        Row(
          children: [
            _buildCounterButton(Icons.remove, () {}),
            SizedBox(width: AppSpacing.lg),
            Text(
              count.toString(),
              style: AppTypography.h4,
            ),
            SizedBox(width: AppSpacing.lg),
            _buildCounterButton(Icons.add, () {}),
          ],
        ),
      ],
    ),
  );
}

Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: AppRadius.radiusSM,
      ),
      child: Icon(
        icon,
        color: AppColors.primary,
        size: 20,
      ),
    ),
  );
}
```

---

## ✅ Boas Práticas

### 1. Sempre use o Design System
❌ **Evite:**
```dart
Container(
  color: Color(0xFF2563EB),
  padding: EdgeInsets.all(16),
  child: Text(
    'Hello',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

✅ **Prefira:**
```dart
AppCard(
  padding: AppSpacing.paddingLG,
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: AppTypography.h3,
  ),
)
```

### 2. Reutilize Componentes

Crie widgets customizados quando precisar de algo específico, mas baseie-se nos componentes existentes:

```dart
class CustomFlightCard extends StatelessWidget {
  final Flight flight;
  
  @override
  Widget build(BuildContext context) {
    return AppCard(  // Usa o card do design system
      child: Column(
        children: [
          // Seu conteúdo customizado
        ],
      ),
    );
  }
}
```

### 3. Mantenha Consistência

- Use sempre os mesmos espaçamentos do design system
- Siga a hierarquia de tipografia
- Use as cores definidas
- Mantenha o mesmo border radius

### 4. Responsive Design

```dart
// Use MediaQuery quando necessário
final width = MediaQuery.of(context).size.width;

// Mas prefira usar flex e expanded
Row(
  children: [
    Expanded(child: Widget1()),
    SizedBox(width: AppSpacing.md),
    Expanded(child: Widget2()),
  ],
)
```

### 5. Acessibilidade

```dart
// Adicione Semantics quando apropriado
Semantics(
  button: true,
  label: 'Search flights',
  child: AppButton(
    text: 'Search',
    onPressed: () {},
  ),
)
```

---

## 🎯 Checklist para Novas Telas

Ao criar uma nova tela, verifique:

- [ ] Usa `AppGradients.background` como fundo
- [ ] Usa componentes do design system quando possível
- [ ] Segue a hierarquia de tipografia
- [ ] Usa espaçamentos consistentes (`AppSpacing`)
- [ ] Usa cores do `AppColors`
- [ ] Mantém o mesmo border radius
- [ ] Tem estados de loading quando aplicável
- [ ] É responsiva
- [ ] Tem navegação consistente

---

## 📚 Recursos Adicionais

### Bibliotecas Utilizadas

- **google_fonts**: Fontes personalizadas (Inter)
- **shimmer**: Efeitos de loading
- **flutter_staggered_animations**: Animações de entrada
- **cached_network_image**: Cache de imagens

### Estrutura de Pastas

```
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       └── app_components.dart
├── screens/
│   ├── explore_screen.dart
│   ├── flight_list_screen.dart
│   └── profile_screen.dart
└── main.dart
```

---

## 🤝 Contribuindo

Ao adicionar novos componentes ao design system:

1. Siga os padrões existentes
2. Documente o uso com exemplos
3. Teste em diferentes tamanhos de tela
4. Mantenha a consistência visual

---

**Versão**: 1.0.0  
**Última atualização**: 2024