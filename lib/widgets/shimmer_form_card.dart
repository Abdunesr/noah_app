import 'package:flutter/material.dart';

class ShimmerFormField extends StatelessWidget {
  const ShimmerFormField({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 54,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
