import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/app_dialogs.dart';

class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({super.key});

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _includeEarnings = true;
  bool _includeExpenses = true;
  bool _includeReports = true;
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: const AppTopBar(
        title: 'Exportar Dados',
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

            // Período de exportação
            Text(
              'Período',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),

            AppCard(
              padding: AppSpacing.paddingLG,
              child: Column(
                children: [
                  _buildDateField(
                    label: 'Data Inicial',
                    date: _startDate,
                    onTap: () => _selectStartDate(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildDateField(
                    label: 'Data Final',
                    date: _endDate,
                    onTap: () => _selectEndDate(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Opções de exportação
            Text(
              'Dados para Exportar',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),

            AppCard(
              padding: AppSpacing.paddingLG,
              child: Column(
                children: [
                  _buildExportOption(
                    icon: Icons.trending_up,
                    title: 'Ganhos',
                    subtitle: 'Exportar todos os ganhos',
                    value: _includeEarnings,
                    onChanged: (value) {
                      setState(() {
                        _includeEarnings = value;
                      });
                    },
                  ),
                  const Divider(color: AppColors.textTertiary),
                  _buildExportOption(
                    icon: Icons.trending_down,
                    title: 'Gastos',
                    subtitle: 'Exportar todos os gastos',
                    value: _includeExpenses,
                    onChanged: (value) {
                      setState(() {
                        _includeExpenses = value;
                      });
                    },
                  ),
                  const Divider(color: AppColors.textTertiary),
                  _buildExportOption(
                    icon: Icons.bar_chart,
                    title: 'Relatórios',
                    subtitle: 'Exportar relatórios e gráficos',
                    value: _includeReports,
                    onChanged: (value) {
                      setState(() {
                        _includeReports = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Formato de exportação
            Text(
              'Formato de Exportação',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildFormatOptions(),
            const SizedBox(height: AppSpacing.xxl),

            // Botão de exportar
            AppButton(
              text: 'Exportar Dados',
              icon: Icons.download,
              onPressed: _isExporting ? null : _exportData,
              isLoading: _isExporting,
              width: double.infinity,
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
              'Exporte seus dados em diferentes formatos para análise externa ou backup.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: AppSpacing.paddingLG,
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    date != null
                        ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
                        : 'Selecione uma data',
                    style: AppTypography.bodyMedium.copyWith(
                      color: date != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
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
    );
  }

  Widget _buildFormatOptions() {
    return Column(
      children: [
        _buildFormatOption(
          icon: Icons.description,
          title: 'PDF',
          subtitle: 'Relatório em formato PDF',
          format: 'pdf',
        ),
        const SizedBox(height: AppSpacing.md),
        _buildFormatOption(
          icon: Icons.table_chart,
          title: 'Excel',
          subtitle: 'Planilha Excel (.xlsx)',
          format: 'excel',
        ),
        const SizedBox(height: AppSpacing.md),
        _buildFormatOption(
          icon: Icons.code,
          title: 'JSON',
          subtitle: 'Dados em formato JSON',
          format: 'json',
        ),
      ],
    );
  }

  String _selectedFormat = 'pdf';

  Widget _buildFormatOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String format,
  }) {
    final isSelected = _selectedFormat == format;

    return AppCard(
      onTap: () {
        setState(() {
          _selectedFormat = format;
        });
      },
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

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
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
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
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
        _endDate = picked;
      });
    }
  }

  Future<void> _exportData() async {
    // Validações
    if (!_includeEarnings && !_includeExpenses && !_includeReports) {
      _showSnackBar(context, 'Selecione pelo menos um tipo de dado para exportar');
      return;
    }

    if (_startDate == null || _endDate == null) {
      _showSnackBar(context, 'Selecione o período de exportação');
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      // TODO: Implementar lógica de exportação real
      // 1. Buscar dados do banco de dados no período selecionado
      // 2. Gerar arquivo no formato selecionado (PDF, Excel, JSON)
      // 3. Salvar arquivo no dispositivo
      // 4. Compartilhar arquivo

      // Simula processo de exportação
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isExporting = false;
      });

      if (mounted) {
        AppSuccessDialog.show(
          context: context,
          title: 'Exportação Concluída',
          message: 'Seus dados foram exportados com sucesso!',
        );
      }
    } catch (e) {
      setState(() {
        _isExporting = false;
      });

      if (mounted) {
        AppErrorDialog.show(
          context: context,
          title: 'Erro na Exportação',
          message: 'Não foi possível exportar os dados. Tente novamente.',
        );
      }
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

