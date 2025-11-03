import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/app_colors.dart';

class HandDrawnDivider extends StatelessWidget {
  final Color? color;
  final double? thickness;
  final double? height;
  final double? width;

  const HandDrawnDivider({
    super.key,
    this.color,
    this.thickness,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 16.h,
      child: CustomPaint(
        painter: HandDrawnDividerPainter(
          color: color ?? AppColors.kGray300,
          thickness: thickness ?? 1.0,
        ),
      ),
    );
  }
}

class HandDrawnDividerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final Random random = Random(42); // Fixed seed for consistent drawing

  HandDrawnDividerPainter({
    required this.color,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final roughness = 1.0; // Controls how rough/wavy the line is
    final midY = size.height / 2;

    // Draw a wavy horizontal line
    final segments = (size.width / 8).round().clamp(5, 50);

    path.moveTo(0, midY + (random.nextDouble() - 0.5) * roughness);

    for (int i = 1; i <= segments; i++) {
      final x = size.width * (i / segments);
      // Add wavy variation along Y axis
      final y = midY + (random.nextDouble() - 0.5) * roughness;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HandDrawnDividerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.thickness != thickness;
  }
}

