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
import '../../core/supabase/supabase_service.dart';
import '../../core/supabase/supabase_error_handler.dart';
import '../../shared/models/earning.dart';

enum FilterPeriod { today, week, month, custom }

class EarningsListScreen extends StatefulWidget {
  const EarningsListScreen({super.key});

  @override
  State<EarningsListScreen> createState() => _EarningsListScreenState();
}

class _EarningsListScreenState extends State<EarningsListScreen> {
  FilterPeriod _selectedPeriod = FilterPeriod.month;
  bool _isLoading = true;
  final List<Earning> _earnings = [];

  @override
  void initState() {
    super.initState();
    _loadEarnings();
  }

  Future<void> _loadEarnings() async {
    setState(() => _isLoading = true);
    
    DateTime? start;
    DateTime? end = DateTime.now();
    final now = DateTime.now();

    switch (_selectedPeriod) {
      case FilterPeriod.today:
        start = DateTime(now.year, now.month, now.day);
        break;
      case FilterPeriod.week:
        start = now.subtract(const Duration(days: 7));
        break;
      case FilterPeriod.month:
        start = DateTime(now.year, now.month, 1);
        break;
      case FilterPeriod.custom:
        // TODO: Implementar custom range
        break;
    }

    try {
      final earnings = await SupabaseService.getEarnings(
        start: start,
        end: end,
      );
      if (mounted) {
        setState(() {
          _earnings.clear();
          _earnings.addAll(earnings);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Exibir erro se necessário
      }
    }
  }

  List<Earning> get _filteredEarnings => _earnings;

  double get _totalEarnings {
    return _filteredEarnings.fold(0.0, (sum, earning) => sum + earning.value);
  }

  double get _averagePerDay {
    if (_filteredEarnings.isEmpty) return 0.0;
    final days = _filteredEarnings.map((e) => e.date.day).toSet().length;
    return days > 0 ? _totalEarnings / days : 0.0;
  }

  Map<DateTime, List<Earning>> get _groupedEarnings {
    final grouped = <DateTime, List<Earning>>{};
    for (var earning in _filteredEarnings) {
      final date = DateTime(earning.date.year, earning.date.month, earning.date.day);
      grouped.putIfAbsent(date, () => []).add(earning);
    }
    // Ordenar por data (mais recente primeiro)
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final sorted = <DateTime, List<Earning>>{};
    for (var key in sortedKeys) {
      sorted[key] = grouped[key]!;
    }
    return sorted;
  }

  double _getDayTotal(List<Earning> earnings) {
    return earnings.fold(0.0, (sum, earning) => sum + earning.value);
  }

  IconData _getPlatformIcon(String? platform) {
    switch (platform?.toLowerCase()) {
      case 'uber':
        return Icons.directions_car;
      case '99':
        return Icons.local_taxi;
      case 'indrive':
        return Icons.car_rental;
      default:
        return Icons.attach_money;
    }
  }

  void _showDeleteDialog(Earning earning) {
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
                'Excluir Ganho?',
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
            onPressed: () async {
              try {
                await SupabaseService.deleteEarning(earning.id);
                if (!context.mounted) return;
                
                Navigator.pop(context);
                _loadEarnings(); // Recarrega a lista
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Ganho excluído com sucesso',
                      style: AppTypography.bodyMedium,
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      SupabaseErrorHandler.mapError(e),
                      style: AppTypography.bodyMedium,
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
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

  void _showMenuBottomSheet(Earning earning) {
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
              onTap: () async {
                Navigator.pop(context);
                final result = await context.push('/detail/earning/${earning.id}', extra: earning);
                if (result == true) {
                  _loadEarnings();
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildMenuOption(
              icon: Icons.edit_outlined,
              label: 'Editar',
              onTap: () async {
                Navigator.pop(context);
                final result = await context.push('/earnings/add', extra: earning);
                if (result == true) {
                  _loadEarnings();
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildMenuOption(
              icon: Icons.delete_outline,
              label: 'Excluir',
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(earning);
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
    final filtered = _filteredEarnings;
    final grouped = _groupedEarnings;

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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _loadEarnings,
                            child: SingleChildScrollView(
                                padding: AppSpacing.paddingXL,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Filtros
                                    _buildFilters(),
                                    const SizedBox(height: AppSpacing.xl),
                                    
                                    // Resumo do Período
                                    _buildPeriodSummary(),
                                    const SizedBox(height: AppSpacing.xl),
                                    
                                    // Lista de Ganhos
                                    _buildEarningsList(grouped),
                                  ],
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
              'Meus Ganhos',
              style: AppTypography.h3,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.textPrimary,
            ),
            onPressed: () async {
              final result = await context.push('/earnings/add');
              if (result == true) {
                _loadEarnings();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          AppChip(
            label: 'Hoje',
            isSelected: _selectedPeriod == FilterPeriod.today,
            onTap: () {
              setState(() => _selectedPeriod = FilterPeriod.today);
              _loadEarnings();
            },
          ),
          const SizedBox(width: AppSpacing.md),
          AppChip(
            label: 'Semana',
            isSelected: _selectedPeriod == FilterPeriod.week,
            onTap: () {
              setState(() => _selectedPeriod = FilterPeriod.week);
              _loadEarnings();
            },
          ),
          const SizedBox(width: AppSpacing.md),
          AppChip(
            label: 'Mês',
            isSelected: _selectedPeriod == FilterPeriod.month,
            onTap: () {
              setState(() => _selectedPeriod = FilterPeriod.month);
              _loadEarnings();
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
                      'Total de ganhos',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      CurrencyFormatter.format(_totalEarnings),
                      style: AppTypography.h3.copyWith(
                        color: AppColors.earnings,
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
                      '${_filteredEarnings.length} ganhos',
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
                Icons.trending_up,
                color: AppColors.earnings,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Média por dia: ',
                style: AppTypography.bodyMedium,
              ),
              Text(
                CurrencyFormatter.format(_averagePerDay),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.earnings,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsList(Map<DateTime, List<Earning>> grouped) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ganhos',
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.lg),
        ...grouped.entries.map((entry) {
          final date = entry.key;
          final earnings = entry.value;
          final dayTotal = _getDayTotal(earnings);

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
                        color: AppColors.earnings,
                      ),
                    ),
                  ],
                ),
              ),
              // Lista de ganhos do dia
              ...earnings.map((earning) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildEarningCard(earning),
                );
              }),
              const SizedBox(height: AppSpacing.lg),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildEarningCard(Earning earning) {
    return AppCard(
      onTap: () async {
        final result = await context.push('/detail/earning/${earning.id}', extra: earning);
        if (result == true) {
          _loadEarnings();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ícone da plataforma
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.earnings.withAlpha((0.2 * 255).round()),
                  borderRadius: AppRadius.borderRadiusMD,
                ),
                child: Icon(
                  _getPlatformIcon(earning.platform),
                  color: AppColors.earnings,
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
                        if (earning.platform != null) ...[
                          Text(
                            earning.platform!,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Text(
                          DateFormatter.formatTime(earning.date),
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                    if (earning.numberOfRides != null ||
                        earning.hoursWorked != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          if (earning.numberOfRides != null) ...[
                            const Icon(
                              Icons.pin_drop,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${earning.numberOfRides} corridas',
                              style: AppTypography.caption,
                            ),
                            if (earning.hoursWorked != null)
                              const SizedBox(width: AppSpacing.md),
                          ],
                          if (earning.hoursWorked != null) ...[
                            const Icon(
                              Icons.schedule,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${earning.hoursWorked!.toStringAsFixed(1)}h',
                              style: AppTypography.caption,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Valor
              Text(
                CurrencyFormatter.format(earning.value),
                style: AppTypography.h4.copyWith(
                  color: AppColors.earnings,
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
                onPressed: () => _showMenuBottomSheet(earning),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          // Observações (se houver)
          if (earning.notes != null && earning.notes!.isNotEmpty) ...[
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
                      earning.notes!,
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
              Icons.attach_money_outlined,
              size: 80,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Nenhum ganho registrado',
              style: AppTypography.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Comece adicionando seu primeiro ganho',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              text: 'Adicionar Ganho',
              icon: Icons.add_circle,
              onPressed: () async {
                final result = await context.push('/earnings/add');
                if (result == true) {
                  _loadEarnings();
                }
              },
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
