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
  const ScoringView({
    super.key,
    required this.selectedAlphabet,
    required this.sessionId,
    required this.roundNumber,
  });

  final String selectedAlphabet;
  final String sessionId;
  final int roundNumber;

  static const String path = '/scoring/:letter';
  static const String name = 'Scoring';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<ScoringController>(
      init: ScoringController(
        sessionId: sessionId,
        roundNumber: roundNumber,
        selectedLetter: selectedAlphabet,
      ),
      builder: (controller) {
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
                                style: AppTypography.kBold21.copyWith(
                                  height: 1,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              ...[
                                    'Name',
                                    'Object',
                                    'Animal',
                                    'Plant',
                                    'Country',
                                  ]
                                  .where(
                                    (category) =>
                                        controller.hasCategoryAnswers(category),
                                  )
                                  .map((category) {
                                    final answers = controller
                                        .getCategoryAnswers(category);
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category,
                                          style: AppTypography.kRegular24
                                              .copyWith(height: 1),
                                        ),
                                        SizedBox(height: 12.h),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.kWhite,
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(16.h),
                                          child: Column(
                                            children: [
                                              for (
                                                int i = 0;
                                                i < answers.length;
                                                i++
                                              ) ...[
                                                ScoringPlayingTile(
                                                  imagePath: controller
                                                      .getPlayerAvatar(
                                                        answers[i]['name']
                                                            as String,
                                                      ),
                                                  name:
                                                      answers[i]['name']
                                                          as String,
                                                  answer:
                                                      answers[i]['answer']
                                                          as String,
                                                  points:
                                                      answers[i]['points']
                                                          as int,
                                                  color:
                                                      answers[i]['color']
                                                          as Color,
                                                  index: i + 1,
                                                ),
                                                if (i != answers.length - 1)
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
                                      ],
                                    );
                                  })
                                  .toList(),
                            ],
                          ),
                        ),
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
