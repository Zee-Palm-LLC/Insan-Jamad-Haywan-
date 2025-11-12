import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/data/helpers/wheel_helper.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/animations/confetti_animation.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';

class FortuneWheelWidget extends StatefulWidget {
  const FortuneWheelWidget({
    super.key,
    this.onSpinComplete,
    this.onCountdownComplete,
    this.isHost = true,
  });

  final Function(String letter)? onSpinComplete;
  final Function(String letter)? onCountdownComplete;
  final bool isHost;

  @override
  State<FortuneWheelWidget> createState() => _FortuneWheelWidgetState();
}

class _FortuneWheelWidgetState extends State<FortuneWheelWidget> {
  bool _showSpinButton = false;
  StreamController<int>? _controller;
  final Random _random = Random();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<WheelController>().resetController();
    });
    super.initState();
    _controller = StreamController<int>();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showSpinButton = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  int? _selectedIndex;

  void _spinWheel() {
    final wheelController = Get.find<WheelController>();
    if (wheelController.isSpinning) return;
    wheelController.isSpinning = true;
    wheelController.update();
    _selectedIndex = _random.nextInt(WheelHelper.getAlphabets().length);
    _controller?.add(_selectedIndex!);
    AudioService.instance.playAudio(AudioType.spinningWheel);
  }

  void _onSpinComplete() {
    if (_selectedIndex == null) return;

    final wheelController = Get.find<WheelController>();
    final selectedLetter = WheelHelper.getAlphabets()[_selectedIndex!];
    wheelController.isSpinning = false;
    wheelController.onLetterSelection(selectedLetter);
    
    AudioService.instance.player.stop();

    widget.onSpinComplete?.call(selectedLetter);
    dev.log('Wheel stopped at: $selectedLetter');
    _selectedIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WheelController>(
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
                child: GestureDetector(
                  onTap:
                      controller.isSpinning || controller.selectedLetter != null
                      ? null
                      : _spinWheel,
                  child: FortuneWheel(
                    selected: _controller!.stream,
                    indicators: <FortuneIndicator>[],
                    animateFirst: false,
                    onAnimationEnd: () {
                      if (controller.isSpinning) {
                        _onSpinComplete();
                      }
                    },
                    physics: CircularPanPhysics(
                      duration: const Duration(milliseconds: 2500),
                      curve: Curves.decelerate,
                    ),
                    items: [
                      for (
                        int i = 0;
                        i < WheelHelper.getAlphabets().length;
                        i++
                      )
                        FortuneItem(
                          onTapUp: (details) {},
                          style: FortuneItemStyle(
                            color:
                                controller.selectedLetter != null &&
                                    WheelHelper.getAlphabets()[i] !=
                                        controller.selectedLetter
                                ? WheelHelper.getColorForIndex(
                                    i,
                                  ).withValues(alpha: 0.1)
                                : WheelHelper.getColorForIndex(i),
                            borderWidth: 0,
                          ),
                          child: Container(
                            width: double.maxFinite,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 10.w),
                            color:
                                controller.selectedLetter != null &&
                                    WheelHelper.getAlphabets()[i] !=
                                        controller.selectedLetter
                                ? WheelHelper.getColorForIndex(
                                    i,
                                  ).withValues(alpha: 0.1)
                                : WheelHelper.getColorForIndex(i),
                            child: Text(
                              WheelHelper.getAlphabets()[i],
                              style: AppTypography.kRegular19.copyWith(
                                color:
                                    controller.selectedLetter != null &&
                                        WheelHelper.getAlphabets()[i] !=
                                            controller.selectedLetter
                                    ? AppColors.kBlack.withValues(alpha: 0.1)
                                    : AppColors.kBlack,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (widget.isHost &&
                  _showSpinButton &&
                  controller.selectedLetter == null)
                InkWell(
                  onTap: controller.isSpinning ? null : _spinWheel,
                  child: Opacity(
                    opacity: controller.isSpinning ? 0.3 : 1.0,
                    child: Image.asset(AppAssets.spin),
                  ),
                ),
              if (controller.selectedLetter != null) ...[
                ConfettiAnimation(
                  key: ValueKey(controller.selectedLetter),
                  enabled: controller.selectedLetter != null,
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
                      controller.selectedLetter!,
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
