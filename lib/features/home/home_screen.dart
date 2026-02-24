import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/summary_card.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/transaction_card.dart';
import '../../core/widgets/app_card.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/supabase/supabase_service.dart';
import '../../shared/models/driver.dart';
import '../../shared/models/earning.dart';
import '../../shared/models/expense.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  bool _isLoading = true;
  
  // Dados do motorista vindos do Supabase
  Driver? _driver;
  
  // Totais reais vindos do Supabase (RPC)
  double _todayEarnings = 0.0;
  double _todayExpenses = 0.0;
  double _todayProfit = 0.0;
  
  // Atividades recentes reais
  List<dynamic> _recentActivities = [];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _loadDriverData(),
      _loadTotals(),
      _loadRecentActivities(),
    ]);
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadDriverData() async {
    try {
      final driver = await SupabaseService.getDriver();
      if (mounted) {
        setState(() {
          _driver = driver;
        });
      }
    } catch (e) {
      // Erro tratado no _loadAllData ou exibido via fallback
    }
  }

  Future<void> _loadTotals() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(seconds: 1));
      
      final totals = await SupabaseService.getPeriodTotals(startOfDay, endOfDay);
      if (mounted) {
        setState(() {
          _todayEarnings = totals['totalEarnings'] ?? 0.0;
          _todayExpenses = totals['totalExpenses'] ?? 0.0;
          _todayProfit = totals['netProfit'] ?? 0.0;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar totais: $e');
    }
  }

  Future<void> _loadRecentActivities() async {
    try {
      // Busca os últimos 5 ganhos e 5 despesas
      final results = await Future.wait([
        SupabaseService.getEarnings(from: 0, to: 4),
        SupabaseService.getExpenses(from: 0, to: 4),
      ]);
      
      final earnings = results[0] as List<Earning>;
      final expenses = results[1] as List<Expense>;
      
      // Combina e ordena por data decrescente
      final combined = [...earnings, ...expenses];
      combined.sort((a, b) {
        final dateA = a is Earning ? a.date : (a as Expense).date;
        final dateB = b is Earning ? b.date : (b as Expense).date;
        return dateB.compareTo(dateA);
      });
      
      if (mounted) {
        setState(() {
          _recentActivities = combined.take(5).toList();
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar atividades recentes: $e');
    }
  }


  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final greeting = _getGreeting();

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_driver == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Erro ao carregar perfil.', style: TextStyle(color: Colors.white)),
              TextButton(onPressed: _loadAllData, child: const Text('Tentar novamente')),
            ],
          ),
        ),
      );
    }

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
              _buildHeader(greeting, today),
              
              // Conteúdo scrollável
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.paddingXL,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card de Resumo do Dia
                      _buildTodaySummary(today),
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Botões de Ação Rápida
                      _buildQuickActions(),
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Resumo Semanal (Gráfico placeholder)
                      _buildWeeklySummary(),
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Atividade Recente
                      _buildRecentActivity(),
                    ],
                  ),
                ),
              ),
              
              // Bottom Navigation
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String greeting, DateTime today) {
    return Padding(
      padding: AppSpacing.paddingXL,
      child: Row(
        children: [
          AppAvatar(
            initials: _driver!.name.split(' ').map((n) => n[0]).take(2).join(),
            size: 50,
            onTap: () {
              context.push('/profile');
            },
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, ${_driver!.name.split(' ').first}',
                  style: AppTypography.h3,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  DateFormatter.formatFullDate(today),
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              // TODO: Implementar notificações
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySummary(DateTime today) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hoje',
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          DateFormatter.formatFullDate(today),
          style: AppTypography.caption,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            SummaryCard(
              icon: Icons.attach_money,
              label: 'Ganhos',
              value: CurrencyFormatter.format(_todayEarnings),
              iconColor: AppColors.earnings,
              onTap: () {
                context.push('/earnings');
              },
            ),
            const SizedBox(width: AppSpacing.md),
            SummaryCard(
              icon: Icons.shopping_cart,
              label: 'Gastos',
              value: CurrencyFormatter.format(_todayExpenses),
              iconColor: AppColors.expenses,
              onTap: () {
                context.push('/expenses');
              },
            ),
            const SizedBox(width: AppSpacing.md),
            SummaryCard(
              icon: _todayProfit >= 0 ? Icons.trending_up : Icons.trending_down,
              label: 'Lucro',
              value: CurrencyFormatter.format(_todayProfit),
              iconColor: _todayProfit >= 0 ? AppColors.profit : AppColors.loss,
              onTap: () {
                context.push('/reports');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações Rápidas',
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.add_circle,
                label: 'Adicionar Ganho',
                color: AppColors.earnings,
                onTap: () {
                  context.push('/earnings/add');
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.remove_circle,
                label: 'Adicionar Gasto',
                color: AppColors.expenses,
                onTap: () {
                  context.push('/expenses/add');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.bar_chart,
                label: 'Relatórios',
                color: AppColors.accent,
                onTap: () {
                  context.push('/reports');
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildQuickActionButton(
                icon: Icons.history,
                label: 'Histórico',
                color: AppColors.maintenance,
                onTap: () {
                  // TODO: Implementar histórico
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.paddingLG,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: color.withAlpha((0.2 * 255).round()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Últimos 7 dias',
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          padding: AppSpacing.paddingXL,
          child: Column(
            children: [
              // Placeholder para gráfico
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark.withAlpha((0.3 * 255).round()),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.bar_chart,
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
              // Legenda
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(AppColors.earnings, 'Ganhos'),
                  const SizedBox(width: AppSpacing.xl),
                  _buildLegendItem(AppColors.expenses, 'Gastos'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
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

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Atividade Recente',
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.lg),
        ..._recentActivities.map((activity) {
          if (activity is Earning) {
            final earning = activity;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: TransactionCard(
                icon: Icons.attach_money,
                iconColor: AppColors.earnings,
                description: earning.notes ?? 'Ganho do dia',
                date: DateFormatter.formatTime(earning.date),
                value: CurrencyFormatter.format(earning.value),
                valueColor: AppColors.earnings,
                onTap: () {
                  context.push('/detail/earning/${earning.id}', extra: earning);
                },
              ),
            );
          } else if (activity is Expense) {
            final expense = activity;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: TransactionCard(
                icon: _getExpenseIcon(expense),
                iconColor: _getExpenseColor(expense),
                description: expense.description,
                date: DateFormatter.formatTime(expense.date),
                value: CurrencyFormatter.format(expense.value),
                valueColor: AppColors.expenses,
                onTap: () {
                  context.push('/detail/expense/${expense.id}', extra: expense);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  IconData _getExpenseIcon(Expense expense) {
    switch (expense.category.toLowerCase()) {
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

  Color _getExpenseColor(Expense expense) {
    switch (expense.category.toLowerCase()) {
      case 'combustível':
      case 'fuel':
        return AppColors.fuel;
      case 'manutenção':
      case 'maintenance':
        return AppColors.maintenance;
      default:
        return AppColors.expenses;
    }
  }

  Widget _buildBottomNav() {
    return AppBottomNav(
      currentIndex: _currentNavIndex,
      onTap: (index) {
        setState(() {
          _currentNavIndex = index;
        });
        
        switch (index) {
          case 0:
            // Já está na home
            break;
          case 1:
            context.push('/earnings');
            break;
          case 2:
            context.push('/expenses');
            break;
          case 3:
            context.push('/reports');
            break;
          case 4:
            context.push('/profile');
            break;
        }
      },
      items: const [
        AppBottomNavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Home',
        ),
        AppBottomNavItem(
          icon: Icons.attach_money_outlined,
          activeIcon: Icons.attach_money,
          label: 'Ganhos',
        ),
        AppBottomNavItem(
          icon: Icons.shopping_cart_outlined,
          activeIcon: Icons.shopping_cart,
          label: 'Gastos',
        ),
        AppBottomNavItem(
          icon: Icons.bar_chart_outlined,
          activeIcon: Icons.bar_chart,
          label: 'Relatórios',
        ),
        AppBottomNavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Perfil',
        ),
      ],
    );
  }
}
