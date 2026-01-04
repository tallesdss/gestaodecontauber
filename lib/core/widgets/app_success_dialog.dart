import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_colors.dart';
import 'app_dialog.dart';
import 'app_button.dart';

/// Modal de sucesso com auto-fechamento
class AppSuccessDialog extends StatefulWidget {
  final String title;
  final String? message;
  final String buttonText;
  final VoidCallback? onClose;
  final bool autoClose;
  final Duration autoCloseDuration;

  const AppSuccessDialog({
    super.key,
    required this.title,
    this.message,
    this.buttonText = 'OK',
    this.onClose,
    this.autoClose = true,
    this.autoCloseDuration = const Duration(seconds: 2),
  });

  @override
  State<AppSuccessDialog> createState() => _AppSuccessDialogState();

  /// Helper method para mostrar o dialog
  static Future<void> show({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'OK',
    VoidCallback? onClose,
    bool autoClose = true,
    Duration autoCloseDuration = const Duration(seconds: 2),
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => AppSuccessDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onClose: onClose,
        autoClose: autoClose,
        autoCloseDuration: autoCloseDuration,
      ),
    );
  }
}

class _AppSuccessDialogState extends State<AppSuccessDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoClose) {
      _timer = Timer(widget.autoCloseDuration, () {
        if (mounted) {
          widget.onClose?.call();
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.success,
      title: widget.title,
      message: widget.message,
      actions: [
        AppButton(
          text: widget.buttonText,
          onPressed: () {
            widget.onClose?.call();
            Navigator.of(context).pop();
          },
          width: double.infinity,
        ),
      ],
    );
  }
}

