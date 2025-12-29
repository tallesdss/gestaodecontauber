import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Controllers para a tela 3
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // Máscara para o campo de meta mensal (formato brasileiro)
  final _goalMaskFormatter = MaskTextInputFormatter(
    mask: 'R\$ #.##0,00',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    if (_currentPage == 2) {
      // Validação na última tela
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingCompleted, true);
    
    if (_currentPage == 2) {
      // Salvar dados do motorista
      await prefs.setString(AppConstants.keyDriverName, _nameController.text.trim());
      final goal = CurrencyFormatter.parse(_goalController.text);
      await prefs.setDouble(AppConstants.keyMonthlyGoal, goal);
    }

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Indicador de página
            Padding(
              padding: AppSpacing.paddingXL,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => _buildPageIndicator(index == _currentPage),
                ),
              ),
            ),

            // Conteúdo das páginas
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildWelcomePage(),
                  _buildFeaturesPage(),
                  _buildStartPage(),
                ],
              ),
            ),

            // Botões de navegação
            Padding(
              padding: AppSpacing.paddingXXL,
              child: Column(
                children: [
                  AppButton(
                    text: _currentPage == 2 ? 'Iniciar' : _currentPage == 0 ? 'Começar' : 'Próximo',
                    onPressed: _nextPage,
                    width: double.infinity,
                    size: ButtonSize.large,
                  ),
                  if (_currentPage < 2) ...[
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Pular',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.textTertiary,
        borderRadius: AppRadius.borderRadiusRound,
      ),
    );
  }

  // Tela 1: Bem-vindo
  Widget _buildWelcomePage() {
    return Padding(
      padding: AppSpacing.paddingXXL,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ilustração/Ícone grande
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car,
              size: 100,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          // Título
          Text(
            'Bem-vindo ao UberControl',
            style: AppTypography.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Subtítulo
          Text(
            'Controle total dos seus ganhos e gastos',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Tela 2: Recursos
  Widget _buildFeaturesPage() {
    return Padding(
      padding: AppSpacing.paddingXXL,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ilustração/Ícone
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.2),
              borderRadius: AppRadius.borderRadiusXL,
            ),
            child: const Icon(
              Icons.attach_money,
              size: 80,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          // Título
          Text(
            'Registre seus Ganhos',
            style: AppTypography.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Lista de recursos
          _buildFeatureItem('Acompanhe ganhos diários'),
          const SizedBox(height: AppSpacing.lg),
          _buildFeatureItem('Registre todas as despesas'),
          const SizedBox(height: AppSpacing.lg),
          _buildFeatureItem('Veja relatórios detalhados'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyLarge,
          ),
        ),
      ],
    );
  }

  // Tela 3: Começar
  Widget _buildStartPage() {
    return SingleChildScrollView(
      padding: AppSpacing.paddingXXL,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.xxl),
            
            // Ilustração/Ícone
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.2),
                borderRadius: AppRadius.borderRadiusXL,
              ),
              child: const Icon(
                Icons.rocket_launch,
                size: 80,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),

            // Título
            Text(
              'Pronto para começar?',
              style: AppTypography.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxxl),

            // Campo: Nome do motorista
            AppTextField(
              label: 'Nome do motorista',
              hint: 'Digite seu nome',
              prefixIcon: Icons.person,
              controller: _nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, digite seu nome';
                }
                if (value.trim().length < 2) {
                  return 'Nome deve ter pelo menos 2 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Campo: Meta mensal
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meta mensal (R\$)',
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _goalController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_goalMaskFormatter],
                  style: AppTypography.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'R\$ 0,00',
                    hintStyle: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    prefixIcon: const Icon(Icons.flag, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: const OutlineInputBorder(
                      borderRadius: AppRadius.borderRadiusMD,
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: AppRadius.borderRadiusMD,
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: AppRadius.borderRadiusMD,
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: AppRadius.borderRadiusMD,
                      borderSide: BorderSide(color: AppColors.error, width: 2),
                    ),
                    contentPadding: AppSpacing.paddingLG,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, digite sua meta mensal';
                    }
                    final numericValue = CurrencyFormatter.parse(value);
                    if (numericValue <= 0) {
                      return 'Digite um valor maior que zero';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
