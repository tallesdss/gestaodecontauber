import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_chip.dart';
import '../../core/widgets/app_button.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../shared/models/expense.dart';

enum FilterPeriod { today, week, month, custom }
enum ExpenseCategory { all, fuel, maintenance, carWash, parking, toll, others }

class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({super.key});

  @override
  State<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  FilterPeriod _selectedPeriod = FilterPeriod.month;
  ExpenseCategory _selectedCategory = ExpenseCategory.all;

  // Dados mock - serão substituídos por dados reais depois
  final List<Expense> _expenses = [
    Expense(
      id: '1',
      date: DateTime.now(),
      category: 'Combustível',
      value: 150.0,
      description: 'Gasolina comum',
      liters: 50.0,
    ),
    Expense(
      id: '2',
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Manutenção',
      value: 200.0,
      description: 'Troca de óleo',
    ),
    Expense(
      id: '3',
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Lavagem',
      value: 30.0,
      description: 'Lavagem completa',
    ),
    Expense(
      id: '4',
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Combustível',
      value: 120.0,
      description: 'Gasolina aditivada',
      liters: 40.0,
    ),
    Expense(
      id: '5',
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Estacionamento',
      value: 15.0,
      description: 'Shopping Center',
    ),
    Expense(
      id: '6',
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Pedágio',
      value: 45.0,
      description: 'Pedágio rodovia',
    ),
    Expense(
      id: '7',
      date: DateTime.now().subtract(const Duration(days: 4)),
      category: 'Manutenção',
      value: 350.0,
      description: 'Revisão completa',
      notes: 'Inclui freios e pneus',
    ),
    Expense(
      id: '8',
      date: DateTime.now().subtract(const Duration(days: 5)),
      category: 'Combustível',
      value: 180.0,
      description: 'Gasolina comum',
      liters: 60.0,
    ),
  ];

  List<Expense> get _filteredExpenses {
    final now = DateTime.now();
    List<Expense> filtered = _expenses;

    // Filtro por período
    switch (_selectedPeriod) {
      case FilterPeriod.today:
        filtered = filtered.where((e) {
          return e.date.year == now.year &&
              e.date.month == now.month &&
              e.date.day == now.day;
        }).toList();
        break;
      case FilterPeriod.week:
        final weekAgo = now.subtract(const Duration(days: 7));
        filtered = filtered.where((e) => e.date.isAfter(weekAgo)).toList();
        break;
      case FilterPeriod.month:
        filtered = filtered.where((e) {
          return e.date.year == now.year && e.date.month == now.month;
        }).toList();
        break;
      case FilterPeriod.custom:
        // TODO: Implementar filtro personalizado
        break;
    }

    // Filtro por categoria
    if (_selectedCategory != ExpenseCategory.all) {
      final categoryMap = {
        ExpenseCategory.fuel: 'Combustível',
        ExpenseCategory.maintenance: 'Manutenção',
        ExpenseCategory.carWash: 'Lavagem',
        ExpenseCategory.parking: 'Estacionamento',
        ExpenseCategory.toll: 'Pedágio',
        ExpenseCategory.others: 'Outros',
      };
      final categoryName = categoryMap[_selectedCategory];
      filtered = filtered
          .where((e) => e.category.toLowerCase() == categoryName?.toLowerCase())
          .toList();
    }

    return filtered;
  }

  double get _totalExpenses {
    return _filteredExpenses.fold(0.0, (sum, expense) => sum + expense.value);
  }

  double get _averageExpense {
    if (_filteredExpenses.isEmpty) return 0.0;
    return _totalExpenses / _filteredExpenses.length;
  }

  Map<DateTime, List<Expense>> get _groupedExpenses {
    final grouped = <DateTime, List<Expense>>{};
    for (var expense in _filteredExpenses) {
      final date = DateTime(expense.date.year, expense.date.month, expense.date.day);
      grouped.putIfAbsent(date, () => []).add(expense);
    }
    // Ordenar por data (mais recente primeiro)
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final sorted = <DateTime, List<Expense>>{};
    for (var key in sortedKeys) {
      sorted[key] = grouped[key]!;
    }
    return sorted;
  }

  Map<String, double> get _expensesByCategory {
    final map = <String, double>{};
    for (var expense in _filteredExpenses) {
      map[expense.category] = (map[expense.category] ?? 0.0) + expense.value;
    }
    return map;
  }

  double _getDayTotal(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, expense) => sum + expense.value);
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'combustível':
      case 'fuel':
        return Icons.local_gas_station;
      case 'manutenção':
      case 'maintenance':
        return Icons.build;
      case 'lavagem':
      case 'car_wash':
        return Icons.local_car_wash;
      case 'estacionamento':
      case 'parking':
        return Icons.local_parking;
      case 'pedágio':
      case 'toll':
        return Icons.toll;
      default:
        return Icons.shopping_cart;
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
      case 'parking':
        return AppColors.info;
      case 'pedágio':
      case 'toll':
        return AppColors.warning;
      default:
        return AppColors.expenses;
    }
  }

  void _showDeleteDialog(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLG,
        ),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.error,
              size: 28,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Excluir Gasto?',
                style: AppTypography.h4,
              ),
            ),
          ],
        ),
        content: Text(
          'Esta ação não pode ser desfeita.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppTypography.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implementar exclusão
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Gasto excluído com sucesso',
                    style: AppTypography.bodyMedium,
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(
              'Excluir',
              style: AppTypography.button.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenuBottomSheet(Expense expense) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            // Opções
            _buildMenuOption(
              icon: Icons.visibility_outlined,
              label: 'Ver detalhes',
              onTap: () {
                Navigator.pop(context);
                context.push('/detail/expense/${expense.id}', extra: expense);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildMenuOption(
              icon: Icons.edit_outlined,
              label: 'Editar',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar para editar
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildMenuOption(
              icon: Icons.delete_outline,
              label: 'Excluir',
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(expense);
              },
              isDestructive: true,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
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
              color: isDestructive ? AppColors.error : AppColors.textPrimary,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.lg),
            Text(
              label,
              style: AppTypography.bodyLarge.copyWith(
                color: isDestructive ? AppColors.error : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredExpenses;
    final grouped = _groupedExpenses;

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

              // Conteúdo scrollável
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState()
                    : SingleChildScrollView(
                        padding: AppSpacing.paddingXL,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Filtros por período
                            _buildPeriodFilters(),
                            const SizedBox(height: AppSpacing.lg),

                            // Filtros por categoria
                            _buildCategoryFilters(),
                            const SizedBox(height: AppSpacing.xl),

                            // Resumo do Período
                            _buildPeriodSummary(),
                            const SizedBox(height: AppSpacing.xl),

                            // Gráfico de Gastos por Categoria
                            _buildCategoryChart(),
                            const SizedBox(height: AppSpacing.xl),

                            // Lista de Gastos
                            _buildExpensesList(grouped),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: AppSpacing.paddingXL,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
            ),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              'Meus Gastos',
              style: AppTypography.h3,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              context.push('/expenses/add');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Período',
          style: AppTypography.labelLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AppChip(
                label: 'Hoje',
                isSelected: _selectedPeriod == FilterPeriod.today,
                onTap: () {
                  setState(() {
                    _selectedPeriod = FilterPeriod.today;
                  });
                },
              ),
              const SizedBox(width: AppSpacing.md),
              AppChip(
                label: 'Semana',
                isSelected: _selectedPeriod == FilterPeriod.week,
                onTap: () {
                  setState(() {
                    _selectedPeriod = FilterPeriod.week;
                  });
                },
              ),
              const SizedBox(width: AppSpacing.md),
              AppChip(
                label: 'Mês',
                isSelected: _selectedPeriod == FilterPeriod.month,
                onTap: () {
                  setState(() {
                    _selectedPeriod = FilterPeriod.month;
                  });
                },
              ),
              const SizedBox(width: AppSpacing.md),
              AppChip(
                label: 'Personalizado',
                icon: Icons.calendar_today,
                isSelected: _selectedPeriod == FilterPeriod.custom,
                onTap: () {
                  setState(() {
                    _selectedPeriod = FilterPeriod.custom;
                  });
                  // TODO: Abrir DateRangePicker
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categoria',
          style: AppTypography.labelLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AppChip(
                label: 'Todos',
                isSelected: _selectedCategory == ExpenseCategory.all,
                onTap: () {
                  setState(() {
                    _selectedCategory = ExpenseCategory.all;
                  });
                },
              ),
              const SizedBox(width: AppSpacing.md),
              AppChip(
                label: 'Combustível',
                icon: Icons.local_gas_station,
                isSelected: _selectedCategory == ExpenseCategory.fuel,
                onTap: () {
                  setState(() {
                    _selectedCategory = ExpenseCategory.fuel;
                  });
                },
              ),
              const SizedBox(width: AppSpacing.md),
              AppChip(
                label: 'Manutenção',
                icon: Icons.build,
                isSelected: _selectedCategory == ExpenseCategory.maintenance,
                onTap: () {
                  setState(() {
                    _selectedCategory = ExpenseCategory.maintenance;
                  });
                },
              ),
              const SizedBox(width: AppSpacing.md),
              AppChip(
                label: 'Lavagem',
                icon: Icons.local_car_wash,
                isSelected: _selectedCategory == ExpenseCategory.carWash,
                onTap: () {
                  setState(() {
                    _selectedCategory = ExpenseCategory.carWash;
                  });
                },
              ),
              const SizedBox(width: AppSpacing.md),
              AppChip(
                label: 'Outros',
                isSelected: _selectedCategory == ExpenseCategory.others,
                onTap: () {
                  setState(() {
                    _selectedCategory = ExpenseCategory.others;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSummary() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo do Período',
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total de gastos',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      CurrencyFormatter.format(_totalExpenses),
                      style: AppTypography.h3.copyWith(
                        color: AppColors.expenses,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.textTertiary.withAlpha((0.3 * 255).round()),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total de registros',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${_filteredExpenses.length} gastos',
                      style: AppTypography.h4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.textTertiary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Icon(
                Icons.trending_down,
                color: AppColors.expenses,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Gasto médio: ',
                style: AppTypography.bodyMedium,
              ),
              Text(
                CurrencyFormatter.format(_averageExpense),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.expenses,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChart() {
    final expensesByCategory = _expensesByCategory;
    if (expensesByCategory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gastos por Categoria',
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          padding: AppSpacing.paddingXL,
          child: Column(
            children: [
              // Placeholder para gráfico de pizza/donut
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark.withAlpha((0.3 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.pie_chart,
                        size: 48,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Gráfico será implementado',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Lista de categorias com valores
              ...expensesByCategory.entries.map((entry) {
                final category = entry.key;
                final value = entry.value;
                final percentage = (_totalExpenses > 0)
                    ? (value / _totalExpenses * 100).toStringAsFixed(1)
                    : '0.0';

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(category),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          category,
                          style: AppTypography.bodyMedium,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(value),
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '($percentage%)',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesList(Map<DateTime, List<Expense>> grouped) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gastos',
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.lg),
        ...grouped.entries.map((entry) {
          final date = entry.key;
          final expenses = entry.value;
          final dayTotal = _getDayTotal(expenses);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho do dia
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.md,
                  bottom: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormatter.formatDate(date),
                      style: AppTypography.labelLarge,
                    ),
                    Text(
                      CurrencyFormatter.format(dayTotal),
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.expenses,
                      ),
                    ),
                  ],
                ),
              ),
              // Lista de gastos do dia
              ...expenses.map((expense) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildExpenseCard(expense),
                );
              }),
              const SizedBox(height: AppSpacing.lg),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildExpenseCard(Expense expense) {
    final categoryIcon = _getCategoryIcon(expense.category);
    final categoryColor = _getCategoryColor(expense.category);

    return AppCard(
      onTap: () {
        context.push('/detail/expense/${expense.id}', extra: expense);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ícone da categoria
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: categoryColor.withAlpha((0.2 * 255).round()),
                  borderRadius: AppRadius.borderRadiusMD,
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Informações principais
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          expense.category,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          DateFormatter.formatTime(expense.date),
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      expense.description,
                      style: AppTypography.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (expense.liters != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_gas_station,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${expense.liters!.toStringAsFixed(1)}L',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Valor
              Text(
                CurrencyFormatter.format(expense.value),
                style: AppTypography.h4.copyWith(
                  color: AppColors.expenses,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Menu de ações
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () => _showMenuBottomSheet(expense),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          // Badge da categoria
          if (expense.category.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: categoryColor.withAlpha((0.2 * 255).round()),
                borderRadius: AppRadius.borderRadiusSM,
              ),
              child: Text(
                expense.category,
                style: AppTypography.caption.copyWith(
                  color: categoryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          // Observações (se houver)
          if (expense.notes != null && expense.notes!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingMD,
              decoration: BoxDecoration(
                color: AppColors.backgroundDark.withAlpha((0.3 * 255).round()),
                borderRadius: AppRadius.borderRadiusMD,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.note_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      expense.notes!,
                      style: AppTypography.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Nenhum gasto registrado',
              style: AppTypography.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Comece adicionando seu primeiro gasto',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              text: 'Adicionar Gasto',
              icon: Icons.add_circle,
              onPressed: () {
                context.push('/expenses/add');
              },
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
