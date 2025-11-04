import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';

class PlayerTile extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const PlayerTile({super.key, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AudioService.instance.playAudio(AudioType.click);
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(6.h),
        decoration: BoxDecoration(
          color: AppColors.kGray300,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Container(
              height: 54.h,
              width: 54.h,
              decoration: BoxDecoration(
                color: AppColors.kGray300,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.kGray500),
              ),
              padding: EdgeInsets.all(2.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Image.network(
                  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                name,
                style: AppTypography.kBold24.copyWith(color: AppColors.kRed500),
              ),
            ),
            Text('Player', style: AppTypography.kRegular19),
            SizedBox(width: 5.w),
          ],
        ),
      ),
    );
  }
}
