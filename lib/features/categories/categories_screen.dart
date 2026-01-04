import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/app_dialogs.dart';
import '../../core/constants/app_constants.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // Lista de categorias padrão
  final List<Map<String, dynamic>> _defaultCategories = [
    {
      'id': AppConstants.categoryFuel,
      'label': 'Combustível',
      'icon': Icons.local_gas_station,
      'color': AppColors.fuel,
      'isDefault': true,
    },
    {
      'id': AppConstants.categoryMaintenance,
      'label': 'Manutenção',
      'icon': Icons.build,
      'color': AppColors.maintenance,
      'isDefault': true,
    },
    {
      'id': AppConstants.categoryWash,
      'label': 'Lavagem',
      'icon': Icons.water_drop,
      'color': AppColors.accent,
      'isDefault': true,
    },
    {
      'id': AppConstants.categoryParking,
      'label': 'Estacionamento',
      'icon': Icons.local_parking,
      'color': AppColors.warning,
      'isDefault': true,
    },
    {
      'id': AppConstants.categoryToll,
      'label': 'Pedágio',
      'icon': Icons.toll,
      'color': AppColors.info,
      'isDefault': true,
    },
    {
      'id': AppConstants.categoryOther,
      'label': 'Outros',
      'icon': Icons.category,
      'color': AppColors.textSecondary,
      'isDefault': true,
    },
  ];

  // Lista de categorias customizadas (seria carregada do banco de dados)
  List<Map<String, dynamic>> _customCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: const AppTopBar(
        title: 'Categorias',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingXL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informação sobre categorias
            _buildInfoCard(),
            const SizedBox(height: AppSpacing.xxl),

            // Título das categorias padrão
            Text(
              'Categorias Padrão',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Lista de categorias padrão
            ..._defaultCategories.map((category) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildCategoryCard(category, isDefault: true),
                )),

            // Título das categorias customizadas
            if (_customCategories.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Categorias Customizadas',
                style: AppTypography.h4,
              ),
              const SizedBox(height: AppSpacing.lg),
              ..._customCategories.map((category) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _buildCategoryCard(category, isDefault: false),
                  )),
            ],

            const SizedBox(height: AppSpacing.xxl),

            // Botão para adicionar categoria
            AppButton(
              text: 'Adicionar Categoria',
              icon: Icons.add,
              onPressed: () => _showAddCategoryDialog(context),
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
              'As categorias padrão não podem ser excluídas. Você pode adicionar categorias personalizadas.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    Map<String, dynamic> category, {
    required bool isDefault,
  }) {
    return AppCard(
      padding: AppSpacing.paddingLG,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: (category['color'] as Color).withAlpha((0.2 * 255).round()),
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: Icon(
              category['icon'] as IconData,
              color: category['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category['label'] as String,
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  isDefault ? 'Categoria padrão' : 'Categoria personalizada',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (!isDefault)
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: AppColors.textSecondary,
              ),
              onPressed: () => _showEditCategoryDialog(context, category),
            ),
          if (!isDefault)
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: AppColors.error,
              ),
              onPressed: () => _showDeleteCategoryDialog(context, category),
            ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    IconData selectedIcon = Icons.category;
    Color selectedColor = AppColors.primary;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Adicionar Categoria',
            style: AppTypography.h4,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: AppTypography.bodyMedium,
                  decoration: InputDecoration(
                    labelText: 'Nome da categoria',
                    labelStyle: AppTypography.labelMedium,
                    filled: true,
                    fillColor: AppColors.backgroundDark,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.borderRadiusMD,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Escolha um ícone',
                  style: AppTypography.labelMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    Icons.local_gas_station,
                    Icons.build,
                    Icons.water_drop,
                    Icons.local_parking,
                    Icons.toll,
                    Icons.category,
                    Icons.restaurant,
                    Icons.phone,
                    Icons.car_repair,
                    Icons.cleaning_services,
                  ].map((icon) {
                    final isSelected = selectedIcon == icon;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = icon;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withAlpha((0.2 * 255).round())
                              : AppColors.backgroundDark,
                          borderRadius: AppRadius.borderRadiusMD,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Escolha uma cor',
                  style: AppTypography.labelMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    AppColors.primary,
                    AppColors.secondary,
                    AppColors.accent,
                    AppColors.warning,
                    AppColors.info,
                    AppColors.fuel,
                    AppColors.maintenance,
                  ].map((color) {
                    final isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.textPrimary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: AppColors.textPrimary,
                                size: 20,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
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
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  setState(() {
                    _customCategories.add({
                      'id': 'custom_${DateTime.now().millisecondsSinceEpoch}',
                      'label': nameController.text.trim(),
                      'icon': selectedIcon,
                      'color': selectedColor,
                      'isDefault': false,
                    });
                  });
                  Navigator.of(context).pop();
                  _showSnackBar(context, 'Categoria adicionada com sucesso!');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                'Adicionar',
                style: AppTypography.button,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCategoryDialog(
      BuildContext context, Map<String, dynamic> category) {
    final nameController = TextEditingController(text: category['label']);
    IconData selectedIcon = category['icon'];
    Color selectedColor = category['color'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Editar Categoria',
            style: AppTypography.h4,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: AppTypography.bodyMedium,
                  decoration: InputDecoration(
                    labelText: 'Nome da categoria',
                    labelStyle: AppTypography.labelMedium,
                    filled: true,
                    fillColor: AppColors.backgroundDark,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.borderRadiusMD,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Escolha um ícone',
                  style: AppTypography.labelMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    Icons.local_gas_station,
                    Icons.build,
                    Icons.water_drop,
                    Icons.local_parking,
                    Icons.toll,
                    Icons.category,
                    Icons.restaurant,
                    Icons.phone,
                    Icons.car_repair,
                    Icons.cleaning_services,
                  ].map((icon) {
                    final isSelected = selectedIcon == icon;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = icon;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withAlpha((0.2 * 255).round())
                              : AppColors.backgroundDark,
                          borderRadius: AppRadius.borderRadiusMD,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Escolha uma cor',
                  style: AppTypography.labelMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    AppColors.primary,
                    AppColors.secondary,
                    AppColors.accent,
                    AppColors.warning,
                    AppColors.info,
                    AppColors.fuel,
                    AppColors.maintenance,
                  ].map((color) {
                    final isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.textPrimary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: AppColors.textPrimary,
                                size: 20,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
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
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  setState(() {
                    final index = _customCategories.indexWhere(
                        (c) => c['id'] == category['id']);
                    if (index != -1) {
                      _customCategories[index] = {
                        ..._customCategories[index],
                        'label': nameController.text.trim(),
                        'icon': selectedIcon,
                        'color': selectedColor,
                      };
                    }
                  });
                  Navigator.of(context).pop();
                  _showSnackBar(context, 'Categoria atualizada com sucesso!');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                'Salvar',
                style: AppTypography.button,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteCategoryDialog(
      BuildContext context, Map<String, dynamic> category) {
    AppConfirmDialog.show(
      context: context,
      title: 'Excluir Categoria',
      message:
          'Tem certeza que deseja excluir a categoria "${category['label']}"? Esta ação não pode ser desfeita.',
      confirmText: 'Excluir',
      cancelText: 'Cancelar',
      confirmColor: AppColors.error,
      onConfirm: () {
        setState(() {
          _customCategories.removeWhere((c) => c['id'] == category['id']);
        });
        _showSnackBar(context, 'Categoria excluída com sucesso!');
      },
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

