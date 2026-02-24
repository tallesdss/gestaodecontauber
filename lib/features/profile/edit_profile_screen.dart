import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/utils/currency_formatter.dart';

import '../../core/supabase/supabase_service.dart';
import '../../core/supabase/supabase_error_handler.dart';
import '../../core/supabase/auth_service.dart';
import '../../shared/models/driver.dart';

class EditProfileScreen extends StatefulWidget {
  final Driver? driver;
  const EditProfileScreen({super.key, this.driver});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _phoneController = TextEditingController();
  late TextEditingController _monthlyGoalController;

  Uint8List? _imageBytes;
  bool _isLoading = true;
  bool _isSaving = false;

  late final MaskTextInputFormatter _phoneMaskFormatter;

  @override
  void initState() {
    super.initState();
    _phoneMaskFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );

    _nameController = TextEditingController(text: widget.driver?.name ?? '');
    _emailController = TextEditingController(text: AuthService.currentUser?.email ?? '');
    _monthlyGoalController = TextEditingController(
      text: widget.driver != null ? CurrencyFormatter.format(widget.driver!.monthlyGoal) : '',
    );
    
    if (widget.driver != null) {
      _isLoading = false;
    } else {
      _loadDriverData();
    }
  }

  Future<void> _loadDriverData() async {
    try {
      final driver = await SupabaseService.getDriver();
      if (mounted && driver != null) {
        setState(() {
          _nameController.text = driver.name;
          _monthlyGoalController.text = CurrencyFormatter.format(driver.monthlyGoal);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _monthlyGoalController.dispose();
    super.dispose();
  }

  void _formatCurrency(String value) {
    if (value.isEmpty) {
      _monthlyGoalController.text = '';
      return;
    }
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      _monthlyGoalController.text = '';
      return;
    }
    double amount = int.parse(digitsOnly) / 100;
    _monthlyGoalController.text = CurrencyFormatter.format(amount);
    _monthlyGoalController.selection = TextSelection.fromPosition(
      TextPosition(offset: _monthlyGoalController.text.length),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image != null && mounted) {
        final bytes = await image.readAsBytes();
        if (mounted) {
          setState(() {
            _imageBytes = bytes;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Erro ao selecionar imagem');
      }
    }
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: AppSpacing.paddingXXL,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Alterar Foto',
                style: AppTypography.h4,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImageSourceOption(
                    icon: Icons.camera_alt,
                    label: 'Câmera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  const SizedBox(width: AppSpacing.xxl),
                  _buildImageSourceOption(
                    icon: Icons.photo_library,
                    label: 'Galeria',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderRadiusMD,
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha((0.2 * 255).round()),
                borderRadius: AppRadius.borderRadiusMD,
              ),
              child: Icon(icon, color: AppColors.primary, size: 40),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(label, style: AppTypography.labelLarge),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
-
    setState(() => _isSaving = true);
-
    try {
-      // Simular salvamento (frontend only)
-      await Future.delayed(const Duration(milliseconds: 800));
-
+      final goal = CurrencyFormatter.parse(_monthlyGoalController.text);
+      
+      final updatedDriver = Driver(
+        name: _nameController.text.trim(),
+        monthlyGoal: goal,
+        memberSince: widget.driver?.memberSince ?? DateTime.now(),
+      );
+
+      await SupabaseService.upsertDriver(updatedDriver);
+
       if (mounted) {
         setState(() => _isSaving = false);
-        _showSnackBar('Perfil atualizado com sucesso!');
+        ScaffoldMessenger.of(context).showSnackBar(
+          const SnackBar(
+            content: Text('Perfil atualizado com sucesso!'),
+            backgroundColor: AppColors.success,
+          ),
+        );
         context.pop();
       }
     } catch (e) {
       if (mounted) {
         setState(() => _isSaving = false);
-        _showSnackBar('Erro ao salvar perfil');
+        ScaffoldMessenger.of(context).showSnackBar(
+          SnackBar(
+            content: Text(SupabaseErrorHandler.mapError(e)),
+            backgroundColor: AppColors.error,
+          ),
+        );
       }
     }
   }

  void _cancel() {
    context.pop();
  }

  void _showSnackBar(String message) {
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

  String _getInitials() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return '?';
    final parts = name.split(' ').where((p) => p.isNotEmpty);
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppTopBar(
        title: 'Editar Perfil',
        showBackButton: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: TextButton(
              onPressed: _isSaving ? null : _saveProfile,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Salvar',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: AppSpacing.paddingXL,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Foto
                    _buildPhotoSection(),
                    const SizedBox(height: AppSpacing.xxl),

                    // Campos do formulário
                    AppTextField(
                      label: 'Nome completo',
                      hint: 'Digite seu nome',
                      prefixIcon: Icons.person,
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Digite seu nome';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    AppTextField(
                      label: 'Email',
                      hint: 'Digite seu email (opcional)',
                      prefixIcon: Icons.email,
                      controller: _emailController,
                      enabled: false, // Email não é editável diretamente aqui
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    AppTextField(
                      label: 'Telefone',
                      hint: '(00) 00000-0000',
                      prefixIcon: Icons.phone,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [_phoneMaskFormatter],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    AppTextField(
                      label: 'Meta de ganho mensal',
                      hint: 'R\$ 0,00',
                      prefixIcon: Icons.flag,
                      controller: _monthlyGoalController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: _formatCurrency,
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Botões
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: 'Cancelar',
                            isOutlined: true,
                            onPressed: _cancel,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          flex: 2,
                          child: AppButton(
                            text: _isSaving ? 'Salvando...' : 'Salvar',
                            onPressed: _isSaving ? null : _saveProfile,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPhotoSection() {
    return AppCard(
      padding: AppSpacing.paddingXXL,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              _imageBytes != null
                  ? ClipOval(
                      child: Image.memory(
                        _imageBytes!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => AppAvatar(
                          initials: _getInitials(),
                          size: 120,
                        ),
                      ),
                    )
                  : AppAvatar(
                      imageUrl: null,
                      initials: _getInitials(),
                      size: 120,
                    ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            text: 'Alterar Foto',
            isOutlined: true,
            onPressed: _showImageSourceBottomSheet,
            icon: Icons.camera_alt,
          ),
        ],
      ),
    );
  }
}
