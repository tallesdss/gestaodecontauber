import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../utils/currency_formatter.dart';

class PieChartWidget extends StatelessWidget {
  final List<CategoryExpenseData> data;
  final String title;

  const PieChartWidget({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            // Gráfico
            SizedBox(
              width: 200,
              height: 200,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(enabled: true),
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  sections: data.map((item) {
                    final percentage = (item.value / total * 100);
                    return PieChartSectionData(
                      value: item.value,
                      title: '${percentage.toStringAsFixed(0)}%',
                      color: item.color,
                      radius: 80,
                      titleStyle: AppTypography.caption.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            // Legenda
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((item) {
                  final percentage = (item.value / total * 100);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: item.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: AppTypography.bodyMedium,
                              ),
                              Text(
                                '${CurrencyFormatter.format(item.value)} (${percentage.toStringAsFixed(1)}%)',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CategoryExpenseData {
  final String label;
  final double value;
  final Color color;

  CategoryExpenseData({
    required this.label,
    required this.value,
    required this.color,
  });
}

