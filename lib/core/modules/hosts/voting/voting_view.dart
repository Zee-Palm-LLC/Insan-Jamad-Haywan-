import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/voting_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/scoring_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class VotingView extends StatefulWidget {
  const VotingView({
    super.key,
    required this.selectedAlphabet,
    this.playerName,
    this.playerAnswer,
  });

  final String selectedAlphabet;
  final String? playerName;
  final String? playerAnswer;

  static const String path = '/voting/:letter';
  static const String name = 'Voting';

  @override
  State<VotingView> createState() => _VotingViewState();
}

class _VotingViewState extends State<VotingView> {
  LobbyController get lobbyController => Get.find<LobbyController>();
  WheelController get wheelController => Get.find<WheelController>();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<VotingController>()) {
      Get.put(VotingController());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<VotingController>(
      builder: (controller) {
        final unclearAnswers = controller.getUnclearAnswers();

        if (controller.votingCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.pushReplacementNamed(
                ScoringView.name,
                pathParameters: {'letter': widget.selectedAlphabet},
                extra: {'selectedAlphabet': widget.selectedAlphabet},
              );
            }
          });
          return Center(child: CircularProgressIndicator.adaptive());
        }

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
                      RoomCodeText(lobbyId: lobbyController.lobby.id ?? "N/A"),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Letter', style: AppTypography.kRegular24),
                          SizedBox(width: 8.w),
                          Container(
                            height: 50.h,
                            width: 74.w,
                            decoration: BoxDecoration(
                              color: AppColors.kPrimary,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.only(top: 6.h),
                            child: Text(
                              widget.selectedAlphabet,
                              style: AppTypography.kRegular41.copyWith(
                                color: AppColors.kWhite,
                                height: 1,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.kLightYellow,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: AppColors.kGray600),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(AppAssets.timerIcon),
                                SizedBox(width: 8.w),
                                Text(
                                  '${controller.timeRemaining}s',
                                  style: AppTypography.kRegular19.copyWith(
                                    color: AppColors.kRed500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      if (unclearAnswers.isEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.kGreen100,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.all(16.h),
                          child: Text(
                            'No unclear answers to vote on',
                            style: AppTypography.kBold24.copyWith(
                              fontSize: 20.sp,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      else
                        ...unclearAnswers.map(
                          (item) => _buildVotingCard(
                            controller: controller,
                            answerPlayerId: item['answerPlayerId'] as String,
                            answerPlayerName:
                                item['answerPlayerName'] as String,
                            category: item['category'] as String,
                            answer: item['answer'] as String,
                          ),
                        ),
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

  Widget _buildVotingCard({
    required VotingController controller,
    required String answerPlayerId,
    required String answerPlayerName,
    required String category,
    required String answer,
  }) {
    final currentVote = controller.getPlayerVote(answerPlayerId, category);
    final isClearVoted = currentVote == true;
    final isUnclearVoted = currentVote == false;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.kGreen100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$answerPlayerName entered "$answer" ($category)',
            style: AppTypography.kBold24.copyWith(fontSize: 18.sp, height: 1.2),
          ),
          SizedBox(height: 12.h),
          Text(
            'Is this answer clear?',
            style: AppTypography.kRegular19.copyWith(fontSize: 16.sp),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Clear (10 pts)',
                  onPressed: controller.votingCompleted
                      ? null
                      : () {
                          controller.submitVote(
                            answerPlayerId: answerPlayerId,
                            category: category,
                            isClear: true,
                          );
                        },
                  color: isClearVoted ? AppColors.kPrimary : AppColors.kGray300,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: PrimaryButton(
                  text: 'Unclear (0 pts)',
                  onPressed: controller.votingCompleted
                      ? null
                      : () {
                          controller.submitVote(
                            answerPlayerId: answerPlayerId,
                            category: category,
                            isClear: false,
                          );
                        },
                  color: isUnclearVoted
                      ? AppColors.kRed500
                      : AppColors.kGray300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
