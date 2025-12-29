import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import 'app_card.dart';

class TransactionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String description;
  final String date;
  final String value;
  final Color valueColor;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.description,
    required this.date,
    required this.value,
    required this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.paddingLG,
      child: Row(
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
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: AppTypography.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  date,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Text(
            value,
            style: AppTypography.h5.copyWith(
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

