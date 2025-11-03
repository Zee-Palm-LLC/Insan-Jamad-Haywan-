import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:insan_jamd_hawan/data/constants/app_theme.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/game_lobby_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet =
            constraints.maxWidth >= 650 && constraints.maxWidth < 1100;
        final Size designSize = isTablet
            ? Size(constraints.maxWidth, constraints.maxHeight)
            : const Size(375, 812);
        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          builder: (context, child) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: GetMaterialApp(
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
                home: child,
              ),
            );
          },
          child: const GameLobbyView(),
        );
      },
    );
  }
}
