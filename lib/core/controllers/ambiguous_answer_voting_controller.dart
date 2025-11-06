import 'dart:async';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/models/session/ambiguous_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/scoring_view.dart';
import 'package:insan_jamd_hawan/core/services/ambiguous_answer_voting_service.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';

class AmbiguousAnswerVotingController extends GetxController {
  final String sessionId;
  final int roundNumber;
  final String selectedLetter;

  final FirebaseFirestoreService _firestore = FirebaseFirestoreService.instance;
  final AmbiguousAnswerVotingService _votingService =
      AmbiguousAnswerVotingService.instance;

  List<AmbiguousAnswerModel> _ambiguousAnswers = [];
  List<AmbiguousAnswerModel> get ambiguousAnswers => _ambiguousAnswers;

  final Map<String, bool?> _playerVotes = {};
  Timer? _votingTimer;
  int _timeRemaining = 10;
  int get timeRemaining => _timeRemaining;
  bool get isVotingActive => _timeRemaining > 0 && _ambiguousAnswers.isNotEmpty;

  bool _hasPlayedNarrator = false;
  bool _votingCompleted = false;

  AmbiguousAnswerVotingController({
    required this.sessionId,
    required this.roundNumber,
    required this.selectedLetter,
  });

  @override
  void onInit() {
    super.onInit();
    _loadAmbiguousAnswers();
  }

  @override
  void onClose() {
    _votingTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadAmbiguousAnswers() async {
    try {
      _ambiguousAnswers = await _firestore.getAllAmbiguousAnswers(
        sessionId,
        roundNumber,
      );

      if (_ambiguousAnswers.isEmpty) {
        developer.log(
          'No ambiguous answers found, skipping voting',
          name: 'AmbiguousAnswerVotingController',
        );
        return;
      }

      _ambiguousAnswers = _ambiguousAnswers
          .where((a) => a.status == VotingStatus.active)
          .toList();

      if (_ambiguousAnswers.isEmpty) {
        developer.log(
          'No active ambiguous answers to vote on, navigating to scoring',
          name: 'AmbiguousAnswerVotingController',
        );
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateToScoring();
        return;
      }

      await _playNarratorAudio();
      _startVotingTimer();
      _listenToVotes();
      update();
    } catch (e, stackTrace) {
      developer.log(
        'Error loading ambiguous answers: $e',
        name: 'AmbiguousAnswerVotingController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _playNarratorAudio() async {
    if (_hasPlayedNarrator) return;
    _hasPlayedNarrator = true;
    await AudioService.instance.playAudio(AudioType.narratorCreative);
  }

  void _startVotingTimer() {
    _timeRemaining = 10;
    _votingTimer?.cancel();
    _votingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        _timeRemaining--;
        update();
      } else {
        timer.cancel();
        _completeVoting();
      }
    });
  }

  void _listenToVotes() {
    _firestore.listenToAmbiguousAnswers(sessionId, roundNumber).listen((
      answers,
    ) {
      _ambiguousAnswers = answers
          .where((a) => a.status == VotingStatus.active)
          .toList();
      update();
    });
  }

  Future<void> submitVote(String ambiguousAnswerId, bool isCorrect) async {
    if (!isVotingActive) return;

    try {
      final playerId = await AppService.getPlayerId();
      final playerName = await AppService.getPlayerId();
      if (playerId == null || playerName == null) {
        throw Exception('Player ID not found');
      }

      await _votingService.submitVote(
        sessionId: sessionId,
        roundNumber: roundNumber,
        ambiguousAnswerId: ambiguousAnswerId,
        voterId: playerId,
        voterName: playerName,
        isCorrect: isCorrect,
      );

      _playerVotes[ambiguousAnswerId] = isCorrect;
      update();

      developer.log(
        'Vote submitted: $isCorrect for answer $ambiguousAnswerId',
        name: 'AmbiguousAnswerVotingController',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error submitting vote: $e',
        name: 'AmbiguousAnswerVotingController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  bool? getPlayerVote(String ambiguousAnswerId) {
    return _playerVotes[ambiguousAnswerId];
  }

  Future<void> _completeVoting() async {
    if (_votingCompleted) return;
    _votingCompleted = true;

    try {
      final votingResults = await _votingService.processVotingResults(
        sessionId: sessionId,
        roundNumber: roundNumber,
        forceComplete: true,
      );

      await _votingService.updateAnswerScoringAfterVoting(
        sessionId: sessionId,
        roundNumber: roundNumber,
        votingResults: votingResults,
      );

      await _firestore.updateRoundStatus(
        sessionId,
        roundNumber,
        RoundStatus.completed,
      );

      developer.log(
        'Voting completed and scores updated',
        name: 'AmbiguousAnswerVotingController',
      );

      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToScoring();
    } catch (e, stackTrace) {
      developer.log(
        'Error completing voting: $e',
        name: 'AmbiguousAnswerVotingController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _navigateToScoring() {
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      developer.log(
        'Navigating to scoring after voting - Round $roundNumber, Letter: $selectedLetter',
        name: 'AmbiguousAnswerVotingController',
      );
      context.push(
        ScoringView.path.replaceAll(':letter', selectedLetter),
        extra: {'sessionId': sessionId, 'roundNumber': roundNumber},
      );
    }
  }
}
