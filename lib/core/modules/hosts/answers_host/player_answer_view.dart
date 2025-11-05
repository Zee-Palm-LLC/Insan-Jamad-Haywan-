import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/player_answer_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/custom_paint/handdrawn_border.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class PlayerAnswerView extends StatelessWidget {
  const PlayerAnswerView({
    super.key,
    required this.selectedLetter,
    required this.sessionId,
    required this.roundNumber,
    required this.totalSeconds,
  });

  final String selectedLetter;
  final String sessionId;
  final int roundNumber;
  final int totalSeconds;

  static const String path = '/player-answer';
  static const String name = 'PlayerAnswer';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<PlayerAnswerController>(
      init: PlayerAnswerController(
        sessionId: sessionId,
        roundNumber: roundNumber,
        selectedLetter: selectedLetter,
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
                      RoomCodeText(lobbyId: sessionId, iSend: true),
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
                              selectedLetter,
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
                        enabled: controller.isInputEnabled,
                      ),
                      SizedBox(height: 12.h),
                      _buildAnswerField(
                        label: 'Object',
                        controller: controller.objectController,
                        enabled: controller.isInputEnabled,
                      ),
                      SizedBox(height: 12.h),
                      _buildAnswerField(
                        label: 'Animal',
                        controller: controller.animalController,
                        enabled: controller.isInputEnabled,
                      ),
                      SizedBox(height: 12.h),
                      _buildAnswerField(
                        label: 'Plant',
                        controller: controller.plantController,
                        enabled: controller.isInputEnabled,
                      ),
                      SizedBox(height: 12.h),
                      _buildAnswerField(
                        label: 'Country',
                        controller: controller.countryController,
                        enabled: controller.isInputEnabled,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              onPressed:
                                  controller.isInputEnabled &&
                                      !controller.hasSubmitted &&
                                      !controller.isSubmitting
                                  ? () => controller.stopRound(context)
                                  : null,
                              text: controller.roundStopped
                                  ? 'Stopped'
                                  : 'Stop !',
                              color: AppColors.kRed500,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: PrimaryButton(
                              text: controller.hasSubmitted
                                  ? 'Submitted'
                                  : controller.isSubmitting
                                  ? 'Submitting...'
                                  : 'Next',
                              width: double.infinity,
                              onPressed:
                                  controller.isInputEnabled &&
                                      !controller.hasSubmitted &&
                                      !controller.isSubmitting
                                  ? () => controller.submitAnswers(context)
                                  : null,
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
    required bool enabled,
  }) {
    return Container(
      decoration: ShapeDecoration(
        color: enabled
            ? AppColors.kWhite.withOpacity(0.9)
            : AppColors.kGray300.withOpacity(0.5),
        shape: HandStyleBorder(
          side: BorderSide(
            color: enabled ? AppColors.kBlack : AppColors.kGray500,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(2.r),
          roughness: 0.5,
        ),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        textAlign: TextAlign.center,
        maxLength: 50,
        buildCounter:
            (_, {required currentLength, required isFocused, maxLength}) =>
                null,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(
            color: enabled ? AppColors.kGray600 : AppColors.kGray500,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
        style: AppTypography.kRegular19.copyWith(
          fontSize: 16.sp,
          color: enabled ? AppColors.kBlack : AppColors.kGray600,
        ),
      ),
    );
  }
}
