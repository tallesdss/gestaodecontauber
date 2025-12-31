import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';

class LineChartWidget extends StatelessWidget {
  final List<ChartDataPoint> earningsData;
  final List<ChartDataPoint> expensesData;
  final List<ChartDataPoint> profitData;
  final String title;

  const LineChartWidget({
    super.key,
    required this.earningsData,
    required this.expensesData,
    required this.profitData,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: AppSpacing.paddingLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.textTertiary.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() % 5 == 0) {
                          return Text(
                            value.toInt().toString(),
                            style: AppTypography.caption,
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          'R\$ ${value.toInt()}',
                          style: AppTypography.caption,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: AppColors.textTertiary.withValues(alpha: 0.2),
                  ),
                ),
                minX: 0,
                maxX: 30,
                minY: 0,
                maxY: 1000,
                lineBarsData: [
                  // Linha de Ganhos (verde)
                  LineChartBarData(
                    spots: earningsData
                        .map((point) => FlSpot(point.x, point.y))
                        .toList(),
                    isCurved: true,
                    color: AppColors.earnings,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.earnings.withValues(alpha: 0.1),
                    ),
                  ),
                  // Linha de Gastos (laranja)
                  LineChartBarData(
                    spots: expensesData
                        .map((point) => FlSpot(point.x, point.y))
                        .toList(),
                    isCurved: true,
                    color: AppColors.expenses,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.expenses.withValues(alpha: 0.1),
                    ),
                  ),
                  // Linha de Lucro (azul)
                  LineChartBarData(
                    spots: profitData
                        .map((point) => FlSpot(point.x, point.y))
                        .toList(),
                    isCurved: true,
                    color: AppColors.accent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.accent.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Legenda
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Ganhos', AppColors.earnings),
              const SizedBox(width: AppSpacing.lg),
              _buildLegendItem('Gastos', AppColors.expenses),
              const SizedBox(width: AppSpacing.lg),
              _buildLegendItem('Lucro', AppColors.accent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.caption,
        ),
      ],
    );
  }
}

class ChartDataPoint {
  final double x;
  final double y;

  ChartDataPoint(this.x, this.y);
}

