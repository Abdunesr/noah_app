// lib/widgets/brand_header.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class BrandHeader extends StatelessWidget {
  final double? logoSize;

  const BrandHeader({super.key, this.logoSize = 120});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/logo.png',
          height: logoSize,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: logoSize! * 0.7,
              width: logoSize! * 0.7,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.apartment,
                size: logoSize! * 0.3,
                color: AppColors.primaryWhite,
              ),
            );
          },
        ),
      ],
    );
  }
}
