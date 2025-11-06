import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/fortune_wheel_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/animations/confetti_animation.dart';

class FortuneWheelPage extends StatefulWidget {
  const FortuneWheelPage({
    super.key,
    this.onSpinComplete,
    this.onCountdownComplete,
    this.isHost = true,
  });

  final Function(String letter)? onSpinComplete;
  final Function(String letter)? onCountdownComplete;
  final bool isHost;

  @override
  State<FortuneWheelPage> createState() => _FortuneWheelPageState();
}

class _FortuneWheelPageState extends State<FortuneWheelPage> {
  bool _showSpinButton = false;

  @override
  void initState() {
    super.initState();
    // Show spin button after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showSpinButton = true;
        });
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FortuneWheelController>(
      init: FortuneWheelController()
        ..onSpinComplete = widget.onSpinComplete
        ..onCountdownComplete = widget.onCountdownComplete,
      builder: (controller) {
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
                  color: AppColors.kWhite,
                ),
              ),
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
                  selected: controller.wheelControllerStream,
                  indicators: <FortuneIndicator>[],
                  animateFirst: false,
                  onAnimationEnd: controller.handleSpinComplete,
                  physics: CircularPanPhysics(
                    duration: const Duration(milliseconds: 2500),
                    curve: Curves.decelerate,
                  ),
                  items: [
                    for (int i = 0; i < controller.alphabets.length; i++)
                      FortuneItem(
                        style: FortuneItemStyle(
                          color:
                              controller.selectedAlphabet != null &&
                                  controller.alphabets[i] !=
                                      controller.selectedAlphabet
                              ? _getColorForIndex(i).withValues(alpha: 0.1)
                              : _getColorForIndex(i),
                          borderWidth: 0,
                        ),
                        child: Container(
                          width: double.maxFinite,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 10.w),
                          color:
                              controller.selectedAlphabet != null &&
                                  controller.alphabets[i] !=
                                      controller.selectedAlphabet
                              ? _getColorForIndex(i).withValues(alpha: 0.1)
                              : _getColorForIndex(i),
                          child: Text(
                            controller.alphabets[i],
                            style: AppTypography.kRegular19.copyWith(
                              color:
                                  controller.selectedAlphabet != null &&
                                      controller.alphabets[i] !=
                                          controller.selectedAlphabet
                                  ? AppColors.kBlack.withValues(alpha: 0.1)
                                  : AppColors.kBlack,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.isHost &&
                  _showSpinButton &&
                  controller.selectedAlphabet == null)
                InkWell(
                  onTap: controller.isSpinning ? null : controller.spinWheel,
                  child: Opacity(
                    opacity: controller.isSpinning ? 0.5 : 1.0,
                    child: Image.asset(AppAssets.spin),
                  ),
                ),

              if (controller.selectedAlphabet != null) ...[
                ConfettiAnimation(
                  key: ValueKey(controller.selectedAlphabet),
                  enabled: controller.selectedAlphabet != null,
                  duration: const Duration(seconds: 3),
                ),
                Container(
                  width: 61.w,
                  height: 61.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.kPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      controller.selectedAlphabet!,
                      style: AppTypography.kBold24.copyWith(
                        color: AppColors.kWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
