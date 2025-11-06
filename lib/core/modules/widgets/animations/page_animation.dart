import 'package:flutter/material.dart';

/// Gaming-style page element animation with fade and scale
class PageAnimation extends StatefulWidget {
  const PageAnimation({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
    this.startScale = 0.8,
    this.startOpacity = 0.0,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double startScale;
  final double startOpacity;

  @override
  State<PageAnimation> createState() => _PageAnimationState();
}

class _PageAnimationState extends State<PageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(
      begin: widget.startOpacity,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: widget.startScale,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}

