import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:insan_jamd_hawan/core/models/game/lobby_settings.dart';
import 'package:insan_jamd_hawan/core/models/game/player_state_model.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_model.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_resource_model.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/playflow/credentials.dart';
import 'package:insan_jamd_hawan/core/services/playflow/endpoints.dart';
import 'package:insan_jamd_hawan/core/services/playflow/playflow_client.dart';
import 'package:insan_jamd_hawan/core/utils/network_call.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';

import '../data/enums/enums.dart';

class LobbyController extends GetxController {
  final LobbyModel lobby;
  LobbyController({required this.lobby}) : _currentRoom = lobby;

  LobbyModel _currentRoom;
  LobbyModel get currentRoom => _currentRoom;

  PageController pageController = PageController();

  int? _selectedMaxRounds;
  int? get selectedMaxRounds => _selectedMaxRounds;

  int? _selectedTimePerRound;
  int? get selectedTimePerRound => _selectedTimePerRound;

  void onMaxRoundChange(int? value) {
    if (value != null) {
      _selectedMaxRounds = value;
      update();
    }
  }

  void onTimePerRoundChange(int? value) {
    if (value != null) {
      _selectedTimePerRound = value;
      update();
    }
  }

  Timer? _playerHeartbeatTimer;
  StreamSubscription<SSEModel>? _sseSubscription;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  static const int _initialReconnectDelay = 2; // seconds
  bool _isReconnecting = false;
  bool _isConnected = false;

  Duration? _serverTimeOffset;
  Timer? _syncTimer;
  DateTime? get serverTime {
    if (_serverTimeOffset == null) return DateTime.now();
    return DateTime.now().add(_serverTimeOffset!);
  }

  RoomStatus _roomStatus = RoomStatus.waiting;
  RoomStatus get roomStatus => _roomStatus;
  bool get isReconnecting => _isReconnecting;
  bool get isConnected => _isConnected;

  PlayflowClient playflowClient = PlayflowClient.instance;

  final TextEditingController _answerController = TextEditingController();
  TextEditingController get answerController => _answerController;

  bool _actionDone = false;
  bool get actionDone => _actionDone;

  void setActionDone(bool value) {
    _actionDone = value;
    update();
  }

  String? _currentLetter;
  String? get currentLetter => _currentLetter;

  void setCurrentLetter(String letter) {
    _currentLetter = letter;
    log('Current letter set to: $letter', name: 'LetterSelection');
    update();
  }

  GamePhase _phase = GamePhase.waiting;
  GamePhase get phase => _phase;

  set phase(GamePhase newPhase) {
    if (_phase == newPhase) return;
    log('Phase Changed: $newPhase', name: 'Phase Changed');
    _phase = newPhase;
    update();
    _onPhaseChanged(newPhase);
  }

  void _onPhaseChanged(GamePhase newPhase) {
    // Handle phase-specific logic here
    if (newPhase == GamePhase.started) {
      // Game started logic
    }
  }

  void setRoomStatus({required RoomStatus status, LobbyModel? room}) {
    _roomStatus = status;
    update();
    switch (_roomStatus) {
      case RoomStatus.connected:
        {
          _playerHeartbeat();
          if (room != null) {
            setCurrentRoom(room);
          } else {
            setCurrentRoom(lobby);
          }
        }
        break;
      case RoomStatus.deleted:
        {
          _playerHeartbeatTimer?.cancel();
          _sseSubscription?.cancel();
          _cancelReconnect();
          _isConnected = false;
          _isReconnecting = false;
          update();
          log('Room deleted', name: 'RoomStatus');
          AppToaster.showToast(
            'Lobby Deleted',
            subTitle: 'The lobby has been deleted by the host.',
            type: ToastificationType.error,
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (navigatorKey.currentState?.canPop() ?? false) {
              navigatorKey.currentState!.pop();
            }
          });
        }
        break;
      case RoomStatus.updated:
        {
          if (room != null) {
            setCurrentRoom(room);
          }
        }
        break;
      default:
    }
  }

  Future<void> startGame() async {
    await NetworkCall.networkCall(
      onError: (e, s) => AppToaster.showToast(
        'Error',
        subTitle: e.toString(),
        type: ToastificationType.error,
      ),
      future: () async {
        String? playerId = await AppService.getPlayerId();
        if (playerId == null) {
          throw Exception('Player ID is not set');
        }
        if (_currentRoom.settings?.status != GameStatus.started) {
          await playflowClient.sendHearBears(lobby.id!);

          final LobbyModel? updated = await playflowClient.updateGameRoom(
            lobbyId: currentRoom.id!,
            resource: LobbyResourceModel(
              settings: LobbySettings(
                settings: GameSettings(
                  maxRounds: _selectedMaxRounds ?? 3,
                  status: GameStatus.started,
                  currentRound: 0,
                ),
              ),
              requesterId: playerId,
            ),
          );

          // Optimistically reflect started state immediately for host
          if (updated != null) {
            setCurrentRoom(updated);
            phase = GamePhase.started;
            log(
              'Game started - broadcast will be sent via SSE to all players',
              name: 'StartGame',
            );
          } else {
            setCurrentRoom(
              currentRoom.copyWith(
                settings: GameSettings(
                  maxRounds: _selectedMaxRounds ?? 3,
                  status: GameStatus.started,
                  currentRound: 0,
                ),
              ),
            );
            phase = GamePhase.started;
          }

          // Broadcast is automatically handled by SSE:
          // When updateGameRoom is called, the server sends an SSE event
          // to all connected players, which triggers _handleOptimizedUpdate
          // and broadcasts the game start to all players in <1s
        } else {
          AppToaster.showToast(
            'Game already started',
            subTitle: 'The game has already started',
            type: ToastificationType.error,
          );
        }
      },
    );
  }

  Future<void> endGame() async {
    await NetworkCall.networkCall(
      onError: (e, s) => AppToaster.showToast(
        'Error',
        subTitle: e.toString(),
        type: ToastificationType.error,
      ),
      onComplete: (_) {
        _phase = GamePhase.waiting;
        setActionDone(false);
        update();
      },
      future: () async {
        String? playerId = await AppService.getPlayerId();
        if (playerId == null) {
          throw Exception('Player ID is not set');
        }
        if (_currentRoom.settings?.status == GameStatus.started) {
          await playflowClient.updateGameRoom(
            lobbyId: currentRoom.id!,
            resource: LobbyResourceModel(
              settings: LobbySettings(
                settings: GameSettings(
                  status: GameStatus.waiting,
                  currentRound: 0,
                ),
              ),
              requesterId: playerId,
            ),
          );
        } else {
          AppToaster.showToast(
            'Game already ended',
            subTitle: 'The game has already ended',
            type: ToastificationType.error,
          );
        }
      },
    );
  }

  /// Broadcasts the selected letter to all players
  /// This is called by the host after the wheel spin is complete
  Future<void> broadcastSelectedLetter(String letter) async {
    await NetworkCall.networkCall(
      onError: (e, s) => AppToaster.showToast(
        'Error',
        subTitle: 'Failed to broadcast letter: ${e.toString()}',
        type: ToastificationType.error,
      ),
      future: () async {
        String? playerId = await AppService.getPlayerId();
        if (playerId == null) {
          throw Exception('Player ID is not set');
        }

        // Set letter locally first for immediate feedback
        setCurrentLetter(letter);

        // Create a round status list with the selected letter
        final roundStatus = [
          'letter:$letter',
          'timestamp:${DateTime.now().toIso8601String()}',
        ];

        // Broadcast via lobby settings update
        final updated = await playflowClient.updateGameRoom(
          lobbyId: currentRoom.id!,
          resource: LobbyResourceModel(
            settings: LobbySettings(
              settings: GameSettings(
                status: _currentRoom.settings?.status ?? GameStatus.started,
                maxRounds: _currentRoom.settings?.maxRounds ?? 3,
                currentRound: _currentRoom.settings?.currentRound ?? 1,
                roundStatus: roundStatus,
                scoreConfig:
                    _currentRoom.settings?.scoreConfig ??
                    const ScoreConfig(correctGuess: 100, fooledOther: 50),
              ),
            ),
            requesterId: playerId,
          ),
        );

        if (updated != null) {
          setCurrentRoom(updated);
          log(
            'Letter "$letter" broadcast to all players via SSE',
            name: 'BroadcastLetter',
          );
        }
      },
    );
  }

  void setCurrentRoom(LobbyModel room) {
    String? playerId = AppService.getPlayerName();
    if (room.players?.contains(playerId) == false) {
      AppToaster.showToast(
        'Left the room',
        subTitle: 'You are no longer a member of this lobby',
        type: ToastificationType.error,
      );
      _playerHeartbeatTimer?.cancel();
      _sseSubscription?.cancel();
      _cancelReconnect();
      _isConnected = false;
      _isReconnecting = false;
      update();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (navigatorKey.currentState?.canPop() ?? false) {
          navigatorKey.currentState!.pop();
        }
      });
      return;
    }

    _currentRoom = room;

    // Check for letter updates in roundStatus
    if (room.settings?.roundStatus != null &&
        room.settings!.roundStatus!.isNotEmpty) {
      for (final status in room.settings!.roundStatus!) {
        if (status.startsWith('letter:')) {
          final letter = status.substring('letter:'.length);
          if (_currentLetter != letter) {
            _currentLetter = letter;
            log('Received letter update: $letter', name: 'LetterSync');
          }
        }
      }
    }

    update();

    if (room.settings?.status == GameStatus.started) {
      phase = GamePhase.started;
    }
  }

  PlayerStateModel getPlayerState() {
    return _currentRoom.lobbyStateRealTime?[AppService.getPlayerName()] ??
        PlayerStateModel();
  }

  Future<void> deleteRoom() async {
    await NetworkCall.networkCall(
      onComplete: (_) {
        _playerHeartbeatTimer?.cancel();
        _sseSubscription?.cancel();
        _cancelReconnect();
        _isConnected = false;
        _isReconnecting = false;
        update();
        log('Room deleted successfully', name: 'deleteRoom');
        if (navigatorKey.currentState?.canPop() ?? false) {
          navigatorKey.currentState!.pop();
        }
      },
      onError: (e, s) => AppToaster.showToast(
        'Error',
        subTitle: e.toString(),
        type: ToastificationType.error,
      ),
      future: () async {
        String? playerId = await AppService.getPlayerId();
        if (playerId == null) {
          AppToaster.showToast(
            'Player ID is not set',
            type: ToastificationType.error,
          );
          throw Exception('Player ID is not set');
        }
        _playerHeartbeatTimer?.cancel();
        await playflowClient.deleteLobby(lobbyId: lobby.id!);
      },
    );
  }

  Future<void> removePlayer({
    bool isKick = true,
    String? playerIdToKick,
  }) async {
    await NetworkCall.networkCall(
      onComplete: (_) {
        log('Player removed successfully', name: 'removePlayer');
        String? playerId = AppService.getPlayerName();
        String? targetPlayerId = playerIdToKick ?? playerId;
        if (targetPlayerId == _currentRoom.host && targetPlayerId == playerId) {
          _playerHeartbeatTimer?.cancel();
          _sseSubscription?.cancel();
          _cancelReconnect();
          _isConnected = false;
          _isReconnecting = false;
          update();
          if (navigatorKey.currentState?.canPop() ?? false) {
            navigatorKey.currentState!.pop();
          }
        }
      },
      onError: (e, s) => AppToaster.showToast(
        'Error',
        subTitle: e.toString(),
        type: ToastificationType.error,
      ),
      future: () async {
        String? playerId = await AppService.getPlayerId();
        if (playerId == null) {
          AppToaster.showToast(
            'Player ID is not set',
            type: ToastificationType.error,
          );
          throw Exception('Player ID is not set');
        }

        String? targetPlayerId = playerIdToKick ?? playerId;

        // If host is leaving voluntarily and there are other players,
        // reassign host instead of deleting the lobby.
        if (targetPlayerId == _currentRoom.host &&
            targetPlayerId == playerId &&
            !isKick) {
          final others = List<String>.from(_currentRoom.players ?? [])
            ..removeWhere((p) => p == _currentRoom.host);
          if (others.isNotEmpty) {
            final newHost = others.first;
            await playflowClient.updateGameRoom(
              lobbyId: lobby.id!,
              resource: LobbyResourceModel(
                host: newHost,
                requesterId: playerId,
              ),
            );
            // Also remove the leaving player
            await playflowClient.kickPlayer(
              lobbyId: lobby.id!,
              playerIdToKick: playerId,
              isKick: false,
            );
            return;
          } else {
            // No other players; delete lobby
            _playerHeartbeatTimer?.cancel();
            await playflowClient.deleteLobby(lobbyId: lobby.id!);
            return;
          }
        }

        await playflowClient.kickPlayer(
          lobbyId: lobby.id!,
          playerIdToKick: targetPlayerId,
          isKick: isKick,
        );
      },
    );
  }

  @override
  Future<void> onReady() async {
    await _connectSSE();
    _initTimerSync();
    super.onReady();
  }

  void _initTimerSync() {
    // Sync timer every 30 seconds to maintain accuracy
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      // Re-sync with server time periodically
      // This will be updated when we receive SSE events with timestamps
      if (_serverTimeOffset != null) {
        log(
          'Timer sync maintained: offset = ${_serverTimeOffset?.inMilliseconds}ms',
          name: 'TimerSync',
        );
      }
    });
  }

  Future<void> _connectSSE() async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        log('Cannot connect SSE: Player ID is not set', name: 'SSE');
        return;
      }

      _sseSubscription?.cancel();

      await playflowClient.sendHearBears(lobby.id!);

      _isReconnecting = false;
      _reconnectAttempts = 0;
      update();

      _sseSubscription =
          SSEClient.subscribeToSSE(
            method: SSERequestType.GET,
            url:
                "${PlayflowEndpoints.lobbyHeartbeat(lobby.id!)}?lobby-config=${PlayflowCredentials.lobbyId}&player-id=$playerId",
            header: {
              "Content-Type": "application/json",
              "api-key": PlayflowCredentials.apiKey,
            },
          ).listen(
            handleEvent,
            onError: _handleSSEError,
            onDone: _handleSSEDone,
            cancelOnError: false,
          );

      _isConnected = true;
      update();
      log('SSE connected successfully', name: 'SSE');
    } catch (e, stackTrace) {
      log(
        'Failed to connect SSE: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'SSE',
      );
      _isConnected = false;
      update();
      _scheduleReconnect();
    }
  }

  void _handleSSEError(error) {
    log('SSE error occurred: $error', name: 'SSE', error: error);
    _isConnected = false;
    update();

    if (_isReconnecting || _roomStatus == RoomStatus.deleted) {
      return;
    }

    AppToaster.showToast(
      'Connection Lost',
      subTitle: 'Attempting to reconnect...',
      type: ToastificationType.warning,
    );

    _scheduleReconnect();
  }

  void _handleSSEDone() {
    log('SSE connection closed', name: 'SSE');
    _isConnected = false;
    update();

    if (_roomStatus == RoomStatus.deleted || _isReconnecting) {
      return;
    }

    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      log(
        'Max reconnect attempts reached ($_maxReconnectAttempts). Giving up.',
        name: 'SSE',
      );
      _isReconnecting = false;
      update();
      AppToaster.showToast(
        'Connection Failed',
        subTitle:
            'Unable to reconnect. Please refresh the page or rejoin the lobby.',
        type: ToastificationType.error,
      );
      return;
    }

    if (_isReconnecting) {
      return; // Already scheduled
    }

    _isReconnecting = true;
    _reconnectAttempts++;
    update();

    int delay = (_initialReconnectDelay * (1 << (_reconnectAttempts - 1)))
        .clamp(_initialReconnectDelay, 30);

    log(
      'Scheduling SSE reconnect attempt $_reconnectAttempts/$_maxReconnectAttempts in ${delay}s',
      name: 'SSE',
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delay), () {
      log('Attempting SSE reconnect...', name: 'SSE');
      _connectSSE();
    });
  }

  Future<void> _cancelReconnect() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _isReconnecting = false;
    _reconnectAttempts = 0;
  }

  void handleEvent(SSEModel event) {
    final eventStartTime = DateTime.now();

    try {
      if (event.event == null || event.event!.isEmpty) {
        log('SSE event received with empty event name', name: 'SSE');
        return;
      }

      if (event.data == null || event.data!.isEmpty) {
        log('SSE event received with empty data', name: 'SSE');
        return;
      }

      if (_reconnectAttempts > 0) {
        _reconnectAttempts = 0;
        _isReconnecting = false;
        _isConnected = true;
        update();
        log('SSE reconnected successfully', name: 'SSE');
      }

      String formattedEvent = event.event!.startsWith('lobby:')
          ? event.event!.replaceAll('lobby:', '')
          : event.event!;

      // Try to parse RoomStatus safely (if it matches an enum)
      RoomStatus? status;
      try {
        status = RoomStatus.values.firstWhere(
          (e) => e.name == formattedEvent,
          orElse: () => RoomStatus.error,
        );
      } catch (_) {
        log('Unknown SSE event: $formattedEvent', name: 'SSE');
        status = RoomStatus.error;
      }

      // Decode the JSON string safely
      dynamic decoded;
      try {
        decoded = jsonDecode(event.data!);
      } catch (e) {
        log(
          'Failed to parse SSE event data: $e. Data: ${event.data}',
          name: 'SSE',
          error: e,
        );
        return;
      }

      LobbyModel room;
      if (decoded is Map<String, dynamic>) {
        try {
          if (decoded.containsKey('lobby')) {
            room = LobbyModel.fromJson(decoded['lobby']);
          } else {
            room = LobbyModel.fromJson(decoded);
          }
        } catch (e) {
          log(
            'Failed to parse LobbyModel from SSE data: $e',
            name: 'SSE',
            error: e,
          );
          return;
        }
      } else {
        log('SSE event data is not a Map: ${decoded.runtimeType}', name: 'SSE');
        return;
      }

      // Sync server time if available (decoded is already Map<String, dynamic> at this point)
      if (decoded.containsKey('timestamp')) {
        try {
          final serverTimestamp = DateTime.parse(
            decoded['timestamp'] as String,
          );
          _serverTimeOffset = serverTimestamp.difference(DateTime.now());
          log(
            'Server time synced: offset = ${_serverTimeOffset!.inMilliseconds}ms',
            name: 'TimerSync',
          );
        } catch (e) {
          log('Failed to sync server time: $e', name: 'TimerSync');
        }
      }

      // Optimize join/leave events for <1s latency
      if (status == RoomStatus.updated) {
        _handleOptimizedUpdate(eventStartTime, room);
      } else {
        setRoomStatus(status: status, room: room);
      }

      // Measure and log latency for critical events
      final latency = DateTime.now().difference(eventStartTime);
      if (latency.inMilliseconds > 100) {
        log(
          'SSE event latency: ${latency.inMilliseconds}ms for event: $formattedEvent',
          name: 'SSE',
        );
      }
    } catch (e, stackTrace) {
      log(
        'Error handling SSE event: $e',
        name: 'SSE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _handleOptimizedUpdate(DateTime eventStartTime, LobbyModel newRoom) {
    // Get previous player list for comparison
    final previousPlayers = Set<String>.from(_currentRoom.players ?? []);
    final newPlayers = Set<String>.from(newRoom.players ?? []);

    // Detect join/leave events immediately
    final joinedPlayers = newPlayers.difference(previousPlayers);
    final leftPlayers = previousPlayers.difference(newPlayers);

    // Check if game started
    final gameStarted =
        newRoom.settings?.status == GameStatus.started &&
        _currentRoom.settings?.status != GameStatus.started;

    // Play "pop" sound on player join
    if (joinedPlayers.isNotEmpty) {
      AudioService.instance.playAudio(AudioType.playerJoinPop);
    }

    // Play "whoosh+chime" sound on game start
    if (gameStarted) {
      AudioService.instance.playAudio(AudioType.gameStartWhoosh);
    }

    // Immediate UI update for join/leave (<1s requirement)
    _currentRoom = newRoom;
    update(); // Immediate UI refresh

    // Log join/leave events with latency
    if (joinedPlayers.isNotEmpty || leftPlayers.isNotEmpty) {
      final latency = DateTime.now().difference(eventStartTime);
      log(
        'Join/Leave detected - Joined: $joinedPlayers, Left: $leftPlayers, Latency: ${latency.inMilliseconds}ms',
        name: 'SSE',
      );
    }

    // Broadcast game start notification
    if (gameStarted) {
      log('Game started broadcast received', name: 'SSE');
      phase = GamePhase.started;

      // Show notification to user
      AppToaster.showToast(
        'Game Started!',
        subTitle: 'The game has begun',
        type: ToastificationType.success,
      );
    }

    // Update room status after immediate UI update
    setRoomStatus(status: RoomStatus.updated, room: newRoom);
  }

  void _playerHeartbeat() async {
    _playerHeartbeatTimer?.cancel();
    _playerHeartbeatTimer = Timer.periodic(const Duration(seconds: 10), (
      timer,
    ) async {
      await playflowClient.sendHearBears(lobby.id!);
    });
  }

  @override
  void onClose() {
    _playerHeartbeatTimer?.cancel();
    _sseSubscription?.cancel();
    _syncTimer?.cancel();
    _cancelReconnect();
    answerController.dispose();
    _isConnected = false;
    _isReconnecting = false;
    super.onClose();
  }
}
