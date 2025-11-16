import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/player_info_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/custom_paint/rough_border.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class PlayerInfo extends StatelessWidget {
  const PlayerInfo({super.key});

  static const String path = '/player-info';
  static const String name = 'PlayerInfo';

  // Widget _buildProfileImagePicker(PlayerInfoController controller) {
  //   return GestureDetector(
  //     onTap: controller.pickProfileImage,
  //     child: Container(
  //       width: 120.w,
  //       height: 120.w,
  //       decoration: ShapeDecoration(
  //         shape: RoughCircleBorder.all(
  //           color: AppColors.kGray600,
  //           width: 2.w,
  //           roughness: 0.8,
  //         ),
  //         color: AppColors.kGreen100,
  //       ),
  //       child: controller.profileImagePath != null
  //           ? ClipOval(
  //               child: kIsWeb
  //                   ? (controller.profileImagePath!.startsWith('blob:') ||
  //                             controller.profileImagePath!.startsWith('data:'))
  //                         ? Image.network(
  //                             controller.profileImagePath!,
  //                             fit: BoxFit.cover,
  //                             errorBuilder: (context, error, stackTrace) {
  //                               return _buildPlaceholder();
  //                             },
  //                           )
  //                         : _buildPlaceholder()
  //                   : Image.file(
  //                       File(controller.profileImagePath!),
  //                       fit: BoxFit.cover,
  //                       errorBuilder: (context, error, stackTrace) {
  //                         return _buildPlaceholder();
  //                       },
  //                     ),
  //             )
  //           : _buildPlaceholder(),
  //     ),
  //   );
  // }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: 40.sp, color: AppColors.kGray600),
          SizedBox(height: 8.h),
          Text(
            'Tap to add\nprofile image',
            textAlign: TextAlign.center,
            style: AppTypography.kRegular19.copyWith(
              fontSize: 12.sp,
              color: AppColors.kGray600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<PlayerInfoController>(
      init: PlayerInfoController(),
      builder: (controller) {
        return Scaffold(
          appBar: isDesktop
              ? null
              : AppBar(
                  leading: Padding(
                    padding: EdgeInsets.all(10.h),
                    child: CustomIconButton(
                      icon: AppAssets.backIcon,
                      onTap: () {
                        context.pop();
                      },
                    ),
                  ),
                  actions: [
                    CustomIconButton(icon: AppAssets.shareIcon, onTap: () {}),
                    SizedBox(width: 16.w),
                  ],
                ),
          body: LobbyBg(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40.w : 16.w,
                vertical: isDesktop ? 20.h : 16.h,
              ),
              child: Center(
                child: DesktopWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isDesktop) SizedBox(height: 50.h),
                      GameLogo(),
                      SizedBox(height: 12.h),

                      Text(
                        "Set up your profile information below. Your username and welcome message will be visible to other players in the lobby.",
                        textAlign: TextAlign.center,
                        style: AppTypography.kRegular19.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.kGray600,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      //Center(child: _buildProfileImagePicker(controller)),
                      SizedBox(height: 32.h),
                      TextField(
                        controller: controller.usernameController,
                        style: AppTypography.kRegular19.copyWith(
                          fontSize: 16.sp,
                        ),
                        enabled: !controller.isLoading,
                        textAlign: TextAlign.center,
                        maxLength: 18, // Enforce max length for username
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                          counterText:
                              '', // Hide default character counter if desired
                        ),
                        onChanged: (value) {
                          if (value.length > 18) {
                            controller.usernameController.text = value
                                .substring(0, 18);
                            controller.usernameController.selection =
                                TextSelection.fromPosition(
                                  TextPosition(offset: 18),
                                );
                          }
                        },
                      ),
                      // You could add a warning if needed
                      if (controller.usernameController.text.length >= 18)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            "Username cannot be longer than 18 characters.",
                            style: AppTypography.kRegular19.copyWith(
                              color: AppColors.kRed500,
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(height: 20.h),
                      Center(
                        child: PrimaryButton(
                          onPressed: controller.isLoading
                              ? null // Disabled during loading
                              : () => controller.savePlayerInfo(context),
                          text: controller.isLoading ? 'Loading...' : 'Save',
                          width: 220.w,
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
