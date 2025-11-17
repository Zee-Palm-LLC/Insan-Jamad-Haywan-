import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/final_round_scoreboard.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/animations/progress_dialog.dart';
import 'package:insan_jamd_hawan/core/services/firestore/answer_evaluation_service.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';

class SurpriseRoundController extends GetxController {
  final TextEditingController answerController = TextEditingController();
  LobbyController get lobbyController => Get.find<LobbyController>();
  FirebaseFirestoreService get _db => FirebaseFirestoreService.instance;
  AnswerEvaluationService get _evaluationService =>
      AnswerEvaluationService.instance;

  List<PlayerAnswerModel> currentRoundPlayersAnswers = <PlayerAnswerModel>[];
  bool submitByAllUsers = false;
  bool isSubmitting = false;
  bool isEvaluating = false;
  StreamSubscription<int>? _submissionCountSubscription;
  StreamSubscription<int>? _timerSubscription;
  StreamSubscription<List<PlayerAnswerModel>>? _answerSubmissionListener;
  RxString formattedTime = '00:00'.obs;

  int secondsRemaining = 0;
  int totalSeconds = 30;
  bool isAutoSubmittedOnTimeout = false;
  bool isAutoSubmittedByOtherPlayer = false;
  Set<String> playersWhoSubmitted = <String>{};

  String? _selectedLetter;
  String? _selectedCategory;
  int? _categoryScore;

  String? get selectedLetter => _selectedLetter;
  String? get selectedCategory => _selectedCategory;
  int? get categoryScore => _categoryScore;

  void startTimerSync() {
    _timerSubscription?.cancel();
    final sessionId = lobbyController.lobby.id ?? "";
    _loadSpecialRoundConfig(sessionId);
    _startPeriodicTimer();
    _startAnswerSubmissionListener(sessionId);
  }

  Future<void> _loadSpecialRoundConfig(String sessionId) async {
    try {
      final session = await _db.getSession(sessionId);
      if (session != null) {
        _selectedLetter = session.config.specialRoundLetter;
        _selectedCategory = session.config.specialRoundCategory;
        _categoryScore = 20;

        update();
      }
    } catch (e) {
      log(
        'Error loading special round config: $e',
        name: 'SurpriseRoundController',
      );
    }
  }

  void _startAnswerSubmissionListener(String sessionId) async {
    _answerSubmissionListener?.cancel();

    log(
      'Starting special round answer submission listener',
      name: 'SurpriseRoundController',
    );

    _answerSubmissionListener = _db
        .streamSpecialRoundAnswers(sessionId)
        .listen(
          (answers) async {
            if (answers.isEmpty) {
              return;
            }
            await _handleAnswerSubmissions(answers);
          },
          onError: (error) {
            log(
              'Error in special round answer submission listener: $error',
              name: 'SurpriseRoundController',
              error: error,
            );
          },
        );
  }

  Future<void> _handleAnswerSubmissions(List<PlayerAnswerModel> answers) async {
    String? currentPlayerId = await AppService.getPlayerId();
    if (currentPlayerId == null) {
      log(
        'Current player ID is null, cannot process answer submissions',
        name: 'SurpriseRoundController',
      );
      return;
    }

    // Check if current player has already submitted
    bool currentPlayerHasSubmitted = answers.any(
      (answer) => answer.playerId == currentPlayerId,
    );

    log(
      'Handle submissions: isSubmitting=$isSubmitting, isAutoSubmittedByOtherPlayer=$isAutoSubmittedByOtherPlayer, currentPlayerHasSubmitted=$currentPlayerHasSubmitted',
      name: 'SurpriseRoundController',
    );

    // Only auto-submit if:
    // 1. Current player hasn't submitted yet
    // 2. Not already submitting
    // 3. Not already auto-submitted by other player
    if (!currentPlayerHasSubmitted &&
        !isSubmitting &&
        !isAutoSubmittedByOtherPlayer) {
      log(
        'Triggering auto-submit for special round',
        name: 'SurpriseRoundController',
      );
      await _autoSubmitDueToOtherPlayer();
    } else {
      log(
        'Auto-submit blocked: currentPlayerHasSubmitted=$currentPlayerHasSubmitted, isSubmitting=$isSubmitting, isAutoSubmittedByOtherPlayer=$isAutoSubmittedByOtherPlayer',
        name: 'SurpriseRoundController',
      );
    }

    currentRoundPlayersAnswers = answers;
    update();
  }

  Future<void> _autoSubmitDueToOtherPlayer() async {
    String? currentPlayerId = await AppService.getPlayerId();
    if (currentPlayerId == null) {
      log(
        'Cannot auto-submit: current player ID is null',
        name: 'SurpriseRoundController',
      );
      return;
    }

    // Set flag immediately to prevent multiple triggers
    isAutoSubmittedByOtherPlayer = true;
    update();

    try {
      await submitAnswer(
        onSuccess: () {
          log(
            'Auto-submitted answer due to other player submission',
            name: 'SurpriseRoundController',
          );

          AppToaster.showToast(
            "Auto-submitted",
            subTitle:
                "Another player submitted, so your answer was automatically submitted",
          );
        },
        showLoader: true,
        isAutoSubmitted: true,
      );
    } catch (e) {
      log('Failed to auto-submit answer: $e', name: 'SurpriseRoundController');
      AppToaster.showToast(
        "Auto-submit failed",
        subTitle: "Failed to auto-submit your answer: ${e.toString()}",
        type: ToastificationType.error,
      );
      // Reset flag on error so user can try again
      isAutoSubmittedByOtherPlayer = false;
      update();
    }
  }

  void _startPeriodicTimer() async {
    _timerSubscription?.cancel();
    totalSeconds = 60;
    secondsRemaining = 60;

    // Periodic timer
    _timerSubscription =
        Stream<int>.periodic(const Duration(seconds: 1), (x) => x).listen((
          tick,
        ) async {
          secondsRemaining--;
          wellFormattedTime();

          if ((secondsRemaining <= 0) && (isAutoSubmittedOnTimeout == false)) {
            // Set flag immediately to prevent multiple timeout submissions
            isAutoSubmittedOnTimeout = true;
            _timerSubscription?.cancel();
            _timerSubscription = null;

            await submitAnswer(
              onSuccess: () {
                log(
                  'Auto-submitted answer due to timeout',
                  name: 'SurpriseRoundController',
                );
                if (navigatorKey.currentContext != null) {
                  ProgressDialog.hide(navigatorKey.currentContext!);
                }
              },
              showLoader: true,
            );
            secondsRemaining = 0;
          }

          update();
        });
  }

  void cancelTimerSync() {
    _timerSubscription?.cancel();
    _timerSubscription = null;
    _answerSubmissionListener?.cancel();
    _answerSubmissionListener = null;
  }

  RxString wellFormattedTime() {
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;
    formattedTime.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  Future<void> submitAnswer({
    required Function onSuccess,
    bool showLoader = false,
    bool isAutoSubmitted = false,
  }) async {
    final String sessionId = lobbyController.lobby.id ?? "";

    String? playerId = await AppService.getPlayerId();
    if (playerId == null || playerId.isEmpty) {
      log(
        'Cannot submit: player ID is null or empty',
        name: 'SurpriseRoundController',
      );
      return;
    }

    // Check if this player has already submitted
    try {
      final existingAnswers = await _db
          .streamSpecialRoundAnswers(sessionId)
          .first;

      bool alreadySubmitted = existingAnswers.any(
        (answer) => answer.playerId == playerId,
      );

      if (alreadySubmitted) {
        log(
          'Player $playerId has already submitted for special round - skipping submission',
          name: 'SurpriseRoundController',
        );
        return;
      }
    } catch (e) {
      log(
        'Error checking existing submissions: $e',
        name: 'SurpriseRoundController',
      );
    }

    log(
      'submitAnswer called - isSubmitting=$isSubmitting, isAutoSubmitted=$isAutoSubmitted, showLoader=$showLoader',
      name: 'SurpriseRoundController',
    );

    _timerSubscription?.cancel();
    _timerSubscription = null;

    if (isSubmitting) {
      log(
        "Answer submission already in progress - blocked!",
        name: 'SurpriseRoundController',
      );
      return;
    }
    if (showLoader) {
      ProgressDialog(message: "Submitting your answer");
    }

    if (!showLoader && !isAutoSubmitted) {
      if (answerController.text.trim().isEmpty) {
        throw Exception("Answer should be provided");
      }
    }

    isSubmitting = true;
    update();

    try {
      String? playerId = await AppService.getPlayerId();
      String sessionId = lobbyController.lobby.id ?? "";

      if (playerId == null || playerId.isEmpty) {
        throw Exception("Player ID cannot be null or empty");
      }

      if (sessionId.isEmpty) {
        throw Exception("Session ID cannot be empty");
      }

      if (_selectedLetter == null || _selectedCategory == null) {
        throw Exception("Special round letter or category not set");
      }

      log(
        'Submitting special round answer for player: $playerId',
        name: 'SurpriseRoundController',
      );

      // Prepare answer with the category key (lowercase)
      final categoryKey = _selectedCategory!.toLowerCase();
      final answerMap = <String, String>{
        categoryKey: answerController.text.trim().toLowerCase(),
      };

      await _db.submitSpecialRoundAnswer(
        sessionId,
        PlayerAnswerModel(
          playerId: playerId,
          playerName: playerId,
          answers: answerMap,
          submittedAt: DateTime.now(),
          timeRemaining: totalSeconds - secondsRemaining,
          usedDoublePoints: false, // Special rounds don't use double points
          votes: VotesReceived(votes: {}),
        ),
      );

      log(
        'Successfully submitted special round answer for player: $playerId',
        name: 'SurpriseRoundController',
      );

      onSuccess.call();
      _allUserWhichHasSubmitTheAnswers();
    } catch (e) {
      log('Failed to submit answer: $e', name: 'SurpriseRoundController');
      rethrow;
    } finally {
      isSubmitting = false;
      update();
    }
  }

  @override
  void onClose() {
    _submissionCountSubscription?.cancel();
    _timerSubscription?.cancel();
    _answerSubmissionListener?.cancel();
    answerController.dispose();
    super.onClose();
  }

  void _allUserWhichHasSubmitTheAnswers() async {
    _submissionCountSubscription?.cancel();

    final sessionId = Get.find<LobbyController>().lobby.id ?? "";

    log(
      "Setting up submission count listener for special round: $sessionId",
      name: 'SurpriseRoundController',
    );

    _submissionCountSubscription = _db
        .streamSpecialRoundSubmissionCount(sessionId)
        .listen((submissionCount) async {
          int totalPlayers = 0;
          try {
            totalPlayers = await _db.getPlayerCount(sessionId);
            log(
              "Got player count from Firebase: $totalPlayers",
              name: 'SurpriseRoundController',
            );
          } catch (e) {
            log(
              "Error getting player count from Firebase, using lobby fallback: $e",
              name: 'SurpriseRoundController',
            );
            totalPlayers =
                Get.find<LobbyController>().lobby.players?.length ?? 0;
          }

          if (totalPlayers == 0) {
            totalPlayers =
                Get.find<LobbyController>().lobby.players?.length ?? 0;
            log(
              "Using lobby controller fallback player count: $totalPlayers",
              name: 'SurpriseRoundController',
            );
          }

          if (totalPlayers == 0) {
            log(
              "ERROR: Total players is 0, this should not happen. Skipping evaluation.",
              name: 'SurpriseRoundController',
            );
            return;
          }

          log(
            "Submission count: $submissionCount, Total players: $totalPlayers",
            name: 'SurpriseRoundController',
          );

          if (submissionCount > 0 && submissionCount == totalPlayers) {
            if (isEvaluating) {
              log(
                "Evaluation already in progress, skipping",
                name: 'SurpriseRoundController',
              );
              return;
            }

            log(
              "All $totalPlayers players have submitted, starting evaluation",
              name: 'SurpriseRoundController',
            );

            isEvaluating = true;
            _submissionCountSubscription?.cancel();

            await Future.delayed(const Duration(milliseconds: 500));

            if (_selectedLetter == null || _selectedCategory == null) {
              log(
                'Cannot evaluate: letter or category is null',
                name: 'SurpriseRoundController',
              );
              isEvaluating = false;
              return;
            }

            final context = navigatorKey.currentContext;
            log(
              "Navigation context available: ${context != null}",
              name: 'SurpriseRoundController',
            );

            if (context != null) {
              log(
                "Showing evaluation progress dialog",
                name: 'SurpriseRoundController',
              );
              ProgressDialog.show(
                context: context,
                message:
                    "Evaluating answers for letter: $_selectedLetter, category: $_selectedCategory",
                barrierDismissible: false,
              );
            } else {
              log(
                "Cannot show evaluation dialog - context is null",
                name: 'SurpriseRoundController',
              );
            }

            try {
              await _evaluationService.evaluateSpecialRound(
                sessionId: sessionId,
                letter: _selectedLetter!,
                category: _selectedCategory!,
                categoryScore: _categoryScore ?? 20,
              );

              // Hide progress dialog
              if (context != null) {
                ProgressDialog.hide(context);
              }

              // Navigate to final round scoreboard
              if (context != null) {
                log(
                  "Evaluation completed, navigating to final round scoreboard",
                  name: 'SurpriseRoundController',
                );
                context.go(FinalRoundScoreboard.path);

                AppToaster.showToast(
                  "Answer evaluation completed successfully",
                );
              } else {
                log(
                  "Navigation context is null, cannot navigate",
                  name: 'SurpriseRoundController',
                );
                AppToaster.showToast(
                  "Navigation context is not available",
                  type: ToastificationType.error,
                );
              }

              log(
                'Special round answer evaluation completed successfully',
                name: 'SurpriseRoundController',
              );
            } catch (e, stackTrace) {
              if (context != null) {
                ProgressDialog.hide(context);
              }

              log(
                'Error during special round answer evaluation: $e',
                name: 'SurpriseRoundController',
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
            log(
              "Waiting for more submissions: $submissionCount/$totalPlayers",
              name: 'SurpriseRoundController',
            );
            return;
          }
        });
  }

  void resetController() {
    log(
      'Resetting surprise round controller...',
      name: 'SurpriseRoundController',
    );

    // Cancel all subscriptions first
    _submissionCountSubscription?.cancel();
    _submissionCountSubscription = null;
    _timerSubscription?.cancel();
    _timerSubscription = null;
    _answerSubmissionListener?.cancel();
    _answerSubmissionListener = null;

    // Clear input field
    answerController.clear();

    // Reset all flags
    secondsRemaining = 0;
    totalSeconds = 60;
    formattedTime.value = '00:00';
    isSubmitting = false;
    isEvaluating = false;
    isAutoSubmittedOnTimeout = false;
    isAutoSubmittedByOtherPlayer = false;
    submitByAllUsers = false;

    // Clear all tracking sets/lists
    playersWhoSubmitted.clear();
    currentRoundPlayersAnswers.clear();

    log(
      'Surprise round controller reset completed.',
      name: 'SurpriseRoundController',
    );
    update();
  }
}
