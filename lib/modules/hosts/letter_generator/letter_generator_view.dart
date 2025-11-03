import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/modules/hosts/answers_host/answers_host_view.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/modules/hosts/letter_generator/components/fortune_wheel.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/custom_icon_button.dart';

class LetterGeneratorView extends StatelessWidget {
  const LetterGeneratorView({super.key});

  static const String path = '/letter-generator';
  static const String name = 'LetterGenerator';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(10.h),
          child: CustomIconButton(icon: AppAssets.backIcon, onTap: () {
            context.pop();
          }),
        ),
        actions: [
          CustomIconButton(icon: AppAssets.shareIcon, onTap: () {}),
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.h),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            GameLogo(),
            SizedBox(height: 12.h),
            RoomCodeText(isSend: true, lobbyId: 'XYZ124'),
            SizedBox(height: 50.h),
            FortuneWheelPage(
              onSpinComplete: (letter) {
                context.push(AnswersHostView.path.replaceAll(':letter', letter));
                },
            ),
          ],
        ),
      ),
    );
  }
}
