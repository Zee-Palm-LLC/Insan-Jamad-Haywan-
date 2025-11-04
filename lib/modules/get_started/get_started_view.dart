import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/data/constants/app_assets.dart';
import 'package:insan_jamd_hawan/modules/players/main_menu/main_menu_page.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/modules/widgets/cards/animated_bg.dart';

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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
