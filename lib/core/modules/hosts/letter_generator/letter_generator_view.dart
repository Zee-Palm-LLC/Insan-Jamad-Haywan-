import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/letter_generator_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/fortune_wheel_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/answers_host/answers_host_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/letter_generator/components/fortune_wheel.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class LetterGeneratorView extends StatelessWidget {
  const LetterGeneratorView({super.key});

  static const String path = '/letter-generator';
  static const String name = 'LetterGenerator';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<LetterGeneratorController>(
      init: LetterGeneratorController(),
      builder: (letterController) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: isDesktop
                ? null
                : AppBar(
                    automaticallyImplyLeading: false,
                    actions: [
                      CustomIconButton(icon: AppAssets.shareIcon, onTap: () {}),
                      SizedBox(width: 16.w),
                    ],
                  ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.h),
              child: Center(
                child: DesktopWrapper(
                  child: Column(
                    children: [
                      if (!isDesktop) SizedBox(height: 50.h),
                      GameLogo(),
                      SizedBox(height: 12.h),
                      GetBuilder<LobbyController>(
                        builder: (lobbyController) {
                          return RoomCodeText(
                            iSend: true,
                            lobbyId:
                                lobbyController.currentRoom.inviteCode ??
                                'XYZ124',
                          );
                        },
                      ),
                      SizedBox(height: 50.h),
                      FortuneWheelPage(
                        isHost: true,
                        onSpinComplete: letterController.handleSpinComplete,
                        onCountdownComplete:
                            letterController.handleCountdownComplete,
                      ),
                      if (letterController.selectedLetter != null &&
                          !letterController.countdownStarted) ...[
                        SizedBox(height: 30.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Spin Again button
                            InkWell(
                              onTap: () {
                                // Reset and allow spinning again
                                final wheelController =
                                    Get.find<FortuneWheelController>();
                                wheelController.selectedAlphabet = null;
                                wheelController.selectedIndex = 0;
                                wheelController.update();
                                letterController.selectedLetter = null;
                                letterController.update();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.kGray300,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'Spin Again',
                                  style: AppTypography.kBold21.copyWith(
                                    color: AppColors.kGray600,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            // Continue button
                            InkWell(
                              onTap: letterController.startCountdown,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32.w,
                                  vertical: 14.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimary,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'Continue',
                                  style: AppTypography.kBold24.copyWith(
                                    color: AppColors.kWhite,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
