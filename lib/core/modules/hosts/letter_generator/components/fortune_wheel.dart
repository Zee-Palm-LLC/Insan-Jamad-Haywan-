import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/fortune_wheel_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/letter_generator_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/data/helpers/color_helpers.dart';

class FortuneWheelPage extends StatelessWidget {
  const FortuneWheelPage({
    super.key,
    this.onSpinComplete,
    this.onCountdownComplete,
    this.onCountdownTrigger,
    this.isHost = true,
  });

  final Function(String letter)? onSpinComplete;
  final Function(String letter)? onCountdownComplete;
  final VoidCallback? onCountdownTrigger;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FortuneWheelController>(
      init: FortuneWheelController(isHost: isHost)
        ..onSpinComplete = onSpinComplete
        ..onCountdownComplete = onCountdownComplete,
      builder: (controller) {
        if (isHost) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            try {
              final letterGenController = Get.find<LetterGeneratorController>();
              letterGenController.setWheelController(controller);
            } catch (e) {}
          });
        }

        if (!isHost) {
          try {
            return GetBuilder<LobbyController>(
              builder: (_) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.syncWithLobby();
                });
                return _buildWheel(controller);
              },
            );
          } catch (e) {
            return _buildWheel(controller);
          }
        }
        return _buildWheel(controller);
      },
    );
  }

  Widget _buildWheel(FortuneWheelController controller) {
    final bool isLetterSelected =
        controller.selectedAlphabet != null && !controller.showCountdown;

    return SizedBox(
      height: 320.h,
      width: 320.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: isLetterSelected ? 0.3 : 1.0,
            child: Container(
              height: 320.h,
              width: 320.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kGray300.withValues(alpha: 0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: FortuneWheel(
                selected: controller.wheelController.stream,
                indicators: <FortuneIndicator>[],
                onAnimationEnd: controller.handleSpinComplete,
                physics: CircularPanPhysics(
                  duration: const Duration(milliseconds: 2500),
                  curve: Curves.decelerate,
                ),
                items: [
                  for (int i = 0; i < controller.alphabets.length; i++)
                    FortuneItem(
                      style: FortuneItemStyle(
                        color: ColorHelpers.getFortuneWheelColor(i),
                        borderWidth: 1,
                      ),
                      child: Container(
                        width: double.maxFinite,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 10.w),
                        color: ColorHelpers.getFortuneWheelColor(i),
                        child: Text(
                          controller.alphabets[i],
                          style: AppTypography.kRegular19,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (isHost &&
              !controller.isSpinning &&
              !controller.showCountdown &&
              controller.selectedAlphabet == null)
            InkWell(
              onTap: () {
                if (!controller.isSpinning &&
                    !controller.showCountdown &&
                    controller.selectedAlphabet == null) {
                  controller.spinWheel();
                }
              },
              child: Image.asset(AppAssets.spin),
            ),

          if (isLetterSelected)
            Container(
              height: 120.h,
              width: 120.h,
              decoration: BoxDecoration(
                color: AppColors.kPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kPrimary.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  controller.selectedAlphabet!,
                  style: AppTypography.kBold24.copyWith(
                    fontSize: 60.sp,
                    color: AppColors.kWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          if (controller.showCountdown)
            Container(
              height: 320.h,
              width: 320.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.7),
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

          if (controller.isSpinning &&
              !controller.showCountdown &&
              controller.selectedAlphabet == null)
            Positioned(
              top: -40.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.kOrange,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.kWhite,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Spinning...',
                      style: AppTypography.kBold16.copyWith(
                        color: AppColors.kWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
