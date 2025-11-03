import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/services/audio_service.dart';

class TimeSelectorCard extends StatelessWidget {
  final VoidCallback onTap;
  final String time;
  final bool isSelected;
  const TimeSelectorCard({
    super.key,
    required this.onTap,
    required this.time,
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
        width: 84.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimary.withValues(alpha: 0.5)
              : AppColors.kLightYellow,
          border: Border.all(color: AppColors.kGray600, width: 1),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          '$time sec',
          style: AppTypography.kBold16.copyWith(
            color: isSelected ? AppColors.kWhite : null,
          ),
        ),
      ),
    );
  }
}
