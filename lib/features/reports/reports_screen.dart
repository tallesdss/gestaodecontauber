import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/summary_card.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/line_chart_widget.dart';
import '../../core/widgets/pie_chart_widget.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/theme/app_radius.dart';

enum ReportPeriod {
  today,
  thisWeek,
  thisMonth,
  custom,
}

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ReportPeriod _selectedPeriod = ReportPeriod.thisMonth;

  // Dados mock - serão substituídos por dados reais depois
  final double _totalEarnings = 2450.0;
  final double _totalExpenses = 850.0;
  double get _totalProfit => _totalEarnings - _totalExpenses;

  // Métricas adicionais
  final double _averageDailyEarnings = 350.0;
  final double _averageDailyExpenses = 85.0;
  final int _daysWorked = 22;
  final double _bestDay = 520.0;

  // Dados para gráfico de linhas (mock - últimos 30 dias)
  List<ChartDataPoint> get _earningsChartData {
    return List.generate(30, (index) {
      return ChartDataPoint(
        index.toDouble(),
        200.0 + (index * 10.0) + (index % 5) * 50.0,
      );
    });
  }

  List<ChartDataPoint> get _expensesChartData {
    return List.generate(30, (index) {
      return ChartDataPoint(
        index.toDouble(),
        50.0 + (index * 2.0) + (index % 3) * 20.0,
      );
    });
  }

  List<ChartDataPoint> get _profitChartData {
    return List.generate(30, (index) {
      final earnings = 200.0 + (index * 10.0) + (index % 5) * 50.0;
      final expenses = 50.0 + (index * 2.0) + (index % 3) * 20.0;
      return ChartDataPoint(index.toDouble(), earnings - expenses);
    });
  }

  // Dados para gráfico de pizza (gastos por categoria)
  List<CategoryExpenseData> get _expensesByCategory {
    return [
      CategoryExpenseData(
        label: 'Combustível',
        value: 500.0,
        color: AppColors.fuel,
      ),
      CategoryExpenseData(
        label: 'Manutenção',
        value: 200.0,
        color: AppColors.maintenance,
      ),
      CategoryExpenseData(
        label: 'Lavagem',
        value: 80.0,
        color: AppColors.accent,
      ),
      CategoryExpenseData(
        label: 'Outros',
        value: 70.0,
        color: AppColors.textTertiary,
      ),
    ];
  }

  String _getPeriodLabel(ReportPeriod period) {
    switch (period) {
      case ReportPeriod.today:
        return 'Hoje';
      case ReportPeriod.thisWeek:
        return 'Esta Semana';
      case ReportPeriod.thisMonth:
        return 'Este Mês';
      case ReportPeriod.custom:
        return 'Personalizado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundDark,
              AppColors.backgroundMedium,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              // Conteúdo
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.paddingLG,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cards de Resumo
                      _buildSummaryCards(),
                      const SizedBox(height: AppSpacing.xl),
                      // Gráfico Principal
                      _buildMainChart(),
                      const SizedBox(height: AppSpacing.xl),
                      // Métricas Adicionais
                      _buildAdditionalMetrics(),
                      const SizedBox(height: AppSpacing.xl),
                      // Gráfico de Gastos por Categoria
                      _buildExpensesByCategoryChart(),
                      const SizedBox(height: AppSpacing.xxxl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildExportButton(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: AppSpacing.paddingLG,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Relatórios',
              style: AppTypography.h2,
            ),
          ),
          // Dropdown de período
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: DropdownButton<ReportPeriod>(
              value: _selectedPeriod,
              underline: const SizedBox(),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: AppColors.textPrimary,
              ),
              dropdownColor: AppColors.surface,
              style: AppTypography.bodyMedium,
              items: ReportPeriod.values.map((period) {
                return DropdownMenuItem(
                  value: period,
                  child: Text(_getPeriodLabel(period)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPeriod = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        // Card 1: Total de Ganhos
        SummaryCard(
          icon: Icons.trending_up,
          label: 'Total de Ganhos',
          value: CurrencyFormatter.format(_totalEarnings),
          iconColor: AppColors.earnings,
          onTap: () {},
        ),
        const SizedBox(width: AppSpacing.md),
        // Card 2: Total de Gastos
        SummaryCard(
          icon: Icons.trending_down,
          label: 'Total de Gastos',
          value: CurrencyFormatter.format(_totalExpenses),
          iconColor: AppColors.expenses,
          onTap: () {},
        ),
        const SizedBox(width: AppSpacing.md),
        // Card 3: Lucro Líquido
        SummaryCard(
          icon: Icons.account_balance_wallet,
          label: 'Lucro Líquido',
          value: CurrencyFormatter.format(_totalProfit),
          iconColor: _totalProfit >= 0 ? AppColors.profit : AppColors.loss,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMainChart() {
    return AppCard(
      padding: AppSpacing.paddingLG,
      child: LineChartWidget(
        title: 'Evolução Mensal',
        earningsData: _earningsChartData,
        expensesData: _expensesChartData,
        profitData: _profitChartData,
      ),
    );
  }

  Widget _buildAdditionalMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Métricas Adicionais',
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.lg),
        // Grid 2x2
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.calendar_today,
                label: 'Média/Dia',
                value: CurrencyFormatter.format(_averageDailyEarnings),
                iconColor: AppColors.earnings,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatCard(
                icon: Icons.shopping_cart,
                label: 'Gasto/Dia',
                value: CurrencyFormatter.format(_averageDailyExpenses),
                iconColor: AppColors.expenses,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.work,
                label: 'Dias Ativos',
                value: '$_daysWorked dias',
                iconColor: AppColors.accent,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatCard(
                icon: Icons.star,
                label: 'Melhor Dia',
                value: CurrencyFormatter.format(_bestDay),
                iconColor: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpensesByCategoryChart() {
    return AppCard(
      padding: AppSpacing.paddingLG,
      child: PieChartWidget(
        title: 'Gastos por Categoria',
        data: _expensesByCategory,
      ),
    );
  }

  Widget _buildExportButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showExportOptions(),
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.download),
      label: const Text('Exportar'),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.radiusXL),
            ),
          ),
          padding: AppSpacing.paddingXL,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: AppRadius.borderRadiusRound,
              ),
            ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Exportar Relatório',
                style: AppTypography.h3,
              ),
              const SizedBox(height: AppSpacing.xxl),
              _buildExportOption(
                icon: Icons.picture_as_pdf,
                label: 'Exportar PDF',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implementar exportação PDF
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _buildExportOption(
                icon: Icons.table_chart,
                label: 'Exportar Excel',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implementar exportação Excel
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _buildExportOption(
                icon: Icons.share,
                label: 'Compartilhar',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implementar compartilhamento
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderRadiusMD,
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.lg),
            Text(
              label,
              style: AppTypography.bodyLarge,
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
