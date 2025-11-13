import 'dart:developer' as developer;
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/player_participation_model.dart';
import 'package:insan_jamd_hawan/core/models/session/round_model.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';

class AnswerSubmissionService {
  final FirebaseFirestoreService _firestore = FirebaseFirestoreService.instance;

  Future<PlayerAnswerModel> submitAnswer({
    required String sessionId,
    required int roundNumber,
    required String playerId,
    required String playerName,
    required Map<String, String> answers,
    required int timeRemaining,
    required bool usedDoublePoints,
    bool autoSubmit = false,
  }) async {
    final sanitizedAnswers = _sanitizeAnswers(answers);

    final answer = PlayerAnswerModel(
      playerId: playerId,
      playerName: playerName,
      answers: sanitizedAnswers,
      submittedAt: DateTime.now(),
      timeRemaining: timeRemaining,
      usedDoublePoints: usedDoublePoints,
      scoring: null,
      votes: VotesReceived(votes: {}),
      isSubmitted: true,
    );

    await _firestore.submitAnswer(sessionId, roundNumber, answer);
    await _updateParticipantStatus(sessionId, roundNumber, playerId);

    developer.log(
      'Answer submitted: ${sanitizedAnswers.length} categories',
      name: 'AnswerSubmissionService',
    );

    return answer;
  }

  Future<void> autoSubmitForPlayers({
    required String sessionId,
    required int roundNumber,
    required List<PlayerParticipationModel> players,
    required bool Function(String playerId) hasPlayerAnswered,
  }) async {
    final playersToSubmit = players
        .where((player) => !hasPlayerAnswered(player.playerId))
        .toList();

    developer.log(
      'Auto-submitting for ${playersToSubmit.length} players',
      name: 'AnswerSubmissionService',
    );

    for (final player in playersToSubmit) {
      try {
        final emptyAnswers = {
          'Name': '',
          'Object': '',
          'Animal': '',
          'Plant': '',
          'Country': '',
        };

        final autoAnswer = PlayerAnswerModel(
          playerId: player.playerId,
          playerName: player.playerName,
          answers: emptyAnswers,
          submittedAt: DateTime.now(),
          timeRemaining: 0,
          usedDoublePoints: false,
          scoring: null,
          votes: VotesReceived(votes: {}),
          isSubmitted: true,
        );

        await _firestore.submitAnswer(sessionId, roundNumber, autoAnswer);

        developer.log(
          'Auto-submitted for player ${player.playerId}',
          name: 'AnswerSubmissionService',
        );
      } catch (e) {
        developer.log(
          'Error auto-submitting for player ${player.playerId}: $e',
          name: 'AnswerSubmissionService',
          error: e,
        );
      }
    }
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

  Future<void> _updateParticipantStatus(
    String sessionId,
    int roundNumber,
    String playerId,
  ) async {
    try {
      final round = await _firestore.getRound(sessionId, roundNumber);

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

        await _firestore.updateRound(sessionId, roundNumber, {
          'participants': updatedParticipants.map((p) => p.toJson()).toList(),
        });

        developer.log(
          'Participant status updated for $playerId',
          name: 'AnswerSubmissionService',
        );
      }
    } catch (e, s) {
      developer.log(
        'Error updating participant status: $e',
        name: 'AnswerSubmissionService',
        error: e,
        stackTrace: s,
      );
    }
  }
}
