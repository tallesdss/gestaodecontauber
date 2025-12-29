import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import 'app_card.dart';

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final VoidCallback? onTap;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        onTap: onTap,
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: iconColor.withAlpha((0.2 * 255).round()),
                borderRadius: AppRadius.borderRadiusMD,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              label,
              style: AppTypography.caption,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: AppTypography.h4.copyWith(
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

