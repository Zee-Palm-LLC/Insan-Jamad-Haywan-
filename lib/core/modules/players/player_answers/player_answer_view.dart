import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/answer_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/custom_paint/handdrawn_border.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class PlayerAnswerView extends StatefulWidget {
  const PlayerAnswerView({super.key});

  static const String path = '/player-answer';
  static const String name = 'PlayerAnswer';
  // WheelController get wheelController => Get.find<WheelController>();
  // LobbyController get lobbyController => Get.find<LobbyController>();

  @override
  State<PlayerAnswerView> createState() => _PlayerAnswerViewState();
}

class _PlayerAnswerViewState extends State<PlayerAnswerView> {
  WheelController get wheelController => Get.find<WheelController>();
  LobbyController get lobbyController => Get.find<LobbyController>();
  AnswerController get answerController => Get.find<AnswerController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      answerController.startTimerSync();
    });
  }

  @override
  void dispose() {
    answerController.cancelTimerSync();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<AnswerController>(
      builder: (controller) {
        return Scaffold(
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
                        lobbyId: lobbyController.lobby.id ?? '',
                        iSend: true,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Letter', style: AppTypography.kRegular24),
                          SizedBox(width: 8.w),
                          StreamBuilder(
                            stream: FirebaseFirestoreService.instance
                                .listenToRound(
                                  lobbyController.lobby.id ?? '',
                                  wheelController.currentRound,
                                ),
                            builder: (context, snapshot) {
                              String displayLetter =
                                  wheelController.selectedLetter ?? '';

                              if (snapshot.hasData && snapshot.data != null) {
                                displayLetter = snapshot.data!.selectedLetter;
                              } else if (displayLetter.isEmpty) {
                                displayLetter =
                                    wheelController.selectedLetter ?? '';
                              }

                              return Container(
                                height: 50.h,
                                width: 74.w,
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimary,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                alignment: Alignment.bottomCenter,
                                padding: EdgeInsets.only(top: 6.h),
                                child: Text(
                                  displayLetter.isNotEmpty
                                      ? displayLetter
                                      : '?',
                                  style: AppTypography.kRegular41.copyWith(
                                    color: AppColors.kWhite,
                                    height: 1,
                                  ),
                                ),
                              );
                            },
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
                                Obx(
                                  () => Text(
                                    controller.formattedTime.value,
                                    style: AppTypography.kRegular19.copyWith(
                                      color: AppColors.kRed500,
                                    ),
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
                            onTap: controller.canUseDoublePoints
                                ? () {
                                    controller.toggleDoublePoints();
                                  }
                                : null,
                            child: Opacity(
                              opacity: controller.canUseDoublePoints
                                  ? 1.0
                                  : 0.5,
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
                                child: controller.doublePoints.value
                                    ? SvgPicture.asset(AppAssets.done)
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              controller.canUseDoublePoints
                                  ? 'Double my points for this round'
                                  : 'Double points already used',
                              style: AppTypography.kRegular19.copyWith(
                                fontSize: 16.sp,
                                color: controller.canUseDoublePoints
                                    ? null
                                    : AppColors.kGray500,
                              ),
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
                      PrimaryButton(
                        text: 'Stop and Submit',
                        width: double.infinity,
                        onPressed: () {
                          controller.submitAnswers(
                            onSuccess: () {
                              // Success callback - submission completed
                              log(
                                'Answer submission completed successfully',
                                name: 'PlayerAnswerView',
                              );
                            },
                          );
                        },
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
