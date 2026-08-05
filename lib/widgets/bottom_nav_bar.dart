// lib/widgets/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildNavItem(
              index: 0,
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: 'Home',
            ),
          ),
          Expanded(
            child: _buildNavItem(
              index: 1,
              icon: const Icon(Icons.description_outlined),
              selectedIcon: const Icon(Icons.description),
              label: 'Payments',
            ),
          ),
          Expanded(
            child: _buildNavItem(
              index: 2,
              icon: const Text(
                'P',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              selectedIcon: const Text(
                'P',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryGreen,
                ),
              ),
              label: 'Parking',
            ),
          ),
          Expanded(
            child: _buildNavItem(
              index: 3,
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: 'Profile',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required Widget icon,
    required Widget selectedIcon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isSelected ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack, // Bouncy spring effect like Telebirr
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 22 : 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGreen.withValues(alpha: 0.12) // Smooth green pill background
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconTheme(
                data: IconThemeData(
                  color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
                  size: 24,
                ),
                child: isSelected ? selectedIcon : icon,
              ),
            ),
          ),
          const SizedBox(height: 3),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
