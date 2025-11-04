import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/services/audio_service.dart';

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

class _FortuneWheelPageState extends State<FortuneWheelPage>
    with SingleTickerProviderStateMixin {
  late List<String> alphabets;
  final StreamController<int> controller = StreamController<int>();
  int selectedIndex = 0;
  String? selectedAlphabet;
  bool isSpinning = false;
  bool showCountdown = false;
  int countdownValue = 3;

  @override
  void initState() {
    super.initState();
    // Generate alphabets and shuffle them randomly each time
    alphabets = List.generate(
      26,
      (i) => String.fromCharCode(65 + i),
    );
    alphabets.shuffle(Random());
  }

  final List<Color> colors = [
    Color(0xFFFCF0DA),
    Color(0xFFBED6E2),
    Color(0xFF449F50),
    Color(0xFFF66F6C),
    Color(0xFFFFD767),
  ];

  Color _getColorForIndex(int index) {
    return colors[index % colors.length];
  }

  Future<void> _spinWheel() async {
    if (isSpinning) return;

    setState(() {
      isSpinning = true;
    });
    await AudioService.instance.playAudio(AudioType.narratorChooseLetter);
    await Future.delayed(const Duration(milliseconds: 500));

    final randomIndex = Random().nextInt(alphabets.length);
    setState(() {
      selectedIndex = randomIndex;
    });

    AudioService.instance.playAudio(AudioType.wheelSpin);
    controller.add(randomIndex);
  }

  Future<void> _onSpinComplete() async {
    final letter = alphabets[selectedIndex];
    setState(() {
      selectedAlphabet = letter;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    await AudioService.instance.playAudio(AudioType.narratorTheLetterIs);

    await Future.delayed(const Duration(milliseconds: 800));

    widget.onSpinComplete?.call(letter);

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      showCountdown = true;
      countdownValue = 3;
    });

    for (int i = 3; i > 0; i--) {
      setState(() {
        countdownValue = i;
      });
      await AudioService.instance.playAudio(AudioType.countdown);
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() {
      showCountdown = false;
    });

    widget.onCountdownComplete?.call(letter);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              selected: controller.stream,
              indicators: <FortuneIndicator>[],
              onAnimationEnd: _onSpinComplete,
              physics: CircularPanPhysics(
                duration: const Duration(milliseconds: 2500),
                curve: Curves.decelerate,
              ),
              items: [
                for (int i = 0; i < alphabets.length; i++)
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
                        alphabets[i],
                        style: AppTypography.kRegular19,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          if (widget.isHost && !isSpinning && !showCountdown)
            InkWell(onTap: _spinWheel, child: Image.asset(AppAssets.spin)),

          if (selectedAlphabet != null && !showCountdown)
            Positioned(
              bottom: -50.h,
              child: AnimatedOpacity(
                opacity: isSpinning ? 0.0 : 1.0,
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
                    'Letter: $selectedAlphabet',
                    style: AppTypography.kBold24.copyWith(
                      color: AppColors.kWhite,
                    ),
                  ),
                ),
              ),
            ),

          if (showCountdown)
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
                    '$countdownValue',
                    style: AppTypography.kRegular41.copyWith(
                      fontSize: 80.sp,
                      color: AppColors.kWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          if (isSpinning && !showCountdown)
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
