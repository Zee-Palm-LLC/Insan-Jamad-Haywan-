import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/fortune_wheel_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';

class FortuneWheelPage extends StatelessWidget {
  FortuneWheelPage({
    super.key,
    this.onSpinComplete,
    this.onCountdownComplete,
    this.isHost = true,
  });

  final Function(String letter)? onSpinComplete;
  final Function(String letter)? onCountdownComplete;
  final bool isHost;

  final List<Color> _colors = const [
    Color(0xFFFCF0DA),
    Color(0xFFBED6E2),
    Color(0xFF449F50),
    Color(0xFFF66F6C),
    Color(0xFFFFD767),
  ];

  Color _getColorForIndex(int index) {
    return _colors[index % _colors.length];
  }

  LobbyController? lobbyController = Get.find<LobbyController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FortuneWheelController>(
      init:
          FortuneWheelController(
              isHost: isHost,
              lobbyController: lobbyController,
            )
            ..onSpinComplete = onSpinComplete
            ..onCountdownComplete = onCountdownComplete,
      builder: (controller) {
        if (!isHost && lobbyController != null) {
          return GetBuilder<LobbyController>(
            init: lobbyController,
            builder: (_) {
              controller.syncWithLobby();
              return _buildWheel(controller);
            },
          );
        }
        return _buildWheel(controller);
      },
    );
  }

  Widget _buildWheel(FortuneWheelController controller) {
    return SizedBox(
      height: 320.h,
      width: 320.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
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
                      color: _getColorForIndex(i),
                      borderWidth: 1,
                    ),
                    child: Container(
                      width: double.maxFinite,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 10.w),
                      color: _getColorForIndex(i),
                      child: Text(
                        controller.alphabets[i],
                        style: AppTypography.kRegular19,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          if (isHost && !controller.isSpinning && !controller.showCountdown)
            InkWell(
              onTap: controller.spinWheel,
              child: Image.asset(AppAssets.spin),
            ),

          if (controller.selectedAlphabet != null && !controller.showCountdown)
            Positioned(
              bottom: -50.h,
              child: AnimatedOpacity(
                opacity: controller.isSpinning ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    'Letter: ${controller.selectedAlphabet}',
                    style: AppTypography.kBold24.copyWith(
                      color: AppColors.kWhite,
                    ),
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

          if (controller.isSpinning && !controller.showCountdown)
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
