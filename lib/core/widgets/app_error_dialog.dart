import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_dialog.dart';
import 'app_button.dart';

/// Modal de erro
class AppErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? retryText;
  final String closeText;
  final VoidCallback? onRetry;
  final VoidCallback? onClose;

  const AppErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.retryText,
    this.closeText = 'Fechar',
    this.onRetry,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      icon: Icons.error_rounded,
      iconColor: AppColors.error,
      title: title,
      message: message,
      actions: [
        if (retryText != null && onRetry != null) ...[
          AppButton(
            text: retryText!,
            onPressed: () {
              onRetry?.call();
              Navigator.of(context).pop();
            },
            width: double.infinity,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        AppButton(
          text: closeText,
          isOutlined: true,
          onPressed: () {
            onClose?.call();
            Navigator.of(context).pop();
          },
          width: double.infinity,
        ),
      ],
    );
  }

  /// Helper method para mostrar o dialog
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String? retryText,
    String closeText = 'Fechar',
    VoidCallback? onRetry,
    VoidCallback? onClose,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) => AppErrorDialog(
        title: title,
        message: message,
        retryText: retryText,
        closeText: closeText,
        onRetry: onRetry,
        onClose: onClose,
      ),
    );
  }
}

