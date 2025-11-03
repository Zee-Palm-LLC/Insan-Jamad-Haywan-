import 'dart:math';
import 'package:flutter/material.dart';
import 'package:insan_jamd_hawan/data/constants/app_colors.dart';

class RoughBorderPainter extends CustomPainter {
  final double borderWidth;
  final Random _random;

  RoughBorderPainter({this.borderWidth = 7.0}) : _random = Random(42);

  @override
  void paint(Canvas canvas, Size size) {
    // Create rough border path for clipping
    final path = _createRoughPath(size);
    
    // Draw the border with rough edges
    final borderPaint = Paint()
      ..color = AppColors.kLightBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, borderPaint);
    
    // Add subtle shadow effect along the right edge
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 0.8;

    canvas.drawPath(path, shadowPaint);
  }

  Path _createRoughPath(Size size) {
    final path = Path();
    final segments = 30; // More segments = smoother but more detailed
    
    // Top edge - slight wavy variations
    path.moveTo(_getJaggedX(0, segments, size.width, offset: -1, maxOffset: 2), 0);
    for (int i = 1; i <= segments; i++) {
      final x = size.width * (i / segments);
      final y = _getJaggedY(i, segments, offset: 0, maxOffset: 2);
      path.lineTo(x, y);
    }
    
    // Right edge - pronounced jagged/wavy pattern (most visible)
    final rightEdgeSegments = segments;
    for (int i = 1; i <= rightEdgeSegments; i++) {
      final y = size.height * (i / rightEdgeSegments);
      // More pronounced jagged effect on right edge
      final x = size.width + _getJaggedX(i, rightEdgeSegments, size.height, 
          offset: -10, maxOffset: 12);
      path.lineTo(x, y);
    }
    
    // Bottom edge - slight variations
    for (int i = segments - 1; i >= 0; i--) {
      final x = size.width * (i / segments);
      final y = size.height + _getJaggedY(i, segments, offset: 0, maxOffset: 2);
      path.lineTo(x, y);
    }
    
    // Left edge - mostly straight with minor undulations
    for (int i = segments - 1; i >= 0; i--) {
      final y = size.height * (i / segments);
      final x = _getJaggedX(i, segments, size.height, offset: -2, maxOffset: 3);
      path.lineTo(x, y);
    }
    
    path.close();
    return path;
  }

  double _getJaggedY(int segment, int total, {required double offset, required double maxOffset}) {
    final normalizedPos = segment / total;
    // Create irregular pattern using multiple sine waves with noise
    final wave1 = sin(normalizedPos * 2 * pi * 2.7) * 0.5;
    final wave2 = cos(normalizedPos * 2 * pi * 5.1) * 0.3;
    final noise = (_random.nextDouble() - 0.5) * 0.6;
    final combined = (wave1 + wave2 + noise) * 0.5;
    return offset + combined * maxOffset;
  }

  double _getJaggedX(int segment, int total, double dimension, {required double offset, required double maxOffset}) {
    final normalizedPos = segment / total;
    // Create more pronounced irregular jagged pattern
    final wave1 = sin(normalizedPos * 2 * pi * 2.3) * 0.5;
    final wave2 = cos(normalizedPos * 2 * pi * 3.7) * 0.4;
    final wave3 = sin(normalizedPos * 2 * pi * 6.2) * 0.2;
    // Add random noise for organic feel
    final noise = (_random.nextDouble() - 0.5) * 0.7;
    final combined = wave1 + wave2 + wave3 + noise;
    // Normalize to ensure it stays within bounds
    final normalized = (combined / 2.0).clamp(-1.0, 1.0);
    return offset + normalized * maxOffset;
  }

  @override
  bool shouldRepaint(covariant RoughBorderPainter oldDelegate) {
    return oldDelegate.borderWidth != borderWidth;
  }
}

/// Custom clipper for rough border shape
class RoughBorderClipper extends CustomClipper<Path> {
  final Random _random = Random(42);

  @override
  Path getClip(Size size) {
    final path = Path();
    final segments = 30;
    
    // Top edge - slight wavy variations
    path.moveTo(_getJaggedX(0, segments, size.width, offset: -1, maxOffset: 2), 0);
    for (int i = 1; i <= segments; i++) {
      final x = size.width * (i / segments);
      final y = _getJaggedY(i, segments, offset: 0, maxOffset: 2);
      path.lineTo(x, y);
    }
    
    // Right edge - pronounced jagged/wavy pattern
    for (int i = 1; i <= segments; i++) {
      final y = size.height * (i / segments);
      final x = size.width + _getJaggedX(i, segments, size.height, 
          offset: -10, maxOffset: 12);
      path.lineTo(x, y);
    }
    
    // Bottom edge - slight variations
    for (int i = segments - 1; i >= 0; i--) {
      final x = size.width * (i / segments);
      final y = size.height + _getJaggedY(i, segments, offset: 0, maxOffset: 2);
      path.lineTo(x, y);
    }
    
    // Left edge - mostly straight with minor undulations
    for (int i = segments - 1; i >= 0; i--) {
      final y = size.height * (i / segments);
      final x = _getJaggedX(i, segments, size.height, offset: -2, maxOffset: 3);
      path.lineTo(x, y);
    }
    
    path.close();
    return path;
  }

  double _getJaggedY(int segment, int total, {required double offset, required double maxOffset}) {
    final normalizedPos = segment / total;
    final wave1 = sin(normalizedPos * 2 * pi * 2.7) * 0.5;
    final wave2 = cos(normalizedPos * 2 * pi * 5.1) * 0.3;
    final noise = (_random.nextDouble() - 0.5) * 0.6;
    final combined = (wave1 + wave2 + noise) * 0.5;
    return offset + combined * maxOffset;
  }

  double _getJaggedX(int segment, int total, double dimension, {required double offset, required double maxOffset}) {
    final normalizedPos = segment / total;
    final wave1 = sin(normalizedPos * 2 * pi * 2.3) * 0.5;
    final wave2 = cos(normalizedPos * 2 * pi * 3.7) * 0.4;
    final wave3 = sin(normalizedPos * 2 * pi * 6.2) * 0.2;
    final noise = (_random.nextDouble() - 0.5) * 0.7;
    final combined = wave1 + wave2 + wave3 + noise;
    final normalized = (combined / 2.0).clamp(-1.0, 1.0);
    return offset + normalized * maxOffset;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

