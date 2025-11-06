import 'package:flutter/material.dart';
import 'package:insan_jamd_hawan/core/data/constants/app_colors.dart';

class ColorHelpers {
  ColorHelpers._();

  static const List<Color> playerColors = [
    AppColors.kPrimary,
    AppColors.kBlue,
    AppColors.kOrange,
    AppColors.kRed500,
  ];

  static const List<Color> fortuneWheelColors = [
    Color(0xFFFCF0DA),
    Color(0xFFBED6E2),
    Color(0xFF449F50),
    Color(0xFFF66F6C),
    Color(0xFFFFD767),
  ];

  static Color getPlayerColor(int index) {
    return playerColors[index % playerColors.length];
  }

  static Color getFortuneWheelColor(int index) {
    return fortuneWheelColors[index % fortuneWheelColors.length];
  }
}
