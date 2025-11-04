import 'dart:math';

import 'package:flutter/material.dart';

class HandStyleBorder extends ShapeBorder {
  final BorderSide side;
  final BorderRadiusGeometry borderRadius;
  final double roughness;

  const HandStyleBorder({
    this.side = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
    this.roughness = 2.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) {
    return HandStyleBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
      roughness: roughness * t,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final innerRect = rect.deflate(side.width);
    return _createRoughPath(innerRect, borderRadius.resolve(textDirection));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _createRoughPath(rect, borderRadius.resolve(textDirection));
  }

  Path _createRoughPath(Rect rect, BorderRadius radius) {
    final path = Path();
    final random = Random(42);
    
    final topLeftRadius = radius.topLeft.x;
    final topRightRadius = radius.topRight.x;
    final bottomRightRadius = radius.bottomRight.x;
    final bottomLeftRadius = radius.bottomLeft.x;

    // Start from top-left after corner
    path.moveTo(rect.left + topLeftRadius, rect.top);

    // Top edge
    _drawRoughLine(
      path,
      rect.left + topLeftRadius,
      rect.top,
      rect.right - topRightRadius,
      rect.top,
      roughness,
      random,
    );

    // Top-right corner
    _drawRoughArc(
      path,
      rect.right - topRightRadius,
      rect.top,
      rect.right,
      rect.top + topRightRadius,
      topRightRadius,
      roughness,
      random,
    );

    // Right edge
    _drawRoughLine(
      path,
      rect.right,
      rect.top + topRightRadius,
      rect.right,
      rect.bottom - bottomRightRadius,
      roughness,
      random,
    );

    // Bottom-right corner
    _drawRoughArc(
      path,
      rect.right,
      rect.bottom - bottomRightRadius,
      rect.right - bottomRightRadius,
      rect.bottom,
      bottomRightRadius,
      roughness,
      random,
    );

    // Bottom edge
    _drawRoughLine(
      path,
      rect.right - bottomRightRadius,
      rect.bottom,
      rect.left + bottomLeftRadius,
      rect.bottom,
      roughness,
      random,
    );

    // Bottom-left corner
    _drawRoughArc(
      path,
      rect.left + bottomLeftRadius,
      rect.bottom,
      rect.left,
      rect.bottom - bottomLeftRadius,
      bottomLeftRadius,
      roughness,
      random,
    );

    // Left edge
    _drawRoughLine(
      path,
      rect.left,
      rect.bottom - bottomLeftRadius,
      rect.left,
      rect.top + topLeftRadius,
      roughness,
      random,
    );

    // Top-left corner
    _drawRoughArc(
      path,
      rect.left,
      rect.top + topLeftRadius,
      rect.left + topLeftRadius,
      rect.top,
      topLeftRadius,
      roughness,
      random,
    );

    path.close();
    return path;
  }

  void _drawRoughLine(
    Path path,
    double x1,
    double y1,
    double x2,
    double y2,
    double roughness,
    Random random,
  ) {
    final distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
    final steps = (distance / 6).round().clamp(3, 60);

    for (int i = 1; i <= steps; i++) {
      final t = i / steps;
      final x = x1 + (x2 - x1) * t;
      final y = y1 + (y2 - y1) * t;

      final angle = atan2(y2 - y1, x2 - x1) + pi / 2;
      final offset = (random.nextDouble() - 0.5) * roughness * 2;
      final offsetX = x + cos(angle) * offset;
      final offsetY = y + sin(angle) * offset;

      path.lineTo(offsetX, offsetY);
    }
  }

  void _drawRoughArc(
    Path path,
    double x1,
    double y1,
    double x2,
    double y2,
    double radius,
    double roughness,
    Random random,
  ) {
    final steps = 10;

    for (int i = 1; i <= steps; i++) {
      final t = i / steps;
      final x = x1 + (x2 - x1) * t;
      final y = y1 + (y2 - y1) * t;

      final offset = (random.nextDouble() - 0.5) * roughness;
      final angle = atan2(y - y1, x - x1);
      final offsetX = x + cos(angle + pi / 2) * offset;
      final offsetY = y + sin(angle + pi / 2) * offset;

      path.lineTo(offsetX, offsetY);
    }
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width == 0.0) return;

    final paint = Paint()
      ..color = side.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = side.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HandStyleBorder &&
        other.side == side &&
        other.borderRadius == borderRadius &&
        other.roughness == roughness;
  }

  @override
  int get hashCode => Object.hash(side, borderRadius, roughness);
}