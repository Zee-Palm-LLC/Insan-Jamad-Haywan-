import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/models/session/game_session_model.dart';
import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/scoring_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/animations/progress_dialog.dart';
import 'package:insan_jamd_hawan/core/services/firestore/answer_evaluation_service.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';
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
  StreamSubscription<List<PlayerAnswerModel>>? _answerSubmissionListener;
  RxString formattedTime = '00:00'.obs;

  bool doublePoints = false;
  int secondsRemaining = 0;
  int totalSeconds = 60;
  bool isAutoSubmittedOnTimeout = false;
  bool isAutoSubmittedByOtherPlayer = false;
  Set<String> playersWhoSubmitted = <String>{};
  int currentProcessedRound = 0;
  Set<String> processedSubmissionEvents = <String>{};

  void startTimerSync() {
    _timerSubscription?.cancel();
    final sessionId = lobbyController.lobby.id ?? "";
    _startPeriodicTimer();
    _startAnswerSubmissionListener(sessionId);
  }

  void _startAnswerSubmissionListener(String sessionId) async {
    _answerSubmissionListener?.cancel();

    GameSessionModel? session = await _db.getCurrentGameSession(sessionId);
    int? currentRound = session?.config.currentRound;

    log(
      'Starting answer submission listener for round $currentRound',
      name: 'AnswerController',
    );

    _answerSubmissionListener = _db
        .streamAllAnswersForTheRound(sessionId, currentRound!)
        .listen(
          (answers) async {
            if (answers.isEmpty) {
              return;
            }
            await _handleAnswerSubmissions(answers);
          },
          onError: (error) {
            log(
              'Error in answer submission listener: $error',
              name: 'AnswerController',
              error: error,
            );
          },
        );
  }

  Future<void> _handleAnswerSubmissions(List<PlayerAnswerModel> answers) async {
    String sessionId = lobbyController.lobby.id ?? "";
    GameSessionModel? session = await _db.getCurrentGameSession(sessionId);
    int? currentRound = session?.config.currentRound;

    String? currentPlayerId = await AppService.getPlayerId();
    if (currentPlayerId == null) {
      log(
        'Current player ID is null, cannot process answer submissions',
        name: 'AnswerController',
      );
      return;
    }

    // Check if current player has already submitted
    bool currentPlayerHasSubmitted = answers.any(
      (answer) => answer.playerId == currentPlayerId,
    );

    log(
      'Handle submissions: round=$currentRound, isSubmitting=$isSubmitting, isAutoSubmittedByOtherPlayer=$isAutoSubmittedByOtherPlayer, currentPlayerHasSubmitted=$currentPlayerHasSubmitted',
      name: 'AnswerController',
    );

    // Only auto-submit if:
    // 1. Current player hasn't submitted yet
    // 2. Not already submitting
    // 3. Not already auto-submitted by other player
    if (!currentPlayerHasSubmitted && 
        !isSubmitting && 
        !isAutoSubmittedByOtherPlayer) {
      log(
        'Triggering auto-submit for round $currentRound',
        name: 'AnswerController',
      );
      await _autoSubmitDueToOtherPlayer(currentRound!);
    } else {
      log(
        'Auto-submit blocked: currentPlayerHasSubmitted=$currentPlayerHasSubmitted, isSubmitting=$isSubmitting, isAutoSubmittedByOtherPlayer=$isAutoSubmittedByOtherPlayer',
        name: 'AnswerController',
      );
    }

    currentRoundPlayersAnswers = answers;
    update();
  }

  Future<void> _autoSubmitDueToOtherPlayer(int roundNumber) async {
    String? currentPlayerId = await AppService.getPlayerId();
    if (currentPlayerId == null) {
      log(
        'Cannot auto-submit: current player ID is null',
        name: 'AnswerController',
      );
      return;
    }
    
    // Set flag immediately to prevent multiple triggers
    isAutoSubmittedByOtherPlayer = true;
    update();

    try {
      await submitAnswers(
        onSuccess: () {
          log(
            'Auto-submitted answers due to other player submission',
            name: 'AnswerController',
          );

          AppToaster.showToast(
            "Auto-submitted",
            subTitle:
                "Another player submitted, so your answers were automatically submitted",
          );
        },
        showLoader: true,
        isAutoSubmitted: true,
      );
    } catch (e) {
      log('Failed to auto-submit answers: $e', name: 'AnswerController');
      AppToaster.showToast(
        "Auto-submit failed",
        subTitle: "Failed to auto-submit your answers: ${e.toString()}",
        type: ToastificationType.error,
      );
      // Reset flag on error so user can try again
      isAutoSubmittedByOtherPlayer = false;
      update();
    }
    // Don't reset flag in finally - it should persist to prevent multiple auto-submissions
    // Flag will be reset in restController() when new round starts
  }

  void _startPeriodicTimer() async {
    int? _roundDuration;
    _timerSubscription?.cancel();
    final session = await _db.getCurrentGameSession(
      lobbyController.lobby.id ?? "",
    );
    if (session != null) {
      _roundDuration = session.config.defaultTimePerRound;
    }
    log("Round duration: $_roundDuration", name: 'AnswerController');
    if (_roundDuration == null) return;
    totalSeconds = _roundDuration;
    secondsRemaining = _roundDuration;

    // Periodic timer replaced with Stream.periodic and listen
    _timerSubscription =
        Stream<int>.periodic(const Duration(seconds: 1), (x) => x).listen((
          tick,
        ) async {
          if (_roundDuration == null) return;

          secondsRemaining--;
          wellFormattedTime();

          if ((secondsRemaining <= 0) && (isAutoSubmittedOnTimeout == false)) {
            // Set flag immediately to prevent multiple timeout submissions
            isAutoSubmittedOnTimeout = true;
            _timerSubscription?.cancel();
            _timerSubscription = null;
            
            await submitAnswers(
              onSuccess: () {
                log(
                  'Auto-submitted answers due to timeout',
                  name: 'AnswerController',
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

  Future<void> submitAnswers({
    required Function onSuccess,
    bool showLoader = false,
    bool isAutoSubmitted = false,
  }) async {
    // Get the current round number from Firestore before proceeding
    final String sessionId = lobbyController.lobby.id ?? "";
    GameSessionModel? session = await _db.getCurrentGameSession(sessionId);
    try {} catch (e) {
      log(
        'Failed to fetch current round from Firebase: $e',
        name: 'AnswerController',
      );
      throw Exception("Could not retrieve current round from the server.");
    }
    
    String? playerId = await AppService.getPlayerId();
    if (playerId == null || playerId.isEmpty) {
      log(
        'Cannot submit: player ID is null or empty',
        name: 'AnswerController',
      );
      return;
    }

    // Check if this player has already submitted for this round
    try {
      final existingAnswers = await _db
          .streamAllAnswersForTheRound(
            sessionId,
            session?.config.currentRound ?? 0,
          )
          .first;
      
      bool alreadySubmitted = existingAnswers.any(
        (answer) => answer.playerId == playerId,
      );
      
      if (alreadySubmitted) {
        log(
          'Player $playerId has already submitted for round ${session?.config.currentRound} - skipping submission',
          name: 'AnswerController',
        );
        return;
      }
    } catch (e) {
      log(
        'Error checking existing submissions: $e',
        name: 'AnswerController',
      );
    }
    
    log(
      'submitAnswers called for round ${session?.config.currentRound} - isSubmitting=$isSubmitting, isAutoSubmitted=$isAutoSubmitted, showLoader=$showLoader',
      name: 'AnswerController',
    );

    _timerSubscription?.cancel();
    _timerSubscription = null;
    
    if (isSubmitting) {
      log(
        "Answer submission already in progress - blocked! Round: ${session?.config.currentRound}, isAutoSubmitted: $isAutoSubmitted",
        name: 'AnswerController',
      );
      return;
    }
    if (showLoader) {
      ProgressDialog(message: "Timeout submitting the answers");
    }

    if (!showLoader && !isAutoSubmitted) {
      if (nameController.text.trim().isEmpty &&
          objectController.text.trim().isEmpty &&
          animalController.text.trim().isEmpty &&
          plantController.text.trim().isEmpty &&
          countryController.text.trim().isEmpty) {
        throw Exception("At least one answer should be provided");
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

      log('Submitting answers for player: $playerId', name: 'AnswerController');

      await FirebaseFirestoreService.instance.submitAnswers(
        sessionId,
        PlayerAnswerModel(
          playerId: playerId,
          playerName: playerId,
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

      log(
        'Successfully submitted answers for player: $playerId',
        name: 'AnswerController',
      );

      onSuccess.call();
      _allUserWhichHasSubmitTheAnswers();
    } catch (e) {
      log('Failed to submit answers: $e', name: 'AnswerController');
      rethrow;
    } finally {
      isSubmitting = false;
      update();
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
    _answerSubmissionListener?.cancel();
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

  void _allUserWhichHasSubmitTheAnswers() async {
    _submissionCountSubscription?.cancel();

    final sessionId = Get.find<LobbyController>().lobby.id ?? "";
    GameSessionModel? session = await _db.getCurrentGameSession(sessionId);
    int? currentRound = session?.config.currentRound;

    log(
      "Setting up submission count listener for session: $sessionId, round: ${session?.config.currentRound}",
      name: 'AnswerController',
    );

    _submissionCountSubscription = _db
        .streamCountOfPlayersWhoSubmittedAnswers(sessionId, currentRound!)
        .listen((submissionCount) async {
          int totalPlayers = 0;
          try {
            totalPlayers = await _db.getPlayerCount(sessionId);
            log(
              "Got player count from Firebase: $totalPlayers",
              name: 'AnswerController',
            );
          } catch (e) {
            log(
              "Error getting player count from Firebase, using lobby fallback: $e",
              name: 'AnswerController',
            );
            totalPlayers =
                Get.find<LobbyController>().lobby.players?.length ?? 0;
          }

          if (totalPlayers == 0) {
            totalPlayers =
                Get.find<LobbyController>().lobby.players?.length ?? 0;
            log(
              "Using lobby controller fallback player count: $totalPlayers",
              name: 'AnswerController',
            );
          }

          if (totalPlayers == 0) {
            log(
              "ERROR: Total players is 0, this should not happen. Skipping evaluation.",
              name: 'AnswerController',
            );
            return;
          }

          log(
            "Submission count: $submissionCount, Total players: $totalPlayers",
            name: 'AnswerController',
          );

          if (submissionCount > 0 && submissionCount == totalPlayers) {
            if (isEvaluating) {
              log(
                "Evaluation already in progress, skipping",
                name: 'AnswerController',
              );
              return;
            }

            log(
              "All $totalPlayers players have submitted, starting evaluation",
              name: 'AnswerController',
            );

            isEvaluating = true;
            _submissionCountSubscription?.cancel();

            await Future.delayed(const Duration(milliseconds: 500));

            String selectedLetter = wheelController.selectedLetter ?? "A";
            GameSessionModel? session = await _db.getCurrentGameSession(
              sessionId,
            );
            int? currentRound = session?.config.currentRound;
            try {
              final round = await _db.getRound(sessionId, currentRound ?? 0);
              if (round != null && round.selectedLetter.isNotEmpty) {
                selectedLetter = round.selectedLetter;
              }
            } catch (e) {
              log(
                'Error getting round letter, using fallback: $e',
                name: 'AnswerController',
              );
            }

            final context = navigatorKey.currentContext;
            log(
              "Navigation context available: ${context != null}",
              name: 'AnswerController',
            );

            if (context != null) {
              log(
                "Showing evaluation progress dialog",
                name: 'AnswerController',
              );
              ProgressDialog.show(
                context: context,
                message: "Evaluating answers for letter: $selectedLetter",
                barrierDismissible: false,
              );
            } else {
              log(
                "Cannot show evaluation dialog - context is null",
                name: 'AnswerController',
              );
            }

            try {
              GameSessionModel? session = await _db.getCurrentGameSession(
                sessionId,
              );
              int? currentRound = session?.config.currentRound;
              await _evaluationService.evaluateRound(
                sessionId: sessionId,
                roundNumber: currentRound!,
                selectedLetter: selectedLetter,
              );

              // Hide progress dialog
              // if (context != null) {
              //   ProgressDialog.hide(context);
              // }

              // Navigate to ScoringView
              if (context != null) {
                log(
                  "Navigating to scoring view with letter: $selectedLetter",
                  name: 'AnswerController',
                );
                context.go(
                  ScoringView.path,
                  // pathParameters: {'letter': selectedLetter},
                  extra: {"selectedAlphabet": selectedLetter},
                );

                AppToaster.showToast(
                  "Answer evaluation completed successfully",
                );
              } else {
                log(
                  "Navigation context is null, cannot navigate to scoring view",
                  name: 'AnswerController',
                );
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
              // if (context != null) {
              //   ProgressDialog.hide(context);
              // }

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
            log(
              "Waiting for more submissions: $submissionCount/$totalPlayers",
              name: 'AnswerController',
            );
            return;
          }
        });
  }

  void restController() {
    log(
      'Resetting answer controller... Current state: isSubmitting=$isSubmitting, isEvaluating=$isEvaluating, isAutoSubmittedByOtherPlayer=$isAutoSubmittedByOtherPlayer',
      name: 'AnswerController',
    );

    // Cancel all subscriptions first
    _submissionCountSubscription?.cancel();
    _submissionCountSubscription = null;
    _timerSubscription?.cancel();
    _timerSubscription = null;
    _answerSubmissionListener?.cancel();
    _answerSubmissionListener = null;

    // Clear all input fields
    nameController.clear();
    objectController.clear();
    animalController.clear();
    plantController.clear();
    countryController.clear();

    // Reset all flags
    doublePoints = false;
    secondsRemaining = 0;
    totalSeconds = 60;
    formattedTime.value = '00:00';
    aiEvaluated = false;
    isSubmitting = false;
    isEvaluating = false;
    isAutoSubmittedOnTimeout = false;
    isAutoSubmittedByOtherPlayer = false;
    submitByAllUsers = false;

    // Clear all tracking sets/lists
    playersWhoSubmitted.clear();
    processedSubmissionEvents.clear();
    currentRoundPlayersAnswers.clear();

    // Update current round tracking
    currentProcessedRound = wheelController.currentRound;

    log(
      'Answer controller reset completed for round $currentProcessedRound. All flags and listeners cleared.',
      name: 'AnswerController',
    );
    update();
  }
}
