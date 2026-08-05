import 'package:flutter/material.dart';

class ShimmerFormInput extends StatelessWidget {
  const ShimmerFormInput({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
