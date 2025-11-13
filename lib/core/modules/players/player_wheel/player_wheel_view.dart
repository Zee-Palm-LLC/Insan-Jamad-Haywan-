import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/answers_host/answers_host_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/letter_generator/components/fortune_wheel.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/letter_generator/components/player_fortune_wheel_widget.dart';
import 'package:insan_jamd_hawan/core/modules/players/player_answers/player_answer_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class PlayerWheelView extends StatelessWidget {
  const PlayerWheelView({super.key, this.letter});
  final String? letter;

  LobbyController get controller => Get.find<LobbyController>();
  WheelController get wheelController => Get.find<WheelController>();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBg(
        showHorizontalLines: true,
        child: Obx(
          () =>
              wheelController.roundStatus.containsKey(
                    "${wheelController.currentRound}",
                  ) &&
                  wheelController
                          .roundStatus["${wheelController.currentRound}"] ==
                      "started"
              ? const PlayerAnswerView()
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.h),
                  child: StreamBuilder(
                    stream: FirebaseFirestoreService.instance.streamGameSession(
                      controller.lobby.id!,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.data?.config.startCounting == true) {
                        return SizedBox(
                          height: context.height,
                          child: AnswersHostView(
                            letter: snapshot.data?.config.currentSelectedLetter,
                            isHost: false,
                          ),
                        );
                      }
                      return Center(
                        child: DesktopWrapper(
                          child: Column(
                            children: [
                              if (!isDesktop) SizedBox(height: 50.h),
                              GameLogo(),
                              SizedBox(height: 12.h),
                              RoomCodeText(iSend: false, lobbyId: 'XYZ124'),
                              SizedBox(height: 50.h),

                              //TDOD: We will replace it with isWheelSpinning  from firebase stream
                              // if (wheelController.roundStatus.values.contains(
                              //   "pending",
                              // )) ...[
                              //   Column(
                              //     children: [
                              //       CircularProgressIndicator(),
                              //       SizedBox(height: 20.h),
                              //       Text(
                              //         'Host is spinning the wheel...',
                              //         style: TextStyle(
                              //           fontSize: 18.sp,
                              //           color: AppColors.kBlack,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ],

                              // Show wheel spinning state or selected letter
                              if (letter == null)
                                Column(
                                  children: [
                                    Text(
                                      'Waiting for host to select a letter...',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppColors.kWhite,
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    PlayerFortuneWheelWidget(showAnimation: false),
                                  ],
                                )
                              else if (letter != null)
                                PlayerFortuneWheelWidget(showAnimation: false)
                              else
                                Text(
                                  'Waiting for host...',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppColors.kWhite,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
