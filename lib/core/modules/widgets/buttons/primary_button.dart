import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Made nullable for disabled state
  final double? width;
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed == null
          ? null // Disabled state
          : () {
              AudioService.instance.playAudio(AudioType.gameStarted);
              onPressed!();
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed == null
            ? AppColors
                  .kGray300 // Disabled color
            : AppColors.kPrimary,
        foregroundColor: onPressed == null
            ? AppColors
                  .kGray600 // Disabled text color
            : AppColors.kWhite,
        fixedSize: Size(width ?? double.maxFinite, 48.h),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        disabledBackgroundColor: AppColors.kGray300,
        disabledForegroundColor: AppColors.kGray600,
      ),
      child: Center(
        child: Text(
          text,
          style: AppTypography.kBold24.copyWith(
            color: onPressed == null ? AppColors.kGray600 : AppColors.kWhite,
          ),
        ),
      ),
    );
  }
}
