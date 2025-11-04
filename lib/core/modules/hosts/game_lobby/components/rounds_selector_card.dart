import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';

class RoundSelectorCard extends StatelessWidget {
  final VoidCallback onTap;
  final String round;
  final bool isSelected;
  const RoundSelectorCard({
    super.key,
    required this.onTap,
    required this.round,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AudioService.instance.playAudio(AudioType.click);
        onTap();
      },
      child: Container(
        height: 36.h,
        width: 36.h,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimary.withValues(alpha: 0.5)
              : AppColors.kLightYellow,
          border: Border.all(color: AppColors.kGray600, width: 1),
          borderRadius: BorderRadius.circular(4.r),
        ),
        alignment: Alignment.center,
        child: Text(
          round,
          style: AppTypography.kBold16.copyWith(
            color: isSelected ? AppColors.kWhite : null,
          ),
        ),
      ),
    );
  }
}
