import 'package:flutter/material.dart';

class ShimmerStatsCard extends StatelessWidget {
  const ShimmerStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: ColoredBox(color: Color(0xFFF3F4F6)),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 22,
            width: 60,
            child: ColoredBox(color: Color(0xFFF3F4F6)),
          ),
          SizedBox(height: 2),
          SizedBox(
            height: 12,
            width: 40,
            child: ColoredBox(color: Color(0xFFF3F4F6)),
          ),
        ],
      ),
    );
  }
}
