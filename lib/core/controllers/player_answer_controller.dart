import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/round_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';

class PlayerAnswerController extends GetxController {
  final String sessionId;
  final int roundNumber;
  final String selectedLetter;
  final int totalSeconds;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController objectController = TextEditingController();
  final TextEditingController animalController = TextEditingController();
  final TextEditingController plantController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  bool doublePoints = false;
  int secondsRemaining = 0;
  bool isInputEnabled = true;
  bool hasSubmitted = false;
  bool roundStopped = false;
  bool timerExpired = false;
  String? stoppedByPlayerId;
  bool isSubmitting = false;

  // Streams and timers
  Timer? _countdownTimer;
  StreamSubscription<RoundModel?>? _roundSubscription;

  PlayerAnswerController({
    required this.sessionId,
    required this.roundNumber,
    required this.selectedLetter,
    this.totalSeconds = 60,
  });

  @override
  void onInit() {
    super.onInit();
    secondsRemaining = totalSeconds;
    _startTimer();
    _listenToRoundUpdates();
    developer.log(
      'PlayerAnswerController initialized: Round $roundNumber, Letter: $selectedLetter, Time: ${totalSeconds}s',
      name: 'PlayerAnswer',
    );
  }

  /// Start countdown timer
  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0 && !roundStopped) {
        secondsRemaining--;
        update();

        if (secondsRemaining == 10) {
          AudioService.instance.playAudio(AudioType.click);
        } else if (secondsRemaining == 5) {
          AudioService.instance.playAudio(AudioType.click);
        }

        if (secondsRemaining == 0) {
          _handleTimerExpired();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _listenToRoundUpdates() {
    _roundSubscription = FirebaseFirestoreService.instance
        .listenToRound(sessionId, roundNumber)
        .listen(
          (round) {
            if (round != null && round.status == RoundStatus.completed) {
              if (!roundStopped && !timerExpired) {
                roundStopped = true;
                _disableInputs();
                AudioService.instance.playAudio(AudioType.click);

                AppToaster.showToast(
                  'Round Stopped!',
                  subTitle: 'Someone stopped you',
                  type: ToastificationType.warning,
                );

                developer.log(
                  'Round stopped by another player',
                  name: 'PlayerAnswer',
                );
                update();
              }
            }
          },
          onError: (error) {
            developer.log(
              'Error listening to round updates: $error',
              name: 'PlayerAnswer',
              error: error,
            );
          },
        );
  }

  void _handleTimerExpired() {
    if (timerExpired || roundStopped) return;

    timerExpired = true;
    _disableInputs();
    _countdownTimer?.cancel();

    AudioService.instance.playAudio(AudioType.lobbyLeave);
    AppToaster.showToast(
      'Time\'s Up!',
      subTitle: 'Seems like you\'re all slow',
      type: ToastificationType.error,
    );

    developer.log('Timer expired for round $roundNumber', name: 'PlayerAnswer');

    if (!hasSubmitted) {
      _autoSubmitAnswers();
    }

    update();
  }

  Future<void> _autoSubmitAnswers() async {
    developer.log(
      'Auto-submitting answers due to timeout',
      name: 'PlayerAnswer',
    );
    await submitAnswers(Get.context!, autoSubmit: true);
  }

  void _disableInputs() {
    isInputEnabled = false;
    update();
  }

  void toggleDoublePoints() {
    if (!isInputEnabled || hasSubmitted) return;
    doublePoints = !doublePoints;
    update();
  }

  Future<void> stopRound(BuildContext context) async {
    if (roundStopped || hasSubmitted || isSubmitting) return;

    try {
      isSubmitting = true;
      update();

      final playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID not found');
      }

      developer.log(
        'Player $playerId stopping round $roundNumber',
        name: 'PlayerAnswer',
      );

      await FirebaseFirestoreService.instance.updateRoundStatus(
        sessionId,
        roundNumber,
        RoundStatus.completed,
      );

      roundStopped = true;
      stoppedByPlayerId = playerId;
      _disableInputs();
      _countdownTimer?.cancel();

      AudioService.instance.playAudio(AudioType.click);

      await submitAnswers(context, isStop: true);

      developer.log('Round stopped successfully', name: 'PlayerAnswer');
    } catch (e, s) {
      developer.log(
        'Error stopping round: $e',
        name: 'PlayerAnswer',
        error: e,
        stackTrace: s,
      );

      AppToaster.showToast(
        'Error',
        subTitle: 'Failed to stop round. Please try again.',
        type: ToastificationType.error,
      );

      isSubmitting = false;
      update();
    }
  }

  Future<void> submitAnswers(
    BuildContext context, {
    bool isStop = false,
    bool autoSubmit = false,
  }) async {
    if (hasSubmitted || isSubmitting) {
      developer.log('Already submitted, ignoring', name: 'PlayerAnswer');
      return;
    }

    try {
      isSubmitting = true;
      update();

      final playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID not found');
      }

      final answers = _getAnswersMap();
      final hasAtLeastOneAnswer = answers.values.any(
        (answer) => answer.trim().isNotEmpty,
      );

      if (!hasAtLeastOneAnswer && !autoSubmit) {
        AppToaster.showToast(
          'No Answers',
          subTitle: 'Please fill at least one category',
          type: ToastificationType.warning,
        );
        isSubmitting = false;
        update();
        return;
      }

      final sanitizedAnswers = _sanitizeAnswers(answers);

      final answer = PlayerAnswerModel(
        playerId: playerId,
        playerName: playerId,
        answers: sanitizedAnswers,
        submittedAt: DateTime.now(),
        timeRemaining: secondsRemaining,
        usedDoublePoints: doublePoints,
        scoring: null,
        votes: VotesReceived(votes: {}),
        isSubmitted: true,
      );

      await FirebaseFirestoreService.instance.submitAnswer(
        sessionId,
        roundNumber,
        answer,
      );

      await _updateParticipantStatus(playerId);

      hasSubmitted = true;
      _disableInputs();

      developer.log(
        'Answers submitted successfully: ${sanitizedAnswers.length} categories',
        name: 'PlayerAnswer',
      );

      if (!isStop && !autoSubmit) {
        AudioService.instance.playAudio(AudioType.lobbyJoin);
        AppToaster.showToast(
          'Success!',
          subTitle: 'Your answers have been submitted',
          type: ToastificationType.success,
        );
      }

      if (context.mounted && !autoSubmit) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            context.pop();
          }
        });
      }

      update();
    } catch (e, s) {
      developer.log(
        'Error submitting answers: $e',
        name: 'PlayerAnswer',
        error: e,
        stackTrace: s,
      );

      AppToaster.showToast(
        'Error',
        subTitle: 'Failed to submit answers. Please try again.',
        type: ToastificationType.error,
      );

      isSubmitting = false;
      update();
    }
  }

  Map<String, String> _getAnswersMap() {
    return {
      'name': nameController.text.trim(),
      'object': objectController.text.trim(),
      'animal': animalController.text.trim(),
      'plant': plantController.text.trim(),
      'country': countryController.text.trim(),
    };
  }

  Map<String, String> _sanitizeAnswers(Map<String, String> answers) {
    return answers.map((category, answer) {
      String sanitized = answer.trim();

      if (sanitized.length > 50) {
        sanitized = sanitized.substring(0, 50);
      }

      sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ');

      if (sanitized.isNotEmpty) {
        sanitized = sanitized[0].toUpperCase() + sanitized.substring(1);
      }

      return MapEntry(category, sanitized);
    });
  }

  Future<void> _updateParticipantStatus(String playerId) async {
    try {
      final round = await FirebaseFirestoreService.instance.getRound(
        sessionId,
        roundNumber,
      );

      if (round != null) {
        final updatedParticipants = round.participants.map((p) {
          if (p.playerId == playerId) {
            return RoundParticipant(
              playerId: p.playerId,
              playerName: p.playerName,
              wasActive: p.wasActive,
              answered: true,
              submittedAt: DateTime.now(),
            );
          }
          return p;
        }).toList();

        await FirebaseFirestoreService.instance.updateRound(
          sessionId,
          roundNumber,
          {'participants': updatedParticipants.map((p) => p.toJson()).toList()},
        );

        developer.log('Participant status updated', name: 'PlayerAnswer');
      }
    } catch (e, s) {
      developer.log(
        'Error updating participant status: $e',
        name: 'PlayerAnswer',
        error: e,
        stackTrace: s,
      );
    }
  }

  String get formattedTime {
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get timerProgress {
    if (totalSeconds == 0) return 0.0;
    return secondsRemaining / totalSeconds;
  }

  Color get timerColor {
    if (secondsRemaining > totalSeconds * 0.5) {
      return Colors.green;
    } else if (secondsRemaining > totalSeconds * 0.25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _roundSubscription?.cancel();
    nameController.dispose();
    objectController.dispose();
    animalController.dispose();
    plantController.dispose();
    countryController.dispose();
    developer.log('PlayerAnswerController disposed', name: 'PlayerAnswer');
    super.onClose();
  }
}
