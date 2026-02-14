import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../shared/models/earning.dart';
import '../../shared/models/expense.dart';

class DetailScreen extends StatelessWidget {
  final Earning? earning;
  final Expense? expense;

  const DetailScreen({
    super.key,
    this.earning,
    this.expense,
  }) : assert(
          !(earning != null && expense != null),
          'Não pode fornecer earning e expense ao mesmo tempo',
        );

  bool get isEarning => earning != null;

  @override
  Widget build(BuildContext context) {
    // Se não houver dados, mostrar mensagem
    if (earning == null && expense == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: const AppTopBar(
          title: 'Detalhes',
          showBackButton: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Dados não encontrados',
                style: AppTypography.h3,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Não foi possível carregar os detalhes',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppTopBar(
        title: 'Detalhes',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              // TODO: Navegar para tela de edição
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: AppColors.error,
            ),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingXL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMainCard(context),
            const SizedBox(height: AppSpacing.xl),
            _buildDetailsSection(context),
            if (expense?.receiptImagePath != null) ...[
              const SizedBox(height: AppSpacing.xl),
              _buildReceiptSection(context),
            ],
            const SizedBox(height: AppSpacing.xxxl),
            _buildActionButtons(context),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    final icon = isEarning ? Icons.attach_money : _getCategoryIcon();
    final type = isEarning ? 'Ganho' : 'Gasto';
    final value = isEarning ? earning!.value : expense!.value;
    final date = isEarning ? earning!.date : expense!.date;
    final color = isEarning ? AppColors.earnings : _getCategoryColor();

    return AppCard(
      padding: AppSpacing.paddingXXL,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            type,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            CurrencyFormatter.format(value),
            style: AppTypography.h1.copyWith(
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                DateFormatter.formatDate(date),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              const Icon(
                Icons.access_time,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                DateFormatter.formatTime(date),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informações Detalhadas',
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildDetailItem(
            icon: Icons.calendar_today,
            label: 'Data',
            value: DateFormatter.formatDate(
              isEarning ? earning!.date : expense!.date,
            ),
          ),
          if (isEarning) ...[
            if (earning!.platform != null)
              _buildDetailItem(
                icon: Icons.directions_car,
                label: 'Plataforma',
                value: earning!.platform!,
              ),
            if (earning!.numberOfRides != null)
              _buildDetailItem(
                icon: Icons.pin_drop,
                label: 'Corridas realizadas',
                value: '${earning!.numberOfRides}',
              ),
            if (earning!.hoursWorked != null)
              _buildDetailItem(
                icon: Icons.schedule,
                label: 'Horas trabalhadas',
                value: '${earning!.hoursWorked!.toStringAsFixed(1)}h',
              ),
          ] else ...[
            _buildDetailItem(
              icon: _getCategoryIcon(),
              label: 'Categoria',
              value: expense!.category,
            ),
            _buildDetailItem(
              icon: Icons.description,
              label: 'Descrição',
              value: expense!.description,
            ),
            if (expense!.liters != null)
              _buildDetailItem(
                icon: Icons.local_gas_station,
                label: 'Litros abastecidos',
                value: '${expense!.liters!.toStringAsFixed(1)}L',
              ),
          ],
          if ((isEarning && earning!.notes != null) ||
              (!isEarning && expense!.notes != null))
            _buildDetailItem(
              icon: Icons.note,
              label: 'Observações',
              value: isEarning ? earning!.notes! : expense!.notes!,
              isLast: true,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Foto do Recibo',
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.lg),
          GestureDetector(
            onTap: () {
              // TODO: Abrir imagem em tela cheia
            },
            child: ClipRRect(
              borderRadius: AppRadius.borderRadiusLG,
              child: _buildReceiptImage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: 'Editar',
          icon: Icons.edit,
          onPressed: () {
            // TODO: Navegar para tela de edição
          },
          width: double.infinity,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          text: 'Excluir',
          icon: Icons.delete,
          backgroundColor: AppColors.error,
          onPressed: () => _showDeleteConfirmation(context),
          width: double.infinity,
          isOutlined: true,
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLG,
        ),
        title: Row(
          children: [
            Container(
              padding: AppSpacing.paddingMD,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.2),
                borderRadius: AppRadius.borderRadiusMD,
              ),
              child: const Icon(
                Icons.warning,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Excluir ${isEarning ? 'Ganho' : 'Gasto'}?',
                style: AppTypography.h4,
              ),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Text(
            'Esta ação não pode ser desfeita',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Cancelar',
                  isOutlined: true,
                  backgroundColor: AppColors.textSecondary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  text: 'Excluir',
                  backgroundColor: AppColors.error,
                  onPressed: () {
                    // TODO: Implementar exclusão
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon() {
    if (!isEarning) {
      switch (expense!.category.toLowerCase()) {
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
    return Icons.attach_money;
  }

  Color _getCategoryColor() {
    if (!isEarning) {
      switch (expense!.category.toLowerCase()) {
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
    return AppColors.earnings;
  }

  Widget _buildReceiptImage() {
    final imagePath = expense!.receiptImagePath!;
    
    // Tenta carregar como arquivo primeiro, depois como asset
    Widget imageWidget;
    
    if (imagePath.startsWith('/') || imagePath.startsWith('file://')) {
      // É um caminho de arquivo
      final filePath = imagePath.replaceFirst('file://', '');
      final file = File(filePath);
      
      if (file.existsSync()) {
        imageWidget = Image.file(
          file,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildImageError(),
        );
      } else {
        imageWidget = _buildImageError();
      }
    } else {
      // Tenta como asset
      imageWidget = Image.asset(
        imagePath,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageError(),
      );
    }

    return imageWidget;
  }

  Widget _buildImageError() {
    return Container(
      width: double.infinity,
      height: 200,
      color: AppColors.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_not_supported,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Imagem não encontrada',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

