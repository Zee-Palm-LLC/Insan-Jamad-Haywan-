import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/scoreboard_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/scoring_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/animations/progress_dialog.dart';
import 'package:insan_jamd_hawan/core/services/answer_evaluation_service.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';

class AnswerController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController objectController = TextEditingController();
  final TextEditingController animalController = TextEditingController();
  final TextEditingController plantController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  LobbyController get lobbyController => Get.find<LobbyController>();
  WheelController get wheelController => Get.find<WheelController>();
  FirebaseFirestoreService get _db => FirebaseFirestoreService.instance;
  AnswerEvaluationService get _evaluationService =>
      AnswerEvaluationService.instance;
  List<PlayerAnswerModel> currentRoundPlayersAnswers = <PlayerAnswerModel>[];
  bool submitByAllUsers = false;
  bool aiEvaluated = false;
  bool isSubmitting = false;
  bool isEvaluating = false;
  StreamSubscription<int>? _submissionCountSubscription;
  StreamSubscription<int>? _timerSubscription;

  bool doublePoints = false;
  int secondsRemaining = 0;
  int totalSeconds = 60;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    secondsRemaining = totalSeconds;
  }

  void startTimerSync() {
    _timerSubscription?.cancel();
    final sessionId = lobbyController.lobby.id ?? "";
    final currentRound = wheelController.currentRound;

    if (sessionId.isEmpty || currentRound == 0) {
      log(
        "Cannot start timer sync: sessionId=$sessionId, currentRound=$currentRound",
        name: 'AnswerController',
      );
      return;
    }

    log(
      "Starting timer sync for sessionId=$sessionId, round=$currentRound",
      name: 'AnswerController',
    );

    _timerSubscription = _db
        .streamRoundRemainingTime(sessionId, currentRound)
        .listen(
          (remainingSeconds) {
            secondsRemaining = remainingSeconds;
            totalSeconds = remainingSeconds > 0
                ? remainingSeconds
                : totalSeconds;
            update();

            log(
              "Timer updated: remaining=$remainingSeconds, total=$totalSeconds",
              name: 'AnswerController',
            );
          },
          onError: (error) {
            log(
              "Error in timer sync stream: $error",
              name: 'AnswerController',
              error: error,
            );
          },
        );
  }

  String get formattedTime {
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> autoSubmit() async {
    //listen the new document in the rounds / 1/ players & answers (answers is not empty)
    // await submitAnswers();
    //  if (wheelController.currentRound ==
    //                                     wheelController
    //                                         .maxRoundSelectedByTheHost) {
    //                                   context.push(ScoreboardView.path);
    //                                   return;
    //                                 }
    //                                 context.push(
    //                                   ScoringView.path.replaceAll(
    //                                     ":letter",
    //                                     wheelController.selectedLetter ?? "A",
    //                                   ),
    //                                   extra: {
    //                                     "selectedAlphabet":
    //                                         wheelController.selectedLetter ??
    //                                         "A",
    //                                   },
    //                                 );
  }

  Future<void> submitAnswers({required Function onSuccess}) async {
    //1- Time out //3- Auto
    //2- Submit the answers by his self
    if (isSubmitting) {
      log("Answer submission already in progress", name: 'AnswerController');
      return;
    }

    if (nameController.text.trim().isEmpty &&
        objectController.text.trim().isEmpty &&
        animalController.text.trim().isEmpty &&
        plantController.text.trim().isEmpty &&
        countryController.text.trim().isEmpty) {
      throw Exception("At least one answer should be provided");
    }

    isSubmitting = true;
    update();

    try {
      String playerName = await AppService.getPlayerId() ?? "N/A";
      String sessionId = lobbyController.lobby.id ?? "";

      if (sessionId.isEmpty) {
        throw Exception("Session ID cannot be empty");
      }

      // Submit the answers to Firestore
      await FirebaseFirestoreService.instance.submitAnswers(
        sessionId,
        PlayerAnswerModel(
          playerId: playerName,
          playerName: playerName,
          answers: {
            "name": nameController.text.toLowerCase(),
            "object": objectController.text.toLowerCase(),
            "animal": animalController.text.toLowerCase(),
            "plant": plantController.text.toLowerCase(),
            "country": countryController.text.toLowerCase(),
          },
          submittedAt: DateTime.now(),
          timeRemaining: totalSeconds - secondsRemaining,
          votes: VotesReceived(votes: {}),
        ),
      );
      onSuccess.call();
      _allUserWhichHasSubmitTheAnswers();
    } catch (e) {
      isSubmitting = false;
      update();
      rethrow;
    }
  }

  void toggleDoublePoints() {
    doublePoints = !doublePoints;
    update();
  }

  @override
  void onClose() {
    _submissionCountSubscription?.cancel();
    _timerSubscription?.cancel();
    nameController.dispose();
    objectController.dispose();
    animalController.dispose();
    plantController.dispose();
    countryController.dispose();
    super.onClose();
  }

  Stream<List<PlayerAnswerModel>> getCurrentRoundPlayerAnswers() {
    var data = _db.streamAllAnswersForTheRound(
      lobbyController.lobby.id ?? "",
      1,
    );
    log("This is the data that we have ${data.map((e) => e.toString())}");
    return data;
  }

  void _allUserWhichHasSubmitTheAnswers() {
    // Cancel previous subscription if exists
    _submissionCountSubscription?.cancel();

    _submissionCountSubscription = _db
        .streamCountOfPlayersWhoSubmittedAnswers(
          Get.find<LobbyController>().lobby.id ?? "",
          Get.find<WheelController>().currentRound,
        )
        .listen((event) async {
          log("This is the data that we have $event");
          if (event > 0 &&
              (event == Get.find<LobbyController>().lobby.players?.length)) {
            // Prevent multiple evaluations
            if (isEvaluating) {
              log("Evaluation already in progress", name: 'AnswerController');
              return;
            }

            isEvaluating = true;
            final currentRound = wheelController.currentRound;
            final selectedLetter = wheelController.selectedLetter ?? "A";
            final context = navigatorKey.currentContext;

            // Show progress dialog with selected letter
            if (context != null) {
              ProgressDialog.show(
                context: context,
                message: "Evaluating answers for letter: $selectedLetter",
                barrierDismissible: false,
              );
            }

            try {
              await _evaluationService.evaluateRound(
                sessionId: Get.find<LobbyController>().lobby.id ?? "",
                roundNumber: currentRound,
                selectedLetter: selectedLetter,
              );

              // Hide progress dialog
              if (context != null) {
                ProgressDialog.hide(context);
              }

              // Navigate to ScoringView
              if (context != null) {
                context.pushNamed(
                  ScoringView.name,
                  pathParameters: {'letter': selectedLetter},
                  extra: {"selectedAlphabet": selectedLetter},
                );

                AppToaster.showToast(
                  "Answer evaluation completed successfully",
                );

                // Check if this is the last round
                if (Get.find<WheelController>().currentRound ==
                    Get.find<WheelController>().maxRoundSelectedByTheHost) {
                  context.pushNamed(ScoreboardView.name);
                  return;
                }
              } else {
                AppToaster.showToast(
                  "Navigation context is not available",
                  type: ToastificationType.error,
                );
              }

              log(
                'Answer evaluation completed successfully',
                name: 'AnswerController',
              );
            } catch (e, stackTrace) {
              // Hide progress dialog on error
              if (context != null) {
                ProgressDialog.hide(context);
              }

              log(
                'Error during answer evaluation: $e',
                name: 'AnswerController',
                error: e,
                stackTrace: stackTrace,
              );

              AppToaster.showToast(
                "Error during evaluation: ${e.toString()}",
                type: ToastificationType.error,
              );
            } finally {
              isEvaluating = false;
            }
          } else {
            log("All users haven't submitted the answers");
            return;
          }
        });
  }

  void restController() {
    _submissionCountSubscription?.cancel();
    _timerSubscription?.cancel();
    nameController.clear();
    objectController.clear();
    animalController.clear();
    plantController.clear();
    countryController.clear();
    doublePoints = false;
    secondsRemaining = 0;
    totalSeconds = 60;
    aiEvaluated = false;
    isSubmitting = false;
    isEvaluating = false;
    update();
  }
}
