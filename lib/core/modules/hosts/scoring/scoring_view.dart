import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/answer_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/components/scoring_playing_tile.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/voting/voting_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class ScoringView extends StatelessWidget {
  const ScoringView({super.key, required this.selectedAlphabet});

  final String selectedAlphabet;

  static const String path = '/scoring/:letter';
  static const String name = 'Scoring';

  LobbyController get lobbyController => Get.find<LobbyController>();
  WheelController get wheelController => Get.find<WheelController>();

  List<Widget> _buildCategoryAnswers(
    List<PlayerAnswerModel> currentRoundPlayersAnswers,
  ) {
    final categories = ['name', 'object', 'animal', 'plant', 'country'];
    final categoryLabels = {
      'name': 'Name',
      'object': 'Object',
      'animal': 'Animal',
      'plant': 'Plant',
      'country': 'Country',
    };

    List<Widget> widgets = [];

    for (String category in categories) {
      List<Map<String, dynamic>> categoryAnswers = [];

      for (var playerAnswer in currentRoundPlayersAnswers) {
        String answer = playerAnswer.answers[category.toLowerCase()] ?? '';
        if (answer.isNotEmpty) {
          categoryAnswers.add({
            'playerName': playerAnswer.playerName,
            'answer': answer,
            'points': playerAnswer.scoring?.breakdown[category]?.points ?? 0,
            'isCorrect':
                playerAnswer.scoring?.breakdown[category]?.isCorrect ?? false,
          });
        }
      }

      if (categoryAnswers.isNotEmpty) {
        widgets.addAll([
          Text(
            categoryLabels[category] ?? category,
            style: AppTypography.kRegular24.copyWith(height: 1),
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.all(16.h),
            child: Column(
              children: [
                for (int i = 0; i < categoryAnswers.length; i++) ...[
                  ScoringPlayingTile(
                    imagePath: '',
                    name: categoryAnswers[i]['playerName'] as String,
                    answer: categoryAnswers[i]['answer'] as String,
                    points: categoryAnswers[i]['points'] as int,
                    color: categoryAnswers[i]['isCorrect']
                        ? AppColors.kGreen100
                        : AppColors.kGray300,
                    index: i + 1,
                  ),
                  if (i != categoryAnswers.length - 1)
                    Divider(
                      color: AppColors.kGray300,
                      thickness: 1,
                      height: 16.h,
                    ),
                ],
              ],
            ),
          ),
          if (category != categories.last) SizedBox(height: 20.h),
        ]);
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    List<PlayerAnswerModel> currentRoundPlayersAnswers = [];
    return StreamBuilder(
      stream: FirebaseFirestoreService.instance.streamAllAnswersForTheRound(
        lobbyController.lobby.id ?? "",
        wheelController.currentRound,
      ),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData == false) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.data != null) {
          currentRoundPlayersAnswers = snapshot.data;
          var allPlayers = lobbyController.lobby.players;
          var answeredPlayers = snapshot.data.map((e) => e.playerName).toList();
          log(
            "This is the player length ${allPlayers?.length} and answered players: ${answeredPlayers.length}",
          );
          if (answeredPlayers.length >= (allPlayers?.length ?? 0)) {
            return GetBuilder<AnswerController>(
              builder: (controller) {
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
                  body: LobbyBg(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.h),
                      child: Center(
                        child: DesktopWrapper(
                          child: Column(
                            children: [
                              if (!isDesktop) SizedBox(height: 50.h),
                              GameLogo(),
                              SizedBox(height: 12.h),
                              RoomCodeText(
                                lobbyId: lobbyController.lobby.id ?? "N/A",
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Letter',
                                    style: AppTypography.kRegular24,
                                  ),
                                  SizedBox(width: 8.w),
                                  InkWell(
                                    onTap: () {
                                      context.push(VotingView.path);
                                    },
                                    child: Container(
                                      height: 50.h,
                                      width: 74.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.kPrimary,
                                        borderRadius: BorderRadius.circular(
                                          5.r,
                                        ),
                                      ),
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.only(top: 6.h),
                                      child: Text(
                                        selectedAlphabet,
                                        style: AppTypography.kRegular41
                                            .copyWith(
                                              color: AppColors.kWhite,
                                              height: 1,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.kGreen100,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.all(16.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Answers',
                                      style: AppTypography.kBold21.copyWith(
                                        height: 1,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    ...currentRoundPlayersAnswers.isNotEmpty
                                        ? _buildCategoryAnswers(
                                            currentRoundPlayersAnswers,
                                          )
                                        : [
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(20.h),
                                                child: Text(
                                                  'No answers submitted yet',
                                                  style:
                                                      AppTypography.kRegular24,
                                                ),
                                              ),
                                            ),
                                          ],
                                  ],
                                ),
                              ),
                              StartNextRoundButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
        return Material(
          child: Center(
            child: Text(
              'Waiting for all players to submit their answers',
              style: AppTypography.kRegular24,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

class StartNextRoundButton extends StatelessWidget {
  const StartNextRoundButton({super.key});

  LobbyController get controller => Get.find<LobbyController>();
  WheelController get wheelController => Get.find<WheelController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppService.getPlayerId(),
      builder: (context, snap) {
        if (snap.hasData == false) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        bool isHost = snap.data == controller.lobby.host;
        if (isHost) {
          return PrimaryButton(
            text:
                wheelController.maxRoundSelectedByTheHost ==
                    wheelController.currentRound
                ? 'Start Final Round'
                : 'Start Next Round',
            onPressed: () {
              wheelController.startNextRound();
              if (isHost) {
                context.pop();
                context.pop();
                context.pop();
              } else {
                context.pop();
                context.pop();
              }
            },
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
