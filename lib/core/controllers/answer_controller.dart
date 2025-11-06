import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/services/answer_submission_service.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/services/player_answer_tracker_service.dart';
import 'package:insan_jamd_hawan/core/services/round_status_monitor_service.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/scoring_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/voting/voting_view.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';

class AnswerController extends GetxController {
  final String sessionId;
  final int roundNumber;
  final String selectedLetter;
  final int totalSeconds;
  final bool isHostView;

  // Services
  final AnswerSubmissionService _submissionService = AnswerSubmissionService();
  final RoundStatusMonitorService _statusMonitor = RoundStatusMonitorService();
  final FirebaseFirestoreService _firestore = FirebaseFirestoreService.instance;
  PlayerAnswerTrackerService? _answerTracker;

  // Timer state
  Timer? _timer;
  int _secondsRemaining = 0;
  int _totalSeconds = 0;
  bool _isTimerRunning = false;
  bool _isTimerPaused = false;

  // Stop/Resume state
  Timer? _resumeTimer;
  bool _isWaitingForResume = false;
  String? _stoppedByPlayerId;

  // State
  bool roundCompleted = false;
  bool roundStopped = false;
  bool timerExpired = false;

  // Input controllers (player view only)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController objectController = TextEditingController();
  final TextEditingController animalController = TextEditingController();
  final TextEditingController plantController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  // UI state
  bool doublePoints = false;
  bool isInputEnabled = true;
  bool hasSubmitted = false;
  bool isSubmitting = false;
  String? currentPlayerId;

  AnswerController({
    required this.sessionId,
    required this.roundNumber,
    required this.selectedLetter,
    this.totalSeconds = 60,
    this.isHostView = false,
  });

  @override
  void onInit() {
    super.onInit();
    _loadPlayerInfo();
    _initializeServices();
    developer.log(
      'AnswerController (${isHostView ? 'Host' : 'Player'}) initialized: Round $roundNumber, Letter: $selectedLetter, Time: ${totalSeconds}s',
      name: 'AnswerController',
    );
  }

  Future<void> _loadPlayerInfo() async {
    currentPlayerId = await AppService.getPlayerId();
    update();
  }

  void _initializeServices() {
    // Initialize round status monitor
    _statusMonitor.startListening(
      sessionId: sessionId,
      roundNumber: roundNumber,
      onCompleted: _handleRoundCompleted,
      onVoting: _handleVotingRequired,
    );
    // Initialize timer
    _startTimer();

    // Initialize answer tracker (host view only)
    if (isHostView) {
      _answerTracker = PlayerAnswerTrackerService();
      _answerTracker!.startListening(
        sessionId: sessionId,
        roundNumber: roundNumber,
        onAnswersUpdate: () => update(),
        onPlayersUpdate: () => update(),
        onAllSubmitted: _handleAllPlayersSubmitted,
      );
    }
  }

  void _startTimer() {
    _totalSeconds = totalSeconds;
    _secondsRemaining = totalSeconds;
    _isTimerRunning = true;
    _isTimerPaused = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isTimerRunning && !_isTimerPaused && _secondsRemaining > 0) {
        _secondsRemaining--;
        update();

        if (_secondsRemaining == 10 || _secondsRemaining == 5) {
          AudioService.instance.playAudio(AudioType.click);
        }

        if (_secondsRemaining == 0) {
          _isTimerRunning = false;
          _handleTimerExpired();
          timer.cancel();
        }
      } else if (!_isTimerRunning || _isTimerPaused) {
        timer.cancel();
      }
    });

    developer.log(
      'Timer started: $_totalSeconds seconds',
      name: 'AnswerController',
    );
  }

  void _pauseTimer() {
    _isTimerPaused = true;
    developer.log('Timer paused', name: 'AnswerController');
  }

  void _resumeTimerMethod() {
    _isTimerPaused = false;
    developer.log('Timer resumed', name: 'AnswerController');
  }

  void _stopTimer() {
    _isTimerRunning = false;
    _isTimerPaused = false;
    _timer?.cancel();
    developer.log('Timer stopped', name: 'AnswerController');
  }

  int get _secondsRemainingValue => _secondsRemaining;

  String get _formattedTime {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get _timerProgress {
    if (_totalSeconds == 0) return 0.0;
    return _secondsRemaining / _totalSeconds;
  }

  void _handleTimerExpired() {
    if (timerExpired) return;

    timerExpired = true;
    _stopTimer();

    if (isHostView) {
      AudioService.instance.playAudio(AudioType.lobbyLeave);
      AppToaster.showToast(
        'Time\'s Up!',
        subTitle: 'Seems like you\'re all slow',
        type: ToastificationType.error,
      );

      developer.log(
        'Timer expired for round $roundNumber',
        name: 'AnswerController',
      );
      update();

      // Mark round as completed - triggers navigation for all players
      _statusMonitor
          .markRoundCompleted(sessionId: sessionId, roundNumber: roundNumber)
          .then((_) {
            _autoSubmitAllAndNavigate();
          });
    } else {
      if (!hasSubmitted) {
        _disableInputs();
        AudioService.instance.playAudio(AudioType.lobbyLeave);
        AppToaster.showToast(
          'Time\'s Up!',
          subTitle: 'Seems like you\'re all slow',
          type: ToastificationType.error,
        );
        _autoSubmitAnswers();
      }

      // Wait for round status change - navigation handled by _handleRoundCompleted
      update();
    }
  }

  void _handleRoundCompleted() {
    if (roundCompleted) return;

    roundCompleted = true;
    _stopTimer();

    if (isHostView) {
      update();
      _autoSubmitAllAndNavigate();
    } else {
      roundStopped = true;
      _disableInputs();

      if (!hasSubmitted) {
        _autoSubmitAnswers();
      }

      _navigateToScoring();
      update();
    }
  }

  void _handleAllPlayersSubmitted() {
    if (!isHostView || roundCompleted || timerExpired) return;

    developer.log(
      'All players have submitted! Completing round...',
      name: 'AnswerController',
    );

    // Mark round as completed - triggers navigation for all players
    _statusMonitor
        .markRoundCompleted(sessionId: sessionId, roundNumber: roundNumber)
        .then((_) {
          roundCompleted = true;
          _stopTimer();
          update();
          _autoSubmitAllAndNavigate();
        });
  }

  Future<void> _autoSubmitAnswers() async {
    // Host can also auto-submit if timer expires (they're a player too)
    developer.log(
      'Auto-submitting answers due to timeout',
      name: 'AnswerController',
    );

    final answers = _getAnswersMap();
    final playerId = currentPlayerId;
    if (playerId == null) return;

    try {
      // Get player name
      String playerName = playerId;
      if (isHostView && _answerTracker != null) {
        playerName = _answerTracker!.getPlayerName(playerId);
      }

      await _submissionService.submitAnswer(
        sessionId: sessionId,
        roundNumber: roundNumber,
        playerId: playerId,
        playerName: playerName,
        answers: answers,
        timeRemaining: 0,
        usedDoublePoints: false,
        autoSubmit: true,
      );

      hasSubmitted = true;
      _disableInputs();
      update();
    } catch (e) {
      developer.log(
        'Error auto-submitting: $e',
        name: 'AnswerController',
        error: e,
      );
    }
  }

  Future<void> _autoSubmitAllAndNavigate() async {
    if (!isHostView) return;

    try {
      final allPlayers = _answerTracker?.playerInfo.values.toList() ?? [];

      developer.log(
        'Auto-submitting answers for all players who haven\'t submitted yet',
        name: 'AnswerController',
      );

      await _submissionService.autoSubmitForPlayers(
        sessionId: sessionId,
        roundNumber: roundNumber,
        players: allPlayers,
        hasPlayerAnswered: (playerId) =>
            _answerTracker?.hasPlayerAnswered(playerId) ?? false,
      );

      // Mark round as completed - this triggers navigation for all players
      await _statusMonitor.markRoundCompleted(
        sessionId: sessionId,
        roundNumber: roundNumber,
      );

      roundCompleted = true;
      _stopTimer();
      update();

      await Future.delayed(const Duration(milliseconds: 500));

      final round = await _firestore.getRound(sessionId, roundNumber);
      if (round != null && round.status == RoundStatus.voting) {
        _handleVotingRequired(round.selectedLetter);
      } else {
        _navigateToScoring();
      }
    } catch (e, s) {
      developer.log(
        'Error in auto-submit and navigate: $e',
        name: 'AnswerController',
        error: e,
        stackTrace: s,
      );
    }
  }

  void _handleVotingRequired(String selectedLetter) {
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      developer.log(
        'Navigating to voting screen - Round $roundNumber, Letter: $selectedLetter',
        name: 'AnswerController',
      );
      context.push(
        VotingView.path.replaceAll(':letter', selectedLetter),
        extra: {'sessionId': sessionId, 'roundNumber': roundNumber},
      );
    }
  }

  void _navigateToScoring() {
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      developer.log(
        'Navigating to scoring screen - Round $roundNumber, Letter: $selectedLetter',
        name: 'AnswerController',
      );
      context.push(
        ScoringView.path.replaceAll(':letter', selectedLetter),
        extra: {'sessionId': sessionId, 'roundNumber': roundNumber},
      );
    }
  }

  void _disableInputs() {
    if (isHostView) return;
    isInputEnabled = false;
    update();
  }

  // ========== Public Methods ==========

  Future<void> submitAnswers(
    BuildContext context, {
    bool isStop = false,
    bool autoSubmit = false,
  }) async {
    if (hasSubmitted || isSubmitting) {
      developer.log('Already submitted, ignoring', name: 'AnswerController');
      return;
    }

    try {
      isSubmitting = true;
      update();

      final playerId = currentPlayerId;
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

      // Get player name
      String playerName = playerId;
      if (isHostView && _answerTracker != null) {
        playerName = _answerTracker!.getPlayerName(playerId);
      }

      await _submissionService.submitAnswer(
        sessionId: sessionId,
        roundNumber: roundNumber,
        playerId: playerId,
        playerName: playerName,
        answers: answers,
        timeRemaining: _secondsRemainingValue,
        usedDoublePoints: doublePoints,
        autoSubmit: autoSubmit,
      );

      hasSubmitted = true;
      _disableInputs();

      if (!isStop && !autoSubmit) {
        AudioService.instance.playAudio(AudioType.lobbyJoin);
        AppToaster.showToast(
          'Success!',
          subTitle: 'Your answers have been submitted',
          type: ToastificationType.success,
        );
      }

      // IMPORTANT: When someone submits, auto-submit everyone else's answers immediately
      // This ensures the round completes as soon as the first person submits

      // If host view, auto-submit all other players immediately
      if (isHostView) {
        Future.delayed(const Duration(milliseconds: 300), () async {
          // Auto-submit all remaining players
          await _autoSubmitAllAndNavigate();
        });
      } else {
        // For player view, wait for host to complete the round
        // The host will auto-submit everyone and mark round as completed
      }

      update();
    } catch (e, s) {
      developer.log(
        'Error submitting answers: $e',
        name: 'AnswerController',
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

  Future<void> showStopConfirmation(BuildContext context) async {
    if (roundStopped || hasSubmitted || roundCompleted || timerExpired) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Stop Round?', style: AppTypography.kBold24),
          content: Text(
            'Are you sure you want to stop this round? All players will be moved to the scoring screen.',
            style: AppTypography.kRegular19,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: AppTypography.kRegular19.copyWith(
                  color: AppColors.kGray600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Stop',
                style: AppTypography.kBold21.copyWith(color: AppColors.kRed500),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await stopRound(context);
    }
  }

  Future<void> stopRound(BuildContext context) async {
    if (roundStopped || hasSubmitted || roundCompleted || timerExpired) {
      return;
    }

    try {
      final playerId = currentPlayerId;
      if (playerId == null) {
        throw Exception('Player ID not found');
      }

      developer.log(
        'Player $playerId stopping round $roundNumber',
        name: 'AnswerController',
      );

      // Start stop/resume process
      _pauseTimer();
      _isWaitingForResume = true;
      _stoppedByPlayerId = playerId;

      developer.log(
        'Stop process started for player $playerId - 10 second window',
        name: 'AnswerController',
      );

      _resumeTimer?.cancel();
      _resumeTimer = Timer(const Duration(seconds: 10), () {
        if (_isWaitingForResume && _stoppedByPlayerId == playerId) {
          developer.log(
            'Player $playerId did not resume - notifying for kick',
            name: 'AnswerController',
          );

          // Handle player kick - try to get LobbyController if available
          Future.microtask(() async {
            try {
              final lobbyController = Get.find<LobbyController>();
              await lobbyController.removePlayer(
                isKick: true,
                playerIdToKick: playerId,
              );
              AppToaster.showToast(
                'Player Kicked',
                subTitle: 'Player did not resume in time',
                type: ToastificationType.warning,
              );
            } catch (e) {
              developer.log(
                'Could not kick player $playerId: LobbyController not available',
                name: 'AnswerController',
                error: e,
              );
            }
          });

          // Complete the round
          Future.microtask(() async {
            roundStopped = true;
            _disableInputs();

            await _statusMonitor.markRoundCompleted(
              sessionId: sessionId,
              roundNumber: roundNumber,
            );

            await submitAnswers(context, isStop: true);
          });
        }
      });

      AudioService.instance.playAudio(AudioType.click);
      AppToaster.showToast(
        'Round Paused',
        subTitle: 'You have 10 seconds to resume',
        type: ToastificationType.warning,
      );

      // Wait 10 seconds
      await Future.delayed(const Duration(seconds: 10));

      // If still waiting, complete the round
      if (_isWaitingForResume && _stoppedByPlayerId == playerId) {
        roundStopped = true;
        _disableInputs();

        await _statusMonitor.markRoundCompleted(
          sessionId: sessionId,
          roundNumber: roundNumber,
        );

        await submitAnswers(context, isStop: true);
      }
    } catch (e, s) {
      developer.log(
        'Error stopping round: $e',
        name: 'AnswerController',
        error: e,
        stackTrace: s,
      );

      AppToaster.showToast(
        'Error',
        subTitle: 'Failed to stop round. Please try again.',
        type: ToastificationType.error,
      );

      _cancelStopResume();
      _resumeTimerMethod();
      update();
    }
  }

  Future<void> resumeRound() async {
    final playerId = currentPlayerId ?? '';
    if (!_isWaitingForResume || _stoppedByPlayerId != playerId) {
      return;
    }

    developer.log('Player $playerId resuming round', name: 'AnswerController');

    _resumeTimer?.cancel();
    _isWaitingForResume = false;
    _stoppedByPlayerId = null;

    _resumeTimerMethod();
    AudioService.instance.playAudio(AudioType.click);
    AppToaster.showToast(
      'Round Resumed',
      subTitle: 'Round continues',
      type: ToastificationType.success,
    );
    update();
  }

  void _cancelStopResume() {
    _resumeTimer?.cancel();
    _isWaitingForResume = false;
    _stoppedByPlayerId = null;
    developer.log('Stop process cancelled', name: 'AnswerController');
  }

  void toggleDoublePoints() {
    if (!isInputEnabled || hasSubmitted) return;
    doublePoints = !doublePoints;
    update();
  }

  Map<String, String> _getAnswersMap() {
    return {
      'Name': nameController.text.trim(),
      'Object': objectController.text.trim(),
      'Animal': animalController.text.trim(),
      'Plant': plantController.text.trim(),
      'Country': countryController.text.trim(),
    };
  }

  bool get isHost =>
      currentPlayerId != null &&
      _answerTracker?.hostId != null &&
      currentPlayerId == _answerTracker!.hostId;

  bool get hostHasAnswered =>
      isHostView &&
      isHost &&
      currentPlayerId != null &&
      (_answerTracker?.hasPlayerAnswered(currentPlayerId!) ?? false);

  String get formattedTime => _formattedTime;

  double get timerProgress => _timerProgress;

  Color get timerColor {
    final remaining = _secondsRemainingValue;
    if (remaining > totalSeconds * 0.5) {
      return Colors.green;
    } else if (remaining > totalSeconds * 0.25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Map<String, List<Map<String, dynamic>>> get answersByCategory {
    if (!isHostView || _answerTracker == null) return {};
    return _answerTracker!.getAnswersByCategory(
      roundCompleted: roundCompleted,
      timerExpired: timerExpired,
    );
  }

  String? getPlayerAvatar(String playerId) =>
      _answerTracker?.getPlayerAvatar(playerId);

  String getPlayerName(String playerId) =>
      _answerTracker?.getPlayerName(playerId) ?? playerId;

  int get answeredPlayersCount => _answerTracker?.answeredPlayersCount ?? 0;

  int get totalPlayersCount => _answerTracker?.totalPlayersCount ?? 0;

  bool hasPlayerAnswered(String playerId) =>
      _answerTracker?.hasPlayerAnswered(playerId) ?? false;

  PlayerAnswerModel? getPlayerAnswer(String playerId) =>
      _answerTracker?.getPlayerAnswer(playerId);

  @override
  void onClose() {
    _timer?.cancel();
    _resumeTimer?.cancel();
    _statusMonitor.dispose();
    _answerTracker?.dispose();

    if (!isHostView) {
      nameController.dispose();
      objectController.dispose();
      animalController.dispose();
      plantController.dispose();
      countryController.dispose();
    }

    developer.log('AnswerController disposed', name: 'AnswerController');
    super.onClose();
  }
}
