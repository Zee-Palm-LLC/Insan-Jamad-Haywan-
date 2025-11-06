import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfettiAnimation extends StatefulWidget {
  const ConfettiAnimation({
    super.key,
    this.enabled = true,
    this.duration = const Duration(seconds: 3),
  });

  final bool enabled;
  final Duration duration;

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation> {
  late ConfettiController _controllerCenter;
  late ConfettiController _controllerTopLeft;
  late ConfettiController _controllerTopRight;
  late ConfettiController _controllerBottomLeft;
  late ConfettiController _controllerBottomRight;
  final Random _random = Random();

  // Custom path for ribbons (long thin rectangles)
  Path _drawRibbon(Size size) {
    final path = Path();
    // Ribbon: long thin rectangle
    path.addRect(Rect.fromLTWH(0, 0, size.width * 3, size.height * 0.3));
    return path;
  }

  // Custom path for small particles (very small dots/rectangles)
  Path _drawSmallParticle(Size size) {
    final path = Path();
    // Very small particle - tiny square or circle
    path.addOval(Rect.fromLTWH(0, 0, size.width * 0.5, size.height * 0.5));
    return path;
  }

  // Randomly choose between ribbon and small particle
  Path _createParticlePath(Size size) {
    // 40% ribbons, 60% small particles
    if (_random.nextDouble() < 0.4) {
      return _drawRibbon(size);
    } else {
      return _drawSmallParticle(size);
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(
      duration: widget.duration,
    );
    _controllerTopLeft = ConfettiController(
      duration: widget.duration,
    );
    _controllerTopRight = ConfettiController(
      duration: widget.duration,
    );
    _controllerBottomLeft = ConfettiController(
      duration: widget.duration,
    );
    _controllerBottomRight = ConfettiController(
      duration: widget.duration,
    );
  }

  void _startFireworksBlasts() {
    if (!mounted || !widget.enabled) return;

    // Center burst immediately
    _controllerCenter.play();

    // Staggered bursts for fireworks effect
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && widget.enabled) {
        _controllerTopLeft.play();
        _controllerBottomRight.play();
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && widget.enabled) {
        _controllerTopRight.play();
        _controllerBottomLeft.play();
      }
    });

    // Repeat the pattern for continuous fireworks
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && widget.enabled) {
        _startFireworksBlasts();
      }
    });
  }

  @override
  void didUpdateWidget(ConfettiAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _startFireworksBlasts();
    } else if (!widget.enabled && oldWidget.enabled) {
      _controllerCenter.stop();
      _controllerTopLeft.stop();
      _controllerTopRight.stop();
      _controllerBottomLeft.stop();
      _controllerBottomRight.stop();
    }
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerTopLeft.dispose();
    _controllerTopRight.dispose();
    _controllerBottomLeft.dispose();
    _controllerBottomRight.dispose();
    super.dispose();
  }

  Widget _buildConfettiWidget({
    required ConfettiController controller,
    required Alignment alignment,
    double blastForceMultiplier = 1.0,
  }) {
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
        confettiController: controller,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: true, // Continuous animation
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple,
          Colors.yellow,
          Colors.red,
          Colors.cyan,
          Colors.white,
        ],
        createParticlePath: _createParticlePath,
        minimumSize: const Size(2, 2),
        maximumSize: const Size(8, 8),
        emissionFrequency: 0.05,
        numberOfParticles: 50,
        gravity: 0.1,
        maxBlastForce: 8 * blastForceMultiplier,
        minBlastForce: 3 * blastForceMultiplier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return const SizedBox.shrink();

    // Start continuous fireworks animation when enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.enabled) {
        _startFireworksBlasts();
      }
    });

    return IgnorePointer(
      child: ClipRect(
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(200.r),
          child: SizedBox(
            width: 220.h,
            height: 200.h,
            child: Stack(
              children: [
                // Center blast - main fireworks
                _buildConfettiWidget(
                  controller: _controllerCenter,
                  alignment: Alignment.center,
                  blastForceMultiplier: 1.2,
                ),
                // Top left blast
                _buildConfettiWidget(
                  controller: _controllerTopLeft,
                  alignment: Alignment.topLeft,
                  blastForceMultiplier: 0.8,
                ),
                // Top right blast
                _buildConfettiWidget(
                  controller: _controllerTopRight,
                  alignment: Alignment.topRight,
                  blastForceMultiplier: 0.8,
                ),
                // Bottom left blast
                _buildConfettiWidget(
                  controller: _controllerBottomLeft,
                  alignment: Alignment.bottomLeft,
                  blastForceMultiplier: 0.8,
                ),
                // Bottom right blast
                _buildConfettiWidget(
                  controller: _controllerBottomRight,
                  alignment: Alignment.bottomRight,
                  blastForceMultiplier: 0.8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

