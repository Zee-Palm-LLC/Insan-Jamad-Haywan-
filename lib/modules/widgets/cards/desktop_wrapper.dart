import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class DesktopWrapper extends StatelessWidget {
  final Widget child;
  const DesktopWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? Container(
            margin: EdgeInsets.all(20.h),
            padding: EdgeInsets.all(24.h),
            constraints: BoxConstraints(maxWidth: 530.w),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .10),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
              border: Border.all(color: AppColors.kLightBorder, width: 7.w),
            ),
            child: child,
          )
        : child;
  }
}
