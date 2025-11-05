import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/player_wheel_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/letter_generator/components/fortune_wheel.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class PlayerWheelView extends StatelessWidget {
  const PlayerWheelView({super.key, required this.controller});

  final LobbyController controller;

  static const String path = '/player-wheel';
  static const String name = 'PlayerWheel';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<PlayerWheelController>(
      init: PlayerWheelController(lobbyController: controller),
      builder: (wheelController) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: LobbyBg(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.h),
              child: Center(
                child: DesktopWrapper(
                  child: Column(
                    children: [
                      if (!isDesktop) SizedBox(height: 50.h),
                      GameLogo(),
                      SizedBox(height: 12.h),
                      GetBuilder<LobbyController>(
                        init: controller,
                        builder: (lobbyController) {
                          return RoomCodeText(
                            iSend: false,
                            lobbyId:
                                lobbyController.currentRoom.inviteCode ??
                                'XYZ124',
                          );
                        },
                      ),
                      SizedBox(height: 50.h),
                      // Display "Waiting for host to spin the wheel" or the wheel
                      GetBuilder<LobbyController>(
                        init: controller,
                        builder: (lobbyController) {
                          if (!lobbyController.isWheelSpinning &&
                              lobbyController.currentLetter == null) {
                            return Container(
                              padding: EdgeInsets.all(24.h),
                              decoration: BoxDecoration(
                                color: AppColors.kLightYellow,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.kPrimary,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.hourglass_empty,
                                    size: 48.sp,
                                    color: AppColors.kPrimary,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Waiting for host to spin the wheel...',
                                    textAlign: TextAlign.center,
                                    style: AppTypography.kBold16.copyWith(
                                      color: AppColors.kGray600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return FortuneWheelPage(
                            isHost: false,
                            onSpinComplete: wheelController.handleSpinComplete,
                            onCountdownComplete:
                                wheelController.handleCountdownComplete,
                          );
                        },
                      ),
                      SizedBox(height: 30.h),
                      // Show selected letter if available
                      if (controller.currentLetter != null) ...[
                        Container(
                          padding: EdgeInsets.all(16.h),
                          decoration: BoxDecoration(
                            color: AppColors.kGreen100,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.kPrimary,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Selected Letter',
                                style: AppTypography.kBold16.copyWith(
                                  color: AppColors.kGray600,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                controller.currentLetter!,
                                style: AppTypography.kBold24.copyWith(
                                  fontSize: 48.sp,
                                  color: AppColors.kPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (isDesktop) SizedBox(height: 50.h),
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
