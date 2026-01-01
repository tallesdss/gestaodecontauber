import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/utils/currency_formatter.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados mockados - em produção viriam de um provider/service
    final currentMonth = DateTime.now();
    final monthName = _getMonthName(currentMonth.month);
    const goalValue = 10000.0;
    const currentValue = 6600.0;
    final percentage = (currentValue / goalValue * 100).round();
    final daysRemaining = _getDaysRemainingInMonth(currentMonth);
    final dailyNeeded = (goalValue - currentValue) / daysRemaining;
    final status = _getStatus(percentage);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: const AppTopBar(
        title: 'Minhas Metas',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingXL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card de Meta Mensal
            _buildMonthlyGoalCard(
              monthName: monthName,
              goalValue: goalValue,
              currentValue: currentValue,
              percentage: percentage,
              daysRemaining: daysRemaining,
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Card de Previsão
            _buildForecastCard(
              dailyNeeded: dailyNeeded,
              status: status,
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Histórico de Metas
            _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyGoalCard({
    required String monthName,
    required double goalValue,
    required double currentValue,
    required int percentage,
    required int daysRemaining,
  }) {
    return AppCard(
      padding: AppSpacing.paddingXXL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meta de $monthName',
                style: AppTypography.h3,
              ),
              const Icon(
                Icons.flag,
                color: AppColors.primary,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Valor da meta
          Text(
            'Meta: ${CurrencyFormatter.format(goalValue)}',
            style: AppTypography.h4.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Barra de progresso
          _buildProgressBar(percentage: percentage),
          const SizedBox(height: AppSpacing.lg),

          // Valor atual e percentual
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valor atual',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    CurrencyFormatter.format(currentValue),
                    style: AppTypography.h2.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Percentual',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '$percentage%',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Dias restantes
          Container(
            padding: AppSpacing.paddingMD,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '$daysRemaining ${daysRemaining == 1 ? 'dia restante' : 'dias restantes'}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Botão Editar Meta
          AppButton(
            text: 'Editar Meta',
            icon: Icons.edit,
            isOutlined: true,
            onPressed: () {
              // TODO: Implementar edição de meta
            },
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({required int percentage}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: AppRadius.borderRadiusRound,
          child: Container(
            height: 12,
            width: double.infinity,
            color: AppColors.backgroundMedium,
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard({
    required double dailyNeeded,
    required ForecastStatus status,
  }) {
    IconData statusIcon;
    Color statusColor;
    String statusText;

    switch (status) {
      case ForecastStatus.onTrack:
        statusIcon = Icons.check_circle;
        statusColor = AppColors.success;
        statusText = 'No caminho certo';
        break;
      case ForecastStatus.attention:
        statusIcon = Icons.warning;
        statusColor = AppColors.warning;
        statusText = 'Atenção';
        break;
      case ForecastStatus.below:
        statusIcon = Icons.error;
        statusColor = AppColors.error;
        statusText = 'Abaixo da meta';
        break;
    }

    return AppCard(
      padding: AppSpacing.paddingXXL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            'Previsão de Atingimento',
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Status com ícone
          Row(
            children: [
              Icon(
                statusIcon,
                color: statusColor,
                size: 32,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: AppTypography.labelLarge.copyWith(
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Você precisa ganhar ${CurrencyFormatter.format(dailyNeeded)} por dia',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Histórico de Metas',
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildHistoryItem(
          month: 'Novembro 2024',
          goalValue: 10000.0,
          achievedValue: 10500.0,
          isAchieved: true,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildHistoryItem(
          month: 'Outubro 2024',
          goalValue: 10000.0,
          achievedValue: 9800.0,
          isAchieved: false,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildHistoryItem(
          month: 'Setembro 2024',
          goalValue: 9500.0,
          achievedValue: 10200.0,
          isAchieved: true,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildHistoryItem(
          month: 'Agosto 2024',
          goalValue: 9000.0,
          achievedValue: 8750.0,
          isAchieved: false,
        ),
      ],
    );
  }

  Widget _buildHistoryItem({
    required String month,
    required double goalValue,
    required double achievedValue,
    required bool isAchieved,
  }) {
    final percentage = (achievedValue / goalValue * 100).round();

    return AppCard(
      padding: AppSpacing.paddingLG,
      child: Row(
        children: [
          // Ícone de status
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isAchieved
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.error.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: Icon(
              isAchieved ? Icons.check_circle : Icons.cancel,
              color: isAchieved ? AppColors.success : AppColors.error,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          // Informações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      'Meta: ${CurrencyFormatter.format(goalValue)}',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      '•',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Atingido: ${CurrencyFormatter.format(achievedValue)}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Percentual
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$percentage%',
                style: AppTypography.h5.copyWith(
                  color: isAchieved ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                isAchieved ? 'Atingida' : 'Não atingida',
                style: AppTypography.caption.copyWith(
                  color: isAchieved ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return months[month - 1];
  }

  int _getDaysRemainingInMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0);
    final today = DateTime.now();
    final remaining = lastDay.difference(today).inDays;
    return remaining > 0 ? remaining : 0;
  }

  ForecastStatus _getStatus(int percentage) {
    if (percentage >= 80) {
      return ForecastStatus.onTrack;
    } else if (percentage >= 50) {
      return ForecastStatus.attention;
    } else {
      return ForecastStatus.below;
    }
  }
}

enum ForecastStatus {
  onTrack,
  attention,
  below,
}

