import 'dart:async';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';

class VotingController extends GetxController {
  final FirebaseFirestoreService _firestore = FirebaseFirestoreService.instance;
  LobbyController get lobbyController => Get.find<LobbyController>();
  WheelController get wheelController => Get.find<WheelController>();

  List<PlayerAnswerModel> _allAnswers = [];
  List<PlayerAnswerModel> get allAnswers => _allAnswers;

  Timer? _votingTimer;
  int _timeRemaining = 10;
  int get timeRemaining => _timeRemaining;
  bool _votingCompleted = false;
  bool get votingCompleted => _votingCompleted;
  final Map<String, Map<String, bool?>> _playerVotes = {};

  @override
  void onInit() {
    super.onInit();
    _loadAnswers();
    _startVotingTimer();
  }

  @override
  void onClose() {
    _votingTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadAnswers() async {
    try {
      final sessionId = lobbyController.lobby.id ?? '';
      final roundNumber = wheelController.currentRound;

      if (sessionId.isEmpty) {
        developer.log(
          'Session ID is empty, cannot load answers',
          name: 'CategoryVotingController',
        );
        return;
      }

      // Listen to answers stream
      _firestore.streamAllAnswersForTheRound(sessionId, roundNumber).listen((
        answers,
      ) {
        _allAnswers = answers;
        _loadPlayerVotes();
        update();
      });
    } catch (e, stackTrace) {
      developer.log(
        'Error loading answers: $e',
        name: 'CategoryVotingController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _loadPlayerVotes() async {
    try {
      final voterId = await AppService.getPlayerId();
      if (voterId == null) return;

      _playerVotes.clear();

      for (final answer in _allAnswers) {
        if (answer.scoring == null) continue;

        final answerVotes = <String, bool?>{};
        for (final entry in answer.scoring!.breakdown.entries) {
          final category = entry.key;
          if (entry.value.status == AnswerEvaluationStatus.unclear) {
            // Check if this voter has already voted
            final categoryVotes = answer.votes.votes[category] ?? [];
            bool? existingVote;
            for (final vote in categoryVotes) {
              if (vote.startsWith('$voterId:')) {
                existingVote = vote.endsWith(':clear');
                break;
              }
            }
            answerVotes[category] = existingVote;
          }
        }
        if (answerVotes.isNotEmpty) {
          _playerVotes[answer.playerId] = answerVotes;
        }
      }
      update();
    } catch (e) {
      developer.log(
        'Error loading player votes: $e',
        name: 'CategoryVotingController',
      );
    }
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

  /// Get unclear answers that need voting
  List<Map<String, dynamic>> getUnclearAnswers() {
    final unclearAnswers = <Map<String, dynamic>>[];

    for (final answer in _allAnswers) {
      if (answer.scoring == null) continue;

      for (final entry in answer.scoring!.breakdown.entries) {
        final category = entry.key;
        final categoryScore = entry.value;

        if (categoryScore.status == AnswerEvaluationStatus.unclear) {
          final answerText = answer.answers[category.toLowerCase()] ?? '';
          if (answerText.isNotEmpty) {
            unclearAnswers.add({
              'answerPlayerId': answer.playerId,
              'answerPlayerName': answer.playerName,
              'category': category,
              'answer': answerText,
            });
          }
        }
      }
    }

    return unclearAnswers;
  }

  bool? getPlayerVote(String answerPlayerId, String category) {
    return _playerVotes[answerPlayerId]?[category];
  }

  Future<void> submitVote({
    required String answerPlayerId,
    required String category,
    required bool isClear,
  }) async {
    try {
      final voterId = await AppService.getPlayerId();
      if (voterId == null) {
        throw Exception('Player ID not found');
      }

      if (voterId == answerPlayerId) {
        developer.log(
          'Cannot vote on own answer',
          name: 'CategoryVotingController',
        );
        return;
      }

      final sessionId = lobbyController.lobby.id ?? '';
      final roundNumber = wheelController.currentRound;

      if (sessionId.isEmpty) {
        throw Exception('Session ID is empty');
      }

      await _firestore.submitCategoryVote(
        sessionId: sessionId,
        roundNumber: roundNumber,
        answerPlayerId: answerPlayerId,
        category: category,
        voterId: voterId,
        isClear: isClear,
      );

      // Update local state
      _playerVotes.putIfAbsent(answerPlayerId, () => {})[category] = isClear;

      // Reload answers to get updated votes
      await _loadPlayerVotes();
      update();

      developer.log(
        'Vote submitted: $voterId voted ${isClear ? "clear" : "unclear"} for $answerPlayerId\'s $category',
        name: 'CategoryVotingController',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error submitting vote: $e',
        name: 'CategoryVotingController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _completeVoting() async {
    if (_votingCompleted) return;
    _votingCompleted = true;

    try {
      final sessionId = lobbyController.lobby.id ?? '';
      final roundNumber = wheelController.currentRound;

      if (sessionId.isEmpty) {
        throw Exception('Session ID is empty');
      }

      await _firestore.processVotingResults(
        sessionId: sessionId,
        roundNumber: roundNumber,
      );

      developer.log(
        'Voting completed and scores updated',
        name: 'CategoryVotingController',
      );

      update();
    } catch (e, stackTrace) {
      developer.log(
        'Error completing voting: $e',
        name: 'CategoryVotingController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  bool hasUnclearAnswers() {
    return getUnclearAnswers().isNotEmpty;
  }
}
