import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';

class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? selectedColor;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.backgroundColor,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = isSelected
        ? (selectedColor ?? AppColors.primary)
        : (backgroundColor ?? AppColors.surface);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderRadiusMD,
      child: Container(
        padding: AppSpacing.paddingMD,
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: AppRadius.borderRadiusMD,
          border: isSelected
              ? Border.all(
                  color: selectedColor ?? AppColors.primary,
                  width: 2,
                )
              : Border.all(
                  color: AppColors.textTertiary.withValues(alpha: 0.3),
                  width: 1,
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





