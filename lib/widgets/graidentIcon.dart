import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final List<Color> gradientColors;
  final List<Color> shimmerColors; // NEW: Custom shimmer colors

  const GradientIcon({
    required this.icon,
    this.size = 80,
    required this.gradientColors,
    required this.shimmerColors, // NEW: Require shimmer colors
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: gradientColors,
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: Icon(
        icon,
        size: size,
        color: Colors.grey[100],
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .shimmer(duration: 5.seconds, colors: shimmerColors); 
  }
}
