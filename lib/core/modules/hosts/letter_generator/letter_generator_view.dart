import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/letter_generator_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
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
  const LetterGeneratorView({super.key, this.controller});

  final LobbyController? controller;

  static const String path = '/letter-generator';
  static const String name = 'LetterGenerator';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<LetterGeneratorController>(
      init: LetterGeneratorController(lobbyController: controller),
      builder: (letterController) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: isDesktop
              ? null
              : AppBar(
                  leading: Padding(
                    padding: EdgeInsets.all(10.h),
                    child: CustomIconButton(
                      icon: AppAssets.backIcon,
                      onTap: () => context.pop(),
                    ),
                  ),
                  actions: [
                    CustomIconButton(icon: AppAssets.shareIcon, onTap: () {}),
                    SizedBox(width: 16.w),
                  ],
                ),
          body: AnimatedBg(
            showHorizontalLines: true,
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
                      if (letterController.selectedLetter != null) ...[
                        SizedBox(height: 50.h),
                        PrimaryButton(
                          text: 'Continue..',
                          onPressed: () {
                            context.push(AnswersHostView.path);
                          },
                          width: 250.w,
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
