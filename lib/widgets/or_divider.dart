// lib/widgets/or_divider.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class OrDivider extends StatelessWidget {
  final String text;
  final double? height;

  const OrDivider({super.key, required this.text, this.height});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.borderDefault)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.borderDefault)),
      ],
    );
  }
}
