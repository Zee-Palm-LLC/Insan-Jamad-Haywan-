import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/data/helpers/app_helpers.dart';

class PlayerTile extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const PlayerTile({super.key, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AudioService.instance.playAudio(AudioType.click);
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(6.h),
        decoration: BoxDecoration(
          color: AppColors.kGray300,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            GetBuilder<PlayerTileController>(
              init: PlayerTileController(),
              builder: (controller) {
                return Container(
                  height: 54.h,
                  width: 54.h,
                  decoration: BoxDecoration(
                    color: AppColors.kGray300,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.kGray500),
                  ),
                  padding: EdgeInsets.all(2.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: controller.profileImagePath != null
                        ? Platform.isAndroid
                              ? (controller.profileImagePath!.startsWith(
                                          'blob:',
                                        ) ||
                                        controller.profileImagePath!.startsWith(
                                          'data:',
                                        ) ||
                                        controller.profileImagePath!.startsWith(
                                          'http://',
                                        ) ||
                                        controller.profileImagePath!.startsWith(
                                          'https://',
                                        ))
                                    ? Image.network(
                                        controller.profileImagePath!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return _buildPlaceholder(name);
                                            },
                                      )
                                    : _buildPlaceholder(name)
                              : Image.file(
                                  File(controller.profileImagePath!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildPlaceholder(name);
                                  },
                                )
                        : _buildPlaceholder(name),
                  ),
                );
              },
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                name,
                style: AppTypography.kBold24.copyWith(color: AppColors.kRed500),
              ),
            ),
            Text('Player', style: AppTypography.kRegular19),
            SizedBox(width: 5.w),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String playerName) {
    final initials = AppHelpers.getInitials(playerName);
    return Container(
      color: AppColors.kGray300,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTypography.kBold16.copyWith(color: AppColors.kGray600),
      ),
    );
  }
}

class PlayerTileController extends GetxController {
  String? profileImagePath;

  @override
  void onInit() {
    super.onInit();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    profileImagePath = await AppService.getProfileImage();
    update();
  }
}
