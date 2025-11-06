import 'dart:developer' as developer;
import 'package:insan_jamd_hawan/core/models/session/ambiguous_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';

class AmbiguousAnswerVotingService {
  static final AmbiguousAnswerVotingService instance =
      AmbiguousAnswerVotingService._();
  AmbiguousAnswerVotingService._();

  final FirebaseFirestoreService _firestore = FirebaseFirestoreService.instance;

  Future<List<AmbiguousAnswerModel>> createVotingItems({
    required String sessionId,
    required int roundNumber,
    required List<PlayerAnswerModel> allAnswers,
  }) async {
    final ambiguousAnswers = <AmbiguousAnswerModel>[];

    for (final answer in allAnswers) {
      if (answer.scoring == null) continue;

      final breakdown = answer.scoring!.breakdown;
      for (final entry in breakdown.entries) {
        final category = entry.key;
        final categoryScore = entry.value;

        if (categoryScore.status == AnswerEvaluationStatus.unclear) {
          final answerText = answer.answers[category];
          if (answerText == null || answerText.trim().isEmpty) continue;

          final votingItem = AmbiguousAnswerModel(
            id: '${answer.playerId}_$category',
            sessionId: sessionId,
            roundNumber: roundNumber,
            playerId: answer.playerId,
            playerName: answer.playerName,
            category: category,
            answer: answerText,
            createdAt: DateTime.now(),
            votingEndsAt: DateTime.now().add(const Duration(seconds: 10)),
            status: VotingStatus.active,
            votes: {},
            correctVotes: 0,
            incorrectVotes: 0,
          );

          await _firestore.createAmbiguousAnswer(votingItem);
          ambiguousAnswers.add(votingItem);

          developer.log(
            'Created voting item for ${answer.playerName}: $answerText ($category)',
            name: 'AmbiguousAnswerVotingService',
          );
        }
      }
    }

    return ambiguousAnswers;
  }

  Future<void> submitVote({
    required String sessionId,
    required int roundNumber,
    required String ambiguousAnswerId,
    required String voterId,
    required String voterName,
    required bool isCorrect,
  }) async {
    try {
      final ambiguousAnswer = await _firestore.getAmbiguousAnswer(
        sessionId,
        roundNumber,
        ambiguousAnswerId,
      );

      if (ambiguousAnswer == null) {
        throw Exception('Ambiguous answer not found');
      }

      if (ambiguousAnswer.status != VotingStatus.active) {
        throw Exception('Voting is not active for this answer');
      }

      if (DateTime.now().isAfter(
        ambiguousAnswer.votingEndsAt ?? DateTime.now(),
      )) {
        throw Exception('Voting time has expired');
      }

      final updatedVotes = Map<String, bool>.from(ambiguousAnswer.votes);
      final previousVote = updatedVotes[voterId];
      updatedVotes[voterId] = isCorrect;

      int correctCount = ambiguousAnswer.correctVotes;
      int incorrectCount = ambiguousAnswer.incorrectVotes;

      if (previousVote != null) {
        if (previousVote) {
          correctCount--;
        } else {
          incorrectCount--;
        }
      }

      if (isCorrect) {
        correctCount++;
      } else {
        incorrectCount++;
      }

      await _firestore.updateAmbiguousAnswerVote(
        sessionId,
        roundNumber,
        ambiguousAnswerId,
        voterId,
        isCorrect,
        correctCount,
        incorrectCount,
      );

      developer.log(
        'Vote submitted: $voterName voted ${isCorrect ? "correct" : "incorrect"}',
        name: 'AmbiguousAnswerVotingService',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error submitting vote: $e',
        name: 'AmbiguousAnswerVotingService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<Map<String, bool>> processVotingResults({
    required String sessionId,
    required int roundNumber,
    bool forceComplete = false,
  }) async {
    final ambiguousAnswers = await _firestore.getAllAmbiguousAnswers(
      sessionId,
      roundNumber,
    );

    final results = <String, bool>{};

    for (final ambiguousAnswer in ambiguousAnswers) {
      if (ambiguousAnswer.status != VotingStatus.active) continue;

      final isExpired =
          ambiguousAnswer.votingEndsAt != null &&
          DateTime.now().isAfter(ambiguousAnswer.votingEndsAt!);

      if (!isExpired && !forceComplete) continue;

      final correctVotes = ambiguousAnswer.correctVotes;
      final incorrectVotes = ambiguousAnswer.incorrectVotes;

      final finalDecision = correctVotes > incorrectVotes;
      final answerKey =
          '${ambiguousAnswer.playerId}_${ambiguousAnswer.category}';

      results[answerKey] = finalDecision;

      await _firestore.completeAmbiguousAnswerVoting(
        sessionId,
        roundNumber,
        ambiguousAnswer.id,
        finalDecision,
      );

      developer.log(
        'Voting completed for ${ambiguousAnswer.playerName}: ${ambiguousAnswer.answer} - Decision: ${finalDecision ? "Correct" : "Incorrect"}',
        name: 'AmbiguousAnswerVotingService',
      );
    }

    return results;
  }

  Future<void> updateAnswerScoringAfterVoting({
    required String sessionId,
    required int roundNumber,
    required Map<String, bool> votingResults,
  }) async {
    final allAnswers = await _firestore.getAllAnswers(sessionId, roundNumber);

    for (final answer in allAnswers) {
      if (answer.scoring == null) continue;

      final updatedBreakdown = <String, CategoryScore>{};
      bool needsUpdate = false;

      for (final entry in answer.scoring!.breakdown.entries) {
        final category = entry.key;
        final categoryScore = entry.value;
        final answerKey = '${answer.playerId}_$category';

        if (categoryScore.status == AnswerEvaluationStatus.unclear &&
            votingResults.containsKey(answerKey)) {
          final isCorrect = votingResults[answerKey]!;
          final newStatus = isCorrect
              ? AnswerEvaluationStatus.correct
              : AnswerEvaluationStatus.incorrect;
          final newPoints = newStatus.points;

          updatedBreakdown[category] = CategoryScore(
            isCorrect: isCorrect,
            points: newPoints,
            status: newStatus,
          );
          needsUpdate = true;
        } else {
          updatedBreakdown[category] = categoryScore;
        }
      }

      if (needsUpdate) {
        int newTotalScore = 0;
        int newCorrectCount = 0;
        for (final score in updatedBreakdown.values) {
          newTotalScore += score.points;
          if (score.isCorrect) newCorrectCount++;
        }

        final updatedScoring = ScoringResult(
          correctAnswers: newCorrectCount,
          fooledPlayers: answer.scoring!.fooledPlayers,
          roundScore: newTotalScore,
          breakdown: updatedBreakdown,
        );

        await _firestore.updateAnswerScoring(
          sessionId,
          roundNumber,
          answer.playerId,
          updatedScoring.toJson(),
        );

        final participation = await _firestore.getPlayer(
          sessionId,
          answer.playerId,
        );
        if (participation != null) {
          final oldRoundScore =
              participation.scoresByRound[roundNumber.toString()] ?? 0;
          final scoreDifference = newTotalScore - oldRoundScore;
          final updatedTotalScore = participation.totalScore + scoreDifference;

          await _firestore.updatePlayerScore(
            sessionId,
            answer.playerId,
            updatedTotalScore,
            roundNumber.toString(),
            newTotalScore,
          );
        }

        developer.log(
          'Updated scoring for ${answer.playerName} after voting: $newTotalScore points',
          name: 'AmbiguousAnswerVotingService',
        );
      }
    }
  }
}
