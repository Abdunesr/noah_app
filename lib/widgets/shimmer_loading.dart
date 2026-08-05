import 'dart:ui';
import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
    required this.shimmerChild,
  });

  final bool isLoading;
  final Widget child;
  final Widget shimmerChild;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return _createShimmerGradient(bounds);
          },
          child: widget.shimmerChild,
        );
      },
    );
  }

  Shader _createShimmerGradient(Rect bounds) {
    const gradientWidth = 0.3;
    const baseColor = Color(0xFFF3F4F6);
    const highlightColor = Color(0xFFE5E7EB);

    final shimmerOffset = (bounds.width * gradientWidth) * _animation.value;

    return LinearGradient(
      colors: const [baseColor, highlightColor, baseColor],
      stops: const [0.0, 0.5, 1.0],
      begin: Alignment(-1.0 + _animation.value, 0.0),
      end: Alignment(1.0 + _animation.value, 0.0),
    ).createShader(bounds);
  }
}
