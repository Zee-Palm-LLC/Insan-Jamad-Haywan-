import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/scoreboard_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/manager/game_controller_mananger.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/components/final_scoreboard_list.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/components/final_scoreboard_podium.dart';
import 'package:insan_jamd_hawan/core/modules/main_menu/main_menu_page.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class FinalRoundScoreboard extends StatefulWidget {
  const FinalRoundScoreboard({super.key});

  static const String path = '/final-round-scoreboard';
  static const String name = 'FinalRoundScoreboard';

  @override
  State<FinalRoundScoreboard> createState() => _FinalRoundScoreboardState();
}

class _FinalRoundScoreboardState extends State<FinalRoundScoreboard> {
  @override
  void initState() {
    super.initState();
    // Initialize controller once and ensure it persists
    if (Get.isRegistered<ScoreboardController>()) {
      Get.delete<ScoreboardController>();
    }
    Get.put(ScoreboardController(), permanent: false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final lobbyController = Get.find<LobbyController>();
    return GetBuilder<ScoreboardController>(
      builder: (builderController) {
        // Debug: Log when builder is called
        debugPrint(
          'FinalRoundScoreboard builder called: isLoading=${builderController.isLoading}, podiumPlayers=${builderController.podiumPlayers.length}, listPlayers=${builderController.listPlayers.length}',
        );
        debugPrint(
          'Podium players details: ${builderController.podiumPlayers.map((p) => '${p.name} (rank ${p.rank})').join(', ')}',
        );
        return WillPopScope(
          onWillPop: () async {
            context.pop();
            return false;
          },
          child: Scaffold(
            extendBodyBehindAppBar: true,
            // appBar: isDesktop
            //     ? null
            //     : AppBar(
            //         leading: Padding(
            //           padding: EdgeInsets.all(10.h),
            //           child: CustomIconButton(
            //             icon: AppAssets.backIcon,
            //             onTap: () => context.pop(),
            //           ),
            //         ),
            //         actions: [
            //           CustomIconButton(icon: AppAssets.shareIcon, onTap: () {}),
            //           SizedBox(width: 16.w),
            //         ],
            //       ),
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
                        if (builderController.isLoading)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.h),
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          )
                        else if (builderController.error != null)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.h),
                              child: Text(
                                'Error: ${builderController.error}',
                                style: AppTypography.kRegular24,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        else ...[
                          if (builderController.podiumPlayers.isEmpty &&
                              builderController.listPlayers.isEmpty)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.h),
                                child: Text(
                                  'No players found',
                                  style: AppTypography.kRegular24,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else ...[
                            if (builderController.podiumPlayers.isNotEmpty)
                              FinalScoreboardPodium(
                                players: builderController.podiumPlayers,
                              ),
                            if (builderController.listPlayers.isNotEmpty)
                              FinalScoreboardList(
                                players: builderController.listPlayers,
                              ),
                          ],
                        ],
                        SizedBox(height: 30.h),
                        PrimaryButton(
                          text: 'Back to Main Menu',
                          onPressed: () async {
                            await lobbyController.deleteRoom(shouldPop: false);
                            GameControllerManager.restAllControllers();
                            if (mounted) {
                              context.go(MainMenuPage.path);
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
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
