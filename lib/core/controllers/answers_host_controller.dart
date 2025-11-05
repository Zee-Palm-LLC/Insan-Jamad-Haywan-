import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';
import 'dart:async';
import 'dart:developer' as developer;

class AnswersHostController extends GetxController {
  final String sessionId;
  final int roundNumber;
  final String selectedLetter;
  final int totalSeconds;

  int secondsRemaining = 0;
  bool isRunning = true;
  bool roundCompleted = false;
  bool timerExpired = false;
  String? stoppedByPlayerId;

  Map<String, PlayerAnswerModel> playerAnswers = {};
  StreamSubscription? _answersSubscription;
  StreamSubscription? _roundSubscription;
  Timer? _countdownTimer;

  AnswersHostController({
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
    _listenToAnswers();
    _listenToRoundStatus();
    developer.log(
      'AnswersHostController initialized: Round $roundNumber, Letter: $selectedLetter, Time: ${totalSeconds}s',
      name: 'AnswersHost',
    );
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0 && !roundCompleted && isRunning) {
        secondsRemaining--;
        update();

        if (secondsRemaining == 10) {
          AudioService.instance.playAudio(AudioType.click);
        } else if (secondsRemaining == 5) {
          AudioService.instance.playAudio(AudioType.click);
        }

        // Timer expired
        if (secondsRemaining == 0) {
          _handleTimerExpired();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void stopTimer() {
    isRunning = false;
    _countdownTimer?.cancel();
    update();
  }

  String get formattedTime {
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _listenToRoundStatus() {
    try {
      _roundSubscription = FirebaseFirestoreService.instance
          .listenToRound(sessionId, roundNumber)
          .listen(
            (round) {
              if (round != null && round.status == RoundStatus.completed) {
                if (!roundCompleted) {
                  _handleRoundCompleted();
                }
              }
            },
            onError: (error) {
              developer.log(
                'Error listening to round status: $error',
                name: 'AnswersHost',
                error: error,
              );
            },
          );
    } catch (e, s) {
      developer.log(
        'Error setting up round listener: $e',
        name: 'AnswersHost',
        error: e,
        stackTrace: s,
      );
    }
  }

  void _listenToAnswers() {
    try {
      _answersSubscription = FirebaseFirestoreService.instance
          .listenToAnswers(sessionId, roundNumber)
          .listen(
            (answers) {
              playerAnswers = {
                for (var answer in answers) answer.playerId: answer,
              };
              update();
              developer.log(
                'Received ${answers.length} answers for round $roundNumber',
                name: 'AnswersHost',
              );
            },
            onError: (error) {
              developer.log(
                'Error listening to answers: $error',
                name: 'AnswersHost',
                error: error,
              );
            },
          );
    } catch (e, s) {
      developer.log(
        'Error setting up answers listener: $e',
        name: 'AnswersHost',
        error: e,
        stackTrace: s,
      );
    }
  }

  void _handleRoundCompleted() {
    if (roundCompleted) return;

    roundCompleted = true;
    isRunning = false;
    _countdownTimer?.cancel();
    update();
    AudioService.instance.playAudio(AudioType.click);
    AppToaster.showToast(
      'Round Stopped!',
      subTitle: 'Someone stopped you',
      type: ToastificationType.warning,
    );

    developer.log('Round stopped by a player', name: 'AnswersHost');
  }

  /// Handle timer expiration
  void _handleTimerExpired() {
    if (timerExpired || roundCompleted) return;

    timerExpired = true;
    isRunning = false;
    _countdownTimer?.cancel();

    // Play audio and show message
    AudioService.instance.playAudio(AudioType.lobbyLeave);
    AppToaster.showToast(
      'Time\'s Up!',
      subTitle: 'Seems like you\'re all slow',
      type: ToastificationType.error,
    );

    developer.log('Timer expired for round $roundNumber', name: 'AnswersHost');
    update();
  }

  int get answeredPlayersCount => playerAnswers.length;

  bool hasPlayerAnswered(String playerId) =>
      playerAnswers.containsKey(playerId);

  PlayerAnswerModel? getPlayerAnswer(String playerId) =>
      playerAnswers[playerId];

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
    _answersSubscription?.cancel();
    _roundSubscription?.cancel();
    developer.log('AnswersHostController disposed', name: 'AnswersHost');
    super.onClose();
  }
}
