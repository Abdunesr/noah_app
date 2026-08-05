import 'package:flutter/material.dart';

class ShimmerCalendarGrid extends StatelessWidget {
  const ShimmerCalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final screenWidth = MediaQuery.of(context).size.width;

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
      child: Column(
        children: [
          // Weekday Labels
          Row(
            children: weekDays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Days grid - 6 rows of 7 days
          ...List.generate(6, (row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: List.generate(7, (col) {
                  return SizedBox(
                    width: (screenWidth - 72) / 7.5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          height: 4,
                          width: 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF3F4F6),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}
