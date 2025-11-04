import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/components/scoring_playing_tile.dart';
import 'package:insan_jamd_hawan/core/controllers/scoring_controller.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/voting/voting_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class ScoringView extends StatelessWidget {
  const ScoringView({super.key, required this.selectedAlphabet});

  final String selectedAlphabet;

  static const String path = '/scoring/:letter';
  static const String name = 'Scoring';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<ScoringController>(
      init: ScoringController(),
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
                      RoomCodeText(lobbyId: 'XY21234'),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Letter', style: AppTypography.kRegular24),
                          SizedBox(width: 8.w),
                          InkWell(
                            onTap: () {
                              context.push(VotingView.path);
                            },
                            child: Container(
                              height: 50.h,
                              width: 74.w,
                              decoration: BoxDecoration(
                                color: AppColors.kPrimary,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(top: 6.h),
                              child: Text(
                                selectedAlphabet,
                                style: AppTypography.kRegular41.copyWith(
                                  color: AppColors.kWhite,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.kGreen100,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.all(16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Answers',
                              style: AppTypography.kBold21.copyWith(height: 1),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Fruit',
                              style: AppTypography.kRegular24.copyWith(
                                height: 1,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.all(16.h),
                              child: Column(
                                children: [
                                  for (
                                    int i = 0;
                                    i < controller.shownFruitAnswers.length;
                                    i++
                                  ) ...[
                                    ScoringPlayingTile(
                                      imagePath: controller.getPlayerAvatar(
                                        controller.shownFruitAnswers[i]['name']
                                            as String,
                                      ),
                                      name:
                                          controller
                                                  .shownFruitAnswers[i]['name']
                                              as String,
                                      answer:
                                          controller
                                                  .shownFruitAnswers[i]['answer']
                                              as String,
                                      points:
                                          controller
                                                  .shownFruitAnswers[i]['points']
                                              as int,
                                      color:
                                          controller
                                                  .shownFruitAnswers[i]['color']
                                              as Color,
                                      index: i + 1,
                                    ),
                                    if (i !=
                                        controller.shownFruitAnswers.length - 1)
                                      Divider(
                                        color: AppColors.kGray300,
                                        thickness: 1,
                                        height: 16.h,
                                      ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text('Animals', style: AppTypography.kRegular24),
                            SizedBox(height: 12.h),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.all(16.h),
                              child: Column(
                                children: [
                                  for (
                                    int i = 0;
                                    i < controller.shownAnimalAnswers.length;
                                    i++
                                  ) ...[
                                    ScoringPlayingTile(
                                      imagePath: controller.getPlayerAvatar(
                                        controller.shownAnimalAnswers[i]['name']
                                            as String,
                                      ),
                                      name:
                                          controller
                                                  .shownAnimalAnswers[i]['name']
                                              as String,
                                      answer:
                                          controller
                                                  .shownAnimalAnswers[i]['answer']
                                              as String,
                                      points:
                                          controller
                                                  .shownAnimalAnswers[i]['points']
                                              as int,
                                      color:
                                          controller
                                                  .shownAnimalAnswers[i]['color']
                                              as Color,
                                      index: i + 1,
                                    ),
                                    if (i !=
                                        controller.shownAnimalAnswers.length -
                                            1)
                                      Divider(
                                        color: AppColors.kGray300,
                                        thickness: 1,
                                        height: 16.h,
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
