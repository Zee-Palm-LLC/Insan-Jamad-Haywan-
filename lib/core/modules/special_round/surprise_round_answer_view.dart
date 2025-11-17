import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/surprise_round_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/final_round_scoreboard.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/custom_paint/handdrawn_border.dart';

class SurpriseRoundAnswerView extends StatefulWidget {
  const SurpriseRoundAnswerView({
    super.key,
    this.specialRoundLetter,
    this.specialRoundCategory,
  });
  final String? specialRoundLetter;
  final String? specialRoundCategory;

  static const String path = '/surprise-round';
  static const String name = 'SurpriseRound';

  @override
  State<SurpriseRoundAnswerView> createState() =>
      _SurpriseRoundAnswerViewState();
}

class _SurpriseRoundAnswerViewState extends State<SurpriseRoundAnswerView> {
  late final SurpriseRoundController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SurpriseRoundController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.startTimerSync();
    });
  }

  @override
  void dispose() {
    _controller.cancelTimerSync();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SurpriseRoundController>(
      builder: (controller) {
        return Scaffold(
          body: Center(
            child: DesktopWrapper(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GameLogo(),
                  SizedBox(height: 24.h),
                  Text('Special Round', style: AppTypography.kBold24),
                  SizedBox(height: 8.h),
                  // Timer display
                  Text(
                    controller.formattedTime.value,
                    style: AppTypography.kBold21.copyWith(fontSize: 24.sp),
                  ),
                  SizedBox(height: 24.h),

                  // Display selected letter
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    decoration: ShapeDecoration(
                      color: AppColors.kWhite.withOpacity(0.9),
                      shape: HandStyleBorder(
                        side: BorderSide(color: AppColors.kBlack, width: 1.5),
                        borderRadius: BorderRadius.circular(2.r),
                        roughness: 0.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Selected Letter',
                          style: AppTypography.kRegular19,
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: AppColors.kYellow,
                            border: Border.all(color: AppColors.kGray600),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text(
                              widget.specialRoundLetter ?? '',
                              style: AppTypography.kBold21.copyWith(
                                fontSize: 32.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Display selected category
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    decoration: ShapeDecoration(
                      color: AppColors.kWhite.withOpacity(0.9),
                      shape: HandStyleBorder(
                        side: BorderSide(color: AppColors.kBlack, width: 1.5),
                        borderRadius: BorderRadius.circular(2.r),
                        roughness: 0.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Selected Category',
                          style: AppTypography.kRegular19,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          widget.specialRoundCategory ?? '',
                          style: AppTypography.kBold21,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Answer TextField
                  TextField(
                    controller: controller.answerController,
                    textAlign: TextAlign.center,
                    //enabled: !controller.isSubmitting,
                    decoration: InputDecoration(
                      hintText: 'Enter your answer',
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                    ),
                    style: AppTypography.kRegular19.copyWith(fontSize: 16.sp),
                  ),
                  SizedBox(height: 24.h),
                  // Submit button
                  PrimaryButton(
                    text: 'Submit',
                    width: double.infinity,
                    onPressed: controller.isSubmitting
                        ? null
                        : () {
                            controller.submitAnswer(onSuccess: () {});
                          },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
