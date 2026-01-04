import 'package:flutter/material.dart';
import 'app_dialogs.dart';
import '../theme/app_colors.dart';

/// Exemplos de uso dos dialogs e modais
/// Este arquivo serve como documentação e referência de uso

class DialogsExamples {
  /// Exemplo 1: Dialog de Confirmação de Exclusão
  static void showDeleteConfirmation(BuildContext context) {
    AppConfirmDialog.show(
      context: context,
      title: 'Excluir Ganho?',
      message: 'Esta ação não pode ser desfeita. Tem certeza que deseja excluir este ganho?',
      confirmText: 'Excluir',
      cancelText: 'Cancelar',
      onConfirm: () {
        // Lógica de exclusão
        // print('Item excluído');
      },
      onCancel: () {
        // print('Cancelado');
      },
    );
  }

  /// Exemplo 2: Dialog de Confirmação de Exclusão de Gasto
  static void showDeleteExpenseConfirmation(BuildContext context) {
    AppConfirmDialog.show(
      context: context,
      title: 'Excluir Gasto?',
      message: 'Esta ação não pode ser desfeita.',
      confirmText: 'Excluir',
      cancelText: 'Cancelar',
      confirmColor: AppColors.error,
    ).then((confirmed) {
      if (confirmed == true) {
        // Lógica de exclusão
        // print('Gasto excluído');
      }
    });
  }

  /// Exemplo 3: Modal de Sucesso
  static void showSuccessDialog(BuildContext context) {
    AppSuccessDialog.show(
      context: context,
      title: 'Salvo com sucesso!',
      message: 'Seu ganho foi registrado com sucesso.',
      autoClose: true,
      autoCloseDuration: const Duration(seconds: 2),
      onClose: () {
        // print('Dialog fechado');
      },
    );
  }

  /// Exemplo 4: Modal de Sucesso sem auto-fechamento
  static void showSuccessDialogManual(BuildContext context) {
    AppSuccessDialog.show(
      context: context,
      title: 'Operação concluída!',
      message: 'Os dados foram salvos com sucesso.',
      autoClose: false,
      buttonText: 'Continuar',
    );
  }

  /// Exemplo 5: Modal de Erro
  static void showErrorDialog(BuildContext context) {
    AppErrorDialog.show(
      context: context,
      title: 'Ops! Algo deu errado',
      message: 'Não foi possível salvar os dados. Verifique sua conexão e tente novamente.',
      retryText: 'Tentar novamente',
      closeText: 'Fechar',
      onRetry: () {
        // Lógica de retry
        // print('Tentando novamente...');
      },
      onClose: () {
        // print('Fechado');
      },
    );
  }

  /// Exemplo 6: Modal de Erro simples (sem retry)
  static void showSimpleErrorDialog(BuildContext context) {
    AppErrorDialog.show(
      context: context,
      title: 'Erro',
      message: 'Não foi possível completar a operação.',
      closeText: 'OK',
    );
  }

  /// Exemplo 7: Bottom Sheet de Opções para Ganho
  static void showEarningOptionsBottomSheet(BuildContext context) {
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
            // print('Ver detalhes');
          },
        ),
        BottomSheetOption(
          title: 'Editar',
          icon: Icons.edit_outlined,
          onTap: () {
            Navigator.pop(context);
            // Navegar para edição
            // print('Editar');
          },
        ),
        BottomSheetOption(
          title: 'Duplicar',
          icon: Icons.copy_outlined,
          onTap: () {
            Navigator.pop(context);
            // Duplicar item
            // print('Duplicar');
          },
        ),
        BottomSheetOption(
          title: 'Excluir',
          subtitle: 'Esta ação não pode ser desfeita',
          icon: Icons.delete_outline,
          isDestructive: true,
          onTap: () {
            Navigator.pop(context);
            // Mostrar confirmação de exclusão
            showDeleteConfirmation(context);
          },
        ),
      ],
    );
  }

  /// Exemplo 8: Bottom Sheet de Opções para Gasto
  static void showExpenseOptionsBottomSheet(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: 'Opções do Gasto',
      options: [
        BottomSheetOption(
          title: 'Ver detalhes',
          subtitle: 'Visualizar informações completas',
          icon: Icons.info_outline,
          iconColor: AppColors.info,
          onTap: () {
            Navigator.pop(context);
            // print('Ver detalhes');
          },
        ),
        BottomSheetOption(
          title: 'Editar',
          subtitle: 'Modificar este gasto',
          icon: Icons.edit_outlined,
          iconColor: AppColors.primary,
          onTap: () {
            Navigator.pop(context);
            // print('Editar');
          },
        ),
        BottomSheetOption(
          title: 'Excluir',
          subtitle: 'Remover permanentemente',
          icon: Icons.delete_outline,
          isDestructive: true,
          onTap: () {
            Navigator.pop(context);
            showDeleteExpenseConfirmation(context);
          },
        ),
      ],
    );
  }

  /// Exemplo 9: Bottom Sheet customizado com conteúdo próprio
  static void showCustomBottomSheet(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: 'Selecionar Categoria',
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCategoryOption(context, 'Combustível', Icons.local_gas_station, AppColors.fuel),
          _buildCategoryOption(context, 'Manutenção', Icons.build, AppColors.maintenance),
          _buildCategoryOption(context, 'Lavagem', Icons.local_car_wash, AppColors.accent),
          _buildCategoryOption(context, 'Pedágio', Icons.toll, AppColors.warning),
        ],
      ),
    );
  }

  static Widget _buildCategoryOption(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, title);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Exemplo 10: Fluxo completo - Excluir com confirmação e feedback
  static void deleteItemWithConfirmation(BuildContext context) {
    // Primeiro mostra o bottom sheet
    AppBottomSheet.show(
      context: context,
      options: [
        BottomSheetOption(
          title: 'Excluir',
          icon: Icons.delete_outline,
          isDestructive: true,
          onTap: () {
            Navigator.pop(context);
            // Depois mostra a confirmação
            AppConfirmDialog.show(
              context: context,
              title: 'Excluir Item?',
              message: 'Esta ação não pode ser desfeita.',
              onConfirm: () {
                // Após confirmar, mostra sucesso
                AppSuccessDialog.show(
                  context: context,
                  title: 'Excluído!',
                  message: 'O item foi removido com sucesso.',
                );
              },
            );
          },
        ),
      ],
    );
  }
}

