import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/core/data/constants/app_theme.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/final_round_scoreboard.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class InsanJamdHawan extends StatelessWidget {
  const InsanJamdHawan({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth >= 1100;
        final bool isTablet =
            constraints.maxWidth >= 650 && constraints.maxWidth < 1100;
        final Size designSize = isTablet || isDesktop
            ? Size(constraints.maxWidth, constraints.maxHeight)
            : const Size(375, 812);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          builder: (context, child) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ToastificationWrapper(
                child: MaterialApp(
                  title: 'INSAN JAMD HAWAN',
                  scrollBehavior: ScrollBehavior().copyWith(overscroll: false),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(textScaler: TextScaler.linear(1.2)),
                      child: child!,
                    );
                  },
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.gameLobbyTheme,
                  home: FinalRoundScoreboard(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
