import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/waiting_view_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/data/helpers/app_helpers.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
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
        try {
          return GetBuilder<LobbyController>(
            builder: (_) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                waitingController.syncWithLobby();
              });
              return _buildScaffold(isDesktop);
            },
          );
        } catch (e) {
          return _buildScaffold(isDesktop);
        }
      },
    );
  }

  Widget _buildPlaceholder(String playerName) {
    final initials = AppHelpers.getInitials(playerName);
    return Center(
      child: Text(
        initials,
        style: AppTypography.kBold16.copyWith(
          fontSize: 48.sp,
          color: AppColors.kGray600,
        ),
      ),
    );
  }

  Widget _buildScaffold(bool isDesktop) {
    return GetBuilder<WaitingViewController>(
      builder: (controller) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            // appBar: isDesktop
            //     ? null
            //     : AppBar(
            //         automaticallyImplyLeading: false,
            //         actions: [
            //           CustomIconButton(icon: AppAssets.shareIcon, onTap: () {}),
            //           SizedBox(width: 16.w),
            //         ],
            //       ),
            body: AnimatedBg(
              showHorizontalLines: true,
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: Center(
                  child: DesktopWrapper(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isDesktop) SizedBox(height: 50.h),
                        GameLogo(),
                        SizedBox(height: 12.h),
                        RoomCodeText(
                          lobbyId: controller.lobbyCode,
                          iSend: true,
                        ),
                        SizedBox(height: 40.h),
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
                                          ? (controller.playerAvatar!
                                                        .startsWith('blob:') ||
                                                    controller.playerAvatar!
                                                        .startsWith('data:') ||
                                                    controller.playerAvatar!
                                                        .startsWith(
                                                          'http://',
                                                        ) ||
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
                                                          return _buildPlaceholder(
                                                            controller
                                                                .playerName,
                                                          );
                                                        },
                                                  )
                                                : _buildPlaceholder(
                                                    controller.playerName,
                                                  )
                                          : Image.file(
                                              File(controller.playerAvatar!),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return _buildPlaceholder(
                                                      controller.playerName,
                                                    );
                                                  },
                                            ),
                                    )
                                  : _buildPlaceholder(controller.playerName),
                            ),
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
                          style: AppTypography.kBold24.copyWith(
                            fontSize: 34.sp,
                          ),
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
                            fontSize: 28.sp,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        if (!controller.isCountdownActive)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 14.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.kPrimary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              'Loading.',
                              style: AppTypography.kBold24.copyWith(
                                color: AppColors.kWhite,
                                fontSize: 18.sp,
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
          ),
        );
      },
    );
  }
}
