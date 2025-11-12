import 'dart:async';
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
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/final_round_scoreboard.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/scoreboard_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/components/scoring_playing_tile.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/voting/voting_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class ScoringView extends StatefulWidget {
  const ScoringView({super.key, required this.selectedAlphabet});

  final String selectedAlphabet;

  static const String path = '/scoring/:letter';
  static const String name = 'Scoring';

  @override
  State<ScoringView> createState() => _ScoringViewState();
}

class _ScoringViewState extends State<ScoringView> {
  LobbyController get lobbyController => Get.find<LobbyController>();
  WheelController get wheelController => Get.find<WheelController>();
  Timer? _navigationTimer;
  bool _hasNavigated = false;
  bool _hasPlayedCreativeAudio = false;
  final Set<String> _playedAnswerKeys = {};
  final Set<String> _playedCategoryKeys = {};

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _scheduleNavigation() {
    if (_hasNavigated) return;

    _navigationTimer?.cancel();
    _navigationTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && !_hasNavigated) {
        _hasNavigated = true;
        final bool isFinalRound =
            wheelController.maxRoundSelectedByTheHost ==
            wheelController.currentRound;

        if (isFinalRound) {
          context.pushReplacement(FinalRoundScoreboard.path);
        } else {
          context.pushReplacement(ScoreboardView.path);
        }
      }
    });
  }

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
    int categoryIndex = 0;

    for (String category in categories) {
      List<Map<String, dynamic>> categoryAnswers = [];

      for (var playerAnswer in currentRoundPlayersAnswers) {
        String answer = playerAnswer.answers[category.toLowerCase()] ?? '';
        if (answer.isNotEmpty) {
          final categoryKey = categoryLabels[category] ?? category;
          final categoryScore = playerAnswer.scoring?.breakdown[categoryKey];
          categoryAnswers.add({
            'playerName': playerAnswer.playerName,
            'answer': answer,
            'points': categoryScore?.points ?? 0,
            'isCorrect': categoryScore?.isCorrect ?? false,
            'status': categoryScore?.status,
          });
        }
      }

      if (categoryAnswers.isNotEmpty) {
        final categoryKey = category;
        final isFirstCategory = categoryIndex == 0;
        
        // Play nextCategory audio for categories after the first one
        if (!isFirstCategory && !_playedCategoryKeys.contains(categoryKey)) {
          _playedCategoryKeys.add(categoryKey);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AudioService.instance.playAudio(AudioType.nextCategory);
          });
        }

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
                  _buildAnswerTileWithSound(
                    categoryAnswers[i],
                    i + 1,
                    categoryKey,
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
        categoryIndex++;
      }
    }

    return widgets;
  }

  Widget _buildAnswerTileWithSound(
    Map<String, dynamic> answerData,
    int index,
    String categoryKey,
  ) {
    final answerKey = '${answerData['playerName']}_${answerData['answer']}_$categoryKey';
    final points = answerData['points'] as int;
    
    return ScoringPlayingTile(
      imagePath: '',
      name: answerData['playerName'] as String,
      answer: answerData['answer'] as String,
      points: points,
      status: answerData['status'] as AnswerEvaluationStatus?,
      index: index,
      onReveal: () {
        // Play pop sound when answer is revealed
        if (!_playedAnswerKeys.contains(answerKey)) {
          _playedAnswerKeys.add(answerKey);
          AudioService.instance.playAudio(AudioType.answerRevealPop);
          
          // Play cash sound after a short delay if points > 0
          if (points > 0) {
            Future.delayed(const Duration(milliseconds: 400), () {
              AudioService.instance.playAudio(AudioType.pointsCash);
            });
          }
        }
      },
    );
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
            // Play creative audio when answers are first displayed
            if (!_hasPlayedCreativeAudio) {
              _hasPlayedCreativeAudio = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AudioService.instance.playAudio(AudioType.creative);
              });
            }
            
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scheduleNavigation();
            });

            return GetBuilder<AnswerController>(
              builder: (controller) {
                return Scaffold(
                  extendBodyBehindAppBar: true,
                  // appBar: isDesktop
                  //     ? null
                  //     : AppBar(
                  //         leading: Padding(
                  //           padding: EdgeInsets.all(10.h),
                  //           child: CustomIconButton(
                  //             icon: AppAssets.backIcon,
                  //             onTap: () => context.pop(),
                  //           ),
                  //         ),
                  //         actions: [
                  //           CustomIconButton(
                  //             icon: AppAssets.shareIcon,
                  //             onTap: () {},
                  //           ),
                  //           SizedBox(width: 16.w),
                  //         ],
                  //       ),
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
                                        widget.selectedAlphabet,
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
