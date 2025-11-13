import 'dart:developer';
import 'package:insan_jamd_hawan/core/models/session/player_participation_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/services/game_player_service.dart';

class LobbyFirestoreSyncService {
  String sessionId;
  LobbyFirestoreSyncService({required this.sessionId});

  Future<void> updateSessionStatus(SessionStatus status) async {
    try {
      await FirebaseFirestoreService.instance.updateSessionStatus(
        sessionId,
        status,
      );
      log(
        'Firestore session status updated: $status',
        name: 'LobbyFirestoreSync',
      );
    } catch (e, s) {
      log(
        'Error updating Firestore session status: $e',
        name: 'LobbyFirestoreSync',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> syncPlayer(String playerId, String hostId) async {
    try {
      await GamePlayerService.instance.syncLocalPlayerToFirestore();

      final existingPlayer = await FirebaseFirestoreService.instance.getPlayer(
        sessionId,
        playerId,
      );

      if (existingPlayer == null) {
        final now = DateTime.now();
        final participation = PlayerParticipationModel(
          playerId: playerId,
          playerName: playerId,
          playerAvatar: null,
          joinedAt: now,
          leftAt: null,
          status: PlayerStatus.active,
          disconnectedAt: null,
          reconnectedAt: null,
          roundParticipation: {},
          totalTimeInGame: null,
          averageTimePerRound: null,
          totalScore: 0,
          scoresByRound: {},
          roundsPlayed: 0,
          roundsCompleted: 0,
          averageScorePerRound: null,
          finalRank: null,
          lastHeartbeat: now,
          isOnline: true,
        );

        await FirebaseFirestoreService.instance.addPlayer(
          sessionId,
          participation,
        );
        log('Player $playerId synced to Firestore', name: 'LobbyFirestoreSync');
      } else {
        if (existingPlayer.status != PlayerStatus.active) {
          await FirebaseFirestoreService.instance.updatePlayerStatus(
            sessionId,
            playerId,
            PlayerStatus.active,
          );
          log(
            'Player $playerId reactivated in Firestore',
            name: 'LobbyFirestoreSync',
          );
        }
      }
    } catch (e, s) {
      log(
        'Error syncing player to Firestore: $e',
        name: 'LobbyFirestoreSync',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> markPlayerLeft(String playerId) async {
    try {
      // Use removePlayer which properly sets status, leftAt, and isOnline
      await FirebaseFirestoreService.instance.removePlayer(sessionId, playerId);
      log(
        'Player $playerId marked as left in Firestore (status: left, isOnline: false)',
        name: 'LobbyFirestoreSync',
      );
    } catch (e, s) {
      log(
        'Error updating left player in Firestore: $e',
        name: 'LobbyFirestoreSync',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> syncJoinedPlayers(Set<String> playerIds, String hostId) async {
    for (final playerId in playerIds) {
      await syncPlayer(playerId, hostId);
    }
  }

  Future<void> syncLeftPlayers(Set<String> playerIds) async {
    for (final playerId in playerIds) {
      await markPlayerLeft(playerId);
    }
  }
}
