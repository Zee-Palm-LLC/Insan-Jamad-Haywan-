import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/scoreboard_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/components/final_scoreboard_list.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/components/final_scoreboard_podium.dart';
import 'package:insan_jamd_hawan/core/modules/main_menu/main_menu_page.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class FinalRoundScoreboard extends StatelessWidget {
  const FinalRoundScoreboard({super.key});

  static const String path = '/final-round-scoreboard';
  static const String name = 'FinalRoundScoreboard';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final lobbyController = Get.find<LobbyController>();
    return GetBuilder<ScoreboardController>(
      init: ScoreboardController(),
      builder: (controller) {
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isDesktop) SizedBox(height: 50.h),
                      GameLogo(),
                      SizedBox(height: 12.h),
                      RoomCodeText(
                        lobbyId: lobbyController.lobby.id ?? 'N/A',
                        iSend: true,
                      ),
                      SizedBox(height: 40.h),
                      // Title
                      Text(
                        'Final Round\nScoreboard',
                        textAlign: TextAlign.center,
                        style: AppTypography.kBold24.copyWith(
                          color: AppColors.kRed500,
                          height: 1.2,
                          fontSize: 34.sp,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      if (controller.isLoading)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.h),
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        )
                      else if (controller.error != null)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.h),
                            child: Text(
                              'Error: ${controller.error}',
                              style: AppTypography.kRegular24,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else ...[
                        if (controller.podiumPlayers.isNotEmpty)
                          FinalScoreboardPodium(
                            players: controller.podiumPlayers,
                          ),
                        if (controller.listPlayers.isNotEmpty)
                          FinalScoreboardList(players: controller.listPlayers),
                      ],
                      SizedBox(height: 30.h),
                      PrimaryButton(
                        text: 'Back to Main Menu',
                        onPressed: () {
                          // Navigate back to main menu
                          context.pushReplacement(MainMenuPage.path);
                        },
                      ),
                      SizedBox(height: 20.h),
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
