import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/join_lobby_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';

class JoinLobbyDialog extends StatelessWidget {
  const JoinLobbyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JoinLobbyController>(
      init: JoinLobbyController(),
      builder: (controller) {
        return AlertDialog(
          backgroundColor: AppColors.kGreen100,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
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
                  controller: controller.codeController,
                  enabled: !controller.isLoading,
                  style: AppTypography.kRegular19.copyWith(fontSize: 16.sp),
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(hintText: 'Enter Lobby Code'),
                  onSubmitted: (_) async {
                    await controller.joinLobby(context);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 20.h),
                PrimaryButton(
                  text: controller.isLoading ? 'Joining...' : 'Join!',
                  onPressed: controller.isLoading
                      ? () {}
                      : () async {
                          await controller.joinLobby(context);
                          if (context.mounted) Navigator.of(context).pop();
                        },
                  width: 220.w,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
