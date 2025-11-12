import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/scoring_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/animations/progress_dialog.dart';
import 'package:insan_jamd_hawan/core/services/answer_evaluation_service.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';
import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';

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
  Timer? _periodicTimer;
  DateTime? _roundEndTime;
  bool _hasPlayedFinishedSound = false;

  bool doublePoints = false;
  int secondsRemaining = 0;
  int totalSeconds = 60;
  bool isAutoSubmittedOnTimeout = false;
  bool isAutoSubmittedByOtherPlayer = false;
  Set<String> playersWhoSubmitted = <String>{};
  int currentProcessedRound = 0;
  Set<String> processedSubmissionEvents = <String>{};

  @override
  void onInit() {
    super.onInit();
    _setupAnswerSubmissionListener();
  }

  void _setupAnswerSubmissionListener() {
    // This will be called when the round starts to listen for answer submissions
    log('Answer submission listener setup completed', name: 'AnswerController');
  }

  void startTimer() {
    secondsRemaining = totalSeconds;
  }

  void startTimerSync() {
    _timerSubscription?.cancel();
    _periodicTimer?.cancel();
    final sessionId = lobbyController.lobby.id ?? "";
    final currentRound = wheelController.currentRound;

    if (sessionId.isEmpty || currentRound == 0) {
      log(
        "Cannot start timer sync: sessionId=$sessionId, currentRound=$currentRound",
        name: 'AnswerController',
      );
      return;
    }

    // Reset state for new round if round has changed
    if (currentProcessedRound != currentRound) {
      log(
        'New round detected: $currentProcessedRound -> $currentRound, resetting state',
        name: 'AnswerController',
      );
      _resetForNewRound(currentRound);
    }

    log(
      "Starting timer sync for sessionId=$sessionId, round=$currentRound",
      name: 'AnswerController',
    );

    // Start listening for answer submissions from other players
    _startAnswerSubmissionListener(sessionId, currentRound);

    _timerSubscription = _db
        .streamRoundRemainingTime(sessionId, currentRound)
        .listen(
          (remainingSeconds) {
            secondsRemaining = remainingSeconds;
            totalSeconds = remainingSeconds > 0
                ? remainingSeconds
                : totalSeconds;
            _roundEndTime = DateTime.now().add(
              Duration(seconds: remainingSeconds),
            );

            update();

            log(
              "Timer updated: remaining=$remainingSeconds, total=$totalSeconds, endTime=$_roundEndTime",
              name: 'AnswerController',
            );
            _startPeriodicTimer();
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

  void _resetForNewRound(int newRound) {
    // Reset auto-submit state
    isAutoSubmittedByOtherPlayer = false;
    isAutoSubmittedOnTimeout = false;
    playersWhoSubmitted.clear();
    processedSubmissionEvents.clear();
    currentProcessedRound = newRound;

    // Reset submission state
    isSubmitting = false;
    isEvaluating = false;

    // Cancel previous answer submission listener
    _answerSubmissionListener?.cancel();
    _answerSubmissionListener = null;

    log(
      'Answer controller reset for new round: $newRound',
      name: 'AnswerController',
    );
    update();
  }

  void _startAnswerSubmissionListener(String sessionId, int roundNumber) {
    _answerSubmissionListener?.cancel();

    log(
      'Starting answer submission listener for round $roundNumber',
      name: 'AnswerController',
    );

    _answerSubmissionListener = _db
        .streamAllAnswersForTheRound(sessionId, roundNumber)
        .listen(
          (answers) async {
            await _handleAnswerSubmissions(answers, roundNumber);
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

  Future<void> _handleAnswerSubmissions(
    List<PlayerAnswerModel> answers,
    int roundNumber,
  ) async {
    final currentRound = wheelController.currentRound;
    if (roundNumber != currentRound) {
      log(
        'Ignoring answer submissions for round $roundNumber, current round is $currentRound',
        name: 'AnswerController',
      );
      return;
    }

    String? currentPlayerId = await AppService.getPlayerId();
    if (currentPlayerId == null) {
      log(
        'Current player ID is null, cannot process answer submissions',
        name: 'AnswerController',
      );
      return;
    }

    log(
      'Processing answer submissions for round $roundNumber. Current player: $currentPlayerId',
      name: 'AnswerController',
    );
    log(
      'Received ${answers.length} submissions: ${answers.map((a) => a.playerId).join(', ')}',
      name: 'AnswerController',
    );

    bool currentPlayerSubmitted = answers.any(
      (answer) => answer.playerId == currentPlayerId,
    );

    List<PlayerAnswerModel> otherPlayersAnswers = answers
        .where((answer) => answer.playerId != currentPlayerId)
        .toList();

    log(
      'Current player submitted: $currentPlayerSubmitted, Other players count: ${otherPlayersAnswers.length}',
      name: 'AnswerController',
    );

    if (otherPlayersAnswers.isNotEmpty && !currentPlayerSubmitted) {
      log(
        'Other player(s) submitted answers: ${otherPlayersAnswers.map((a) => a.playerId).join(', ')}',
        name: 'AnswerController',
      );

      if (!isSubmitting && !isAutoSubmittedByOtherPlayer) {
        await _autoSubmitDueToOtherPlayer(
          otherPlayersAnswers.first.playerId,
          roundNumber,
        );
      }
    }

    currentRoundPlayersAnswers = answers;
    update();
  }

  Future<void> _autoSubmitDueToOtherPlayer(
    String otherPlayerId,
    int roundNumber,
  ) async {
    String? currentPlayerId = await AppService.getPlayerId();
    if (currentPlayerId == null) {
      log(
        'Cannot auto-submit: current player ID is null',
        name: 'AnswerController',
      );
      return;
    }

    if (otherPlayerId == currentPlayerId) {
      log(
        'Skipping auto-submit: other player ID matches current player ID ($otherPlayerId)',
        name: 'AnswerController',
      );
      return;
    }

    final eventId = '${otherPlayerId}_$roundNumber';
    if (processedSubmissionEvents.contains(eventId)) {
      log(
        'Already processed submission event: $eventId',
        name: 'AnswerController',
      );
      return;
    }

    processedSubmissionEvents.add(eventId);
    playersWhoSubmitted.add(otherPlayerId);

    log(
      'Auto-submitting due to other player ($otherPlayerId) submission for round $roundNumber',
      name: 'AnswerController',
    );

    isAutoSubmittedByOtherPlayer = true;

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
      isAutoSubmittedByOtherPlayer = false;

      AppToaster.showToast(
        "Auto-submit failed",
        subTitle: "Failed to auto-submit your answers: ${e.toString()}",
        type: ToastificationType.error,
      );
    }
  }

  void _startPeriodicTimer() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_roundEndTime == null) return;

      final now = DateTime.now();
      final difference = _roundEndTime!.difference(now);
      final remainingSeconds = difference.inSeconds;
      if (remainingSeconds <= 0) {
        _periodicTimer?.cancel();
      }

      if ((remainingSeconds <= 0) && (isAutoSubmittedOnTimeout == false)) {
        _periodicTimer?.cancel();
        await submitAnswers(
          onSuccess: () {
            isAutoSubmittedOnTimeout = true;
            ProgressDialog.hide(navigatorKey.currentContext!);
          },
          showLoader: true,
        );
        secondsRemaining = 0;
        _periodicTimer?.cancel();
        if (!_hasPlayedFinishedSound) {
          _hasPlayedFinishedSound = true;
          AudioService.instance.playAudio(AudioType.timerFinished);
        }
      } else {
        secondsRemaining = remainingSeconds;
        AudioService.instance.playAudio(AudioType.timer);
      }

      update();
    });
  }

  void cancelTimerSync() {
    _timerSubscription?.cancel();
    _timerSubscription = null;
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _answerSubmissionListener?.cancel();
    _answerSubmissionListener = null;
    _roundEndTime = null;
    _hasPlayedFinishedSound = false;
  }

  String get formattedTime {
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> submitAnswers({
    required Function onSuccess,
    bool showLoader = false,
    bool isAutoSubmitted = false,
  }) async {
    if (isSubmitting) {
      log("Answer submission already in progress", name: 'AnswerController');
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
    _periodicTimer?.cancel();
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

  void _allUserWhichHasSubmitTheAnswers() {
    _submissionCountSubscription?.cancel();

    final sessionId = Get.find<LobbyController>().lobby.id ?? "";
    final currentRound = Get.find<WheelController>().currentRound;

    log(
      "Setting up submission count listener for session: $sessionId, round: $currentRound",
      name: 'AnswerController',
    );

    _submissionCountSubscription = _db
        .streamCountOfPlayersWhoSubmittedAnswers(sessionId, currentRound)
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
            try {
              final round = await _db.getRound(sessionId, currentRound);
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
              await _evaluationService.evaluateRound(
                sessionId: sessionId,
                roundNumber: currentRound,
                selectedLetter: selectedLetter,
              );

              // Hide progress dialog
              if (context != null) {
                ProgressDialog.hide(context);
              }

              // Navigate to ScoringView
              if (context != null) {
                log(
                  "Navigating to scoring view with letter: $selectedLetter",
                  name: 'AnswerController',
                );
                context.pushNamed(
                  ScoringView.name,
                  pathParameters: {'letter': selectedLetter},
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
            log(
              "Waiting for more submissions: $submissionCount/$totalPlayers",
              name: 'AnswerController',
            );
            return;
          }
        });
  }

  void restController() {
    log('Resetting answer controller...', name: 'AnswerController');

    _submissionCountSubscription?.cancel();
    _timerSubscription?.cancel();
    _periodicTimer?.cancel();
    _answerSubmissionListener?.cancel();
    _roundEndTime = null;
    _hasPlayedFinishedSound = false;
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
    cancelTimerSync();
    isAutoSubmittedOnTimeout = false;
    isAutoSubmittedByOtherPlayer = false;
    playersWhoSubmitted.clear();

    currentProcessedRound = wheelController.currentRound;
    processedSubmissionEvents.clear();
    currentRoundPlayersAnswers.clear();

    log(
      'Answer controller reset completed for round $currentProcessedRound',
      name: 'AnswerController',
    );
    update();
  }
}
