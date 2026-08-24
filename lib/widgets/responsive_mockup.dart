import 'package:flutter/material.dart';

class ResponsiveMockup extends StatelessWidget {
  final Widget child;

  const ResponsiveMockup({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 500) {
      return Scaffold(
        backgroundColor: const Color(0xFF1E2022), // Sleek slate outer background
        body: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 390,
              maxHeight: 844,
            ),
            margin: const EdgeInsets.all(16), // Prevent overflows on smaller desktop/tablet viewports
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: const Color(0xFF8E9196), // Outer phone bezel
                width: 10,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: child,
            ),
          ),
        ),
      );
    }

    return child;
  }
}
