import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/primary_button.dart';

class JoinLobbyDialog extends StatelessWidget {
  const JoinLobbyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.kGreen100,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter Lobby / Room Code to join the lobby',
              style: AppTypography.kBold21,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 14.h),
            TextField(
              style: AppTypography.kRegular19.copyWith(fontSize: 16.sp),
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: 'Enter Lobby Code'),
            ),
            SizedBox(height: 20.h),
            PrimaryButton(text: 'Join!', onPressed: () {}, width: 220.w),
          ],
        ),
      ),
    );
  }
}
