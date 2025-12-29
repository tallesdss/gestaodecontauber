import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 45,
    this.onTap,
  }) : assert(imageUrl != null || initials != null, 'Deve fornecer imageUrl ou initials');

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withAlpha((0.2 * 255).round()),
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      child: imageUrl != null
          ? ClipOval(
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildInitials();
                },
              ),
            )
          : _buildInitials(),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildInitials() {
    if (initials == null) return const SizedBox();
    
    return Center(
      child: Text(
        initials!.toUpperCase(),
        style: TextStyle(
          color: AppColors.primary,
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

