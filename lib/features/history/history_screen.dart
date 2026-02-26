import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/utils/currency_formatter.dart';

// ─────────────────────────────────────────────
//  MOCKUP DATA
// ─────────────────────────────────────────────
class _MockData {
  /// Anos disponíveis (mockup)
  static const List<int> years = [2023, 2024, 2025];

  static const List<String> monthNames = [
    'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
    'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
  ];

  /// Dados por ano → mês (1-based) → {earnings, expenses}
  static const Map<int, Map<int, Map<String, double>>> monthly = {
    2025: {
      1:  {'earnings': 3100, 'expenses':  820},
      2:  {'earnings': 2850, 'expenses':  760},
      3:  {'earnings': 3400, 'expenses':  900},
      4:  {'earnings': 3250, 'expenses':  980},
      5:  {'earnings': 3600, 'expenses': 1050},
      6:  {'earnings': 3120, 'expenses':  870},
      7:  {'earnings': 2900, 'expenses':  800},
      8:  {'earnings': 3300, 'expenses':  950},
      9:  {'earnings': 3450, 'expenses': 1000},
      10: {'earnings': 3700, 'expenses': 1100},
      11: {'earnings': 3550, 'expenses': 1020},
      12: {'earnings': 4000, 'expenses': 1200},
    },
    2024: {
      1:  {'earnings': 2800, 'expenses':  700},
      2:  {'earnings': 2600, 'expenses':  680},
      3:  {'earnings': 3000, 'expenses':  800},
      4:  {'earnings': 2900, 'expenses':  780},
      5:  {'earnings': 3200, 'expenses':  900},
      6:  {'earnings': 2850, 'expenses':  750},
      7:  {'earnings': 2700, 'expenses':  720},
      8:  {'earnings': 3100, 'expenses':  860},
      9:  {'earnings': 3250, 'expenses':  890},
      10: {'earnings': 3400, 'expenses':  950},
      11: {'earnings': 3300, 'expenses':  920},
      12: {'earnings': 3800, 'expenses': 1100},
    },
    2023: {
      1:  {'earnings': 2200, 'expenses':  600},
      2:  {'earnings': 2000, 'expenses':  550},
      3:  {'earnings': 2400, 'expenses':  640},
      4:  {'earnings': 2300, 'expenses':  620},
      5:  {'earnings': 2600, 'expenses':  700},
      6:  {'earnings': 2200, 'expenses':  580},
      7:  {'earnings': 2100, 'expenses':  560},
      8:  {'earnings': 2500, 'expenses':  660},
      9:  {'earnings': 2650, 'expenses':  700},
      10: {'earnings': 2800, 'expenses':  750},
      11: {'earnings': 2700, 'expenses':  720},
      12: {'earnings': 3100, 'expenses':  900},
    },
  };

  /// Breakdown semanal mockup para qualquer mês selecionado
  static List<Map<String, dynamic>> weeklyBreakdown(double earnings, double expenses) {
    // Distribui os valores do mês em 4 semanas proporcionalmente (mockup)
    return [
      {'week': 1, 'earnings': earnings * 0.22, 'expenses': expenses * 0.20},
      {'week': 2, 'earnings': earnings * 0.26, 'expenses': expenses * 0.28},
      {'week': 3, 'earnings': earnings * 0.28, 'expenses': expenses * 0.27},
      {'week': 4, 'earnings': earnings * 0.24, 'expenses': expenses * 0.25},
    ];
  }

  /// Transações recentes mockup para visão mensal
  static List<Map<String, dynamic>> recentTransactions(int month) {
    final mName = monthNames[month - 1];
    return [
      {'date': '15 $mName', 'type': 'earning', 'desc': 'Uber — Turno da tarde', 'value': 180.0},
      {'date': '14 $mName', 'type': 'expense', 'desc': 'Combustível — Posto Shell', 'value': -95.0},
      {'date': '12 $mName', 'type': 'earning', 'desc': '99 — Turno da manhã',  'value': 210.0},
      {'date': '10 $mName', 'type': 'expense', 'desc': 'Manutenção — Troca de óleo', 'value': -150.0},
      {'date': '08 $mName', 'type': 'earning', 'desc': 'Uber — Turno noturno',  'value': 240.0},
    ];
  }
}

// ─────────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────────
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  int _selectedYear = DateTime.now().year;
  int? _selectedMonth; // null = visão anual
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // dados calculados
  double _earnings = 0;
  double _expenses = 0;
  double _profit = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _selectedMonth = DateTime.now().month;
    _refreshData();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _refreshData({bool showLoading = false}) {
    if (showLoading) {
      setState(() => _isLoading = true);
    }
    _animController.reset();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final yearData = _MockData.monthly[_selectedYear] ?? {};

      double e = 0, x = 0;
      if (_selectedMonth != null) {
        final mData = yearData[_selectedMonth] ?? {'earnings': 0.0, 'expenses': 0.0};
        e = mData['earnings']!;
        x = mData['expenses']!;
      } else {
        // visão anual: soma todos os meses
        for (final m in yearData.values) {
          e += m['earnings']!;
          x += m['expenses']!;
        }
      }

      setState(() {
        _earnings = e;
        _expenses = x;
        _profit = e - x;
        _isLoading = false;
      });
      _animController.forward();
    });
  }

  void _changeYear(int delta) {
    final idx = _MockData.years.indexOf(_selectedYear);
    final newIdx = idx - delta; // seta → avança (anos decrescentes na lista)
    if (newIdx < 0 || newIdx >= _MockData.years.length) return;
    setState(() {
      _selectedYear = _MockData.years[newIdx];
    });
    _refreshData(showLoading: true);
  }

  void _selectMonth(int? month) {
    setState(() => _selectedMonth = month);
    _refreshData(showLoading: true);
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surface,
      ),
    );
  }

  // ─── BUILD ───────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundDark, AppColors.backgroundMedium],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              _buildYearSelector(),
              _buildMonthChips(),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : FadeTransition(
                        opacity: _fadeAnim,
                        child: RefreshIndicator(
                          onRefresh: () async =>
                              _refreshData(showLoading: true),
                          child: SingleChildScrollView(
                            padding: AppSpacing.paddingLG,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSummaryCards(),
                                const SizedBox(height: AppSpacing.xl),
                                _selectedMonth == null
                                    ? _buildAnnualBreakdown()
                                    : _buildMonthlyBreakdown(),
                                const SizedBox(height: AppSpacing.xl),
                                _buildExportSection(),
                                const SizedBox(height: AppSpacing.xxxl),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── APP BAR ─────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surface.withAlpha(180),
                borderRadius: AppRadius.borderRadiusMD,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              'Histórico Financeiro',
              style: AppTypography.h4,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: const Icon(
              Icons.history,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ─── YEAR SELECTOR ───────────────────────────
  Widget _buildYearSelector() {
    final idx = _MockData.years.indexOf(_selectedYear);
    final canGoBack = idx < _MockData.years.length - 1;
    final canGoForward = idx > 0;

    return Padding(
      padding: AppSpacing.horizontalLG,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface.withAlpha(180),
          borderRadius: AppRadius.borderRadiusXL,
          border: Border.all(
            color: AppColors.primary.withAlpha(50),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _YearArrowButton(
              icon: Icons.chevron_left,
              enabled: canGoBack,
              onTap: () => _changeYear(-1),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                '$_selectedYear',
                key: ValueKey(_selectedYear),
                style: AppTypography.h4.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 2,
                ),
              ),
            ),
            _YearArrowButton(
              icon: Icons.chevron_right,
              enabled: canGoForward,
              onTap: () => _changeYear(1),
            ),
          ],
        ),
      ),
    );
  }

  // ─── MONTH CHIPS ─────────────────────────────
  Widget _buildMonthChips() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: AppSpacing.horizontalLG,
          itemCount: _MockData.monthNames.length + 1, // +1 = "Tudo"
          itemBuilder: (ctx, i) {
            if (i == 0) {
              final sel = _selectedMonth == null;
              return _MonthChip(
                label: 'Tudo',
                selected: sel,
                onTap: () => _selectMonth(null),
              );
            }
            final month = i; // 1-based
            final sel = _selectedMonth == month;
            return _MonthChip(
              label: _MockData.monthNames[i - 1],
              selected: sel,
              onTap: () => _selectMonth(month),
            );
          },
        ),
      ),
    );
  }

  // ─── SUMMARY CARDS ───────────────────────────
  Widget _buildSummaryCards() {
    return Row(
      children: [
        _SummaryCard(
          label: 'Ganhos',
          value: _earnings,
          color: AppColors.earnings,
          icon: Icons.trending_up,
          trend: '+12%',
        ),
        const SizedBox(width: AppSpacing.sm),
        _SummaryCard(
          label: 'Gastos',
          value: _expenses,
          color: AppColors.secondary,
          icon: Icons.trending_down,
          trend: '+5%',
        ),
        const SizedBox(width: AppSpacing.sm),
        _SummaryCard(
          label: 'Lucro',
          value: _profit,
          color: AppColors.accent,
          icon: Icons.account_balance_wallet,
          trend: '+18%',
        ),
      ],
    );
  }

  // ─── ANNUAL BREAKDOWN ────────────────────────
  Widget _buildAnnualBreakdown() {
    final yearData = _MockData.monthly[_selectedYear] ?? {};
    // Calcula o maior lucro do ano para normalizar as mini-barras
    double maxProfit = 1;
    for (final m in yearData.values) {
      final p = m['earnings']! - m['expenses']!;
      if (p > maxProfit) maxProfit = p;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumo por Mês', style: AppTypography.h4),
        const SizedBox(height: AppSpacing.lg),
        ...List.generate(12, (i) {
          final month = i + 1;
          final mData = yearData[month] ?? {'earnings': 0.0, 'expenses': 0.0};
          final e = mData['earnings']!;
          final x = mData['expenses']!;
          final p = e - x;
          return _AnnualMonthItem(
            month: month,
            monthName: _MockData.monthNames[i],
            year: _selectedYear,
            earnings: e,
            expenses: x,
            profit: p,
            maxProfit: maxProfit,
            onTap: () => _selectMonth(month),
          );
        }),
      ],
    );
  }

  // ─── MONTHLY BREAKDOWN ───────────────────────
  Widget _buildMonthlyBreakdown() {
    final yearData = _MockData.monthly[_selectedYear] ?? {};
    final mData = yearData[_selectedMonth] ?? {'earnings': 0.0, 'expenses': 0.0};
    final e = mData['earnings']!;
    final x = mData['expenses']!;
    final weeks = _MockData.weeklyBreakdown(e, x);
    final transactions = _MockData.recentTransactions(_selectedMonth!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Seção semanal
        Text('Breakdown Semanal', style: AppTypography.h4),
        const SizedBox(height: AppSpacing.lg),
        ...weeks.map((w) => _WeekItem(data: w)),
        const SizedBox(height: AppSpacing.xl),

        // Transações recentes
        Text('Transações Recentes', style: AppTypography.h4),
        const SizedBox(height: AppSpacing.lg),
        ...transactions.map((t) => _TransactionItem(data: t)),
      ],
    );
  }

  // ─── EXPORT SECTION ──────────────────────────
  Widget _buildExportSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(180),
        borderRadius: AppRadius.borderRadiusLG,
        border: Border.all(color: AppColors.primary.withAlpha(40)),
      ),
      padding: AppSpacing.paddingLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.file_download, color: AppColors.primary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text('Exportar Dados', style: AppTypography.h5),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _ExportButton(
                  icon: Icons.picture_as_pdf,
                  label: 'PDF',
                  color: const Color(0xFFEF4444),
                  onTap: () => _showSnackBar('Funcionalidade em breve'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ExportButton(
                  icon: Icons.table_chart,
                  label: 'Excel',
                  color: const Color(0xFF22C55E),
                  onTap: () => _showSnackBar('Funcionalidade em breve'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ExportButton(
                  icon: Icons.share,
                  label: 'Compartilhar',
                  color: AppColors.accent,
                  onTap: () => _showSnackBar('Funcionalidade em breve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WIDGETS AUXILIARES
// ─────────────────────────────────────────────

class _YearArrowButton extends StatelessWidget {
  const _YearArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary.withAlpha(40)
              : AppColors.textTertiary.withAlpha(30),
          borderRadius: AppRadius.borderRadiusMD,
        ),
        child: Icon(
          icon,
          color: enabled ? AppColors.primary : AppColors.textTertiary,
          size: 24,
        ),
      ),
    );
  }
}

class _MonthChip extends StatelessWidget {
  const _MonthChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface.withAlpha(200),
          borderRadius: AppRadius.borderRadiusRound,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.textTertiary.withAlpha(80),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.trend,
  });
  final String label;
  final double value;
  final Color color;
  final IconData icon;
  final String trend;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: AppSpacing.paddingMD,
        decoration: BoxDecoration(
          color: AppColors.surface.withAlpha(220),
          borderRadius: AppRadius.borderRadiusLG,
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withAlpha(40),
                    borderRadius: AppRadius.borderRadiusRound,
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              CurrencyFormatter.format(value),
              style: AppTypography.labelMedium.copyWith(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.caption.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnualMonthItem extends StatelessWidget {
  const _AnnualMonthItem({
    required this.month,
    required this.monthName,
    required this.year,
    required this.earnings,
    required this.expenses,
    required this.profit,
    required this.maxProfit,
    required this.onTap,
  });
  final int month;
  final String monthName;
  final int year;
  final double earnings;
  final double expenses;
  final double profit;
  final double maxProfit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final barRatio = maxProfit > 0 ? (profit / maxProfit).clamp(0.0, 1.0) : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: AppSpacing.paddingLG,
        decoration: BoxDecoration(
          color: AppColors.surface.withAlpha(200),
          borderRadius: AppRadius.borderRadiusMD,
          border: Border.all(color: AppColors.textTertiary.withAlpha(30)),
        ),
        child: Row(
          children: [
            // Mês abreviado
            SizedBox(
              width: 36,
              child: Text(
                monthName,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Mini-bar de lucro
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: AppRadius.borderRadiusRound,
                child: LinearProgressIndicator(
                  value: barRatio,
                  minHeight: 8,
                  backgroundColor: AppColors.backgroundDark,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    profit >= 0 ? AppColors.primary : AppColors.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            // Valores compactos
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _MiniValue(value: earnings, color: AppColors.earnings),
                  const SizedBox(width: AppSpacing.sm),
                  _MiniValue(value: expenses, color: AppColors.secondary),
                  const SizedBox(width: AppSpacing.sm),
                  _MiniValue(
                    value: profit,
                    color: profit >= 0 ? AppColors.accent : AppColors.secondary,
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
          ],
        ),
      ),
    );
  }
}

class _MiniValue extends StatelessWidget {
  const _MiniValue({
    required this.value,
    required this.color,
    this.isBold = false,
  });
  final double value;
  final Color color;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Text(
      CurrencyFormatter.format(value),
      style: TextStyle(
        fontSize: 10,
        fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
        color: color,
      ),
    );
  }
}

class _WeekItem extends StatelessWidget {
  const _WeekItem({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final week = data['week'] as int;
    final e = data['earnings'] as double;
    final x = data['expenses'] as double;
    final p = e - x;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(200),
        borderRadius: AppRadius.borderRadiusMD,
        border: Border.all(color: AppColors.textTertiary.withAlpha(30)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Text(
              'S$week',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Semana $week',
                  style: AppTypography.labelLarge.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  'G: ${CurrencyFormatter.format(e)}  •  D: ${CurrencyFormatter.format(x)}',
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.format(p),
            style: AppTypography.labelMedium.copyWith(
              color: p >= 0 ? AppColors.primary : AppColors.secondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final isEarning = data['type'] == 'earning';
    final color = isEarning ? AppColors.earnings : AppColors.secondary;
    final icon = isEarning ? Icons.arrow_upward : Icons.arrow_downward;
    final value = data['value'] as double;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(200),
        borderRadius: AppRadius.borderRadiusMD,
        border: Border.all(color: AppColors.textTertiary.withAlpha(30)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['desc'] as String,
                  style: AppTypography.labelLarge.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  data['date'] as String,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Text(
            '${value >= 0 ? '+' : ''}${CurrencyFormatter.format(value.abs())}',
            style: AppTypography.labelMedium.copyWith(color: color, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  const _ExportButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: AppRadius.borderRadiusMD,
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
