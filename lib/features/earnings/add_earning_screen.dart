import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../shared/models/earning.dart';

class AddEarningScreen extends StatefulWidget {
  const AddEarningScreen({super.key});

  @override
  State<AddEarningScreen> createState() => _AddEarningScreenState();
}

class _AddEarningScreenState extends State<AddEarningScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _numberOfRidesController = TextEditingController();
  final _hoursWorkedController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedPlatform;
  bool _isLoading = false;

  final List<String> _platforms = ['Uber', '99', 'InDrive', 'Outros'];

  @override
  void dispose() {
    _valueController.dispose();
    _numberOfRidesController.dispose();
    _hoursWorkedController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _formatCurrency(String value) {
    if (value.isEmpty) {
      _valueController.text = '';
      return;
    }

    // Remove tudo que não é número
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      _valueController.text = '';
      return;
    }

    // Converte para double e formata
    double amount = int.parse(digitsOnly) / 100;
    _valueController.text = CurrencyFormatter.format(amount);
    _valueController.selection = TextSelection.fromPosition(
      TextPosition(offset: _valueController.text.length),
    );
  }

  void _saveEarning() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Parse do valor
      final value = CurrencyFormatter.parse(_valueController.text);

      // Criar o ganho
      final earning = Earning(
        id: const Uuid().v4(),
        date: _selectedDate,
        value: value,
        platform: _selectedPlatform,
        numberOfRides: _numberOfRidesController.text.isNotEmpty
            ? int.tryParse(_numberOfRidesController.text)
            : null,
        hoursWorked: _hoursWorkedController.text.isNotEmpty
            ? double.tryParse(_hoursWorkedController.text.replaceAll(',', '.'))
            : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      // TODO: Salvar no banco de dados
      // await DatabaseService.instance.addEarning(earning);
      // ignore: unused_local_variable
      final _ = earning; // Será usado quando o banco de dados for implementado

      // Simular delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ganho adicionado com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              AppTopBar(
                title: 'Adicionar Ganho',
                showBackButton: true,
                actions: [
                  IconButton(
                    icon: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.check,
                            color: AppColors.primary,
                          ),
                    onPressed: _isLoading ? null : _saveEarning,
                  ),
                ],
              ),

              // Formulário
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.paddingXL,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Campo Data
                        _buildDateField(),
                        const SizedBox(height: AppSpacing.xl),

                        // Campo Valor
                        _buildValueField(),
                        const SizedBox(height: AppSpacing.xl),

                        // Campo Plataforma
                        _buildPlatformField(),
                        const SizedBox(height: AppSpacing.xl),

                        // Campo Número de Corridas
                        _buildNumberOfRidesField(),
                        const SizedBox(height: AppSpacing.xl),

                        // Campo Horas Trabalhadas
                        _buildHoursWorkedField(),
                        const SizedBox(height: AppSpacing.xl),

                        // Campo Observações
                        _buildNotesField(),
                        const SizedBox(height: AppSpacing.xxxl),

                        // Botão Cancelar
                        AppButton(
                          text: 'Cancelar',
                          isOutlined: true,
                          onPressed: () => context.pop(),
                        ),
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

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data',
          style: AppTypography.labelLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: _selectDate,
          borderRadius: AppRadius.borderRadiusMD,
          child: AppCard(
            padding: AppSpacing.paddingLG,
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    DateFormatter.formatDate(_selectedDate),
                    style: AppTypography.bodyLarge,
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
    );
  }

  Widget _buildValueField() {
    return AppTextField(
      label: 'Valor ganho',
      hint: 'R\$ 0,00',
      prefixIcon: Icons.attach_money,
      controller: _valueController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'O valor é obrigatório';
        }
        final parsedValue = CurrencyFormatter.parse(value);
        if (parsedValue <= 0) {
          return 'O valor deve ser maior que zero';
        }
        return null;
      },
      onChanged: _formatCurrency,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  Widget _buildPlatformField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plataforma',
          style: AppTypography.labelLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => _buildPlatformBottomSheet(),
            );
          },
          borderRadius: AppRadius.borderRadiusMD,
          child: AppCard(
            padding: AppSpacing.paddingLG,
            child: Row(
              children: [
                const Icon(
                  Icons.directions_car,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    _selectedPlatform ?? 'Selecione uma plataforma',
                    style: AppTypography.bodyLarge.copyWith(
                      color: _selectedPlatform != null
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
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
    );
  }

  Widget _buildPlatformBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.radiusXL),
        ),
      ),
      padding: AppSpacing.paddingXXL,
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
          Text(
            'Selecione a Plataforma',
            style: AppTypography.h3,
          ),
          const SizedBox(height: AppSpacing.xxl),
          ..._platforms.map((platform) => _buildPlatformOption(platform)),
        ],
      ),
    );
  }

  Widget _buildPlatformOption(String platform) {
    final isSelected = _selectedPlatform == platform;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPlatform = platform;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: AppSpacing.paddingLG,
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: AppRadius.borderRadiusMD,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                platform,
                style: AppTypography.bodyLarge,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberOfRidesField() {
    return AppTextField(
      label: 'Corridas realizadas',
      hint: '0',
      prefixIcon: Icons.pin_drop,
      controller: _numberOfRidesController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final rides = int.tryParse(value);
          if (rides == null || rides < 0) {
            return 'Digite um número válido';
          }
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  Widget _buildHoursWorkedField() {
    return AppTextField(
      label: 'Horas trabalhadas',
      hint: '0.0',
      prefixIcon: Icons.schedule,
      controller: _hoursWorkedController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final hours = double.tryParse(value.replaceAll(',', '.'));
          if (hours == null || hours < 0) {
            return 'Digite um número válido';
          }
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d{0,2}')),
      ],
    );
  }

  Widget _buildNotesField() {
    return AppTextField(
      label: 'Observações',
      hint: 'Adicione uma nota...',
      prefixIcon: Icons.note,
      controller: _notesController,
      maxLines: 4,
    );
  }
}
