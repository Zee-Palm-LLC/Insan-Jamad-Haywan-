import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
<<<<<<< HEAD:lib/modules/get_started/get_started_view.dart
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/data/constants/app_assets.dart';
import 'package:insan_jamd_hawan/modules/players/main_menu/main_menu_page.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/modules/widgets/cards/animated_bg.dart';
=======
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/players/player_info/player_info.dart';
>>>>>>> 1768c22fba3eb258ce705c48139ae7c9ab0bef6b:lib/core/modules/get_started/get_started_view.dart

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  static const String path = '/get-started';
  static const String name = 'GetStarted';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBg(
        showHorizontalLines: true,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  Center(
                    child: Image.asset(
                      AppAssets.logo,
                      height: 180.h,
                      width: 180.h,
                      fit: BoxFit.contain,
                    ),
<<<<<<< HEAD:lib/modules/get_started/get_started_view.dart
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: 'Get Started!',
                    width: 260.w,
                    onPressed: () {
                      AudioService.instance.playAudio(AudioType.click);
                      context.push(MainMenuPage.path);
                    },
                  ),
                ],
=======
                    const Spacer(),
                    PrimaryButton(
                      text: 'Get Started!',
                      width: 260.w,
                      onPressed: () {
                        context.go(PlayerInfo.path);
                      },
                    ),
                  ],
                ),
>>>>>>> 1768c22fba3eb258ce705c48139ae7c9ab0bef6b:lib/core/modules/get_started/get_started_view.dart
              ),
            ),
          ),
        ),
      ),
    );
  }
}
