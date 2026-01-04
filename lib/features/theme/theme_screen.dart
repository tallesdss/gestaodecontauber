import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  String _selectedTheme = 'dark'; // 'dark', 'light', 'system'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: const AppTopBar(
        title: 'Tema',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingXL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card de informações
            _buildInfoCard(),
            const SizedBox(height: AppSpacing.xxl),

            // Opções de tema
            Text(
              'Modo de Tema',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildThemeOption(
              icon: Icons.dark_mode,
              title: 'Escuro',
              subtitle: 'Tema escuro (padrão)',
              value: 'dark',
              isSelected: _selectedTheme == 'dark',
              onTap: () {
                setState(() {
                  _selectedTheme = 'dark';
                });
                // TODO: Implementar mudança de tema
              },
            ),
            const SizedBox(height: AppSpacing.md),

            _buildThemeOption(
              icon: Icons.light_mode,
              title: 'Claro',
              subtitle: 'Tema claro',
              value: 'light',
              isSelected: _selectedTheme == 'light',
              onTap: () {
                setState(() {
                  _selectedTheme = 'light';
                });
                // TODO: Implementar mudança de tema
              },
            ),
            const SizedBox(height: AppSpacing.md),

            _buildThemeOption(
              icon: Icons.brightness_auto,
              title: 'Sistema',
              subtitle: 'Seguir configuração do sistema',
              value: 'system',
              isSelected: _selectedTheme == 'system',
              onTap: () {
                setState(() {
                  _selectedTheme = 'system';
                });
                // TODO: Implementar mudança de tema
              },
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Preview do tema
            Text(
              'Preview',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildThemePreview(),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return AppCard(
      padding: AppSpacing.paddingLG,
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Escolha o tema que melhor se adapta ao seu uso. O tema escuro economiza bateria em telas OLED.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.paddingLG,
      color: isSelected
          ? AppColors.primary.withAlpha((0.1 * 255).round())
          : null,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: (isSelected ? AppColors.primary : AppColors.textSecondary)
                  .withAlpha((0.2 * 255).round()),
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
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
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }

  Widget _buildThemePreview() {
    return AppCard(
      padding: AppSpacing.paddingLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Como ficará o app',
            style: AppTypography.labelLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          // Preview de card
          Container(
            padding: AppSpacing.paddingLG,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha((0.2 * 255).round()),
                    borderRadius: AppRadius.borderRadiusMD,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
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
                        'Ganhos do Mês',
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'R\$ 5.000,00',
                        style: AppTypography.h4.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Preview de botão
          Container(
            padding: AppSpacing.paddingLG,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: Center(
              child: Text(
                'Botão de Ação',
                style: AppTypography.button,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

