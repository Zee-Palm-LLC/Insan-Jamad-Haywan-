import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/app_colors.dart';
import 'package:insan_jamd_hawan/data/constants/app_typography.dart';

class AppTheme {
  static ThemeData get gameLobbyTheme => ThemeData(
    scaffoldBackgroundColor: AppColors.kWhite,
    useMaterial3: true,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: defaultOverlay,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFFFFCF4),
      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
      hintStyle: AppTypography.kRegular19.copyWith(fontSize: 16.sp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(width: 1.w, color: AppColors.kGray600),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(width: 1.5.w, color: AppColors.kGray600),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(width: 1.5.w, color: AppColors.kGray600),
      ),
    ),
  );
}

final defaultOverlay = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark, // dark == black icons
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.dark, // dark == black icons
  systemNavigationBarContrastEnforced: false,
  systemNavigationBarDividerColor: Colors.transparent,
);
