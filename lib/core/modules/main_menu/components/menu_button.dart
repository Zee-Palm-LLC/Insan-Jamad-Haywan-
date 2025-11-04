import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';

class MenuButton extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  final String name;
  const MenuButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await AudioService.instance.playAudio(AudioType.click);
        onTap();
      },
      child: Container(
        height: 140.h,
        decoration: BoxDecoration(
          color: AppColors.kLightYellow,
          border: Border.all(color: AppColors.kGray600, width: 1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon),
            SizedBox(height: 5.h),
            Text(name, style: AppTypography.kBold16.copyWith(fontSize: 20.sp)),
          ],
        ),
      ),
    );
  }
}
