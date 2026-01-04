import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/constants/app_constants.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'Como adicionar um ganho?',
      'answer':
          'Na tela principal, toque no botão "Adicionar Ganho" ou vá em Ganhos > Adicionar. Preencha os dados da corrida e salve.',
      'expanded': false,
    },
    {
      'question': 'Como adicionar um gasto?',
      'answer':
          'Na tela principal, toque no botão "Adicionar Gasto" ou vá em Gastos > Adicionar. Selecione a categoria, preencha o valor e salve.',
      'expanded': false,
    },
    {
      'question': 'Como definir uma meta mensal?',
      'answer':
          'Vá em Perfil > Metas e defina o valor que deseja alcançar no mês. O app mostrará seu progresso em tempo real.',
      'expanded': false,
    },
    {
      'question': 'Como fazer backup dos meus dados?',
      'answer':
          'Vá em Perfil > Backup e toque em "Fazer Backup". Seus dados serão salvos localmente no dispositivo.',
      'expanded': false,
    },
    {
      'question': 'Como exportar meus dados?',
      'answer':
          'Vá em Perfil > Exportar Dados, selecione o período e o formato (PDF, Excel ou JSON) e toque em "Exportar Dados".',
      'expanded': false,
    },
    {
      'question': 'Como adicionar uma categoria personalizada?',
      'answer':
          'Vá em Perfil > Categorias e toque em "Adicionar Categoria". Escolha um nome, ícone e cor para sua categoria.',
      'expanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: const AppTopBar(
        title: 'Ajuda',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingXL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card de boas-vindas
            _buildWelcomeCard(),
            const SizedBox(height: AppSpacing.xxl),

            // Seção de contato
            Text(
              'Precisa de Ajuda?',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildContactOption(
              icon: Icons.email,
              title: 'Enviar E-mail',
              subtitle: 'Suporte por e-mail',
              onTap: () {
                // TODO: Abrir cliente de e-mail
                _showSnackBar(context, 'Funcionalidade em desenvolvimento');
              },
            ),
            const SizedBox(height: AppSpacing.md),

            _buildContactOption(
              icon: Icons.chat_bubble,
              title: 'Chat de Suporte',
              subtitle: 'Conversar com suporte',
              onTap: () {
                // TODO: Abrir chat
                _showSnackBar(context, 'Funcionalidade em desenvolvimento');
              },
            ),

            const SizedBox(height: AppSpacing.xxl),

            // FAQ
            Text(
              'Perguntas Frequentes',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),

            ..._faqItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _buildFAQItem(index, item),
              );
            }),

            const SizedBox(height: AppSpacing.xxl),

            // Guias rápidos
            Text(
              'Guias Rápidos',
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildGuideCard(
              icon: Icons.play_circle_outline,
              title: 'Tutorial Inicial',
              subtitle: 'Aprenda a usar o app em 5 minutos',
              onTap: () {
                // TODO: Abrir tutorial
                _showSnackBar(context, 'Tutorial em breve!');
              },
            ),
            const SizedBox(height: AppSpacing.md),

            _buildGuideCard(
              icon: Icons.video_library,
              title: 'Vídeos Tutoriais',
              subtitle: 'Assista vídeos explicativos',
              onTap: () {
                // TODO: Abrir vídeos
                _showSnackBar(context, 'Vídeos em breve!');
              },
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Informações do app
            _buildAppInfoCard(),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return AppCard(
      padding: AppSpacing.paddingXXL,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha((0.2 * 255).round()),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.help_outline,
              color: AppColors.primary,
              size: 48,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Central de Ajuda',
            style: AppTypography.h3,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Estamos aqui para ajudar você a aproveitar ao máximo o UberControl',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.paddingLG,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha((0.2 * 255).round()),
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: Icon(
              icon,
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
          const Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(int index, Map<String, dynamic> item) {
    final isExpanded = item['expanded'] as bool;

    return AppCard(
      onTap: () {
        setState(() {
          _faqItems[index]['expanded'] = !isExpanded;
        });
      },
      padding: AppSpacing.paddingLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item['question'] as String,
                  style: AppTypography.labelLarge,
                ),
              ),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.textTertiary,
              ),
            ],
          ),
          if (isExpanded) ...[
            const SizedBox(height: AppSpacing.md),
            Divider(color: AppColors.textTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              item['answer'] as String,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGuideCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.paddingLG,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.warning.withAlpha((0.2 * 255).round()),
              borderRadius: AppRadius.borderRadiusMD,
            ),
            child: Icon(
              icon,
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
          const Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoCard() {
    return AppCard(
      padding: AppSpacing.paddingLG,
      child: Column(
        children: [
          Text(
            AppConstants.appName,
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Versão ${AppConstants.appVersion}',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Aplicativo para gestão financeira de motoristas de aplicativo.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                icon: Icons.policy,
                label: 'Política de Privacidade',
                onTap: () {
                  // TODO: Abrir política de privacidade
                  _showSnackBar(context, 'Política de privacidade em breve!');
                },
              ),
              const SizedBox(width: AppSpacing.lg),
              _buildSocialButton(
                icon: Icons.description,
                label: 'Termos de Uso',
                onTap: () {
                  // TODO: Abrir termos de uso
                  _showSnackBar(context, 'Termos de uso em breve!');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusMD,
        child: Container(
          padding: AppSpacing.paddingMD,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textTertiary),
            borderRadius: AppRadius.borderRadiusMD,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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

