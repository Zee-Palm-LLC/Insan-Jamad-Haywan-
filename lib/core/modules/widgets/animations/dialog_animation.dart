import 'package:flutter/material.dart';

/// Dialog animation widget with gaming-style elastic bounce effect
class DialogAnimation extends StatefulWidget {
  const DialogAnimation({
    super.key,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 400),
  });

  final Widget child;
  final Duration animationDuration;

  @override
  State<DialogAnimation> createState() => _DialogAnimationState();

  /// Helper method to show an animated dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget dialog,
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
    Duration animationDuration = const Duration(milliseconds: 400),
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => DialogAnimation(
        animationDuration: animationDuration,
        child: dialog,
      ),
    );
  }
}

class _DialogAnimationState extends State<DialogAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Scale animation with elastic bounce effect for gaming feel
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut, // Gaming-style elastic bounce
      ),
    );

    // Fade animation for smooth appearance
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start animation immediately
    _controller.forward();
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

