import 'dart:math';

import 'package:flutter/material.dart';

/// Custom InputBorder with rough pencil-style drawing for TextField inputs
class RoughInputBorder extends InputBorder {
  final BorderRadius borderRadius;
  final double roughness;

  const RoughInputBorder({
    super.borderSide = const BorderSide(),
    this.borderRadius = BorderRadius.zero,
    this.roughness = 0.8,
  });

  @override
  InputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? roughness,
    InputBorder? enabledBorder,
    InputBorder? focusedBorder,
    InputBorder? disabledBorder,
    InputBorder? errorBorder,
    InputBorder? focusedErrorBorder,
  }) {
    return RoughInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      roughness: roughness ?? this.roughness,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(borderSide.width);

  @override
  RoughInputBorder scale(double t) {
    return RoughInputBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
      roughness: roughness * t,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final resolvedRadius = borderRadius.resolve(textDirection);
    final innerRect = rect.deflate(borderSide.width);
    return Path()..addRRect(RRect.fromRectAndRadius(innerRect, resolvedRadius.topLeft));
  }

  @override
  bool get isOutline => true;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final resolvedRadius = borderRadius.resolve(textDirection);
    return Path()..addRRect(RRect.fromRectAndCorners(rect, topLeft: resolvedRadius.topLeft, topRight: resolvedRadius.topRight, bottomLeft: resolvedRadius.bottomLeft, bottomRight: resolvedRadius.bottomRight));
  }

  @override
  void paint(Canvas canvas, Rect rect, {double? gapStart, double gapExtent = 0.0, double gapPercentage = 0.0, TextDirection? textDirection}) {
    if (borderSide.style == BorderStyle.none || borderSide.width == 0.0) return;
    final localRandom = Random(42);
    final resolvedRadius = borderRadius.resolve(textDirection);
    final topLeftRadius = resolvedRadius.topLeft.x;
    final topRightRadius = resolvedRadius.topRight.x;
    final bottomRightRadius = resolvedRadius.bottomRight.x;
    final bottomLeftRadius = resolvedRadius.bottomLeft.x;
    final topEdge = _generateRoughEdge(rect.left + topLeftRadius, rect.top, rect.right - topRightRadius, rect.top, localRandom);
    final rightEdge = _generateRoughEdge(rect.right, rect.top + topRightRadius, rect.right, rect.bottom - bottomRightRadius, localRandom);
    final bottomEdge = _generateRoughEdge(rect.right - bottomRightRadius, rect.bottom, rect.left + bottomLeftRadius, rect.bottom, localRandom);
    final leftEdge = _generateRoughEdge(rect.left, rect.bottom - bottomLeftRadius, rect.left, rect.top + topLeftRadius, localRandom);
    final topRightCorner = _generateRoughArc(rect.right - topRightRadius, rect.top, rect.right, rect.top + topRightRadius, topRightRadius, localRandom);
    final bottomRightCorner = _generateRoughArc(rect.right, rect.bottom - bottomRightRadius, rect.right - bottomRightRadius, rect.bottom, bottomRightRadius, localRandom);
    final bottomLeftCorner = _generateRoughArc(rect.left + bottomLeftRadius, rect.bottom, rect.left, rect.bottom - bottomLeftRadius, bottomLeftRadius, localRandom);
    final topLeftCorner = _generateRoughArc(rect.left, rect.top + topLeftRadius, rect.left + topLeftRadius, rect.top, topLeftRadius, localRandom);
    final allSegments = [...topEdge, ...topRightCorner, ...rightEdge, ...bottomRightCorner, ...bottomEdge, ...bottomLeftCorner, ...leftEdge, ...topLeftCorner];
    for (int i = 0; i < allSegments.length - 1; i++) {
      final currentPoint = allSegments[i];
      final nextPoint = allSegments[i + 1];
      final widthVariation = localRandom.nextDouble();
      final strokeWidth = widthVariation < 0.6 ? borderSide.width : borderSide.width * 0.5;
      final paint = Paint()..color = borderSide.color..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
      canvas.drawLine(currentPoint, nextPoint, paint);
      if (widthVariation > 0.85) {
        final lightPaint = Paint()..color = borderSide.color.withOpacity(0.6)..style = PaintingStyle.stroke..strokeWidth = borderSide.width * 0.3..strokeCap = StrokeCap.round;
        canvas.drawLine(currentPoint, nextPoint, lightPaint);
      }
    }
  }

  List<Offset> _generateRoughEdge(double x1, double y1, double x2, double y2, Random random) {
    final points = <Offset>[];
    final distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
    final steps = (distance / 4).round().clamp(3, 40);
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = x1 + (x2 - x1) * t;
      final y = y1 + (y2 - y1) * t;
      final angle = atan2(y2 - y1, x2 - x1) + pi / 2;
      final offset = (random.nextDouble() - 0.5) * roughness;
      points.add(Offset(x + cos(angle) * offset, y + sin(angle) * offset));
    }
    return points;
  }

  List<Offset> _generateRoughArc(double x1, double y1, double x2, double y2, double radius, Random random) {
    final points = <Offset>[];
    // Calculate the center of the arc (corner center)
    // For a 90-degree corner, determine which corner it is based on point positions
    // The center is always at the corner vertex, offset by radius
    double centerX, centerY;
    
    // Determine corner type and calculate center based on actual corner calls
    // For rounded rectangle corners, the center is always at the corner vertex
    if (x1 < x2 && y1 < y2) {
      // Top-right corner: center is at (x1, y2)
      centerX = x1;
      centerY = y2;
    } else if (x1 > x2 && y1 < y2) {
      // Top-left corner: center is at (x2, y1)
      centerX = x2;
      centerY = y1;
    } else if (x1 > x2 && y1 > y2) {
      // Bottom-left corner: center is at (x1, y2)
      centerX = x1;
      centerY = y2;
    } else {
      // Bottom-right corner: center is at (x2, y1)
      centerX = x2;
      centerY = y1;
    }
    
    // Calculate start and end angles
    final startAngle = atan2(y1 - centerY, x1 - centerX);
    final endAngle = atan2(y2 - centerY, x2 - centerX);
    
    // Ensure we go the shorter way around the arc (90 degrees)
    var angleDiff = endAngle - startAngle;
    if (angleDiff > pi) angleDiff -= 2 * pi;
    if (angleDiff < -pi) angleDiff += 2 * pi;
    
    // Use more steps for larger radii to ensure smoothness
    final steps = max(10, (radius * angleDiff.abs() / 4).round()).clamp(10, 30);
    
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final angle = startAngle + angleDiff * t;
      // Apply roughness in radial direction (adjust radius)
      final radiusOffset = (random.nextDouble() - 0.5) * roughness * 0.3;
      final adjustedRadius = radius + radiusOffset;
      points.add(Offset(
        centerX + cos(angle) * adjustedRadius,
        centerY + sin(angle) * adjustedRadius,
      ));
    }
    return points;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is RoughInputBorder && other.borderSide == borderSide && other.borderRadius == borderRadius && other.roughness == roughness;
  @override
  int get hashCode => Object.hash(borderSide, borderRadius, roughness);
}

/// Custom border that extends ShapeBorder for use with ShapeDecoration
/// Usage: decoration: ShapeDecoration(shape: RoughCircleBorder.all(...), color: ...)
class RoughCircleBorder extends ShapeBorder {
  final BorderSide side;
  final double roughness;
  final Random random;

  RoughCircleBorder({
    this.side = BorderSide.none,
    this.roughness = 0.8,
    Random? random,
  }) : random = random ?? Random(42);

  RoughCircleBorder.all({
    Color color = const Color(0xFF6B7280),
    double width = 2.0,
    BorderStyle style = BorderStyle.solid,
    this.roughness = 0.8,
    Random? random,
  }) : side = BorderSide(color: color, width: width, style: style),
       random = random ?? Random(42);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) {
    return RoughCircleBorder(
      side: side.scale(t),
      roughness: roughness,
      random: random,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final center = Offset(rect.center.dx, rect.center.dy);
    final radius = (rect.width / 2) - side.width;
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final center = Offset(rect.center.dx, rect.center.dy);
    final radius = rect.width / 2;
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width == 0.0) return;

    // Create a local Random with fixed seed to ensure consistent drawing
    // This prevents the border from regenerating on mouse movements
    final localRandom = Random(42);

    final center = Offset(rect.center.dx, rect.center.dy);
    final radius = (rect.width / 2) - (side.width / 2);
    
    final segments = 120;
    final angleStep = (2 * pi) / segments;
    
    // Pre-calculate all points with consistent random values
    final points = <Offset>[];
    for (int i = 0; i <= segments; i++) {
      final angle = i * angleStep;
      final randomOffset = (localRandom.nextDouble() - 0.5) * roughness;
      final adjustedRadius = radius + randomOffset;
      points.add(Offset(
        center.dx + cos(angle) * adjustedRadius,
        center.dy + sin(angle) * adjustedRadius,
      ));
    }
    
    // Pre-calculate all width variations to ensure consistency
    final widthVariations = <double>[];
    for (int i = 0; i < points.length - 1; i++) {
      widthVariations.add(localRandom.nextDouble());
    }
    
    // Draw segments with varying widths (pencil-style)
    for (int i = 0; i < points.length - 1; i++) {
      final currentPoint = points[i];
      final nextPoint = points[i + 1];
      
      final widthVariation = widthVariations[i];
      final strokeWidth = widthVariation < 0.6 
          ? side.width 
          : side.width * 0.5; // 60% full width, 40% half width
      
      final paint = Paint()
        ..color = side.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      
      canvas.drawLine(currentPoint, nextPoint, paint);
      
      // Occasionally add lighter strokes (10% chance)
      if (widthVariation > 0.85) {
        final lightPaint = Paint()
          ..color = side.color.withOpacity(0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = side.width * 0.3
          ..strokeCap = StrokeCap.round;
        
        canvas.drawLine(currentPoint, nextPoint, lightPaint);
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RoughCircleBorder &&
        other.side == side &&
        other.roughness == roughness;
  }

  @override
  int get hashCode => Object.hash(side, roughness);
}

// Legacy painter for backward compatibility
class RoughBorderPainter extends CustomPainter {
  final Color color;
  final double baseWidth;
  final double roughness;
  final Random random = Random(42);

  RoughBorderPainter({
    required this.color,
    required this.baseWidth,
    required this.roughness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (baseWidth / 2);
    
    final segments = 120;
    final angleStep = (2 * pi) / segments;
    
    final points = <Offset>[];
    for (int i = 0; i <= segments; i++) {
      final angle = i * angleStep;
      final randomOffset = (random.nextDouble() - 0.5) * roughness;
      final adjustedRadius = radius + randomOffset;
      points.add(Offset(
        center.dx + cos(angle) * adjustedRadius,
        center.dy + sin(angle) * adjustedRadius,
      ));
    }
    
    for (int i = 0; i < points.length - 1; i++) {
      final currentPoint = points[i];
      final nextPoint = points[i + 1];
      
      final widthVariation = random.nextDouble();
      final strokeWidth = widthVariation < 0.6 
          ? baseWidth 
          : baseWidth * 0.5;
      
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      
      canvas.drawLine(currentPoint, nextPoint, paint);
      
      if (widthVariation > 0.85) {
        final lightPaint = Paint()
          ..color = color.withOpacity(0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = baseWidth * 0.3
          ..strokeCap = StrokeCap.round;
        
        canvas.drawLine(currentPoint, nextPoint, lightPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RoughBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.baseWidth != baseWidth ||
        oldDelegate.roughness != roughness;
  }
}
