import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_dialog.dart';
import 'app_button.dart';

/// Dialog de confirmação de exclusão
class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Excluir',
    this.cancelText = 'Cancelar',
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      icon: Icons.warning_rounded,
      iconColor: confirmColor ?? AppColors.error,
      title: title,
      message: message,
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: cancelText,
                isOutlined: true,
                onPressed: () {
                  onCancel?.call();
                  Navigator.of(context).pop(false);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppButton(
                text: confirmText,
                backgroundColor: confirmColor ?? AppColors.error,
                onPressed: () {
                  onConfirm?.call();
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Helper method para mostrar o dialog
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Excluir',
    String cancelText = 'Cancelar',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AppConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
      ),
    );
  }
}

