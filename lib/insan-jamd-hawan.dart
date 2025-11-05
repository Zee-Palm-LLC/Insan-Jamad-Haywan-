import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/config/routes/router.dart';
import 'package:insan_jamd_hawan/core/controllers/game_config_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/app_theme.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';
import 'package:insan_jamd_hawan/main.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class InsanJamdHawan extends StatelessWidget {
  const InsanJamdHawan({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameConfigController>(
      //This insanJamdHawanFirebaseApp is just used for testing when we use in the mesh platform, then we will remove this and use the firebase app from the mesh platform.
      init: GameConfigController(firebaseApp: insanJamdHawanFirebaseApp),
      builder: (controller) {
        if (!controller.isInitialized) {
          return const ColoredBox(
            color: Colors.black,
            child: Center(
              child: SizedBox(
                width: 220,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 24),
                    Text(
                      'Initializing Game...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

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
                    child: MaterialApp.router(
                      title: 'INSAN JAMD HAWAN',
                      scrollBehavior: ScrollBehavior().copyWith(
                        overscroll: false,
                      ),
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
                      routerConfig: AppRouter.router,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
