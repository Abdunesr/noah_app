// lib/widgets/divider_line.dart
import 'package:flutter/material.dart';

class DividerLine extends StatelessWidget {
  final Color? color;
  final double? height;

  const DividerLine({super.key, this.color, this.height = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: color ?? Color(0xFF2E7D32),
    );
  }
}
