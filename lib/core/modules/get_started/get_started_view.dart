import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/players/player_info/player_info.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  static const String path = '/get-started';
  static const String name = 'GetStarted';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LobbyBg(
        child: AnimatedBg(
          child: DesktopWrapper(
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
                    ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
