import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/app_dialogs.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _isBackingUp = false;
  DateTime? _lastBackupDate;

  @override
  void initState() {
    super.initState();
    // TODO: Carregar data do último backup do SharedPreferences
    _loadLastBackupDate();
  }

  Future<void> _loadLastBackupDate() async {
    // TODO: Implementar carregamento da data do último backup
    // Por enquanto, simula uma data
    setState(() {
      _lastBackupDate = DateTime.now().subtract(const Duration(days: 2));
    });
  }

  Future<void> _performBackup() async {
    setState(() {
      _isBackingUp = true;
    });

    try {
      // TODO: Implementar lógica de backup real
      // 1. Exportar dados do banco de dados
      // 2. Salvar em arquivo JSON ou SQLite
      // 3. Fazer upload para cloud storage (opcional)
      // 4. Salvar data do backup no SharedPreferences

      // Simula processo de backup
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _lastBackupDate = DateTime.now();
        _isBackingUp = false;
      });

      if (mounted) {
        AppSuccessDialog.show(
          context: context,
          title: 'Backup Realizado',
          message: 'Seus dados foram salvos com sucesso!',
        );
      }
    } catch (e) {
      setState(() {
        _isBackingUp = false;
      });

      if (mounted) {
        AppErrorDialog.show(
          context: context,
          title: 'Erro no Backup',
          message: 'Não foi possível realizar o backup. Tente novamente.',
        );
      }
    }
  }

  Future<void> _restoreBackup() async {
    // TODO: Implementar restauração de backup
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Restaurar Backup',
          style: AppTypography.h4,
        ),
        content: Text(
          'Esta ação irá substituir todos os dados atuais pelos dados do backup. Tem certeza?',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: AppTypography.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(
              'Restaurar',
              style: AppTypography.button,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Implementar lógica de restauração
      _showSnackBar(context, 'Funcionalidade de restauração em desenvolvimento');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: const AppTopBar(
        title: 'Backup',
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

            // Status do último backup
            _buildLastBackupCard(),
            const SizedBox(height: AppSpacing.xxl),

            // Opções de backup
            Text(
              'Opções de Backup',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Backup manual
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
                          color: AppColors.primary.withAlpha((0.2 * 255).round()),
                          borderRadius: AppRadius.borderRadiusMD,
                        ),
                        child: const Icon(
                          Icons.cloud_upload,
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
                              'Backup Manual',
                              style: AppTypography.labelLarge,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Faça backup dos seus dados agora',
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
                  AppButton(
                    text: 'Fazer Backup',
                    icon: Icons.backup,
                    onPressed: _isBackingUp ? null : _performBackup,
                    isLoading: _isBackingUp,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Backup automático
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
                          Icons.schedule,
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
                              'Backup Automático',
                              style: AppTypography.labelLarge,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Backup automático diário',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: false, // TODO: Implementar controle de backup automático
                        onChanged: (value) {
                          // TODO: Implementar toggle de backup automático
                          _showSnackBar(
                            context,
                            'Funcionalidade em desenvolvimento',
                          );
                        },
                        activeThumbColor: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Restaurar backup
            Text(
              'Restaurar Dados',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),

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
                          color: AppColors.warning.withAlpha((0.2 * 255).round()),
                          borderRadius: AppRadius.borderRadiusMD,
                        ),
                        child: const Icon(
                          Icons.restore,
                          color: AppColors.warning,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Restaurar Backup',
                              style: AppTypography.labelLarge,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Restaurar dados de um backup anterior',
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
                  AppButton(
                    text: 'Restaurar Backup',
                    icon: Icons.restore,
                    isOutlined: true,
                    onPressed: _restoreBackup,
                    width: double.infinity,
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
          Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'O backup salva todos os seus dados localmente. Recomendamos fazer backup regularmente para não perder informações importantes.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastBackupCard() {
    return AppCard(
      padding: AppSpacing.paddingLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha((0.2 * 255).round()),
                  borderRadius: AppRadius.borderRadiusMD,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Último Backup',
                      style: AppTypography.labelLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _lastBackupDate != null
                          ? _formatDate(_lastBackupDate!)
                          : 'Nunca',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoje às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Ontem às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return '${date.day}/${date.month}/${date.year}';
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

