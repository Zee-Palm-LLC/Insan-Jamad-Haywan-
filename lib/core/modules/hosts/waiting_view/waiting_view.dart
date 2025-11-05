import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/waiting_view_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class WaitingView extends StatelessWidget {
  const WaitingView({super.key});

  static String path = '/waiting';
  static String name = 'Waiting';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<WaitingViewController>(
      init: WaitingViewController(),
      builder: (waitingController) {
        // Listen to LobbyController updates and sync waiting controller
        try {
          return GetBuilder<LobbyController>(
            builder: (_) {
              // Defer sync to avoid setState during build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                waitingController.syncWithLobby();
              });
              return _buildScaffold(waitingController, isDesktop);
            },
          );
        } catch (e) {
          // LobbyController not found, show waiting view anyway
          return _buildScaffold(waitingController, isDesktop);
        }
      },
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(Icons.person, size: 100.h, color: AppColors.kGray600),
    );
  }

  Widget _buildScaffold(WaitingViewController controller, bool isDesktop) {
    return GetBuilder<WaitingViewController>(
      builder: (_) {
        return Scaffold(
          appBar: isDesktop
              ? null
              : AppBar(
                  leading: Padding(
                    padding: EdgeInsets.all(10.h),
                    child: CustomIconButton(
                      icon: AppAssets.backIcon,
                      onTap: () => Get.context?.pop(),
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
                    children: [
                      if (!isDesktop) SizedBox(height: 50.h),
                      GameLogo(),
                      SizedBox(height: 12.h),
                      RoomCodeText(lobbyId: controller.lobbyCode, iSend: true),
                      SizedBox(height: 34.h),
                      // Player Avatar with Countdown Overlay
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 238.h,
                            width: 238.h,
                            decoration: BoxDecoration(
                              color: AppColors.kGray300,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.kPrimary),
                            ),
                            child: controller.playerAvatar != null
                                ? ClipOval(
                                    child: kIsWeb
                                        ? (controller.playerAvatar!.startsWith(
                                                    'blob:',
                                                  ) ||
                                                  controller.playerAvatar!
                                                      .startsWith('data:') ||
                                                  controller.playerAvatar!
                                                      .startsWith('http://') ||
                                                  controller.playerAvatar!
                                                      .startsWith('https://'))
                                              ? Image.network(
                                                  controller.playerAvatar!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return _buildPlaceholder();
                                                      },
                                                )
                                              : _buildPlaceholder()
                                        : Image.file(
                                            File(controller.playerAvatar!),
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return _buildPlaceholder();
                                                },
                                          ),
                                  )
                                : _buildPlaceholder(),
                          ),
                          // Countdown Overlay
                          if (controller.isCountdownActive)
                            Container(
                              height: 238.h,
                              width: 238.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              child: Center(
                                child: AnimatedScale(
                                  scale: 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    '${controller.countdownValue}',
                                    style: AppTypography.kRegular41.copyWith(
                                      fontSize: 80.sp,
                                      color: AppColors.kWhite,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        controller.playerName,
                        style: AppTypography.kBold24.copyWith(fontSize: 34.sp),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        controller.isCountdownActive
                            ? 'Get ready!'
                            : controller.selectedLetter != null
                            ? 'Letter selected: ${controller.selectedLetter}!'
                            : 'You are in! Wait for host to start game...',
                        textAlign: TextAlign.center,
                        style: AppTypography.kBold24.copyWith(
                          height: 1.2,
                          color: AppColors.kPrimary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // Loading indicator when not countdown
                      if (!controller.isCountdownActive)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.kGreen100,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColors.kPrimary),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.kPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Waiting...',
                                style: AppTypography.kBold16.copyWith(
                                  color: AppColors.kPrimary,
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
