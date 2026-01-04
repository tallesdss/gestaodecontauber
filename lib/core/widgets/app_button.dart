import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';

enum ButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.size = ButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.width,
  });

  double get _height {
    switch (size) {
      case ButtonSize.small:
        return 40;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  @override
  Widget build(BuildContext context) {
    final button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              padding: AppSpacing.paddingLG,
              minimumSize: Size(width ?? double.infinity, _height),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.borderRadiusMD,
              ),
              side: BorderSide(
                color: backgroundColor ?? AppColors.primary,
                width: 2,
              ),
            ),
            child: _buildContent(),
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? AppColors.primary,
              foregroundColor: textColor ?? AppColors.textPrimary,
              padding: AppSpacing.paddingLG,
              minimumSize: Size(width ?? double.infinity, _height),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.borderRadiusMD,
              ),
            ),
            child: _buildContent(),
          );

    return button;
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? AppColors.textPrimary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(text, style: AppTypography.button),
        ],
      );
    }

    return Text(text, style: AppTypography.button);
  }
}





