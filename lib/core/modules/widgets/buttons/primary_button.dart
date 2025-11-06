import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed; // Made nullable for disabled state
  final double? width;
  final Color? color;
  final bool animated;
  final Duration delay;
  final Duration duration;
  final Offset slideOffset;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.color,
    this.animated = true,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 600),
    this.slideOffset = const Offset(0, 0.3),
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _controller = AnimationController(
        vsync: this,
        duration: widget.duration,
      );

      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeIn,
        ),
      );

      _slideAnimation = Tween<Offset>(
        begin: widget.slideOffset,
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(PrimaryButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animated && !oldWidget.animated && !_hasStarted) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (!widget.animated || _hasStarted) return;
    _hasStarted = true;
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    if (widget.animated) {
      _controller.dispose();
    }
    super.dispose();
  }

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: widget.onPressed == null
          ? null // Disabled state
          : () {
              AudioService.instance.playAudio(AudioType.gameStarted);
              widget.onPressed!();
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.onPressed == null
            ? AppColors
                  .kGray300 // Disabled color
            : widget.color ?? AppColors.kPrimary,
        foregroundColor: widget.onPressed == null
            ? AppColors
                  .kGray600 // Disabled text color
            : AppColors.kWhite,
        fixedSize: Size(widget.width ?? double.maxFinite, 48.h),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        disabledBackgroundColor: AppColors.kGray300,
        disabledForegroundColor: AppColors.kGray600,
      ),
      child: Center(
        child: Text(
          widget.text,
          style: AppTypography.kBold24.copyWith(
            color: widget.onPressed == null ? AppColors.kGray600 : AppColors.kWhite,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animated) {
      return _buildButton();
    }

    // Start animation when enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.animated && !_hasStarted) {
        _startAnimation();
      }
    });

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildButton(),
      ),
    );
  }
}
