import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/controllers/answers_host_controller.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/scoring_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class AnswersHostView extends StatelessWidget {
  const AnswersHostView({
    super.key,
    required this.selectedAlphabet,
    required this.sessionId,
    required this.roundNumber,
    this.totalSeconds = 60,
  });

  final String selectedAlphabet;
  final String sessionId;
  final int roundNumber;
  final int totalSeconds;

  static const String path = '/answers-host/:letter';
  static const String name = 'AnswersHost';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<AnswersHostController>(
      init: AnswersHostController(
        sessionId: sessionId,
        roundNumber: roundNumber,
        selectedLetter: selectedAlphabet,
        totalSeconds: totalSeconds,
      ),
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
                      RoomCodeText(lobbyId: sessionId),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                  controller.formattedTime,
                                  style: AppTypography.kRegular19.copyWith(
                                    color: AppColors.kRed500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // Timer Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: controller.timerProgress,
                          backgroundColor: AppColors.kGray300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            controller.timerColor,
                          ),
                          minHeight: 8.h,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      InkWell(
                        onTap: () {
                          context.push(
                            ScoringView.path.replaceAll(
                              ':letter',
                              selectedAlphabet,
                            ),
                          );
                        },
                        child: Container(
                          width: 200.h,
                          height: 200.h,
                          decoration: BoxDecoration(
                            color: AppColors.kPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              selectedAlphabet,
                              style: AppTypography.kBold24.copyWith(
                                color: AppColors.kWhite,
                                fontSize: 80.sp,
                              ),
                            ),
                          ),
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
}
