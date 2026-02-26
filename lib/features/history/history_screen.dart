import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/supabase/supabase_service.dart';
import '../../core/utils/export_utils.dart';

// ─────────────────────────────────────────────
//  CONSTANTS
// ─────────────────────────────────────────────
const List<String> _kMonthNames = [
  'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
  'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
];

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
  // ── state ──────────────────────────────────
  List<int> _availableYears = [];
  int _selectedYear = DateTime.now().year;
  int? _selectedMonth; // null = visão anual

  bool _isLoadingYears = true;
  bool _isLoadingData  = true;
  String? _error;

  // dados do período atual
  double _earnings = 0;
  double _expenses = 0;
  double _profit   = 0;

  // dados do período anterior (para calcular variação %)
  double _prevEarnings = 0;
  double _prevExpenses = 0;
  double _prevProfit   = 0;

  // breakdown lists
  List<Map<String, dynamic>> _monthlyData  = [];
  List<Map<String, dynamic>> _weeklyData   = [];
  List<Map<String, dynamic>> _transactions = [];

  // animation
  late AnimationController _animController;
  late Animation<double>    _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _selectedMonth = DateTime.now().month;
    _init();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ── initialise: years first, then data ─────
  Future<void> _init() async {
    await _loadAvailableYears();
    await _loadData();
  }

  Future<void> _loadAvailableYears() async {
    try {
      final years = await SupabaseService.getAvailableYears();
      if (!mounted) return;
      setState(() {
        _availableYears = years.isEmpty ? [DateTime.now().year] : years;
        // snap selection to a valid year
        if (!_availableYears.contains(_selectedYear)) {
          _selectedYear = _availableYears.first;
        }
        _isLoadingYears = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _availableYears  = [DateTime.now().year];
        _isLoadingYears  = false;
      });
    }
  }

  // ── load all data for current year/month ───
  Future<void> _loadData({bool showLoading = false}) async {
    if (!mounted) return;
    if (showLoading) setState(() => _isLoadingData = true);
    _animController.reset();
    _error = null;

    try {
      // current period
      final summary = await SupabaseService.getHistorySummary(
        _selectedYear,
        month: _selectedMonth,
      );

      // previous period (for trend %)
      final Map<String, double> prevSummary;
      if (_selectedMonth != null) {
        // previous month (may cross year boundary)
        final prevMonth = _selectedMonth! - 1;
        if (prevMonth == 0) {
          prevSummary = await SupabaseService.getHistorySummary(
            _selectedYear - 1,
            month: 12,
          );
        } else {
          prevSummary = await SupabaseService.getHistorySummary(
            _selectedYear,
            month: prevMonth,
          );
        }
      } else {
        // previous year
        prevSummary = await SupabaseService.getHistorySummary(_selectedYear - 1);
      }

      // breakdown
      List<Map<String, dynamic>> monthly  = [];
      List<Map<String, dynamic>> weekly   = [];
      List<Map<String, dynamic>> transactions = [];

      if (_selectedMonth == null) {
        monthly = await SupabaseService.getMonthlyBreakdown(_selectedYear);
      } else {
        weekly       = await SupabaseService.getWeeklyBreakdown(_selectedYear, _selectedMonth!);
        transactions = await SupabaseService.getRecentTransactionsForHistory(
          _selectedYear, _selectedMonth!,
        );
      }

      if (!mounted) return;
      setState(() {
        _earnings     = summary['totalEarnings']!;
        _expenses     = summary['totalExpenses']!;
        _profit       = _earnings - _expenses;
        _prevEarnings = prevSummary['totalEarnings']!;
        _prevExpenses = prevSummary['totalExpenses']!;
        _prevProfit   = _prevEarnings - _prevExpenses;
        _monthlyData  = monthly;
        _weeklyData   = weekly;
        _transactions = transactions;
        _isLoadingData = false;
      });
      _animController.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error         = 'Erro ao carregar dados. Tente novamente.';
        _isLoadingData = false;
      });
    }
  }

  // ── helpers ────────────────────────────────
  String _trendString(double current, double previous) {
    if (previous == 0) {
      return current > 0 ? '+100%' : '0%';
    }
    final pct = ((current - previous) / previous * 100).round();
    return pct >= 0 ? '+$pct%' : '$pct%';
  }

  void _changeYear(int delta) {
    final idx    = _availableYears.indexOf(_selectedYear);
    final newIdx = idx - delta; // seta → percorre da posição mais recente
    if (newIdx < 0 || newIdx >= _availableYears.length) return;
    setState(() => _selectedYear = _availableYears[newIdx]);
    _loadData(showLoading: true);
  }

  void _selectMonth(int? month) {
    setState(() => _selectedMonth = month);
    _loadData(showLoading: true);
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
              if (_isLoadingYears)
                const LinearProgressIndicator(color: AppColors.primary, minHeight: 2)
              else ...[
                _buildYearSelector(),
                _buildMonthChips(),
              ],
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: _isLoadingData
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    : _error != null
                        ? _buildErrorState()
                        : FadeTransition(
                            opacity: _fadeAnim,
                            child: RefreshIndicator(
                              onRefresh: () => _loadData(showLoading: true),
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

  // ─── ERROR STATE ─────────────────────────────
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, color: AppColors.textTertiary, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text(_error!, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: () => _loadData(showLoading: true),
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
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
            child: Text('Histórico Financeiro', style: AppTypography.h4),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: const Icon(Icons.history, color: AppColors.primary, size: 22),
          ),
        ],
      ),
    );
  }

  // ─── YEAR SELECTOR ───────────────────────────
  Widget _buildYearSelector() {
    final idx        = _availableYears.indexOf(_selectedYear);
    final canGoBack  = idx < _availableYears.length - 1; // mais antigo
    final canGoForward = idx > 0;                         // mais recente

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
          border: Border.all(color: AppColors.primary.withAlpha(50)),
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
          itemCount: _kMonthNames.length + 1, // +1 = "Tudo"
          itemBuilder: (ctx, i) {
            if (i == 0) {
              return _MonthChip(
                label: 'Tudo',
                selected: _selectedMonth == null,
                onTap: () => _selectMonth(null),
              );
            }
            final month = i; // 1-based
            return _MonthChip(
              label: _kMonthNames[i - 1],
              selected: _selectedMonth == month,
              onTap: () => _selectMonth(month),
            );
          },
        ),
      ),
    );
  }

  // ─── SUMMARY CARDS ───────────────────────────
  Widget _buildSummaryCards() {
    final earnTrend  = _trendString(_earnings, _prevEarnings);
    final expTrend   = _trendString(_expenses, _prevExpenses);
    final profTrend  = _trendString(_profit,   _prevProfit);

    return Row(
      children: [
        _SummaryCard(
          label: 'Ganhos',
          value: _earnings,
          color: AppColors.earnings,
          icon: Icons.trending_up,
          trend: earnTrend,
        ),
        const SizedBox(width: AppSpacing.sm),
        _SummaryCard(
          label: 'Gastos',
          value: _expenses,
          color: AppColors.secondary,
          icon: Icons.trending_down,
          trend: expTrend,
        ),
        const SizedBox(width: AppSpacing.sm),
        _SummaryCard(
          label: 'Lucro',
          value: _profit,
          color: AppColors.accent,
          icon: Icons.account_balance_wallet,
          trend: profTrend,
        ),
      ],
    );
  }

  // ─── ANNUAL BREAKDOWN ────────────────────────
  Widget _buildAnnualBreakdown() {
    if (_monthlyData.isEmpty) {
      return _buildEmptyState('Sem registros para $_selectedYear.');
    }

    final maxProfit = _monthlyData.fold<double>(
      1,
      (prev, m) => m['profit'] as double > prev ? m['profit'] as double : prev,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumo por Mês', style: AppTypography.h4),
        const SizedBox(height: AppSpacing.lg),
        ..._monthlyData.map((m) {
          final month = m['month'] as int;
          return _AnnualMonthItem(
            month:     month,
            monthName: _kMonthNames[month - 1],
            year:      _selectedYear,
            earnings:  m['earnings'] as double,
            expenses:  m['expenses'] as double,
            profit:    m['profit']   as double,
            maxProfit: maxProfit,
            onTap:    () => _selectMonth(month),
          );
        }),
      ],
    );
  }

  // ─── MONTHLY BREAKDOWN ───────────────────────
  Widget _buildMonthlyBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Seção semanal
        Text('Breakdown Semanal', style: AppTypography.h4),
        const SizedBox(height: AppSpacing.lg),
        if (_weeklyData.isEmpty)
          _buildEmptyState('Sem dados semanais para este mês.')
        else
          ..._weeklyData.map((w) => _WeekItem(data: w)),
        const SizedBox(height: AppSpacing.xl),

        // Transações recentes
        Text('Transações Recentes', style: AppTypography.h4),
        const SizedBox(height: AppSpacing.lg),
        if (_transactions.isEmpty)
          _buildEmptyState('Sem transações neste mês.')
        else
          ..._transactions.map((t) => _TransactionItem(data: t)),
      ],
    );
  }

  // ─── EMPTY STATE ─────────────────────────────
  Widget _buildEmptyState(String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Center(
        child: Text(
          msg,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ─── EXPORTAÇÃO REAL ─────────────────────────────
  Future<void> _exportData(String format) async {
    setState(() => _isLoadingData = true);
    try {
      final driver = await SupabaseService.getDriver();
      final driverName = driver?.name ?? 'Motorista';
      
      final periodName = _selectedMonth == null 
        ? 'Ano $_selectedYear'
        : '${_kMonthNames[_selectedMonth! - 1]} $_selectedYear';

      final start = _selectedMonth == null 
        ? DateTime(_selectedYear, 1, 1) 
        : DateTime(_selectedYear, _selectedMonth!, 1);
      final end = _selectedMonth == null 
        ? DateTime(_selectedYear, 12, 31) 
        : DateTime(_selectedYear, _selectedMonth! + 1, 0);

      final earningsList = await SupabaseService.getEarnings(
        start: start, end: end, to: 9999,
      );
      final expensesList = await SupabaseService.getExpenses(
        start: start, end: end, to: 9999,
      );

      if (!mounted) return;

      if (format == 'pdf' || format == 'share') {
        await ExportUtils.exportPdf(
          context: context,
          driverName: driverName,
          periodName: periodName,
          earnings: _earnings,
          expenses: _expenses,
          profit: _profit,
          allEarnings: earningsList,
          allExpenses: expensesList,
        );
      } else if (format == 'excel') {
        await ExportUtils.exportExcel(
          context: context,
          driverName: driverName,
          periodName: periodName,
          earnings: _earnings,
          expenses: _expenses,
          profit: _profit,
          allEarnings: earningsList,
          allExpenses: expensesList,
        );
      }
    } catch (e) {
      if (mounted) _showSnackBar('Erro ao exportar: $e');
    } finally {
      if (mounted) setState(() => _isLoadingData = false);
    }
  }

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
                  onTap: () => _exportData('pdf'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ExportButton(
                  icon: Icons.table_chart,
                  label: 'Excel',
                  color: const Color(0xFF22C55E),
                  onTap: () => _exportData('excel'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ExportButton(
                  icon: Icons.share,
                  label: 'Compartilhar',
                  color: AppColors.accent,
                  onTap: () => _exportData('share'),
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
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
    final e    = data['earnings'] as double;
    final x    = data['expenses'] as double;
    final p    = data['profit']   as double;  // already computed by RPC

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
    final color     = isEarning ? AppColors.earnings : AppColors.secondary;
    final icon      = isEarning ? Icons.arrow_upward : Icons.arrow_downward;
    final value     = data['value'] as double;
    final date      = data['date'] as DateTime;

    // Format date as "dd Mmm"
    final day     = date.day.toString().padLeft(2, '0');
    final monthNm = _kMonthNames[date.month - 1];
    final dateStr = '$day $monthNm';

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
                Text(dateStr, style: AppTypography.caption),
              ],
            ),
          ),
          Text(
            '${isEarning ? '+' : '-'}${CurrencyFormatter.format(value)}',
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
