import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insan_jamd_hawan/data/constants/app_colors.dart';

enum AnimationType {
  rightToLeft,
  upDown,
  circular,
  diagonal,
  floating,
  pulsing,
  rotating,
  bouncing,
}

class AnimatedBg extends StatefulWidget {
  final bool showHorizontalLines;
  final Widget child;

  const AnimatedBg({
    super.key,
    this.showHorizontalLines = false,
    required this.child,
  });

  @override
  State<AnimatedBg> createState() => _AnimatedBgState();
}

class _AnimatedBgState extends State<AnimatedBg> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _controller3 = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _controller4 = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
    
        return Stack(
          children: [
            if (widget.showHorizontalLines)
              CustomPaint(
                painter: HorizontalLinesPainter(),
                size: Size(width, height),
              ),
            CustomPaint(
              painter: DoodlePatternPainter(),
              size: Size(width, height),
            ),
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    animation: _particleController.value,
                    size: Size(width, height),
                  ),
                  size: Size(width, height),
                );
              },
            ),
            AnimatedBuilder(
              animation: Listenable.merge([_controller1, _controller3]),
              builder: (context, child) {
                return _buildLetter(
                  letter: 'B',
                  baseLeftPercent: 0,
                  baseTopPercent: 0.12,
                  color: const Color(0xFFBED6E2),
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w700,
                  width: width,
                  height: height,
                  animation: _controller1,
                  animationType: AnimationType.floating,
                  scaleAnimation: _controller3,
                );
              },
            ),
            AnimatedBuilder(
              animation: Listenable.merge([_controller2, _controller4]),
              builder: (context, child) {
                return _buildLetter(
                  letter: 'z',
                  baseLeftPercent: 0.45,
                  baseTopPercent: 0.05,
                  color: const Color(0xFF90FF9F),
                  fontSize: 42.sp,
                  fontWeight: FontWeight.w400,
                  width: width,
                  height: height,
                  animation: _controller2,
                  animationType: AnimationType.upDown,
                  rotationAnimation: _controller4,
                );
              },
            ),
            AnimatedBuilder(
              animation: Listenable.merge([_controller1, _controller3]),
              builder: (context, child) {
                return _buildLetter(
                  letter: 'q',
                  baseLeftPercent: 0.80,
                  baseTopPercent: 0.10,
                  color: const Color(0xFFFFB5B3),
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w400,
                  width: width,
                  height: height,
                  animation: _controller1,
                  animationType: AnimationType.pulsing,
                  scaleAnimation: _controller3,
                );
              },
            ),
            AnimatedBuilder(
              animation: _controller2,
              builder: (context, child) {
                return _buildLetter(
                  letter: 'V',
                  baseLeftPercent: 0.10,
                  baseTopPercent: 0.35,
                  color: const Color(0xFF90FF9F),
                  fontSize: 44.sp,
                  fontWeight: FontWeight.w700,
                  width: width,
                  height: height,
                  animation: _controller2,
                  animationType: AnimationType.bouncing,
                );
              },
            ),
            AnimatedBuilder(
              animation: _controller4,
              builder: (context, child) {
                return _buildLetter(
                  letter: 'a',
                  baseLeftPercent: 0.85,
                  baseTopPercent: 0.35,
                  color: const Color(0xFFFFD767),
                  fontSize: 38.sp,
                  fontWeight: FontWeight.w400,
                  width: width,
                  height: height,
                  animation: _controller4,
                  animationType: AnimationType.circular,
                );
              },
            ),
            AnimatedBuilder(
              animation: Listenable.merge([_controller2, _controller3]),
              builder: (context, child) {
                return _buildLetter(
                  letter: 'f',
                  baseLeftPercent: 0.10,
                  baseTopPercent: 0.55,
                  color: const Color(0xFFFFB5B3),
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w400,
                  width: width,
                  height: height,
                  animation: _controller2,
                  animationType: AnimationType.floating,
                  scaleAnimation: _controller3,
                );
              },
            ),
            AnimatedBuilder(
              animation: _controller4,
              builder: (context, child) {
                return _buildLetter(
                  letter: 'i',
                  baseLeftPercent: 0.85,
                  baseTopPercent: 0.60,
                  color: const Color(0xFFFFD767),
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w400,
                  width: width,
                  height: height,
                  animation: _controller4,
                  animationType: AnimationType.rotating,
                );
              },
            ),
            AnimatedBuilder(
              animation: Listenable.merge([_controller2, _controller3]),
              builder: (context, child) {
                return _buildLetter(
                  letter: 'R',
                  baseLeftPercent: 0.05,
                  baseTopPercent: 0.85,
                  color: const Color(0xFFFFD767),
                  fontSize: 46.sp,
                  fontWeight: FontWeight.w700,
                  width: width,
                  height: height,
                  animation: _controller2,
                  animationType: AnimationType.bouncing,
                  scaleAnimation: _controller3,
                );
              },
            ),
            AnimatedBuilder(
              animation: _controller1,
              builder: (context, child) {
                return _buildLetter(
                  letter: 'y',
                  baseLeftPercent: 0.45,
                  baseTopPercent: 0.90,
                  color: const Color(0xFFFFB5B3),
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w400,
                  width: width,
                  height: height,
                  animation: _controller1,
                  animationType: AnimationType.diagonal,
                );
              },
            ),
            AnimatedBuilder(
              animation: _controller1,
              builder: (context, child) {
                return _buildLetter(
                  letter: 'e',
                  baseLeftPercent: 0.85,
                  baseTopPercent: 0.80,
                  color: const Color(0xFF90FF9F),
                  fontSize: 38.sp,
                  fontWeight: FontWeight.w400,
                  width: width,
                  height: height,
                  animation: _controller1,
                  animationType: AnimationType.floating,
                );
              },
            ),
            AnimatedBuilder(
              animation: _controller3,
              builder: (context, child) {
                return _buildLetter(
                  letter: 't',
                  baseLeftPercent: 0.85,
                  baseTopPercent: 0.90,
                  color: const Color(0xFFBED6E2),
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w400,
                  width: width,
                  height: height,
                  animation: _controller3,
                  animationType: AnimationType.pulsing,
                );
              },
            ),
            widget.child,
          ],
        );
      },
    );
  }

  Widget _buildLetter({
    required String letter,
    required double baseLeftPercent,
    required double baseTopPercent,
    required Color color,
    required double fontSize,
    required FontWeight fontWeight,
    required double width,
    required double height,
    AnimationController? animation,
    AnimationType? animationType,
    AnimationController? scaleAnimation,
    AnimationController? rotationAnimation,
  }) {
    double leftPercent = baseLeftPercent;
    double topPercent = baseTopPercent;
    double animationOffsetX = 0;
    double animationOffsetY = 0;
    double scale = 1.0;
    double rotation = 0.0;

    if (animation != null && animationType != null) {
      final value = animation.value;
      const animationRange = 0.015;

      switch (animationType) {
        case AnimationType.rightToLeft:
          animationOffsetX = sin(value * 2 * pi) * animationRange * width;
          break;
        case AnimationType.upDown:
          animationOffsetY = sin(value * 2 * pi) * animationRange * height;
          break;
        case AnimationType.circular:
          animationOffsetX = cos(value * 2 * pi) * animationRange * width;
          animationOffsetY = sin(value * 2 * pi) * animationRange * height;
          break;
        case AnimationType.diagonal:
          animationOffsetX = sin(value * 2 * pi) * animationRange * width;
          animationOffsetY = cos(value * 2 * pi) * animationRange * height;
          break;
        case AnimationType.floating:
          animationOffsetX = sin(value * 2 * pi) * animationRange * width * 0.6;
          animationOffsetY =
              cos(value * 2 * pi) * animationRange * height * 0.6;
          break;
        case AnimationType.pulsing:
          break;
        case AnimationType.rotating:
          rotation = value * 2 * pi;
          break;
        case AnimationType.bouncing:
          final bounce = sin(value * pi);
          animationOffsetY = -bounce * bounce * animationRange * height * 1.0;
          break;
      }
    }

    if (scaleAnimation != null) {
      final scaleValue = scaleAnimation.value;
      if (animationType == AnimationType.pulsing) {
        scale = 0.95 + (sin(scaleValue * 2 * pi) + 1) * 0.05;
      } else {
        scale = 1.0 + sin(scaleValue * 2 * pi) * 0.03;
      }
    }

    if (rotationAnimation != null && animationType != AnimationType.rotating) {
      rotation = sin(rotationAnimation.value * 2 * pi) * 0.1;
    }

    return Positioned(
      left: width * leftPercent + animationOffsetX,
      top: height * topPercent + animationOffsetY,
      child: Transform.scale(
        scale: scale,
        child: Transform.rotate(
          angle: rotation,
          child: Stack(
            children: [
              ...List.generate(16, (index) {
                final angle = (index * 2 * pi / 16);
                final offsetX = cos(angle) * 2.0;
                final offsetY = sin(angle) * 2.0;
                return Transform.translate(
                  offset: Offset(offsetX, offsetY),
                  child: Text(
                    letter,
                    style: GoogleFonts.kalam(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: color.withValues(alpha: .2),
                    ),
                  ),
                );
              }),
              ...List.generate(8, (index) {
                final angle = (index * 2 * pi / 8);
                final offsetX = cos(angle) * 1.0;
                final offsetY = sin(angle) * 1.0;
                return Transform.translate(
                  offset: Offset(offsetX, offsetY),
                  child: Text(
                    letter,
                    style: GoogleFonts.kalam(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: color.withValues(alpha: .2),
                    ),
                  ),
                );
              }),
              Text(
                letter,
                style: GoogleFonts.kalam(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: color.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBED6E2).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final numberOfLines = 15;
    final spacing = size.height / (numberOfLines + 1);

    for (int i = 1; i <= numberOfLines; i++) {
      final y = spacing * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DoodlePatternPainter extends CustomPainter {
  final Random random = Random(42);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.kGray300.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    _drawPencil(canvas, size, paint);
    _drawBook(canvas, size, paint);
    _drawRuler(canvas, size, paint);
    _drawApple(canvas, size, paint);
    _drawClock(canvas, size, paint);
    _drawSchoolBus(canvas, size, paint);
    _drawGlobe(canvas, size, paint);
    _drawStar(canvas, size, paint);
    _drawPaperAirplane(canvas, size, paint);
    _drawAtom(canvas, size, paint);
    _drawBasketball(canvas, size, paint);
    _drawCrayon(canvas, size, paint);
    _drawEraser(canvas, size, paint);
    _drawBlackboard(canvas, size, paint);
  }

  void _drawPencil(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.2;
    final y = size.height * 0.15;

    path.moveTo(x, y);
    path.lineTo(x + 15, y - 5);
    path.lineTo(x + 15, y + 5);
    path.close();

    path.moveTo(x + 15, y);
    path.lineTo(x + 20, y - 2);
    path.lineTo(x + 20, y + 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawBook(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.6;
    final y = size.height * 0.25;

    path.moveTo(x, y);
    path.lineTo(x + 20, y - 5);
    path.lineTo(x + 20, y + 15);
    path.lineTo(x, y + 20);
    path.close();

    path.moveTo(x, y);
    path.lineTo(x + 20, y - 5);

    canvas.drawPath(path, paint);
  }

  void _drawRuler(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.3;
    final y = size.height * 0.4;

    path.moveTo(x, y);
    path.lineTo(x + 25, y - 2);
    path.lineTo(x + 25, y + 2);
    path.lineTo(x, y + 4);
    path.close();

    for (int i = 0; i < 5; i++) {
      path.moveTo(x + i * 5, y);
      path.lineTo(x + i * 5, y - 1);
    }

    canvas.drawPath(path, paint);
  }

  void _drawApple(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.7;
    final y = size.height * 0.5;

    path.addOval(Rect.fromCenter(center: Offset(x, y), width: 12, height: 12));

    path.moveTo(x, y - 6);
    path.lineTo(x - 1, y - 8);
    path.lineTo(x + 1, y - 8);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawClock(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.4;
    final y = size.height * 0.65;

    path.addOval(Rect.fromCenter(center: Offset(x, y), width: 18, height: 18));

    path.moveTo(x, y);
    path.lineTo(x + 3, y - 3);
    path.moveTo(x, y);
    path.lineTo(x + 5, y);

    canvas.drawPath(path, paint);
  }

  void _drawSchoolBus(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.15;
    final y = size.height * 0.75;

    path.addRect(Rect.fromLTWH(x, y, 20, 10));

    path.addRect(Rect.fromLTWH(x + 2, y + 2, 4, 4));
    path.addRect(Rect.fromLTWH(x + 8, y + 2, 4, 4));
    path.addRect(Rect.fromLTWH(x + 14, y + 2, 4, 4));

    path.addOval(
      Rect.fromCenter(center: Offset(x + 5, y + 10), width: 4, height: 4),
    );
    path.addOval(
      Rect.fromCenter(center: Offset(x + 15, y + 10), width: 4, height: 4),
    );

    canvas.drawPath(path, paint);
  }

  void _drawGlobe(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.8;
    final y = size.height * 0.3;

    path.addOval(Rect.fromCenter(center: Offset(x, y), width: 16, height: 16));

    path.moveTo(x - 8, y);
    path.quadraticBezierTo(x, y - 4, x + 8, y);
    path.moveTo(x - 8, y);
    path.quadraticBezierTo(x, y + 4, x + 8, y);

    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.5;
    final y = size.height * 0.2;

    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * pi / 5) - (pi / 2);
      final radius = i.isEven ? 8.0 : 4.0;
      final px = x + cos(angle) * radius;
      final py = y + sin(angle) * radius;

      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawPaperAirplane(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.25;
    final y = size.height * 0.6;

    path.moveTo(x, y);
    path.lineTo(x + 10, y - 5);
    path.lineTo(x + 15, y);
    path.lineTo(x + 10, y + 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawAtom(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.65;
    final y = size.height * 0.7;

    path.addOval(Rect.fromCenter(center: Offset(x, y), width: 4, height: 4));

    path.addOval(Rect.fromCenter(center: Offset(x, y), width: 12, height: 6));
    path.addOval(Rect.fromCenter(center: Offset(x, y), width: 12, height: 6));

    canvas.drawPath(path, paint);
  }

  void _drawBasketball(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.35;
    final y = size.height * 0.8;

    path.addOval(Rect.fromCenter(center: Offset(x, y), width: 14, height: 14));

    path.moveTo(x - 7, y);
    path.lineTo(x + 7, y);
    path.moveTo(x, y - 7);
    path.lineTo(x, y + 7);

    canvas.drawPath(path, paint);
  }

  void _drawCrayon(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.55;
    final y = size.height * 0.55;

    path.moveTo(x, y);
    path.lineTo(x + 12, y - 3);
    path.lineTo(x + 12, y + 3);
    path.close();

    path.moveTo(x + 12, y);
    path.lineTo(x + 16, y - 1);
    path.lineTo(x + 16, y + 1);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawEraser(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.45;
    final y = size.height * 0.35;

    path.addRect(Rect.fromLTWH(x, y, 8, 4));

    path.addRect(Rect.fromLTWH(x, y, 8, 1));

    canvas.drawPath(path, paint);
  }

  void _drawBlackboard(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final x = size.width * 0.75;
    final y = size.height * 0.6;

    path.addRect(Rect.fromLTWH(x, y, 14, 10));

    final textPainter = TextPainter(
      text: TextSpan(
        text: '2+2',
        style: TextStyle(
          color: AppColors.kGray300.withOpacity(0.5),
          fontSize: 8,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x + 2, y + 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ParticlePainter extends CustomPainter {
  final double animation;
  final Size size;
  final Random random = Random(42);

  ParticlePainter({required this.animation, required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final particleCount = 20;
    final colors = [
      const Color(0xFFBED6E2),
      const Color(0xFF90FF9F),
      const Color(0xFFFFB5B3),
      const Color(0xFFFFD767),
    ];

    for (int i = 0; i < particleCount; i++) {
      final seed = Random(42 + i);
      final x = (seed.nextDouble() * size.width);
      final y = (seed.nextDouble() * size.height);
      final colorIndex = i % colors.length;
      final color = colors[colorIndex];

      final offsetY = (animation * 2 * pi + i * 0.5) % (2 * pi);
      final finalY = (y - sin(offsetY) * 50) % size.height;
      final finalX = (x + cos(offsetY) * 20) % size.width;

      final particleSize = 2.0 + (seed.nextDouble() * 2.0);

      final opacity = (sin(offsetY) + 1) / 2 * 0.6 + 0.2;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(finalX, finalY), particleSize, paint);

      if (i % 3 == 0) {
        final glowPaint = Paint()
          ..color = color.withOpacity(opacity * 0.3)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(finalX, finalY), particleSize * 2, glowPaint);
      }
    }

    final sparkleCount = 8;
    for (int i = 0; i < sparkleCount; i++) {
      final seed = Random(100 + i);
      final x = (seed.nextDouble() * size.width);
      final y = (seed.nextDouble() * size.height);

      final sparklePhase = (animation * 3 + i * 0.3) % (2 * pi);
      final sparkleOpacity = (sin(sparklePhase) + 1) / 2;

      if (sparkleOpacity > 0.3) {
        final sparklePaint = Paint()
          ..color = Colors.white.withOpacity(sparkleOpacity * 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

        final sparkleSize = 3.0;
        canvas.drawLine(
          Offset(x - sparkleSize, y),
          Offset(x + sparkleSize, y),
          sparklePaint,
        );
        canvas.drawLine(
          Offset(x, y - sparkleSize),
          Offset(x, y + sparkleSize),
          sparklePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) =>
      oldDelegate.animation != animation || oldDelegate.size != size;
}
