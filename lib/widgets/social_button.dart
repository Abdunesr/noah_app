// lib/widgets/social_button.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22, color: AppColors.textSecondary),
        label: Text(
          label,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.borderDefault),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
