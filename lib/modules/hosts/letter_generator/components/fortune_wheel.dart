import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/services/audio_service.dart';

class FortuneWheelPage extends StatefulWidget {
  const FortuneWheelPage({super.key, this.onSpinComplete});

  final Function(String letter)? onSpinComplete;

  @override
  State<FortuneWheelPage> createState() => _FortuneWheelPageState();
}

class _FortuneWheelPageState extends State<FortuneWheelPage>
    with SingleTickerProviderStateMixin {
  final List<String> alphabets = List.generate(
    26,
    (i) => String.fromCharCode(65 + i),
  );
  final StreamController<int> controller = StreamController<int>();
  int selectedIndex = 0;
  String? selectedAlphabet;

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

  void _spinWheel() {
    final randomIndex = Random().nextInt(alphabets.length);
    setState(() {
      selectedIndex = randomIndex;
    });
    controller.add(randomIndex);
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
              onAnimationEnd: () {
                final letter = alphabets[selectedIndex];
                setState(() {
                  selectedAlphabet = letter;
                });
                widget.onSpinComplete?.call(letter);
              },
              physics: CircularPanPhysics(
                duration: const Duration(seconds: 1),
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
                        style: AppTypography.kRegular19
                      ),
                    ),
                  ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              AudioService.instance.playAudio(AudioType.click);
              _spinWheel();
            },
            child: Image.asset(AppAssets.spin),
          ),
        ],
      ),
    );
  }
}
