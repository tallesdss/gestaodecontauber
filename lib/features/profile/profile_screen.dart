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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              const AppAvatar(
                initials: 'JD',
                size: 100,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implementar edição de avatar
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
            'João da Silva',
            style: AppTypography.h2,
          ),
          const SizedBox(height: AppSpacing.xs),

          // Membro desde
          Text(
            'Membro desde: Dezembro 2024',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Botão Editar Perfil
          AppButton(
            text: 'Editar Perfil',
            isOutlined: true,
            onPressed: () {
              // TODO: Navegar para tela de editar perfil
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
            // TODO: Navegar para gerenciar categorias
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMenuOption(
          context: context,
          icon: Icons.cloud_upload,
          title: 'Backup',
          subtitle: 'Fazer backup dos dados',
          onTap: () {
            // TODO: Implementar backup
            _showSnackBar(context, 'Backup realizado com sucesso!');
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMenuOption(
          context: context,
          icon: Icons.download,
          title: 'Exportar Dados',
          subtitle: 'Exportar relatórios',
          onTap: () {
            // TODO: Implementar exportação
            _showSnackBar(context, 'Dados exportados com sucesso!');
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMenuOption(
          context: context,
          icon: Icons.palette,
          title: 'Tema',
          subtitle: 'Escuro',
          trailing: Switch(
            value: true, // TODO: Implementar controle de tema
            onChanged: (value) {
              // TODO: Implementar toggle de tema
            },
            activeThumbColor: AppColors.primary,
          ),
          onTap: null,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMenuOption(
          context: context,
          icon: Icons.notifications,
          title: 'Notificações',
          subtitle: 'Gerenciar notificações',
          onTap: () {
            // TODO: Navegar para configurações de notificação
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMenuOption(
          context: context,
          icon: Icons.help,
          title: 'Ajuda',
          subtitle: 'Central de ajuda',
          onTap: () {
            // TODO: Mostrar ajuda
            _showSnackBar(context, 'Central de ajuda em breve!');
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLG,
        ),
        title: Text(
          'Confirmar Saída',
          style: AppTypography.h4,
        ),
        content: Text(
          'Tem certeza que deseja sair da sua conta?',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: AppTypography.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implementar logout
              _showSnackBar(context, 'Logout realizado com sucesso!');
            },
            child: Text(
              'Sair',
              style: AppTypography.button.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLG,
        ),
        title: Text(
          'Sobre o App',
          style: AppTypography.h4,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UberControl',
              style: AppTypography.h5,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Versão 1.0.0',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Aplicativo para gestão financeira de motoristas de aplicativo.',
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Fechar',
              style: AppTypography.button.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
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
