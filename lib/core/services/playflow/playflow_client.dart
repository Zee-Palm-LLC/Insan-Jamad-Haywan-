import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_config_model.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_model.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_resource_model.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/playflow/credentials.dart';
import 'package:insan_jamd_hawan/core/services/playflow/endpoints.dart';

class PlayflowClient {
  static final PlayflowClient instance = PlayflowClient._();

  PlayflowClient._();

  static final Dio _networkClient =
      Dio(
          BaseOptions(
            baseUrl: PlayflowEndpoints.baseUrl,
            headers: {'api-key': PlayflowCredentials.apiKey},
            contentType: 'application/json',
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            request: true,
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            error: true,
          ),
        );

  Future<bool> sendHearBears(String lobbyId) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID is not set');
      }
      final response = await _networkClient.post(
        "${PlayflowEndpoints.lobby}/$lobbyId/heartbeat",
        data: {'playerId': playerId},
        queryParameters: {'name': PlayflowCredentials.lobbyId},
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      return false;
    }
  }

  Future<LobbyModel?> createGameRoom({required LobbyConfigModel config}) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID is not set');
      }

      final requestData = config.toJson();
      log('Creating lobby with config: $requestData', name: 'createGameRoom');

      final response = await _networkClient.post(
        PlayflowEndpoints.lobby,
        queryParameters: {'name': PlayflowCredentials.lobbyId},
        data: requestData,
      );

      log(
        'Create lobby response status: ${response.statusCode}',
        name: 'createGameRoom',
      );
      log(
        'Create lobby response data: ${response.data}',
        name: 'createGameRoom',
      );

      if (response.statusCode != 201) {
        final errorMsg =
            response.data['message'] ??
            response.data['error'] ??
            'Failed to create lobby (Status: ${response.statusCode})';
        log(
          'Create lobby failed: $errorMsg',
          name: 'createGameRoom',
          error: errorMsg,
        );
        throw Exception(errorMsg);
      }

      final lobby = LobbyModel.fromJson(response.data);
      log(
        'Lobby created successfully: ${lobby.id}, inviteCode: ${lobby.inviteCode}',
        name: 'createGameRoom',
      );
      return lobby;
    } catch (e, stackTrace) {
      log(
        'Create game room error: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'createGameRoom',
      );
      rethrow;
    }
  }

  Future<LobbyModel?> updateGameRoom({
    required String lobbyId,
    required LobbyResourceModel resource,
  }) async {
    try {
      final response = await _networkClient.put(
        '${PlayflowEndpoints.lobby}/$lobbyId',
        queryParameters: {'name': PlayflowCredentials.lobbyId},
        data: resource.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
      return LobbyModel.fromJson(response.data);
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<LobbyModel?> getGameRoom() async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Lobby ID is not set');
      }
      final response = await _networkClient.get(
        '${PlayflowEndpoints.lobby}/$playerId',
        queryParameters: {'name': PlayflowCredentials.lobbyId},
      );
      log(response.data.toString(), error: response.data, name: 'response');
      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
      return LobbyModel.fromJson(response.data);
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<LobbyModel?> joinGameRoom({required String code}) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID is not set');
      }

      final lobbyName = PlayflowCredentials.lobbyId;
      String cleaned = code.trim();

      // Normalize input: remove known prefixes and whitespace, allow either UUID or short codes
      final variants = <String>[
        cleaned,
        cleaned.replaceAll(' ', ''),
        cleaned.replaceAll('-', ''),
        cleaned.replaceAll('${lobbyName.toLowerCase()}-', ''),
        cleaned.replaceAll('${lobbyName.toUpperCase()}-', ''),
        cleaned.replaceAll('insan-jamd-hawan-', ''),
        cleaned.replaceAll('INSAN-JAMD-HAWAN-', ''),
        cleaned.replaceAll('insan-jamd-haywan-', ''),
        cleaned.replaceAll('INSAN-JAMD-HAYWAN-', ''),
      ].where((e) => e.isNotEmpty).toSet().first;

      cleaned = variants;
      final String withoutDashes = cleaned.replaceAll('-', '');
      final bool isUuid = cleaned.contains('-') && withoutDashes.length == 32;

      String endpoint;
      if (isUuid) {
        endpoint = '${PlayflowEndpoints.lobby}/$cleaned/players';
      } else {
        endpoint = '${PlayflowEndpoints.lobby}/code/$cleaned/players';
      }

      log(
        'Joining with: $cleaned (UUID: $isUuid, endpoint: $endpoint)',
        name: 'joinGameRoom',
      );

      final response = await _networkClient.post(
        endpoint,
        data: {'playerId': playerId},
        queryParameters: {'name': lobbyName},
      );
      log('Join game response: ${response.data}', name: 'joinGameRoom');
      log('Response status: ${response.statusCode}', name: 'joinGameRoom');

      if (response.statusCode != 201) {
        final errorMsg =
            response.data['message'] ??
            response.data['error'] ??
            'Failed to join lobby (Status: ${response.statusCode})';
        log(
          'Join game failed: $errorMsg',
          name: 'joinGameRoom',
          error: errorMsg,
        );
        throw Exception(errorMsg);
      }
      return LobbyModel.fromJson(response.data);
    } catch (e, stackTrace) {
      log(
        'Join game room error: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'joinGameRoom',
      );
      rethrow;
    }
  }

  Future<List<String>?> getPlayers({required String lobbyId}) async {
    try {
      final response = await _networkClient.get(
        '${PlayflowEndpoints.lobby}/$lobbyId/players',
        queryParameters: {'name': PlayflowCredentials.lobbyId},
      );
      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
      return (response.data as List).map((e) => e as String).toList();
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Delete a lobby (host only)
  Future<bool> deleteLobby({required String lobbyId}) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID is not set');
      }

      final response = await _networkClient.delete(
        '${PlayflowEndpoints.lobby}/$lobbyId',
        queryParameters: {'name': PlayflowCredentials.lobbyId},
        data: {'playerId': playerId},
      );

      log('Delete lobby response: ${response.statusCode}', name: 'deleteLobby');
      if (response.statusCode == 404) {
        log(
          'Lobby already deleted (404), treating as success',
          name: 'deleteLobby',
        );
        return true;
      }
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Failed to delete lobby');
      }
      return true;
    } catch (e, stackTrace) {
      // Handle DioException with 404 status (lobby already deleted)
      if (e.toString().contains('404') ||
          (e.toString().contains('Not Found') &&
              e.toString().contains('Lobby'))) {
        log(
          'Lobby already deleted (404), treating as success',
          name: 'deleteLobby',
        );
        return true;
      }

      log(
        'Delete lobby error: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'deleteLobby',
      );
      rethrow;
    }
  }

  /// Kick a player from the lobby (host only)
  Future<bool> kickPlayer({
    required String lobbyId,
    required String playerIdToKick,
    bool isKick = true,
  }) async {
    try {
      String? requesterId = await AppService.getPlayerId();
      if (requesterId == null) {
        throw Exception('Player ID is not set');
      }

      final response = await _networkClient.delete(
        '${PlayflowEndpoints.lobby}/$lobbyId/players/$playerIdToKick',
        queryParameters: {
          'name': PlayflowCredentials.lobbyId,
          'requesterId': requesterId,
          'isKick': isKick,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e, stackTrace) {
      log(
        'Kick player error: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'kickPlayer',
      );
      rethrow;
    }
  }

  /// Update lobby maxPlayers (host only)
  Future<bool> updateMaxPlayers({
    required String lobbyId,
    required int maxPlayers,
  }) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID is not set');
      }

      final response = await _networkClient.put(
        '${PlayflowEndpoints.lobby}/$lobbyId',
        queryParameters: {'name': PlayflowCredentials.lobbyId},
        data: {'playerId': playerId, 'maxPlayers': maxPlayers},
      );

      log(
        'Update maxPlayers response: ${response.statusCode}',
        name: 'updateMaxPlayers',
      );
      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e, stackTrace) {
      log(
        'Update maxPlayers error: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'updateMaxPlayers',
      );
      rethrow;
    }
  }
}
