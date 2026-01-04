import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';

/// Item de opção para o bottom sheet
class BottomSheetOption {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;
  final bool isDestructive;

  const BottomSheetOption({
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor,
    required this.onTap,
    this.isDestructive = false,
  });
}

/// Bottom Sheet customizado seguindo o design system
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final List<BottomSheetOption> options;
  final Widget? customContent;
  final bool showHandle;

  const AppBottomSheet({
    super.key,
    this.title,
    this.options = const [],
    this.customContent,
    this.showHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.radiusXL),
        ),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.lg,
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: AppRadius.borderRadiusRound,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
          ],
          if (title != null) ...[
            Text(
              title!,
              style: AppTypography.h3,
            ),
            SizedBox(height: AppSpacing.xl),
          ],
          if (customContent != null)
            customContent!
          else
            ...options.map((option) => _buildOptionItem(option)),
        ],
      ),
    );
  }

  Widget _buildOptionItem(BottomSheetOption option) {
    final iconColor = option.isDestructive
        ? AppColors.error
        : (option.iconColor ?? AppColors.primary);

    return InkWell(
      onTap: () {
        option.onTap();
      },
      borderRadius: AppRadius.borderRadiusMD,
      child: Padding(
        padding: AppSpacing.verticalLG,
        child: Row(
          children: [
            Container(
              padding: AppSpacing.paddingMD,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: AppRadius.borderRadiusMD,
              ),
              child: Icon(
                option.icon,
                color: iconColor,
                size: 24,
              ),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: option.isDestructive
                        ? AppTypography.labelLarge.copyWith(
                            color: AppColors.error,
                          )
                        : AppTypography.labelLarge,
                  ),
                  if (option.subtitle != null) ...[
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      option.subtitle!,
                      style: AppTypography.caption,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method para mostrar o bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    List<BottomSheetOption> options = const [],
    Widget? customContent,
    bool showHandle = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => AppBottomSheet(
        title: title,
        options: options,
        customContent: customContent,
        showHandle: showHandle,
      ),
    );
  }
}

