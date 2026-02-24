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
import '../../core/supabase/supabase_service.dart';

enum ReportPeriod {
  today,
  thisWeek,
  thisMonth,
}

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ReportPeriod _selectedPeriod = ReportPeriod.thisMonth;
  bool _isLoading = true;

  // Estatísticas Reais
  double _totalEarnings = 0.0;
  double _totalExpenses = 0.0;
  double _netProfit = 0.0;
  
  // Métricas Adicionais
  double _averageDailyEarnings = 0.0;
  double _averageDailyExpenses = 0.0;
  int _daysWorked = 0;
  double _bestDayValue = 0.0;

  // Dados para Gráficos
  List<ChartDataPoint> _earningsChartData = [];
  List<ChartDataPoint> _expensesChartData = [];
  List<ChartDataPoint> _profitChartData = [];
  List<CategoryExpenseData> _expensesByCategory = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final now = DateTime.now();
      DateTime start;
      DateTime end = now;

      switch (_selectedPeriod) {
        case ReportPeriod.today:
          start = DateTime(now.year, now.month, now.day);
          break;
        case ReportPeriod.thisWeek:
          // Início da semana (segunda-feira)
          start = now.subtract(Duration(days: now.weekday - 1));
          start = DateTime(start.year, start.month, start.day);
          break;
        case ReportPeriod.thisMonth:
          start = DateTime(now.year, now.month, 1);
          break;
      }

      // 1. Totais do Período
      final totals = await SupabaseService.getPeriodTotals(start, end);
      
      // 2. Totais Diários (para métricas e gráficos)
      // Se for apenas o dia de hoje, pegamos dos últimos 7 dias para o gráfico fazer sentido
      // ou apenas hoje. Mas o gráfico de linha costuma mostrar evolução.
      // Vou pegar sempre pelo menos 7 dias ou o período selecionado.
      final chartStart = _selectedPeriod == ReportPeriod.today 
          ? now.subtract(const Duration(days: 6)) 
          : start;
      
      final dailyTotals = await SupabaseService.getDailyTotals(chartStart, end);
      
      // 3. Gastos por Categoria
      final categoryData = await SupabaseService.getExpensesByCategory(start, end);

      if (mounted) {
        setState(() {
          _totalEarnings = totals['totalEarnings'] ?? 0.0;
          _totalExpenses = totals['totalExpenses'] ?? 0.0;
          _netProfit = totals['netProfit'] ?? 0.0;

          // Processar dados do gráfico
          _earningsChartData = [];
          _expensesChartData = [];
          _profitChartData = [];
          
          double totalForAverage = 0;
          double totalExpensesForAverage = 0;
          int daysWithEarnings = 0;
          double bestValue = 0;

          for (int i = 0; i < dailyTotals.length; i++) {
            final day = dailyTotals[i];
            final e = day['totalEarnings'] as double;
            final x = day['totalExpenses'] as double;
            final p = day['netProfit'] as double;

            _earningsChartData.add(ChartDataPoint(i.toDouble(), e));
            _expensesChartData.add(ChartDataPoint(i.toDouble(), x));
            _profitChartData.add(ChartDataPoint(i.toDouble(), p));

            if (e > 0) {
              daysWithEarnings++;
              totalForAverage += e;
              if (e > bestValue) bestValue = e;
            }
            totalExpensesForAverage += x;
          }

          _daysWorked = daysWithEarnings;
          _averageDailyEarnings = daysWithEarnings > 0 ? totalForAverage / daysWithEarnings : 0;
          _averageDailyExpenses = dailyTotals.isNotEmpty ? totalExpensesForAverage / dailyTotals.length : 0;
          _bestDayValue = bestValue;

          // Processar gastos por categoria
          _expensesByCategory = categoryData.map((c) {
            return CategoryExpenseData(
              label: c['category'],
              value: c['totalValue'],
              color: _getCategoryColor(c['category']),
            );
          }).toList();

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar relatórios: $e')),
        );
      }
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'combustível':
      case 'fuel':
        return AppColors.fuel;
      case 'manutenção':
      case 'maintenance':
        return AppColors.maintenance;
      case 'lavagem':
      case 'car_wash':
        return AppColors.accent;
      case 'estacionamento':
        return AppColors.warning;
      default:
        return AppColors.textTertiary;
    }
  }

  String _getPeriodLabel(ReportPeriod period) {
    switch (period) {
      case ReportPeriod.today:
        return 'Hoje';
      case ReportPeriod.thisWeek:
        return 'Esta Semana';
      case ReportPeriod.thisMonth:
        return 'Este Mês';
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
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: SingleChildScrollView(
                        padding: AppSpacing.paddingLG,
                        physics: const AlwaysScrollableScrollPhysics(),
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
                            if (_expensesByCategory.isNotEmpty) ...[
                              _buildExpensesByCategoryChart(),
                              const SizedBox(height: AppSpacing.xxxl),
                            ] else if (_totalExpenses > 0)
                              const Padding(
                                padding: EdgeInsets.all(AppSpacing.lg),
                                child: Center(child: Text('Sem dados de categorias disponíveis')),
                              ),
                          ],
                        ),
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
                  _loadData();
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
        Expanded(
          child: SummaryCard(
            icon: Icons.trending_up,
            label: 'Ganhos',
            value: CurrencyFormatter.format(_totalEarnings),
            iconColor: AppColors.earnings,
            onTap: () {},
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: SummaryCard(
            icon: Icons.trending_down,
            label: 'Gastos',
            value: CurrencyFormatter.format(_totalExpenses),
            iconColor: AppColors.expenses,
            onTap: () {},
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: SummaryCard(
            icon: Icons.account_balance_wallet,
            label: 'Lucro',
            value: CurrencyFormatter.format(_netProfit),
            iconColor: _netProfit >= 0 ? AppColors.profit : AppColors.loss,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildMainChart() {
    return AppCard(
      padding: AppSpacing.paddingLG,
      child: LineChartWidget(
        title: _selectedPeriod == ReportPeriod.today 
            ? 'Últimos 7 dias' 
            : 'Evolução no Período',
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
                value: CurrencyFormatter.format(_bestDayValue),
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
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _buildExportOption(
                icon: Icons.table_chart,
                label: 'Exportar Excel',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _buildExportOption(
                icon: Icons.share,
                label: 'Compartilhar',
                onTap: () {
                  Navigator.pop(context);
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
