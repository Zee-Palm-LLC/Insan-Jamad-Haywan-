import 'dart:async';
import 'dart:developer' as developer;
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/player_participation_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';

class PlayerAnswerTrackerService {
  final FirebaseFirestoreService _firestore = FirebaseFirestoreService.instance;
  StreamSubscription? _answersSubscription;
  StreamSubscription? _playersSubscription;
  StreamSubscription? _sessionSubscription;

  Map<String, PlayerAnswerModel> playerAnswers = {};
  Map<String, PlayerParticipationModel> playerInfo = {};
  String? hostId;

  Function()? onAnswersUpdated;
  Function()? onPlayersUpdated;
  Function()? onAllPlayersSubmitted;

  void startListening({
    required String sessionId,
    required int roundNumber,
    required Function() onAnswersUpdate,
    required Function() onPlayersUpdate,
    required Function() onAllSubmitted,
  }) {
    onAnswersUpdated = onAnswersUpdate;
    onPlayersUpdated = onPlayersUpdate;
    onAllPlayersSubmitted = onAllSubmitted;

    _listenToAnswers(sessionId, roundNumber);
    _listenToPlayers(sessionId);
    _listenToSession(sessionId);

    developer.log(
      'Started listening to answers and players',
      name: 'PlayerAnswerTrackerService',
    );
  }

  void _listenToAnswers(String sessionId, int roundNumber) {
    _answersSubscription = _firestore
        .listenToAnswers(sessionId, roundNumber)
        .listen(
          (answers) {
            playerAnswers = {
              for (var answer in answers) answer.playerId: answer,
            };
            developer.log(
              'Received ${answers.length} answers',
              name: 'PlayerAnswerTrackerService',
            );
            onAnswersUpdated?.call();
            _checkAllPlayersSubmitted();
          },
          onError: (error) {
            developer.log(
              'Error listening to answers: $error',
              name: 'PlayerAnswerTrackerService',
              error: error,
            );
          },
        );
  }

  void _listenToPlayers(String sessionId) {
    _playersSubscription = _firestore
        .listenToPlayers(sessionId)
        .listen(
          (players) {
            playerInfo = {for (var player in players) player.playerId: player};
            developer.log(
              'Received ${players.length} players',
              name: 'PlayerAnswerTrackerService',
            );
            onPlayersUpdated?.call();
          },
          onError: (error) {
            developer.log(
              'Error listening to players: $error',
              name: 'PlayerAnswerTrackerService',
              error: error,
            );
          },
        );
  }

  void _listenToSession(String sessionId) {
    _sessionSubscription = _firestore
        .listenToSession(sessionId)
        .listen(
          (session) {
            if (session != null) {
              hostId = session.hostId;
              developer.log(
                'Host ID updated: $hostId',
                name: 'PlayerAnswerTrackerService',
              );
            }
          },
          onError: (error) {
            developer.log(
              'Error listening to session: $error',
              name: 'PlayerAnswerTrackerService',
              error: error,
            );
          },
        );
  }

  void _checkAllPlayersSubmitted() {
    final allPlayers = playerInfo.values
        .where((player) => player.status == PlayerStatus.active)
        .toList();

    if (allPlayers.isEmpty) return;

    final submittedCount = playerAnswers.length;
    final totalCount = allPlayers.length;

    developer.log(
      'Submission check: $submittedCount/$totalCount players submitted',
      name: 'PlayerAnswerTrackerService',
    );

    if (submittedCount > 0) {
      developer.log(
        'Player submitted! Triggering auto-submit for remaining players...',
        name: 'PlayerAnswerTrackerService',
      );
      onAllPlayersSubmitted?.call();
    }
  }

  bool hasPlayerAnswered(String playerId) =>
      playerAnswers.containsKey(playerId);

  PlayerAnswerModel? getPlayerAnswer(String playerId) =>
      playerAnswers[playerId];

  String? getPlayerAvatar(String playerId) =>
      playerInfo[playerId]?.playerAvatar;

  String getPlayerName(String playerId) {
    final player = playerInfo[playerId];
    if (player != null) return player.playerName;

    final answer = playerAnswers[playerId];
    return answer?.playerName ?? playerId;
  }

  int get answeredPlayersCount => playerAnswers.length;

  int get totalPlayersCount {
    return playerInfo.values
        .where((player) => player.status == PlayerStatus.active)
        .length;
  }

  Map<String, List<Map<String, dynamic>>> getAnswersByCategory({
    required bool roundCompleted,
    required bool timerExpired,
  }) {
    if (!roundCompleted && !timerExpired) {
      return {};
    }

    final Map<String, List<Map<String, dynamic>>> categorized = {};

    const categories = ['Name', 'Object', 'Animal', 'Plant', 'Country'];
    for (final category in categories) {
      categorized[category] = [];
    }

    for (final answerEntry in playerAnswers.entries) {
      final answer = answerEntry.value;
      final playerId = answerEntry.key;
      final player = playerInfo[playerId];

      for (final categoryEntry in answer.answers.entries) {
        final category = categoryEntry.key;
        final answerText = categoryEntry.value;

        if (answerText.isNotEmpty && categorized.containsKey(category)) {
          int points = 0;
          if (answer.scoring != null &&
              answer.scoring!.breakdown.containsKey(category)) {
            points = answer.scoring!.breakdown[category]!.points;
          }

          categorized[category]!.add({
            'playerId': playerId,
            'playerName': player?.playerName ?? answer.playerName,
            'playerAvatar': player?.playerAvatar,
            'answer': answerText,
            'points': points,
            'usedDoublePoints': answer.usedDoublePoints,
          });
        }
      }
    }

    return categorized;
  }

  void stopListening() {
    _answersSubscription?.cancel();
    _playersSubscription?.cancel();
    _sessionSubscription?.cancel();
    developer.log(
      'Stopped listening to answers and players',
      name: 'PlayerAnswerTrackerService',
    );
  }

  void dispose() {
    stopListening();
  }
}
