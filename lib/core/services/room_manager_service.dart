import 'dart:developer';

import 'package:insan_jamd_hawan/core/models/lobby/lobby_model.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_resource_model.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/playflow/playflow_client.dart';

class RoomManagerService {
  final PlayflowClient _playflowClient = PlayflowClient.instance;

  Future<void> deleteLobby(String lobbyId) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID is not set');
      }

      await _playflowClient.deleteLobby(lobbyId: lobbyId);
      log('Lobby deleted successfully', name: 'RoomManager');
    } catch (e, s) {
      log(
        'Error deleting lobby: $e',
        name: 'RoomManager',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> removePlayer({
    required String lobbyId,
    required LobbyModel currentRoom,
    bool isKick = true,
    String? playerIdToKick,
  }) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID is not set');
      }

      String? targetPlayerId = playerIdToKick ?? playerId;

      if (targetPlayerId == currentRoom.host &&
          targetPlayerId == playerId &&
          !isKick) {
        final others = List<String>.from(currentRoom.players ?? [])
          ..removeWhere((p) => p == currentRoom.host);

        if (others.isNotEmpty) {
          final newHost = others.first;
          await _playflowClient.updateGameRoom(
            lobbyId: lobbyId,
            resource: LobbyResourceModel(host: newHost, requesterId: playerId),
          );

          await _playflowClient.kickPlayer(
            lobbyId: lobbyId,
            playerIdToKick: playerId,
            isKick: false,
          );

          log(
            'Host reassigned to $newHost and player $playerId left',
            name: 'RoomManager',
          );
          return;
        } else {
          await _playflowClient.deleteLobby(lobbyId: lobbyId);
          log('Last player left, lobby deleted', name: 'RoomManager');
          return;
        }
      }

      await _playflowClient.kickPlayer(
        lobbyId: lobbyId,
        playerIdToKick: targetPlayerId,
        isKick: isKick,
      );

      log(
        'Player $targetPlayerId ${isKick ? 'kicked' : 'left'} successfully',
        name: 'RoomManager',
      );
    } catch (e, s) {
      log(
        'Error removing player: $e',
        name: 'RoomManager',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
