import 'dart:developer' as developer;
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/services/ambiguous_answer_voting_service.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/services/openai/openai_client.dart';

class AnswerEvaluationService {
  static final AnswerEvaluationService instance = AnswerEvaluationService._();
  AnswerEvaluationService._();

  final FirebaseFirestoreService _firestore = FirebaseFirestoreService.instance;
  final OpenAIClient _openAI = OpenAIClient.instance;
  final AmbiguousAnswerVotingService _votingService =
      AmbiguousAnswerVotingService.instance;

  Future<void> evaluateRound({
    required String sessionId,
    required int roundNumber,
    required String selectedLetter,
  }) async {
    try {
      developer.log(
        'Starting evaluation for round $roundNumber',
        name: 'AnswerEvaluationService',
      );

      final allAnswers = await _firestore.getAllAnswers(sessionId, roundNumber);
      if (allAnswers.isEmpty) {
        developer.log(
          'No answers found for round $roundNumber',
          name: 'AnswerEvaluationService',
        );
        return;
      }

      final playerAnswersData = allAnswers
          .map(
            (answer) => {
              'playerId': answer.playerId,
              'playerName': answer.playerName,
              'answers': answer.answers,
            },
          )
          .toList();

      final evaluationResult = await _openAI.evaluateAnswers(
        selectedLetter: selectedLetter,
        playerAnswers: playerAnswersData,
      );

      final evaluations =
          evaluationResult['evaluations'] as Map<String, dynamic>?;
      if (evaluations == null) {
        throw Exception('Invalid evaluation response format');
      }

      final playerIdMap = <String, String>{};
      for (int i = 0; i < allAnswers.length; i++) {
        final answer = allAnswers[i];
        playerIdMap['playerId${i + 1}'] = answer.playerId;
        playerIdMap[answer.playerId] = answer.playerId;
      }

      for (final answer in allAnswers) {
        Map<String, dynamic>? playerEvaluation =
            evaluations[answer.playerId] as Map<String, dynamic>?;

        if (playerEvaluation == null) {
          for (final entry in playerIdMap.entries) {
            if (entry.value == answer.playerId &&
                evaluations.containsKey(entry.key)) {
              playerEvaluation =
                  evaluations[entry.key] as Map<String, dynamic>?;
              developer.log(
                'Mapped placeholder ${entry.key} to player ${answer.playerId}',
                name: 'AnswerEvaluationService',
              );
              break;
            }
          }
        }

        if (playerEvaluation == null) {
          developer.log(
            'No evaluation found for player ${answer.playerId}',
            name: 'AnswerEvaluationService',
          );
          continue;
        }

        final categoryScores = <String, CategoryScore>{};
        int totalScore = 0;
        int correctCount = 0;

        for (final entry in playerEvaluation.entries) {
          final category = entry.key;
          final evaluation = entry.value as Map<String, dynamic>;
          final statusStr = evaluation['status'] as String;
          final status = AnswerEvaluationStatus.fromJson(statusStr);
          final points = status.points;

          final isCorrect = status == AnswerEvaluationStatus.correct;
          if (isCorrect) correctCount++;

          categoryScores[category] = CategoryScore(
            isCorrect: isCorrect,
            points: points,
            status: status,
          );
          totalScore += points;
        }

        final scoringResult = ScoringResult(
          correctAnswers: correctCount,
          fooledPlayers: 0,
          roundScore: totalScore,
          breakdown: categoryScores,
        );

        await _firestore.updateAnswerScoring(
          sessionId,
          roundNumber,
          answer.playerId,
          scoringResult.toJson(),
        );

        await _updatePlayerScore(
          sessionId,
          answer.playerId,
          roundNumber,
          totalScore,
        );

        developer.log(
          'Evaluated player ${answer.playerId}: $totalScore points',
          name: 'AnswerEvaluationService',
        );
      }

      final ambiguousAnswers = await _votingService.createVotingItems(
        sessionId: sessionId,
        roundNumber: roundNumber,
        allAnswers: allAnswers,
      );

      if (ambiguousAnswers.isNotEmpty) {
        developer.log(
          'Created ${ambiguousAnswers.length} voting items for ambiguous answers',
          name: 'AnswerEvaluationService',
        );
        await _firestore.updateRoundStatus(
          sessionId,
          roundNumber,
          RoundStatus.voting,
        );
      } else {
        developer.log(
          'Evaluation completed for round $roundNumber - no ambiguous answers, proceeding to scoring',
          name: 'AnswerEvaluationService',
        );
        await _firestore.updateRoundStatus(
          sessionId,
          roundNumber,
          RoundStatus.completed,
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error evaluating round: $e',
        name: 'AnswerEvaluationService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> _updatePlayerScore(
    String sessionId,
    String playerId,
    int roundNumber,
    int roundScore,
  ) async {
    try {
      final participation = await _firestore.getPlayer(sessionId, playerId);
      if (participation == null) return;

      final updatedScoresByRound = Map<String, int>.from(
        participation.scoresByRound,
      );
      updatedScoresByRound[roundNumber.toString()] = roundScore;

      final newTotalScore = participation.totalScore + roundScore;
      final newRoundsPlayed = participation.roundsPlayed + 1;
      final newRoundsCompleted = participation.roundsCompleted + 1;
      final newAverageScorePerRound =
          newTotalScore / newRoundsPlayed.toDouble();

      await _firestore.updatePlayerScore(
        sessionId,
        playerId,
        newTotalScore,
        roundNumber.toString(),
        roundScore,
      );

      await _firestore.updatePlayer(sessionId, playerId, {
        'roundsPlayed': newRoundsPlayed,
        'roundsCompleted': newRoundsCompleted,
        'averageScorePerRound': newAverageScorePerRound,
      });
    } catch (e, stackTrace) {
      developer.log(
        'Error updating player score: $e',
        name: 'AnswerEvaluationService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
