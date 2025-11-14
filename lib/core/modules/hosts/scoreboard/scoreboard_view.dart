import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/components/first_position_podium.dart';
import 'package:insan_jamd_hawan/core/controllers/scoreboard_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/letter_generator/letter_generator_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/final_round/final_round_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class ScoreboardView extends StatelessWidget {
  const ScoreboardView({super.key});

  static const String path = '/scoreboard';
  static const String name = 'Scoreboard';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<ScoreboardController>(
      init: ScoreboardController(),
      builder: (controller) {
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
                        RoomCodeText(
                          lobbyId: controller.lobbyController.lobby.id ?? 'N/A',
                        ),
                        SizedBox(height: 20.h),
                        // Scoreboard title
                        Text(
                          'Scoreboard',
                          style: AppTypography.kBold24.copyWith(
                            color: AppColors.kRed500,
                            fontSize: 48.sp,
                            height: 1,
                          ),
                        ),
                        SizedBox(height: 24.h),
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
                        else if (controller.shownPlayers.isEmpty)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.h),
                              child: Text(
                                'No players found',
                                style: AppTypography.kRegular24,
                              ),
                            ),
                          )
                        else ...[
                          // First place
                          if (controller.shownPlayers.isNotEmpty)
                            PositionPodium(
                              position: controller.getPositionText(1),
                              badge: AppAssets.firstBadge,
                              image:
                                  controller.shownPlayers[0]['avatarUrl']
                                      as String,
                              name:
                                  controller.shownPlayers[0]['name'] as String,
                              points:
                                  '+${controller.shownPlayers[0]['pointsGained']}',
                              totalPoints:
                                  '${controller.shownPlayers[0]['totalPoints']}',
                            ),
                          // Second and third place container
                          if (controller.shownPlayers.length > 1)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 13.w,
                                vertical: 20.h,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 14.w),
                              decoration: BoxDecoration(
                                color: AppColors.kGreen100,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(12.r),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // 2nd and 3rd place
                                  if (controller.shownPlayers.length >= 2)
                                    Container(
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                        color: AppColors.kWhite,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(10.h),
                                      child: Column(
                                        children: [
                                          if (controller.shownPlayers.length >=
                                              2)
                                            PositionPodium(
                                              isFirst: false,
                                              position: controller
                                                  .getPositionText(2),
                                              badge: AppAssets.secondBadge,
                                              image:
                                                  controller
                                                          .shownPlayers[1]['avatarUrl']
                                                      as String,
                                              name:
                                                  controller
                                                          .shownPlayers[1]['name']
                                                      as String,
                                              points:
                                                  '+${controller.shownPlayers[1]['pointsGained']}',
                                              totalPoints:
                                                  '${controller.shownPlayers[1]['totalPoints']}',
                                            ),
                                          if (controller.shownPlayers.length >=
                                              3) ...[
                                            Divider(
                                              color: AppColors.kGray300,
                                              thickness: 1,
                                              height: 16.h,
                                            ),
                                            PositionPodium(
                                              isFirst: false,
                                              position: controller
                                                  .getPositionText(3),
                                              badge: AppAssets.thirdBadge,
                                              image:
                                                  controller
                                                          .shownPlayers[2]['avatarUrl']
                                                      as String,
                                              name:
                                                  controller
                                                          .shownPlayers[2]['name']
                                                      as String,
                                              points:
                                                  '+${controller.shownPlayers[2]['pointsGained']}',
                                              totalPoints:
                                                  '${controller.shownPlayers[2]['totalPoints']}',
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  // 4th place and below
                                  if (controller.shownPlayers.length > 3) ...[
                                    SizedBox(height: 15.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                      ),
                                      child: Column(
                                        children: [
                                          ...List.generate(
                                            controller.shownPlayers.length - 3,
                                            (idx) {
                                              final playerIndex = idx + 3;
                                              final player = controller
                                                  .shownPlayers[playerIndex];
                                              return Column(
                                                children: [
                                                  PositionPodium(
                                                    isFirst: false,
                                                    position: controller
                                                        .getPositionText(
                                                          playerIndex + 1,
                                                        ),
                                                    image:
                                                        player['avatarUrl']
                                                            as String,
                                                    name:
                                                        player['name']
                                                            as String,
                                                    points:
                                                        '+${player['pointsGained']}',
                                                    totalPoints:
                                                        '${player['totalPoints']}',
                                                  ),
                                                  if (idx !=
                                                      controller
                                                              .shownPlayers
                                                              .length -
                                                          4)
                                                    Divider(
                                                      color: AppColors.kGray300,
                                                      thickness: 1,
                                                      height: 16.h,
                                                    ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                        ],
                        SizedBox(height: 30.h),
                        StartNextRoundButton(),
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

class StartNextRoundButton extends StatelessWidget {
  const StartNextRoundButton({super.key});

  LobbyController get controller => Get.find<LobbyController>();
  WheelController get wheelController => Get.find<WheelController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppService.getPlayerId(),
      builder: (context, snap) {
        if (snap.hasData == false) {
          return const SizedBox.shrink();
        }
        bool isHost = snap.data == controller.lobby.host;
        if (isHost) {
          final bool canStartNextRound =
              wheelController.currentRound <
              wheelController.maxRoundSelectedByTheHost;
          final bool isAboutToStartFinalRound =
              wheelController.currentRound + 1 ==
              wheelController.maxRoundSelectedByTheHost;

          if (!canStartNextRound) {
            return const SizedBox.shrink();
          }

          return PrimaryButton(
            text: isAboutToStartFinalRound
                ? 'Start Final Round'
                : 'Start Next Round',
            onPressed: () {
              if (isAboutToStartFinalRound) {
                wheelController.startNextRound();
                context.go(FinalRoundView.path);
              } else {
                wheelController.startNextRound();
                context.go(LetterGeneratorView.path);
              }
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
