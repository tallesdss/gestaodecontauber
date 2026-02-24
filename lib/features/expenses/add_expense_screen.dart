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
import '../../core/widgets/app_chip.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/supabase/supabase_service.dart';
import '../../core/supabase/supabase_error_handler.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _litersController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  String? _receiptImagePath;
  bool _isLoading = false;

  // Categorias de gastos
  final List<Map<String, dynamic>> _categories = [
    {
      'id': AppConstants.categoryFuel,
      'label': 'Combustível',
      'icon': Icons.local_gas_station,
      'color': AppColors.fuel,
    },
    {
      'id': AppConstants.categoryMaintenance,
      'label': 'Manutenção',
      'icon': Icons.build,
      'color': AppColors.maintenance,
    },
    {
      'id': AppConstants.categoryWash,
      'label': 'Lavagem',
      'icon': Icons.water_drop,
      'color': AppColors.accent,
    },
    {
      'id': AppConstants.categoryParking,
      'label': 'Estacionamento',
      'icon': Icons.local_parking,
      'color': AppColors.warning,
    },
    {
      'id': AppConstants.categoryToll,
      'label': 'Pedágio',
      'icon': Icons.toll,
      'color': AppColors.info,
    },
    {
      'id': AppConstants.categoryOther,
      'label': 'Outros',
      'icon': Icons.category,
      'color': AppColors.textSecondary,
    },
  ];

  @override
  void dispose() {
    _valueController.dispose();
    _litersController.dispose();
    _descriptionController.dispose();
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

  Future<void> _pickReceiptImage() async {
    // TODO: Implementar seleção de imagem da câmera/galeria
    // Por enquanto, apenas simula
    setState(() {
      _receiptImagePath = 'path/to/image.jpg';
    });
  }

  void _removeReceiptImage() {
    setState(() {
      _receiptImagePath = null;
    });
  }

  void _saveExpense() async {
    // Validar categoria antes de validar o formulário
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma categoria'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Parse do valor
      final value = CurrencyFormatter.parse(_valueController.text);

      // Criar o gasto
      final expense = Expense(
        id: const Uuid().v4(),
        date: _selectedDate,
        category: _selectedCategory!,
        value: value,
        description: _descriptionController.text.trim(),
        liters: _selectedCategory == AppConstants.categoryFuel &&
                _litersController.text.isNotEmpty
            ? double.tryParse(_litersController.text.replaceAll(',', '.'))
            : null,
        receiptImagePath: _receiptImagePath,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      // Salvar no Supabase
      await SupabaseService.createExpense(expense);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gasto adicionado com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(SupabaseErrorHandler.mapError(e)),
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
    final isFuelCategory = _selectedCategory == AppConstants.categoryFuel;

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
                title: 'Adicionar Gasto',
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
                    onPressed: _isLoading ? null : _saveExpense,
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

                        // Campo Categoria
                        _buildCategoryField(),
                        const SizedBox(height: AppSpacing.xl),

                        // Campo Valor
                        _buildValueField(),
                        const SizedBox(height: AppSpacing.xl),

                        // Campo Litros (apenas se categoria = Combustível)
                        if (isFuelCategory) ...[
                          _buildLitersField(),
                          const SizedBox(height: AppSpacing.xl),
                        ],

                        // Campo Descrição
                        _buildDescriptionField(),
                        const SizedBox(height: AppSpacing.xl),

                        // Campo Foto do Recibo
                        _buildReceiptField(),
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

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categoria',
          style: AppTypography.labelLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category['id'];
            return AppChip(
              label: category['label'],
              icon: category['icon'],
              isSelected: isSelected,
              selectedColor: category['color'],
              onTap: () {
                setState(() {
                  _selectedCategory = category['id'];
                  // Limpar campo de litros se mudar de categoria
                  if (category['id'] != AppConstants.categoryFuel) {
                    _litersController.clear();
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildValueField() {
    return AppTextField(
      label: 'Valor gasto',
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

  Widget _buildLitersField() {
    return AppTextField(
      label: 'Litros abastecidos',
      hint: '0.0',
      prefixIcon: Icons.local_gas_station,
      controller: _litersController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final liters = double.tryParse(value.replaceAll(',', '.'));
          if (liters == null || liters < 0) {
            return 'Digite um valor válido';
          }
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d{0,2}')),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return AppTextField(
      label: 'Descrição',
      hint: 'Ex: Troca de óleo, Gasolina comum...',
      prefixIcon: Icons.description,
      controller: _descriptionController,
      validator: (value) {
        if (value == null || value.isEmpty || value.trim().isEmpty) {
          return 'A descrição é obrigatória';
        }
        return null;
      },
    );
  }

  Widget _buildReceiptField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Anexar recibo',
          style: AppTypography.labelLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (_receiptImagePath == null)
          InkWell(
            onTap: _pickReceiptImage,
            borderRadius: AppRadius.borderRadiusMD,
            child: AppCard(
              padding: AppSpacing.paddingLG,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Tirar foto ou escolher da galeria',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Stack(
            children: [
              AppCard(
                padding: EdgeInsets.zero,
                child: ClipRRect(
                  borderRadius: AppRadius.borderRadiusMD,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    color: AppColors.surface,
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 48,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: InkWell(
                  onTap: _removeReceiptImage,
                  borderRadius: AppRadius.borderRadiusRound,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
