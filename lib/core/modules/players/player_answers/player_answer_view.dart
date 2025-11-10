import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/answer_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/scoreboard_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/scoring_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/custom_paint/handdrawn_border.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class PlayerAnswerView extends StatelessWidget {
  const PlayerAnswerView({super.key, required this.selectedLetter});

  final String selectedLetter;

  static const String path = '/player-answer';
  static const String name = 'PlayerAnswer';
  WheelController get wheelController => Get.find<WheelController>();
  LobbyController get lobbyController => Get.find<LobbyController>();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<AnswerController>(
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
                      RoomCodeText(lobbyId: 'XY21234', iSend: true),
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
                              'A',
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
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              controller.toggleDoublePoints();
                            },
                            child: Container(
                              height: 22.h,
                              width: 22.h,
                              decoration: ShapeDecoration(
                                color: AppColors.kWhite.withOpacity(0.9),
                                shape: HandStyleBorder(
                                  side: BorderSide(
                                    color: AppColors.kBlack,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(2.r),
                                  roughness: 0.5,
                                ),
                              ),
                              child: controller.doublePoints
                                  ? SvgPicture.asset(AppAssets.done)
                                  : null,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Double my points for this round',
                            style: AppTypography.kRegular19.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Answer Input Fields
                      _buildAnswerField(
                        label: 'Name',
                        controller: controller.nameController,
                      ),
                      SizedBox(height: 12.h),
                      _buildAnswerField(
                        label: 'Object',
                        controller: controller.objectController,
                      ),
                      SizedBox(height: 12.h),
                      _buildAnswerField(
                        label: 'Animal',
                        controller: controller.animalController,
                      ),
                      SizedBox(height: 12.h),
                      _buildAnswerField(
                        label: 'Plant',
                        controller: controller.plantController,
                      ),
                      SizedBox(height: 12.h),
                      _buildAnswerField(
                        label: 'Country',
                        controller: controller.countryController,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              onPressed: () => context.pop(),
                              text: 'Stop !',
                              color: AppColors.kRed500,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: PrimaryButton(
                              text: 'Next',
                              width: double.infinity,
                              onPressed: () {
                                controller.submitAnswers(onSuccess: () {});
                              },
                            ),
                          ),
                        ],
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

  Widget _buildAnswerField({
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: ShapeDecoration(
        color: AppColors.kWhite.withOpacity(0.9),
        shape: HandStyleBorder(
          side: BorderSide(color: AppColors.kBlack, width: 1.5),
          borderRadius: BorderRadius.circular(2.r),
          roughness: 0.5,
        ),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: label,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
        style: AppTypography.kRegular19.copyWith(fontSize: 16.sp),
      ),
    );
  }
}

class LoaderHandlerService {
  void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void hideLoader() {
    if (navigator?.canPop() == true) {
      navigator?.pop();
    }
    final context = navigator?.context;
    if (context != null &&
        ScaffoldMessenger.maybeOf(context)?.mounted == true) {
      ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
    }
  }
}
