import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/modules/widgets/custom_paint/handdrawn_border.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class DesktopWrapper extends StatelessWidget {
  final Widget child;
  const DesktopWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(24.h),
            constraints: BoxConstraints(maxWidth: 530.w),
            decoration: ShapeDecoration(
              color: AppColors.kWhite,
              shape: HandStyleBorder(
                side: BorderSide(color: AppColors.kLightBorder, width: 8.w),
                borderRadius: BorderRadius.circular(20.r),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .10),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: child,
          )
        : child;
  }
}
