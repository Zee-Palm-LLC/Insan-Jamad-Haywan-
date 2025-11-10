import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/core/data/constants/app_colors.dart';
import 'package:insan_jamd_hawan/core/data/constants/app_typography.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/animations/dialog_animation.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({
    super.key,
    required this.message,
    this.showProgressIndicator = true,
  });

  final String message;
  final bool showProgressIndicator;

  static Future<T?> show<T>({
    required BuildContext context,
    required String message,
    bool barrierDismissible = false,
    bool showProgressIndicator = true,
  }) {
    return DialogAnimation.show<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      dialog: ProgressDialog(
        message: message,
        showProgressIndicator: showProgressIndicator,
      ),
    );
  }

  /// Static method to hide the progress dialog
  static void hide(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            color: AppColors.kGreen100,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.kBlack, width: 1.5.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showProgressIndicator) ...[
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.kPrimary),
                  strokeWidth: 3.w,
                ),
                SizedBox(height: 24.h),
              ],
              Text(
                message,
                style: AppTypography.kRegular19.copyWith(
                  color: AppColors.kBlack,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
