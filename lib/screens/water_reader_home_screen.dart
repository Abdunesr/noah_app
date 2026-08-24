// lib/screens/water_reader_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/colors.dart';
import 'water_meter_screen.dart';
import 'profile_screen.dart';

import '../widgets/responsive_mockup.dart';

class WaterReaderHomeScreen extends ConsumerStatefulWidget {
  const WaterReaderHomeScreen({super.key});

  @override
  ConsumerState<WaterReaderHomeScreen> createState() => _WaterReaderHomeScreenState();
}

class _WaterReaderHomeScreenState extends ConsumerState<WaterReaderHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    WaterMeterScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveMockup(
      child: _buildScreenContent(context),
    );
  }

  Widget _buildScreenContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 70 + MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
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
                icon: const Icon(Icons.opacity_outlined, size: 24),
                selectedIcon: const Icon(Icons.opacity, size: 24),
                label: 'Water Readings',
              ),
            ),
            Expanded(
              child: _buildNavItem(
                index: 1,
                icon: const Icon(Icons.person_outline, size: 24),
                selectedIcon: const Icon(Icons.person, size: 24),
                label: 'Profile',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required Widget icon,
    required Widget selectedIcon,
    required String label,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFE8F5E9) // Light green pill background
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: isSelected ? selectedIcon : icon,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
