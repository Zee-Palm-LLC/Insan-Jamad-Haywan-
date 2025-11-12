import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/ambiguous_answer_voting_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/scoreboard_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class VotingView extends StatelessWidget {
  const VotingView({
    super.key,
    required this.selectedAlphabet,
    required this.sessionId,
    required this.roundNumber,
  });

  final String selectedAlphabet;
  final String sessionId;
  final int roundNumber;

  static const String path = '/voting/:letter';
  static const String name = 'Voting';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return GetBuilder<AmbiguousAnswerVotingController>(
      init: AmbiguousAnswerVotingController(
        sessionId: sessionId,
        roundNumber: roundNumber,
        selectedLetter: selectedAlphabet,
      ),
      builder: (controller) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            // appBar: isDesktop
            //     ? null
            //     : AppBar(
            //         automaticallyImplyLeading: false,
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
                        RoomCodeText(lobbyId: 'XY21234'),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Letter', style: AppTypography.kRegular24),
                            SizedBox(width: 8.w),
                            InkWell(
                              onTap: () {
                                context.push(ScoreboardView.path);
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
                        SizedBox(height: 24.h),
                        if (controller.ambiguousAnswers.isEmpty)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.kGreen100,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.all(16.h),
                            child: Text(
                              'No ambiguous answers to vote on',
                              style: AppTypography.kBold24.copyWith(
                                fontSize: 20.sp,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else ...[
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.kGreen100,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.all(16.h),
                            child: Column(
                              children: [
                                Text(
                                  'Time Remaining: ${controller.timeRemaining}s',
                                  style: AppTypography.kBold24.copyWith(
                                    fontSize: 24.sp,
                                    color: controller.timeRemaining <= 3
                                        ? AppColors.kRed500
                                        : AppColors.kPrimary,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'One of you entered something creative or wrong...',
                                  style: AppTypography.kBold24.copyWith(
                                    fontSize: 20.sp,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ...controller.ambiguousAnswers.map((ambiguousAnswer) {
                            final playerVote = controller.getPlayerVote(
                              ambiguousAnswer.id,
                            );
                            return Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.all(16.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${ambiguousAnswer.playerName} entered "${ambiguousAnswer.answer}"',
                                    style: AppTypography.kBold21.copyWith(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Category: ${ambiguousAnswer.category}',
                                    style: AppTypography.kRegular19.copyWith(
                                      fontSize: 14.sp,
                                      color: AppColors.kGray500,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  if (playerVote == null &&
                                      controller.isVotingActive)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: PrimaryButton(
                                            text: 'Correct',
                                            onPressed: () {
                                              controller.submitVote(
                                                ambiguousAnswer.id,
                                                true,
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: PrimaryButton(
                                            text: 'Incorrect',
                                            onPressed: () {
                                              controller.submitVote(
                                                ambiguousAnswer.id,
                                                false,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  else if (playerVote != null)
                                    Container(
                                      padding: EdgeInsets.all(12.h),
                                      decoration: BoxDecoration(
                                        color: playerVote
                                            ? AppColors.kGreen100
                                            : AppColors.kRed500.withOpacity(
                                                0.2,
                                              ),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            playerVote
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color: playerVote
                                                ? AppColors.kPrimary
                                                : AppColors.kRed500,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'You voted: ${playerVote ? "Correct" : "Incorrect"}',
                                            style: AppTypography.kBold21,
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    Text(
                                      'Voting ended',
                                      style: AppTypography.kRegular19,
                                    ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '✓ ${ambiguousAnswer.correctVotes}',
                                        style: AppTypography.kRegular19
                                            .copyWith(
                                              color: AppColors.kPrimary,
                                            ),
                                      ),
                                      Text(
                                        '✗ ${ambiguousAnswer.incorrectVotes}',
                                        style: AppTypography.kRegular19
                                            .copyWith(color: AppColors.kRed500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                        if (isDesktop) SizedBox(height: 50.h),
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
