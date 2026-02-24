import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/summary_card.dart';
import '../../core/widgets/app_dialogs.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/supabase/auth_service.dart';

import '../../core/supabase/supabase_service.dart';
import '../../shared/models/driver.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Driver? _driver;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDriverData();
  }

  Future<void> _loadDriverData() async {
    try {
      final driver = await SupabaseService.getDriver();
      if (mounted) {
        setState(() {
          _driver = driver;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(child: CircularProgressIndicator()),
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
              TextButton(onPressed: _loadDriverData, child: const Text('Tentar novamente')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: const AppTopBar(
        title: 'Perfil',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingXL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card do Usuário
            _buildUserCard(context),
            const SizedBox(height: AppSpacing.xxl),

            // Estatísticas Rápidas
            _buildStatisticsSection(),
            const SizedBox(height: AppSpacing.xxl),

            // Menu de Opções
            _buildMenuSection(context),
            const SizedBox(height: AppSpacing.xxl),

            // Botão Sair
            _buildLogoutButton(context),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context) {
    return AppCard(
      padding: AppSpacing.paddingXXL,
      child: Column(
        children: [
          // Avatar editável
          Stack(
            children: [
              AppAvatar(
                initials: _driver!.name.split(' ').map((n) => n[0]).take(2).join(),
                size: 100,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                onTap: () async {
                  final result = await context.push('/profile/edit', extra: _driver);
                  if (result == true) {
                    _loadDriverData();
                  }
                },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.backgroundDark,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Nome do motorista
          Text(
            _driver!.name,
            style: AppTypography.h2,
          ),
          const SizedBox(height: AppSpacing.xs),

          // Membro desde
          Text(
            'Membro desde: ${DateFormatter.formatMonthYear(_driver!.memberSince)}',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Botão Editar Perfil
          AppButton(
            text: 'Editar Perfil',
            isOutlined: true,
            onPressed: () async {
              final result = await context.push('/profile/edit', extra: _driver);
              if (result == true) {
                _loadDriverData();
              }
            },
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return const Row(
      children: [
        SummaryCard(
          icon: Icons.trending_up,
          label: 'Total Ganho',
          value: 'R\$ 45.000,00',
          iconColor: AppColors.earnings,
        ),
        SizedBox(width: AppSpacing.md),
        SummaryCard(
          icon: Icons.trending_down,
          label: 'Total Gasto',
          value: 'R\$ 12.000,00',
          iconColor: AppColors.expenses,
        ),
        SizedBox(width: AppSpacing.md),
        SummaryCard(
          icon: Icons.account_balance_wallet,
          label: 'Lucro Total',
          value: 'R\$ 33.000,00',
          iconColor: AppColors.profit,
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configurações',
          style: AppTypography.h4,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildMenuOption(
          context: context,
          icon: Icons.flag,
          title: 'Metas',
          subtitle: 'Definir metas mensais',
          onTap: () {
            context.push('/goals');
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMenuOption(
          context: context,
          icon: Icons.category,
          title: 'Categorias',
          subtitle: 'Gerenciar categorias de gastos',
          onTap: () {
            context.push('/categories');
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMenuOption(
          context: context,
          icon: Icons.cloud_upload,
          title: 'Backup',
          subtitle: 'Fazer backup dos dados',
          onTap: () {
            context.push('/backup');
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMenuOption(
          context: context,
          icon: Icons.download,
          title: 'Exportar Dados',
          subtitle: 'Exportar relatórios',
          onTap: () {
            context.push('/export');
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMenuOption(
          context: context,
          icon: Icons.palette,
          title: 'Tema',
          subtitle: 'Escuro',
          onTap: () {
            context.push('/theme');
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMenuOption(
          context: context,
          icon: Icons.notifications,
          title: 'Notificações',
          subtitle: 'Gerenciar notificações',
          onTap: () {
            context.push('/notifications');
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMenuOption(
          context: context,
          icon: Icons.help,
          title: 'Ajuda',
          subtitle: 'Central de ajuda',
          onTap: () {
            context.push('/help');
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMenuOption(
          context: context,
          icon: Icons.info,
          title: 'Sobre',
          subtitle: 'Versão 1.0.0',
          onTap: () {
            // TODO: Mostrar informações do app
            _showAboutDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.paddingLG,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha((0.2 * 255).round()),
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          if (trailing != null)
            trailing
          else
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
            ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return AppButton(
      text: 'Sair',
      backgroundColor: AppColors.error,
      onPressed: () {
        _showLogoutDialog(context);
      },
      width: double.infinity,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    AppConfirmDialog.show(
      context: context,
      title: 'Confirmar Saída',
      message: 'Tem certeza que deseja sair da sua conta?',
      confirmText: 'Sair',
      cancelText: 'Cancelar',
      confirmColor: AppColors.error,
      onConfirm: () async {
        await AuthService.signOut();
        if (context.mounted) {
          _showSnackBar(context, 'Saída realizada com sucesso!');
        }
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    AppAboutDialog.show(
      context: context,
      appName: 'UberControl',
      version: '1.0.0',
      description: 'Aplicativo para gestão financeira de motoristas de aplicativo.',
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMD,
        ),
      ),
    );
  }
}
