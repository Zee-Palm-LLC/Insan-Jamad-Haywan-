import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/modules/hosts/answers_host/answers_host_view.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/modules/hosts/letter_generator/components/fortune_wheel.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/custom_icon_button.dart';

class LetterGeneratorView extends StatefulWidget {
  const LetterGeneratorView({super.key, this.controller});

  final LobbyController? controller;

  static const String path = '/letter-generator';
  static const String name = 'LetterGenerator';

  @override
  State<LetterGeneratorView> createState() => _LetterGeneratorViewState();
}

class _LetterGeneratorViewState extends State<LetterGeneratorView> {
  String? _selectedLetter;

  Future<void> _handleSpinComplete(String letter) async {
    setState(() {
      _selectedLetter = letter;
    });

    // Broadcast letter to all players if we have a controller
    if (widget.controller != null) {
      await widget.controller!.broadcastSelectedLetter(letter);
    }
  }

  void _handleCountdownComplete(String letter) {
    // Navigate to answers screen after countdown
    context.push(AnswersHostView.path.replaceAll(':letter', letter));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(10.h),
          child: CustomIconButton(
            icon: AppAssets.backIcon,
            onTap: () => context.pop(),
          ),
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
            GetBuilder<LobbyController>(
              init: widget.controller,
              builder: (controller) {
                return RoomCodeText(
                  iSend: true,
                  lobbyId: controller.currentRoom.inviteCode ?? 'XYZ124',
                );
              },
            ),
            SizedBox(height: 50.h),
            FortuneWheelPage(
              isHost: true,
              onSpinComplete: _handleSpinComplete,
              onCountdownComplete: _handleCountdownComplete,
            ),
            if (_selectedLetter != null) ...[
              SizedBox(height: 30.h),
              Container(
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: AppColors.kGreen100,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.kPrimary, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Selected Letter',
                      style: AppTypography.kBold16.copyWith(
                        color: AppColors.kGray600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      _selectedLetter!,
                      style: AppTypography.kBold24.copyWith(
                        fontSize: 48.sp,
                        color: AppColors.kPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
