import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insan_jamd_hawan/data/constants/app_colors.dart';

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
