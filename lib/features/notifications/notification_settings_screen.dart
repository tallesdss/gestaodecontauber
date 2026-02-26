import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Configurações de notificações
  bool _enableNotifications = true;
  bool _enableSound = true;
  bool _enableVibration = true;
  bool _enableReminders = true;
  bool _enableReports = false;
  bool _enableGoals = true;
  bool _enableBackup = false;

  // Horários de lembretes
  String _reminderTime = '20:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: const AppTopBar(
        title: 'Notificações',
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

            // Notificações gerais
            Text(
              'Notificações Gerais',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildNotificationToggle(
              icon: Icons.notifications_active,
              title: 'Ativar Notificações',
              subtitle: 'Receber notificações do app',
              value: _enableNotifications,
              onChanged: (value) {
                setState(() {
                  _enableNotifications = value;
                  if (!value) {
                    _enableSound = false;
                    _enableVibration = false;
                    _enableReminders = false;
                    _enableReports = false;
                    _enableGoals = false;
                    _enableBackup = false;
                  }
                });
                // TODO: Implementar controle de notificações
              },
            ),

            if (_enableNotifications) ...[
              const SizedBox(height: AppSpacing.md),
              _buildNotificationToggle(
                icon: Icons.volume_up,
                title: 'Som',
                subtitle: 'Tocar som nas notificações',
                value: _enableSound,
                onChanged: (value) {
                  setState(() {
                    _enableSound = value;
                  });
                  // TODO: Implementar controle de som
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _buildNotificationToggle(
                icon: Icons.vibration,
                title: 'Vibração',
                subtitle: 'Vibrar ao receber notificações',
                value: _enableVibration,
                onChanged: (value) {
                  setState(() {
                    _enableVibration = value;
                  });
                  // TODO: Implementar controle de vibração
                },
              ),
            ],

            const SizedBox(height: AppSpacing.xxl),

            // Tipos de notificações
            if (_enableNotifications) ...[
              Text(
                'Tipos de Notificações',
                style: AppTypography.h4,
              ),
              const SizedBox(height: AppSpacing.lg),

              _buildNotificationToggle(
                icon: Icons.access_time,
                title: 'Lembretes Diários',
                subtitle: 'Lembrar de registrar ganhos e gastos',
                value: _enableReminders,
                onChanged: (value) {
                  setState(() {
                    _enableReminders = value;
                  });
                  // TODO: Implementar lembretes
                },
              ),

              if (_enableReminders) ...[
                const SizedBox(height: AppSpacing.md),
                _buildTimeSelector(),
              ],

              const SizedBox(height: AppSpacing.md),
              _buildNotificationToggle(
                icon: Icons.bar_chart,
                title: 'Relatórios',
                subtitle: 'Notificações sobre relatórios mensais',
                value: _enableReports,
                onChanged: (value) {
                  setState(() {
                    _enableReports = value;
                  });
                  // TODO: Implementar notificações de relatórios
                },
              ),

              const SizedBox(height: AppSpacing.md),
              _buildNotificationToggle(
                icon: Icons.flag,
                title: 'Metas',
                subtitle: 'Avisos sobre progresso das metas',
                value: _enableGoals,
                onChanged: (value) {
                  setState(() {
                    _enableGoals = value;
                  });
                  // TODO: Implementar notificações de metas
                },
              ),

              const SizedBox(height: AppSpacing.md),
              _buildNotificationToggle(
                icon: Icons.backup,
                title: 'Backup',
                subtitle: 'Lembretes para fazer backup',
                value: _enableBackup,
                onChanged: (value) {
                  setState(() {
                    _enableBackup = value;
                  });
                  // TODO: Implementar notificações de backup
                },
              ),
            ],

            const SizedBox(height: AppSpacing.xxl),

            // Teste de notificação
            if (_enableNotifications)
              AppCard(
                padding: AppSpacing.paddingLG,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withAlpha((0.2 * 255).round()),
                            borderRadius: AppRadius.borderRadiusMD,
                          ),
                          child: const Icon(
                            Icons.notification_important,
                            color: AppColors.accent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Testar Notificação',
                                style: AppTypography.labelLarge,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Enviar uma notificação de teste',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implementar teste de notificação
                          _showSnackBar(context, 'Notificação de teste enviada!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: AppSpacing.paddingLG,
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.borderRadiusMD,
                          ),
                        ),
                        child: Text(
                          'Enviar Teste',
                          style: AppTypography.button,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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
          const Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Configure como e quando você deseja receber notificações do app.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AppCard(
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
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    return AppCard(
      padding: AppSpacing.paddingLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Horário do Lembrete',
            style: AppTypography.labelMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          InkWell(
            onTap: () => _selectTime(context),
            child: Container(
              padding: AppSpacing.paddingLG,
              decoration: const BoxDecoration(
                color: AppColors.backgroundDark,
                borderRadius: AppRadius.borderRadiusMD,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      _reminderTime,
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final timeParts = _reminderTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _reminderTime =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
      // TODO: Salvar horário do lembrete
    }
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

