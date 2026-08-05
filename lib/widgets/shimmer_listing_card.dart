import 'package:flutter/material.dart';

class ShimmerListingCard extends StatelessWidget {
  const ShimmerListingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            child: Container(
              height: 200,
              width: double.infinity,
              color: const Color(0xFFF3F4F6),
              child: const Icon(
                Icons.image_outlined,
                color: Color(0xFFD1D5DB),
                size: 40,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row with type and stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerBox(width: 80, height: 12),
                    Row(
                      children: [
                        _buildShimmerBox(width: 20, height: 12),
                        const SizedBox(width: 10),
                        _buildShimmerBox(width: 20, height: 12),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Title
                _buildShimmerBox(width: double.infinity, height: 18),
                const SizedBox(height: 12),
                // Divider
                Container(height: 1, color: const Color(0xFFF3F4F6)),
                const SizedBox(height: 12),
                // Mini stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerBox(width: 50, height: 14),
                    _buildShimmerBox(width: 55, height: 14),
                    _buildShimmerBox(width: 60, height: 14),
                    _buildShimmerBox(width: 40, height: 14),
                  ],
                ),
                const SizedBox(height: 12),
                // Divider
                Container(height: 1, color: const Color(0xFFF3F4F6)),
                const SizedBox(height: 12),
                // Price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerBox(width: 40, height: 14),
                    _buildShimmerBox(width: 100, height: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
