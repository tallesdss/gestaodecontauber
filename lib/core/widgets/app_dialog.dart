import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';

/// Widget base para dialogs customizados seguindo o design system
class AppDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;
  final bool showCloseButton;

  const AppDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.actions,
    this.icon,
    this.iconColor,
    this.showCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.borderRadiusLG,
        ),
        padding: AppSpacing.paddingXXL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCloseButton)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.textTertiary,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            if (icon != null) ...[
              Container(
                padding: AppSpacing.paddingLG,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: iconColor ?? AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: AppTypography.h3,
                textAlign: TextAlign.center,
              ),
              if (message != null || content != null)
                const SizedBox(height: AppSpacing.md),
            ],
            if (message != null)
              Text(
                message!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            if (content != null) content!,
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxl),
              ...actions!,
            ],
          ],
        ),
      ),
    );
  }
}

