import 'dart:developer' as developer;
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/services/openai/openai_client.dart';

class AnswerEvaluationService {
  static final AnswerEvaluationService instance = AnswerEvaluationService._();
  AnswerEvaluationService._();

  final FirebaseFirestoreService _firestore = FirebaseFirestoreService.instance;
  final OpenAIClient _openAI = OpenAIClient.instance;

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

      // Get total number of players in the session
      final totalPlayers = await _firestore.getPlayerCount(sessionId);
      final submittedPlayerIds = allAnswers
          .map((answer) => answer.playerId)
          .toSet();
      final submittedCount = submittedPlayerIds.length;

      developer.log(
        'Submission check: $submittedCount/$totalPlayers players submitted answers',
        name: 'AnswerEvaluationService',
      );

      // Only proceed if all players have submitted their answers
      if (submittedCount < totalPlayers) {
        developer.log(
          'Not all players have submitted answers yet. Waiting for remaining ${totalPlayers - submittedCount} player(s)',
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
              'usedDoublePoints': answer.usedDoublePoints,
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

      // Build player ID mapping for placeholder support
      final playerIdMap = <String, String>{};
      for (int i = 0; i < allAnswers.length; i++) {
        final answer = allAnswers[i];
        playerIdMap['playerId${i + 1}'] = answer.playerId;
        playerIdMap[answer.playerId] = answer.playerId;
      }

      // Detect and fix duplicates to ensure all duplicates get 5 points
      _fixDuplicateEvaluations(allAnswers, evaluations, playerIdMap);

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

        developer.log(
          'Processing evaluation for player ${answer.playerId}: $playerEvaluation',
          name: 'AnswerEvaluationService',
        );

        final categoryScores = <String, CategoryScore>{};
        int totalScore = 0;
        int correctCount = 0;

        for (final entry in playerEvaluation.entries) {
          // Normalize category name to capitalized format (e.g., "name" -> "Name")
          final category = _normalizeCategoryName(entry.key);
          final evaluation = entry.value;

          // // TEST MODE: Force unclear status for testing
          // // Check if answer contains test keywords (case-insensitive)
          // final categoryKey = category.toLowerCase();
          // final answerText = (answer.answers[categoryKey] ?? '')
          //     .trim()
          //     .toLowerCase();

          // if (answerText == 'test' ||
          //     answerText == 'unclear' ||
          //     answerText == 'ambiguous' ||
          //     answerText.contains('test') ||
          //     answerText.contains('unclear')) {
          //   developer.log(
          //     'TEST MODE: Forcing unclear status for ${answer.playerName}\'s $category: "$answerText"',
          //     name: 'AnswerEvaluationService',
          //   );
          //   categoryScores[category] = CategoryScore(
          //     isCorrect: false,
          //     points: 0,
          //     status: AnswerEvaluationStatus.unclear,
          //   );
          //   totalScore += 0;
          //   continue; // Skip normal evaluation for this category
          // }

          Map<String, dynamic> evaluationMap;
          if (evaluation is Map<String, dynamic>) {
            evaluationMap = evaluation;
          } else {
            developer.log(
              'Unexpected evaluation type for category $category: ${evaluation.runtimeType}',
              name: 'AnswerEvaluationService',
            );
            continue;
          }

          String statusStr;
          int basePointsValue;

          if (evaluationMap['status'] is String) {
            statusStr = evaluationMap['status'] as String;
          } else if (evaluationMap['status'] is Map) {
            final statusMap = evaluationMap['status'] as Map<String, dynamic>;
            statusStr =
                statusMap['value'] as String? ??
                statusMap['status'] as String? ??
                'incorrect';
          } else {
            developer.log(
              'Invalid status format for category $category: ${evaluationMap['status']}',
              name: 'AnswerEvaluationService',
            );
            continue;
          }

          final status = AnswerEvaluationStatus.fromJson(statusStr);
          basePointsValue = status.points;
          final isCorrect = status == AnswerEvaluationStatus.correct;
          if (isCorrect) correctCount++;

          final finalPoints = answer.usedDoublePoints && isCorrect
              ? basePointsValue * 2
              : basePointsValue;

          categoryScores[category] = CategoryScore(
            isCorrect: isCorrect,
            points: finalPoints,
            status: status,
          );
          totalScore += finalPoints;
        }

        if (answer.usedDoublePoints) {
          int scoreWithoutDouble = 0;
          for (final score in categoryScores.values) {
            if (score.isCorrect && answer.usedDoublePoints) {
              scoreWithoutDouble += score.points ~/ 2;
            } else {
              scoreWithoutDouble += score.points;
            }
          }
          developer.log(
            'Double points applied for player ${answer.playerId}: '
            'original score would be $scoreWithoutDouble, final score: $totalScore',
            name: 'AnswerEvaluationService',
          );
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

  /// Detects duplicate answers and ensures all duplicates get 5 points
  void _fixDuplicateEvaluations(
    List<PlayerAnswerModel> allAnswers,
    Map<String, dynamic> evaluations,
    Map<String, String> playerIdMap,
  ) {
    // Categories to check for duplicates
    final categories = ['name', 'object', 'animal', 'plant', 'country'];

    for (final category in categories) {
      final normalizedCategory = _normalizeCategoryName(category);

      // Group players by their normalized answer (case-insensitive, trimmed)
      final answerGroups = <String, List<String>>{};

      for (final answer in allAnswers) {
        final answerText = (answer.answers[category] ?? '').trim();
        if (answerText.isEmpty) continue;

        final normalizedAnswer = answerText.toLowerCase();
        answerGroups
            .putIfAbsent(normalizedAnswer, () => [])
            .add(answer.playerId);
      }

      // For each group with multiple players, mark all as duplicate
      for (final entry in answerGroups.entries) {
        if (entry.value.length > 1) {
          // Multiple players have the same answer - mark all as duplicate
          developer.log(
            'Duplicate detected in $normalizedCategory: "${entry.key}" - ${entry.value.length} players',
            name: 'AnswerEvaluationService',
          );

          for (final playerId in entry.value) {
            // Try to find the evaluation using actual playerId or placeholder
            Map<String, dynamic>? playerEval =
                evaluations[playerId] as Map<String, dynamic>?;

            // If not found, try placeholder IDs
            if (playerEval == null) {
              for (final mapEntry in playerIdMap.entries) {
                if (mapEntry.value == playerId &&
                    evaluations.containsKey(mapEntry.key)) {
                  playerEval =
                      evaluations[mapEntry.key] as Map<String, dynamic>?;
                  break;
                }
              }
            }

            if (playerEval != null) {
              // Override the evaluation for this category to be duplicate
              playerEval[normalizedCategory] = {
                'status': 'duplicate',
                'points': 5,
              };
              developer.log(
                'Marked player $playerId\'s $normalizedCategory answer as duplicate (5 points)',
                name: 'AnswerEvaluationService',
              );
            }
          }
        }
      }
    }
  }

  String _normalizeCategoryName(String category) {
    if (category.isEmpty) return category;
    
    final standardCategoryMap = {
      'name': 'Name',
      'object': 'Object',
      'animal': 'Animal',
      'plant': 'Plant',
      'country': 'Country',
    };

    final lowerCategory = category.toLowerCase();
    
    // Check if it's a standard category
    if (standardCategoryMap.containsKey(lowerCategory)) {
      return standardCategoryMap[lowerCategory]!;
    }
    
    // For custom categories (like "tv show"), capitalize each word
    final words = lowerCategory.split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).toList();
    
    return capitalizedWords.join(' ');
  }

  Future<void> evaluateSpecialRound({
    required String sessionId,
    required String letter,
    required String category,
    int categoryScore = 20,
  }) async {
    try {
      developer.log(
        'Starting special round evaluation for category: $category, letter: $letter',
        name: 'AnswerEvaluationService',
      );

      final allAnswers = await _firestore.getAllSpecialRoundAnswers(sessionId);
      if (allAnswers.isEmpty) {
        developer.log(
          'No answers found for special round',
          name: 'AnswerEvaluationService',
        );
        return;
      }

      // Get total number of players in the session
      final totalPlayers = await _firestore.getPlayerCount(sessionId);
      final submittedPlayerIds = allAnswers
          .map((answer) => answer.playerId)
          .toSet();
      final submittedCount = submittedPlayerIds.length;

      developer.log(
        'Submission check: $submittedCount/$totalPlayers players submitted answers',
        name: 'AnswerEvaluationService',
      );

      // Only proceed if all players have submitted their answers
      if (submittedCount < totalPlayers) {
        developer.log(
          'Not all players have submitted answers yet. Waiting for remaining ${totalPlayers - submittedCount} player(s)',
          name: 'AnswerEvaluationService',
        );
        return;
      }

      // Normalize category to lowercase for lookup
      final categoryKey = category.toLowerCase();
      final normalizedCategory = _normalizeCategoryName(category);

      // Detect duplicates for the specified category
      final answerGroups = <String, List<String>>{};
      for (final answer in allAnswers) {
        final answerText = (answer.answers[categoryKey] ?? '').trim();
        if (answerText.isEmpty) continue;

        final normalizedAnswer = answerText.toLowerCase();
        answerGroups
            .putIfAbsent(normalizedAnswer, () => [])
            .add(answer.playerId);
      }

      // Prepare player answers data for OpenAI evaluation
      final playerAnswersData = allAnswers
          .map(
            (answer) => {
              'playerId': answer.playerId,
              'playerName': answer.playerName,
              'answers': {categoryKey: answer.answers[categoryKey] ?? ''},
              'usedDoublePoints': answer.usedDoublePoints,
            },
          )
          .toList();

      // Evaluate using OpenAI - specify only the category being evaluated
      final evaluationResult = await _openAI.evaluateAnswers(
        selectedLetter: letter,
        playerAnswers: playerAnswersData,
        categoriesToEvaluate: [categoryKey],
      );

      final evaluations =
          evaluationResult['evaluations'] as Map<String, dynamic>?;
      if (evaluations == null) {
        throw Exception('Invalid evaluation response format');
      }

      // Build player ID mapping for placeholder support
      final playerIdMap = <String, String>{};
      for (int i = 0; i < allAnswers.length; i++) {
        final answer = allAnswers[i];
        playerIdMap['playerId${i + 1}'] = answer.playerId;
        playerIdMap[answer.playerId] = answer.playerId;
      }

      // Process evaluations and apply duplicate logic
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

        // Check for duplicates
        final answerText = (answer.answers[categoryKey] ?? '').trim();
        final normalizedAnswer = answerText.toLowerCase();
        final isDuplicate = (answerGroups[normalizedAnswer]?.length ?? 0) > 1;

        // Get evaluation for the category
        final categoryEvaluation =
            playerEvaluation[normalizedCategory] as Map<String, dynamic>?;

        String statusStr;
        int basePointsValue;

        if (isDuplicate) {
          // Override with duplicate status
          statusStr = 'duplicate';
          basePointsValue = 5;
          developer.log(
            'Player ${answer.playerId}\'s $normalizedCategory answer marked as duplicate (5 points)',
            name: 'AnswerEvaluationService',
          );
        } else if (categoryEvaluation != null) {
          if (categoryEvaluation['status'] is String) {
            statusStr = categoryEvaluation['status'] as String;
          } else if (categoryEvaluation['status'] is Map) {
            final statusMap =
                categoryEvaluation['status'] as Map<String, dynamic>;
            statusStr =
                statusMap['value'] as String? ??
                statusMap['status'] as String? ??
                'incorrect';
          } else {
            statusStr = 'incorrect';
          }

          final status = AnswerEvaluationStatus.fromJson(statusStr);
          // Use custom categoryScore for correct answers, otherwise use default points
          if (status == AnswerEvaluationStatus.correct) {
            basePointsValue = categoryScore;
          } else {
            basePointsValue = status.points;
          }
        } else {
          // No evaluation found, mark as incorrect
          statusStr = 'incorrect';
          basePointsValue = 0;
        }

        final status = AnswerEvaluationStatus.fromJson(statusStr);
        final isCorrect = status == AnswerEvaluationStatus.correct;

        // Apply double points if used and answer is correct
        final finalPoints = answer.usedDoublePoints && isCorrect
            ? basePointsValue * 2
            : basePointsValue;

        final categoryScores = <String, CategoryScore>{
          normalizedCategory: CategoryScore(
            isCorrect: isCorrect,
            points: finalPoints,
            status: status,
          ),
        };

        final scoringResult = ScoringResult(
          correctAnswers: isCorrect ? 1 : 0,
          fooledPlayers: 0,
          roundScore: finalPoints,
          breakdown: categoryScores,
        );

        await _firestore.updateSpecialRoundAnswerScoring(
          sessionId,
          answer.playerId,
          scoringResult.toJson(),
        );

        // Get the session to find the current round number for special rounds
        final session = await _firestore.getSession(sessionId);
        final specialRoundNumber = session?.config.maxRounds ?? 0;
        
        // Update player score with special round points
        await _updatePlayerScore(
          sessionId,
          answer.playerId,
          specialRoundNumber, // Use maxRounds as the special round number
          finalPoints,
        );

        developer.log(
          'Evaluated player ${answer.playerId} for special round: $finalPoints points (round $specialRoundNumber)',
          name: 'AnswerEvaluationService',
        );
      }

      developer.log(
        'Special round evaluation completed for category: $category',
        name: 'AnswerEvaluationService',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error evaluating special round: $e',
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

      // Get the old round score if it exists (to avoid double-counting)
      final oldRoundScore =
          participation.scoresByRound[roundNumber.toString()] ?? 0;

      // Calculate the score difference (new score - old score)
      final scoreDifference = roundScore - oldRoundScore;

      // Update total score by adding only the difference
      final newTotalScore = participation.totalScore + scoreDifference;

      // Only increment rounds if this is a new round (not an update)
      final isNewRound = oldRoundScore == 0;
      final newRoundsPlayed = isNewRound
          ? participation.roundsPlayed + 1
          : participation.roundsPlayed;
      final newRoundsCompleted = isNewRound
          ? participation.roundsCompleted + 1
          : participation.roundsCompleted;
      final newAverageScorePerRound = newRoundsPlayed > 0
          ? newTotalScore / newRoundsPlayed.toDouble()
          : 0.0;

      developer.log(
        'Updating player $playerId score for round $roundNumber: '
        'oldRoundScore=$oldRoundScore, newRoundScore=$roundScore, '
        'scoreDifference=$scoreDifference, newTotalScore=$newTotalScore',
        name: 'AnswerEvaluationService',
      );

      await _firestore.updatePlayerScore(
        sessionId,
        playerId,
        newTotalScore,
        roundNumber.toString(),
        roundScore,
      );

      // Only update rounds count if this is a new round
      if (isNewRound) {
        await _firestore.updatePlayer(sessionId, playerId, {
          'roundsPlayed': newRoundsPlayed,
          'roundsCompleted': newRoundsCompleted,
          'averageScorePerRound': newAverageScorePerRound,
        });
      } else {
        // Just update the average if the round was already played
        await _firestore.updatePlayer(sessionId, playerId, {
          'averageScorePerRound': newAverageScorePerRound,
        });
      }
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
