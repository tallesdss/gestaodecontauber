# 📱 Dialogs e Modais - Documentação

Componentes de dialogs e modais seguindo o design system do UberControl.

## 📦 Componentes Disponíveis

### 1. AppDialog (Base)
Widget base para criar dialogs customizados.

### 2. AppConfirmDialog
Dialog de confirmação, ideal para ações destrutivas como exclusão.

### 3. AppSuccessDialog
Modal de sucesso com opção de auto-fechamento.

### 4. AppErrorDialog
Modal de erro com opção de retry.

### 5. AppBottomSheet
Bottom sheet para exibir opções e ações.

---

## 🚀 Como Usar

### Dialog de Confirmação de Exclusão

```dart
import 'package:ubercontrol/core/widgets/app_dialogs.dart';

// Uso básico
AppConfirmDialog.show(
  context: context,
  title: 'Excluir Ganho?',
  message: 'Esta ação não pode ser desfeita.',
  onConfirm: () {
    // Lógica de exclusão
  },
);

// Com cores customizadas
AppConfirmDialog.show(
  context: context,
  title: 'Excluir Gasto?',
  message: 'Esta ação não pode ser desfeita.',
  confirmText: 'Excluir',
  cancelText: 'Cancelar',
  confirmColor: AppColors.error,
).then((confirmed) {
  if (confirmed == true) {
    // Item excluído
  }
});
```

### Modal de Sucesso

```dart
// Com auto-fechamento (padrão: 2 segundos)
AppSuccessDialog.show(
  context: context,
  title: 'Salvo com sucesso!',
  message: 'Seu ganho foi registrado com sucesso.',
  autoClose: true,
  autoCloseDuration: Duration(seconds: 2),
);

// Sem auto-fechamento
AppSuccessDialog.show(
  context: context,
  title: 'Operação concluída!',
  message: 'Os dados foram salvos com sucesso.',
  autoClose: false,
  buttonText: 'Continuar',
);
```

### Modal de Erro

```dart
// Com opção de retry
AppErrorDialog.show(
  context: context,
  title: 'Ops! Algo deu errado',
  message: 'Não foi possível salvar os dados.',
  retryText: 'Tentar novamente',
  onRetry: () {
    // Lógica de retry
  },
);

// Simples (sem retry)
AppErrorDialog.show(
  context: context,
  title: 'Erro',
  message: 'Não foi possível completar a operação.',
);
```

### Bottom Sheet de Opções

```dart
AppBottomSheet.show(
  context: context,
  title: 'Opções',
  options: [
    BottomSheetOption(
      title: 'Ver detalhes',
      icon: Icons.visibility_outlined,
      onTap: () {
        Navigator.pop(context);
        // Navegar para detalhes
      },
    ),
    BottomSheetOption(
      title: 'Editar',
      icon: Icons.edit_outlined,
      onTap: () {
        Navigator.pop(context);
        // Navegar para edição
      },
    ),
    BottomSheetOption(
      title: 'Excluir',
      subtitle: 'Esta ação não pode ser desfeita',
      icon: Icons.delete_outline,
      isDestructive: true,
      onTap: () {
        Navigator.pop(context);
        // Mostrar confirmação
      },
    ),
  ],
);
```

### Bottom Sheet Customizado

```dart
AppBottomSheet.show(
  context: context,
  title: 'Selecionar Categoria',
  customContent: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Seu conteúdo customizado aqui
    ],
  ),
);
```

---

## 🎨 Características do Design System

Todos os componentes seguem o design system:

- **Cores**: Usam `AppColors` (primary, error, success, etc.)
- **Tipografia**: Usam `AppTypography` (h3, bodyMedium, etc.)
- **Espaçamentos**: Usam `AppSpacing` (paddingLG, paddingXL, etc.)
- **Border Radius**: Usam `AppRadius` (radiusLG, radiusXL, etc.)
- **Componentes**: Reutilizam `AppButton` e `AppCard`

---

## 📝 Exemplos Completos

Veja o arquivo `dialogs_examples.dart` para exemplos completos de uso de todos os componentes.

---

## ✅ Checklist de Implementação

- [x] AppDialog base
- [x] AppConfirmDialog (confirmação de exclusão)
- [x] AppSuccessDialog (modal de sucesso com auto-fechamento)
- [x] AppErrorDialog (modal de erro)
- [x] AppBottomSheet (bottom sheet de opções)
- [x] Helper methods estáticos para facilitar uso
- [x] Documentação e exemplos

---

## 🔗 Integração com o App

Para usar em qualquer tela:

```dart
import 'package:ubercontrol/core/widgets/app_dialogs.dart';

// Em qualquer método build ou callback
AppConfirmDialog.show(
  context: context,
  title: 'Excluir?',
  message: 'Tem certeza?',
);
```

---

**Versão**: 1.0.0  
**Última atualização**: 2024

