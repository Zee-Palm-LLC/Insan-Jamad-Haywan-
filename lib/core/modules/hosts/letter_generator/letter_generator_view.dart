import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/answers_host/answers_host_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/letter_generator/components/fortune_wheel.dart';
import 'package:insan_jamd_hawan/core/modules/players/player_wheel/player_wheel_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class LetterGeneratorView extends StatefulWidget {
  const LetterGeneratorView({super.key});

  static const String path = '/letter-generator';
  static const String name = 'LetterGenerator';

  @override
  State<LetterGeneratorView> createState() => _LetterGeneratorViewState();
}

class _LetterGeneratorViewState extends State<LetterGeneratorView> {
  LobbyController get controller => Get.find<LobbyController>();
  bool _hasPlayedAudio = false;

  @override
  void initState() {
    super.initState();
    _playInitialAudio();
  }

  Future<void> _playInitialAudio() async {
    if (_hasPlayedAudio) return;
    _hasPlayedAudio = true;
    await AudioService.instance.playAudio(AudioType.timeToChooseLetter);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return FutureBuilder(
      future: AppService.getPlayerId(),
      builder: (context, snap) {
        if (snap.hasData == false) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        bool isHost = snap.data == controller.lobby.host;
        if (isHost == false) {
          return StreamBuilder(
            stream: FirebaseFirestoreService.instance
                .streamCurrentSelectedLetter(controller.lobby.id!),
            builder: (context, snapshot) {
              final letter = snapshot.data;
              return PlayerWheelView(letter: letter);
            },
          );
        }
        return GetBuilder<WheelController>(
          builder: (letterController) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: isDesktop
                  ? null
                  : AppBar(
                      leading: Padding(
                        padding: EdgeInsets.all(10.h),
                        child: CustomIconButton(
                          icon: AppAssets.backIcon,
                          onTap: () => context.pop(),
                        ),
                      ),
                      actions: [
                        CustomIconButton(
                          icon: AppAssets.shareIcon,
                          onTap: () {},
                        ),
                        SizedBox(width: 16.w),
                      ],
                    ),
              body: AnimatedBg(
                showHorizontalLines: true,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.h),
                  child: Center(
                    child: DesktopWrapper(
                      child: Column(
                        children: [
                          if (!isDesktop) SizedBox(height: 50.h),
                          GameLogo(),
                          SizedBox(height: 12.h),
                          GetBuilder<LobbyController>(
                            init: controller,
                            builder: (lobbyController) {
                              return RoomCodeText(
                                iSend: true,
                                lobbyId:
                                    lobbyController.currentRoom.inviteCode ??
                                    'XYZ124',
                              );
                            },
                          ),
                          SizedBox(height: 50.h),
                          FortuneWheelWidget(
                            isHost: true,
                            onSpinComplete: (va) {
                              letterController.onLetterSelection(va);
                            },
                            onCountdownComplete: (va) {},
                          ),
                          if (letterController.selectedLetter != null) ...[
                            SizedBox(height: 50.h),
                            PrimaryButton(
                              text: 'Continue..',
                              onPressed: () async {
                                letterController.createdNewRound(
                                  allocatedTime:
                                      controller.selectedTimePerRound ?? 60,
                                  wheelIndex:
                                      controller.wheelSelectedIndex ?? 0,
                                  participants: [],
                                );
                                context.push(
                                  AnswersHostView.path,
                                  extra: {
                                    'sessionId': controller.lobby.id,
                                    'roundNumber':
                                        controller
                                            .currentRoom
                                            .settings
                                            ?.currentRound ??
                                        0 + 1,
                                  },
                                );
                              },
                              width: 250.w,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
