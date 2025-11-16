import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/config/routes/router.dart';
import 'package:insan_jamd_hawan/core/controllers/join_lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_creation_controller.dart';
import 'package:insan_jamd_hawan/core/data/enums/enums.dart';
import 'package:insan_jamd_hawan/core/models/game/lobby_settings.dart';
import 'package:insan_jamd_hawan/core/models/game/player_state_model.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/letter_generator/letter_generator_view.dart';
import 'package:insan_jamd_hawan/core/modules/main_menu/main_menu_page.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/services/game_broadcast_service.dart';
import 'package:insan_jamd_hawan/core/services/firestore/lobby_firestore_sync_service.dart';
import 'package:insan_jamd_hawan/core/services/playflow/playflow_client.dart';
import 'package:insan_jamd_hawan/core/services/room_manager_service.dart';
import 'package:insan_jamd_hawan/core/services/sse_connection_manager.dart';
import 'package:insan_jamd_hawan/core/utils/network_call.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';
import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';
import 'package:go_router/go_router.dart';

class LobbyController extends GetxController {
  final LobbyModel lobby;

  LobbyController({required this.lobby}) : _currentRoom = lobby;
  LobbyModel _currentRoom;
  LobbyModel get currentRoom => _currentRoom;

  late final SSEConnectionManager _sseManager;
  late final GameBroadcastService _broadcastService;
  late final LobbyFirestoreSyncService _firestoreSync;
  late final RoomManagerService _roomManager;

  final TextEditingController _answerController = TextEditingController();
  TextEditingController get answerController => _answerController;

  int? _selectedMaxRounds;
  int? _selectedTimePerRound;
  int? get selectedMaxRounds => _selectedMaxRounds;
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

  GamePhase _phase = GamePhase.waiting;
  GamePhase get phase => _phase;
  set phase(GamePhase newPhase) {
    if (_phase == newPhase) return;
    log('Phase Changed: $newPhase', name: 'Phase Changed');
    _phase = newPhase;
    update();
  }

  String? _currentLetter;
  String? get currentLetter => _currentLetter;
  bool _isWheelSpinning = false;
  bool get isWheelSpinning => _isWheelSpinning;
  int? _wheelSelectedIndex;
  int? get wheelSelectedIndex => _wheelSelectedIndex;
  bool _isCountdownActive = false;
  bool get isCountdownActive => _isCountdownActive;
  int _countdownValue = 3;
  int get countdownValue => _countdownValue;

  RoomStatus _roomStatus = RoomStatus.waiting;
  RoomStatus get roomStatus => _roomStatus;
  bool get isConnected => _sseManager.isConnected;
  bool get isReconnecting => _sseManager.isReconnecting;

  bool _actionDone = false;
  bool get actionDone => _actionDone;
  void setActionDone(bool value) {
    _actionDone = value;
    update();
  }

  Timer? _playerHeartbeatTimer;
  DateTime? get serverTime => _sseManager.serverTime;

  @override
  Future<void> onReady() async {
    _initializeServices();
    await _sseManager.connect();
    _startPlayerHeartbeat();
    super.onReady();
  }

  void _initializeServices() {
    _sseManager = SSEConnectionManager(
      lobbyId: lobby.id!,
      onRoomUpdate: _handleRoomUpdate,
      onConnectionStatusChanged: () => update(),
    );

    _broadcastService = GameBroadcastService();
    _firestoreSync = LobbyFirestoreSyncService(sessionId: lobby.id!);
    _roomManager = RoomManagerService();
  }

  void setCurrentLetter(String letter) {
    _currentLetter = letter;
    log('Current letter set to: $letter', name: 'LetterSelection');
    update();
  }

  Future<void> startGame({Function? onSuccess}) async {
    await NetworkCall.networkCall(
      onError: (e, s) => AppToaster.showToast(
        'Error',
        subTitle: e.toString(),
        type: ToastificationType.error,
      ),
      future: () async {
        if (_currentRoom.settings?.status == GameStatus.started) {
          AppToaster.showToast(
            'Game already started',
            subTitle: 'The game has already started',
            type: ToastificationType.error,
          );
          return;
        }

        await PlayflowClient.instance.sendHearBears(lobby.id!);
        FirebaseFirestoreService.instance
            .getSessionStatusStream(lobby.id!)
            .listen((event) {
              onSuccess?.call();
            });

        final updated = await _broadcastService.updateGameStatus(
          lobbyId: currentRoom.id!,
          status: GameStatus.started,
          maxRounds: _selectedMaxRounds ?? 3,
          currentRound: 0,
        );

        if (updated != null) {
          setCurrentRoom(updated);
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
        }

        phase = GamePhase.started;
        await _firestoreSync.updateSessionStatus(SessionStatus.started);

        log('Game started - broadcast sent via SSE', name: 'StartGame');
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
        if (_currentRoom.settings?.status != GameStatus.started) {
          AppToaster.showToast(
            'Game already ended',
            subTitle: 'The game has already ended',
            type: ToastificationType.error,
          );
          return;
        }

        await _broadcastService.updateGameStatus(
          lobbyId: currentRoom.id!,
          status: GameStatus.waiting,
          maxRounds: 0,
          currentRound: 0,
        );
      },
    );
  }

  Future<void> broadcastWheelSpinStart() async {
    await NetworkCall.networkCall(
      onError: (e, s) => AppToaster.showToast(
        'Error',
        subTitle: 'Failed to broadcast spin start: ${e.toString()}',
        type: ToastificationType.error,
      ),
      future: () async {
        _isWheelSpinning = true;
        update();

        final updated = await _broadcastService.broadcastWheelSpinStart(
          lobbyId: currentRoom.id!,
          currentRoom: _currentRoom,
        );

        if (updated != null) {
          setCurrentRoom(updated);
        }
      },
    );
  }

  Future<void> broadcastSelectedLetter(String letter, int selectedIndex) async {
    await NetworkCall.networkCall(
      onError: (e, s) => AppToaster.showToast(
        'Error',
        subTitle: 'Failed to broadcast letter: ${e.toString()}',
        type: ToastificationType.error,
      ),
      future: () async {
        setCurrentLetter(letter);
        _wheelSelectedIndex = selectedIndex;
        _isWheelSpinning = false;
        update();

        final updated = await _broadcastService.broadcastSelectedLetter(
          lobbyId: currentRoom.id!,
          currentRoom: _currentRoom,
          letter: letter,
          selectedIndex: selectedIndex,
        );

        if (updated != null) {
          setCurrentRoom(updated);
        }
      },
    );
  }

  Future<void> broadcastCountdown(int value) async {
    await NetworkCall.networkCall(
      onError: (e, s) => log('Failed to broadcast countdown: $e'),
      future: () async {
        _isCountdownActive = true;
        _countdownValue = value;
        update();

        await _broadcastService.broadcastCountdown(
          lobbyId: currentRoom.id!,
          currentRoom: _currentRoom,
          value: value,
          currentLetter: _currentLetter,
          wheelSelectedIndex: _wheelSelectedIndex,
        );
      },
    );
  }

  Future<void> broadcastCountdownComplete() async {
    await NetworkCall.networkCall(
      onError: (e, s) => log('Failed to broadcast countdown complete: $e'),
      future: () async {
        _isCountdownActive = false;
        update();

        await _broadcastService.broadcastCountdownComplete(
          lobbyId: currentRoom.id!,
          currentRoom: _currentRoom,
          currentLetter: _currentLetter,
          wheelSelectedIndex: _wheelSelectedIndex,
        );
      },
    );
  }

  Future<void> deleteRoom({bool shouldPop = true}) async {
    if (Get.isRegistered<LobbyCreationController>()) {
      Get.delete<LobbyCreationController>(force: true);
    }
    if (Get.isRegistered<JoinLobbyController>()) {
      Get.delete<JoinLobbyController>(force: true);
    }
    if (Get.isRegistered<LobbyController>()) {
      Get.delete<LobbyController>(force: true);
    }
    await _roomManager.deleteLobby(lobby.id!);
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
        Get.delete<JoinLobbyController>();
        Get.delete<LobbyCreationController>();
        await _roomManager.removePlayer(
          lobbyId: lobby.id!,
          currentRoom: _currentRoom,
          isKick: isKick,
          playerIdToKick: playerIdToKick,
        );
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
      reInitAllServices();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (navigatorKey.currentState?.canPop() ?? false) {
          navigatorKey.currentState!.pop();
        }
      });
      return;
    }

    _currentRoom = room;
    _updateWheelStateFromRoom(room);
    update();

    if (room.settings?.status == GameStatus.started) {
      phase = GamePhase.started;
    }
  }

  void _updateWheelStateFromRoom(LobbyModel room) {
    if (room.settings?.roundStatus != null &&
        room.settings!.roundStatus!.isNotEmpty) {
      for (final status in room.settings!.roundStatus!) {
        if (status.startsWith('letter:')) {
          final letter = status.substring('letter:'.length);
          if (_currentLetter != letter) {
            _currentLetter = letter;
            log('Received letter update: $letter', name: 'LetterSync');
          }
        } else if (status.startsWith('wheelIndex:')) {
          final indexStr = status.substring('wheelIndex:'.length);
          _wheelSelectedIndex = int.tryParse(indexStr);
        } else if (status.startsWith('wheelSpin:')) {
          final spinStatus = status.substring('wheelSpin:'.length);
          _isWheelSpinning = spinStatus == 'start';
        } else if (status.startsWith('countdown:')) {
          final countdownStr = status.substring('countdown:'.length);
          if (countdownStr == 'complete') {
            _isCountdownActive = false;
          } else {
            final value = int.tryParse(countdownStr);
            if (value != null) {
              _isCountdownActive = true;
              _countdownValue = value;
            }
          }
        }
      }
    }
  }

  void setRoomStatus({required RoomStatus status, LobbyModel? room}) {
    _roomStatus = status;
    update();

    switch (_roomStatus) {
      case RoomStatus.connected:
        if (room != null) {
          setCurrentRoom(room);
        } else {
          setCurrentRoom(lobby);
        }
        break;

      case RoomStatus.deleted:
        reInitAllServices();
        log('Room deleted', name: 'RoomStatus');
        AppToaster.showToast(
          'Lobby Deleted',
          subTitle: 'The lobby has been deleted by the host.',
          type: ToastificationType.error,
        );
        navigatorKey.currentContext?.go(MainMenuPage.path);
        break;

      case RoomStatus.updated:
        if (room != null) {
          setCurrentRoom(room);
        }
        break;

      default:
        break;
    }
  }

  PlayerStateModel getPlayerState() {
    return _currentRoom.lobbyStateRealTime?[AppService.getPlayerName()] ??
        PlayerStateModel();
  }

  void _handleRoomUpdate(
    RoomStatus status,
    LobbyModel? room,
    DateTime eventTime,
  ) {
    if (status == RoomStatus.updated && room != null) {
      _handleOptimizedUpdate(eventTime, room);
    } else {
      setRoomStatus(status: status, room: room);
    }
  }

  void _handleOptimizedUpdate(DateTime eventStartTime, LobbyModel newRoom) {
    final previousPlayers = Set<String>.from(_currentRoom.players ?? []);
    final newPlayers = Set<String>.from(newRoom.players ?? []);
    final joinedPlayers = newPlayers.difference(previousPlayers);
    final leftPlayers = previousPlayers.difference(newPlayers);

    final gameStarted =
        newRoom.settings?.status == GameStatus.started &&
        _currentRoom.settings?.status != GameStatus.started;

    if (joinedPlayers.isNotEmpty) {
      AudioService.instance.playAudio(AudioType.playerJoinPop);
    }
    if (gameStarted) {
      AudioService.instance.playAudio(AudioType.gameStartWhoosh);
    }

    _currentRoom = newRoom;
    update();

    if (joinedPlayers.isNotEmpty || leftPlayers.isNotEmpty) {
      final latency = DateTime.now().difference(eventStartTime);
      log(
        'Join/Leave detected - Joined: $joinedPlayers, Left: $leftPlayers, Latency: ${latency.inMilliseconds}ms',
        name: 'SSE',
      );

      _firestoreSync.syncJoinedPlayers(joinedPlayers, lobby.host!);
      _firestoreSync.syncLeftPlayers(leftPlayers);
    }

    if (gameStarted) {
      log('Game started broadcast received', name: 'SSE');
      phase = GamePhase.started;
      AppToaster.showToast(
        'Game Started!',
        subTitle: 'The game has begun',
        type: ToastificationType.success,
      );
    }

    setRoomStatus(status: RoomStatus.updated, room: newRoom);
  }

  void _startPlayerHeartbeat() {
    _playerHeartbeatTimer?.cancel();
    _playerHeartbeatTimer = Timer.periodic(const Duration(seconds: 10), (
      _,
    ) async {
      await PlayflowClient.instance.sendHearBears(lobby.id!);
      // Also update Firestore heartbeat to keep isOnline true
      final playerId = await AppService.getPlayerId();
      if (playerId != null && lobby.id != null) {
        try {
          await FirebaseFirestoreService.instance.updatePlayerHeartbeat(
            lobby.id!,
            playerId,
          );
        } catch (e) {
          // Silently fail - heartbeat update is not critical
          log('Heartbeat Firestore update failed: $e', name: 'LobbyHeartbeat');
        }
      }
    });
  }

  Future<void> _markPlayerOffline() async {
    try {
      final playerId = await AppService.getPlayerId();
      if (playerId != null && lobby.id != null) {
        await _firestoreSync.markPlayerLeft(playerId);
        log('Player marked as offline in Firestore', name: 'LobbyCleanup');
      }
    } catch (e, s) {
      log(
        'Error marking player as offline: $e',
        name: 'LobbyCleanup',
        error: e,
        stackTrace: s,
      );
    }
  }

  @override
  void onClose() {
    _playerHeartbeatTimer?.cancel();
    _sseManager.dispose();
    _answerController.dispose();
    _markPlayerOffline();
    super.onClose();
  }

  void resetController() {
    _selectedMaxRounds = null;
    _selectedTimePerRound = null;
    _answerController.clear();
    update();
  }

  Future<void> reInitAllServices() async {
    await NetworkCall.networkCall(
      onError: (e, s) => AppToaster.showToast(
        'Error',
        subTitle: 'Failed to reinitialize services: ${e.toString()}',
        type: ToastificationType.error,
      ),
      future: () async {
        log('Re-initializing all services', name: 'ServiceReInit');

        _playerHeartbeatTimer?.cancel();
        _playerHeartbeatTimer = null;

        _sseManager.dispose();

        await _markPlayerOffline();

        _initializeServices();

        await _sseManager.connect();

        _startPlayerHeartbeat();

        log('All services re-initialized successfully', name: 'ServiceReInit');

        AppToaster.showToast(
          'Reconnected',
          subTitle: 'Successfully reconnected to the lobby',
          type: ToastificationType.success,
        );

        update();
      },
    );
  }
}
