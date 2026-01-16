import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import 'app_dialog.dart';
import 'app_button.dart';

/// Dialog de informações sobre o app
class AppAboutDialog extends StatelessWidget {
  final String appName;
  final String version;
  final String? description;
  final String buttonText;

  const AppAboutDialog({
    super.key,
    required this.appName,
    required this.version,
    this.description,
    this.buttonText = 'Fechar',
  });

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      icon: Icons.info_rounded,
      iconColor: AppColors.info,
      title: 'Sobre o App',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appName,
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Versão $version',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              description!,
              style: AppTypography.bodyMedium,
            ),
          ],
        ],
      ),
      actions: [
        AppButton(
          text: buttonText,
          onPressed: () => Navigator.of(context).pop(),
          width: double.infinity,
        ),
      ],
    );
  }

  /// Helper method para mostrar o dialog
  static Future<void> show({
    required BuildContext context,
    required String appName,
    required String version,
    String? description,
    String buttonText = 'Fechar',
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AppAboutDialog(
        appName: appName,
        version: version,
        description: description,
        buttonText: buttonText,
      ),
    );
  }
}


