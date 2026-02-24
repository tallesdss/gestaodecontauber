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
import '../../core/supabase/supabase_service.dart';
import '../../core/supabase/supabase_error_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends StatefulWidget {
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

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? _signedUrl;
  bool _isLoadingUrl = false;

  bool get isEarning => widget.earning != null;

  @override
  void initState() {
    super.initState();
    if (!isEarning && widget.expense?.receiptImagePath != null) {
      _loadSignedUrl();
    }
  }

  Future<void> _loadSignedUrl() async {
    setState(() => _isLoadingUrl = true);
    try {
      final url = await SupabaseService.getReceiptSignedUrl(
          widget.expense!.receiptImagePath!);
      if (mounted) {
        setState(() {
          _signedUrl = url;
          _isLoadingUrl = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingUrl = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se não houver dados, mostrar mensagem
    if (widget.earning == null && widget.expense == null) {
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
            onPressed: () async {
              final result = await context.push(
                isEarning ? '/earnings/add' : '/expenses/add',
                extra: isEarning ? widget.earning : widget.expense,
              );
              if (result == true && context.mounted) {
                context.pop(true); // Retorna para a lista avisando que mudou
              }
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
            if (widget.expense?.receiptImagePath != null) ...[
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
    final value = isEarning ? widget.earning!.value : widget.expense!.value;
    final date = isEarning ? widget.earning!.date : widget.expense!.date;
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
              isEarning ? widget.earning!.date : widget.expense!.date,
            ),
          ),
          if (isEarning) ...[
            if (widget.earning!.platform != null)
              _buildDetailItem(
                icon: Icons.directions_car,
                label: 'Plataforma',
                value: widget.earning!.platform!,
              ),
            if (widget.earning!.numberOfRides != null)
              _buildDetailItem(
                icon: Icons.pin_drop,
                label: 'Corridas realizadas',
                value: '${widget.earning!.numberOfRides}',
              ),
            if (widget.earning!.hoursWorked != null)
              _buildDetailItem(
                icon: Icons.schedule,
                label: 'Horas trabalhadas',
                value: '${widget.earning!.hoursWorked!.toStringAsFixed(1)}h',
              ),
          ] else ...[
            _buildDetailItem(
              icon: _getCategoryIcon(),
              label: 'Categoria',
              value: widget.expense!.category,
            ),
            _buildDetailItem(
              icon: Icons.description,
              label: 'Descrição',
              value: widget.expense!.description,
            ),
            if (widget.expense!.liters != null)
              _buildDetailItem(
                icon: Icons.local_gas_station,
                label: 'Litros abastecidos',
                value: '${widget.expense!.liters!.toStringAsFixed(1)}L',
              ),
          ],
          if ((isEarning && widget.earning!.notes != null) ||
              (!isEarning && widget.expense!.notes != null))
            _buildDetailItem(
              icon: Icons.note,
              label: 'Observações',
              value: isEarning ? widget.earning!.notes! : widget.expense!.notes!,
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
              if (_signedUrl != null) {
                // TODO: Abrir imagem em tela cheia
              }
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
          onPressed: () async {
            final result = await context.push(
              isEarning ? '/earnings/add' : '/expenses/add',
              extra: isEarning ? widget.earning : widget.expense,
            );
            if (result == true && context.mounted) {
              context.pop(true);
            }
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
                  onPressed: () async {
                    try {
                      if (isEarning) {
                        await SupabaseService.deleteEarning(widget.earning!.id);
                      } else {
                        await SupabaseService.deleteExpense(widget.expense!.id);
                      }
                      
                      if (context.mounted) {
                        Navigator.of(context).pop(); // Fecha dialog
                        context.pop(true); // Volta para lista com sinalizador
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(SupabaseErrorHandler.mapError(e)),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
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
      switch (widget.expense!.category.toLowerCase()) {
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
      switch (widget.expense!.category.toLowerCase()) {
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
    if (_isLoadingUrl) {
      return Container(
        width: double.infinity,
        height: 200,
        color: AppColors.surface,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_signedUrl == null) {
      return _buildImageError();
    }

    return CachedNetworkImage(
      imageUrl: _signedUrl!,
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => _buildImageError(),
    );
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
