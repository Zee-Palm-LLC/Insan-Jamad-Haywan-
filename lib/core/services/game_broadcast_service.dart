import 'dart:developer';

import 'package:insan_jamd_hawan/core/models/game/lobby_settings.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_model.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_resource_model.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/playflow/playflow_client.dart';

class GameBroadcastService {
  final PlayflowClient _playflowClient = PlayflowClient.instance;

  Future<LobbyModel?> broadcastWheelSpinStart({
    required String lobbyId,
    required LobbyModel currentRoom,
  }) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID is not set');
      }

      final roundStatus = [
        'wheelSpin:start',
        'timestamp:${DateTime.now().toIso8601String()}',
      ];

      final updated = await _playflowClient.updateGameRoom(
        lobbyId: lobbyId,
        resource: LobbyResourceModel(
          settings: LobbySettings(
            settings: GameSettings(
              status: currentRoom.settings?.status ?? GameStatus.started,
              maxRounds: currentRoom.settings?.maxRounds ?? 3,
              currentRound: currentRoom.settings?.currentRound ?? 1,
              roundStatus: roundStatus,
              scoreConfig:
                  currentRoom.settings?.scoreConfig ??
                  const ScoreConfig(correctGuess: 100, fooledOther: 50),
            ),
          ),
          requesterId: playerId,
        ),
      );

      if (updated != null) {
        log('Wheel spin start broadcast to all players', name: 'WheelSync');
      }

      return updated;
    } catch (e, s) {
      log(
        'Failed to broadcast wheel spin start: $e',
        name: 'GameBroadcast',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<LobbyModel?> broadcastSelectedLetter({
    required String lobbyId,
    required LobbyModel currentRoom,
    required String letter,
    required int selectedIndex,
  }) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID is not set');
      }

      final roundStatus = [
        'letter:$letter',
        'wheelIndex:$selectedIndex',
        'wheelSpin:complete',
        'timestamp:${DateTime.now().toIso8601String()}',
      ];

      final updated = await _playflowClient.updateGameRoom(
        lobbyId: lobbyId,
        resource: LobbyResourceModel(
          settings: LobbySettings(
            settings: GameSettings(
              status: currentRoom.settings?.status ?? GameStatus.started,
              maxRounds: currentRoom.settings?.maxRounds ?? 3,
              currentRound: currentRoom.settings?.currentRound ?? 1,
              roundStatus: roundStatus,
              scoreConfig:
                  currentRoom.settings?.scoreConfig ??
                  const ScoreConfig(correctGuess: 100, fooledOther: 50),
            ),
          ),
          requesterId: playerId,
        ),
      );

      if (updated != null) {
        log(
          'Letter "$letter" broadcast to all players via SSE',
          name: 'BroadcastLetter',
        );
      }

      return updated;
    } catch (e, s) {
      log(
        'Failed to broadcast selected letter: $e',
        name: 'GameBroadcast',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<LobbyModel?> broadcastCountdown({
    required String lobbyId,
    required LobbyModel currentRoom,
    required int value,
    String? currentLetter,
    int? wheelSelectedIndex,
  }) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID is not set');
      }

      final roundStatus = [
        'countdown:$value',
        'letter:${currentLetter ?? ""}',
        'wheelIndex:${wheelSelectedIndex ?? 0}',
        'timestamp:${DateTime.now().toIso8601String()}',
      ];

      final updated = await _playflowClient.updateGameRoom(
        lobbyId: lobbyId,
        resource: LobbyResourceModel(
          settings: LobbySettings(
            settings: GameSettings(
              status: currentRoom.settings?.status ?? GameStatus.started,
              maxRounds: currentRoom.settings?.maxRounds ?? 3,
              currentRound: currentRoom.settings?.currentRound ?? 1,
              roundStatus: roundStatus,
              scoreConfig:
                  currentRoom.settings?.scoreConfig ??
                  const ScoreConfig(correctGuess: 100, fooledOther: 50),
            ),
          ),
          requesterId: playerId,
        ),
      );

      log('Countdown $value broadcast', name: 'GameBroadcast');
      return updated;
    } catch (e, s) {
      log(
        'Failed to broadcast countdown: $e',
        name: 'GameBroadcast',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<LobbyModel?> broadcastCountdownComplete({
    required String lobbyId,
    required LobbyModel currentRoom,
    String? currentLetter,
    int? wheelSelectedIndex,
  }) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID is not set');
      }

      final roundStatus = [
        'countdown:complete',
        'letter:${currentLetter ?? ""}',
        'wheelIndex:${wheelSelectedIndex ?? 0}',
        'timestamp:${DateTime.now().toIso8601String()}',
      ];

      final updated = await _playflowClient.updateGameRoom(
        lobbyId: lobbyId,
        resource: LobbyResourceModel(
          settings: LobbySettings(
            settings: GameSettings(
              status: currentRoom.settings?.status ?? GameStatus.started,
              maxRounds: currentRoom.settings?.maxRounds ?? 3,
              currentRound: currentRoom.settings?.currentRound ?? 1,
              roundStatus: roundStatus,
              scoreConfig:
                  currentRoom.settings?.scoreConfig ??
                  const ScoreConfig(correctGuess: 100, fooledOther: 50),
            ),
          ),
          requesterId: playerId,
        ),
      );

      log('Countdown complete broadcast', name: 'GameBroadcast');
      return updated;
    } catch (e, s) {
      log(
        'Failed to broadcast countdown complete: $e',
        name: 'GameBroadcast',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<LobbyModel?> updateGameStatus({
    required String lobbyId,
    required GameStatus status,
    required int maxRounds,
    required int currentRound,
  }) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID is not set');
      }

      final updated = await _playflowClient.updateGameRoom(
        lobbyId: lobbyId,
        resource: LobbyResourceModel(
          settings: LobbySettings(
            settings: GameSettings(
              maxRounds: maxRounds,
              status: status,
              currentRound: currentRound,
            ),
          ),
          requesterId: playerId,
        ),
      );

      log('Game status updated to: $status', name: 'GameBroadcast');
      return updated;
    } catch (e, s) {
      log(
        'Failed to update game status: $e',
        name: 'GameBroadcast',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
