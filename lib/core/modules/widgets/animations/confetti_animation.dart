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
  bool _hasStarted = false;
  final Random _random = Random();
  
  // Pre-cached simple particle paths for better performance
  static final Path _circlePath = Path()..addOval(Rect.fromLTWH(0, 0, 4, 4));
  static final Path _squarePath = Path()..addRect(Rect.fromLTWH(0, 0, 4, 4));
  
  // Simplified particle path - use cached paths instead of creating new ones
  Path _createParticlePath(Size size) {
    // Use simple cached paths - 50% circle, 50% square
    return _random.nextBool() ? _circlePath : _squarePath;
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
  }

  void _startFireworksBlasts() {
    if (!mounted || !widget.enabled || _hasStarted) return;
    _hasStarted = true;

    // Single burst sequence - no recursion for better performance
    _controllerCenter.play();

    // Staggered bursts for fireworks effect
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && widget.enabled) {
        _controllerTopLeft.play();
      }
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted && widget.enabled) {
        _controllerTopRight.play();
      }
    });
  }

  @override
  void didUpdateWidget(ConfettiAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _hasStarted = false;
      _startFireworksBlasts();
    } else if (!widget.enabled && oldWidget.enabled) {
      _controllerCenter.stop();
      _controllerTopLeft.stop();
      _controllerTopRight.stop();
      _hasStarted = false;
    }
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerTopLeft.dispose();
    _controllerTopRight.dispose();
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
        shouldLoop: false, // Single burst for better performance
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.yellow,
          Colors.red,
        ], // Reduced from 9 to 6 colors
        createParticlePath: _createParticlePath,
        minimumSize: const Size(3, 3),
        maximumSize: const Size(6, 6),
        emissionFrequency: 0.1, // Reduced from 0.05 (less frequent emissions)
        numberOfParticles: 25, // Reduced from 50 (half the particles)
        gravity: 0.15,
        maxBlastForce: 6 * blastForceMultiplier, // Reduced from 8
        minBlastForce: 2 * blastForceMultiplier, // Reduced from 3
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
                  blastForceMultiplier: 1.0,
                ),
                // Top left blast
                _buildConfettiWidget(
                  controller: _controllerTopLeft,
                  alignment: Alignment.topLeft,
                  blastForceMultiplier: 0.7,
                ),
                // Top right blast
                _buildConfettiWidget(
                  controller: _controllerTopRight,
                  alignment: Alignment.topRight,
                  blastForceMultiplier: 0.7,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

