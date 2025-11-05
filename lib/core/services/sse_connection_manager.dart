import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_model.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/playflow/credentials.dart';
import 'package:insan_jamd_hawan/core/services/playflow/endpoints.dart';
import 'package:insan_jamd_hawan/core/services/playflow/playflow_client.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';
import 'package:insan_jamd_hawan/core/data/enums/enums.dart';

class SSEConnectionManager {
  final String lobbyId;
  final Function(RoomStatus status, LobbyModel? room, DateTime eventTime)
  onRoomUpdate;
  final Function() onConnectionStatusChanged;

  StreamSubscription<SSEModel>? _sseSubscription;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  static const int _initialReconnectDelay = 2; // seconds

  bool _isReconnecting = false;
  bool _isConnected = false;
  bool _isDisposed = false;

  Duration? _serverTimeOffset;

  bool get isConnected => _isConnected;
  bool get isReconnecting => _isReconnecting;
  DateTime? get serverTime {
    if (_serverTimeOffset == null) return DateTime.now();
    return DateTime.now().add(_serverTimeOffset!);
  }

  SSEConnectionManager({
    required this.lobbyId,
    required this.onRoomUpdate,
    required this.onConnectionStatusChanged,
  });

  /// Initialize SSE connection
  Future<void> connect() async {
    if (_isDisposed) return;

    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        log('Cannot connect SSE: Player ID is not set', name: 'SSE');
        return;
      }

      _sseSubscription?.cancel();

      await PlayflowClient.instance.sendHearBears(lobbyId);

      _isReconnecting = false;
      _reconnectAttempts = 0;
      _notifyConnectionStatus();

      _sseSubscription =
          SSEClient.subscribeToSSE(
            method: SSERequestType.GET,
            url:
                "${PlayflowEndpoints.lobbyHeartbeat(lobbyId)}?lobby-config=${PlayflowCredentials.lobbyId}&player-id=$playerId",
            header: {
              "Content-Type": "application/json",
              "api-key": PlayflowCredentials.apiKey,
            },
          ).listen(
            _handleEvent,
            onError: _handleError,
            onDone: _handleDone,
            cancelOnError: false,
          );

      _isConnected = true;
      _notifyConnectionStatus();
      log('SSE connected successfully', name: 'SSE');
    } catch (e, stackTrace) {
      log(
        'Failed to connect SSE: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'SSE',
      );
      _isConnected = false;
      _notifyConnectionStatus();
      _scheduleReconnect();
    }
  }

  void _handleEvent(SSEModel event) {
    if (_isDisposed) return;

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
        _notifyConnectionStatus();
        log('SSE reconnected successfully', name: 'SSE');
      }

      String formattedEvent = event.event!.startsWith('lobby:')
          ? event.event!.replaceAll('lobby:', '')
          : event.event!;

      // Parse room status
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

      // Decode JSON
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

      // Parse lobby model
      LobbyModel? room;
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

        // Sync server time
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
      } else {
        log('SSE event data is not a Map: ${decoded.runtimeType}', name: 'SSE');
        return;
      }

      // Notify room update
      onRoomUpdate(status, room, eventStartTime);

      // Measure latency
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

  void _handleError(error) {
    if (_isDisposed) return;

    log('SSE error occurred: $error', name: 'SSE', error: error);
    _isConnected = false;
    _notifyConnectionStatus();

    if (!_isReconnecting) {
      AppToaster.showToast(
        'Connection Lost',
        subTitle: 'Attempting to reconnect...',
        type: ToastificationType.warning,
      );
      _scheduleReconnect();
    }
  }

  void _handleDone() {
    if (_isDisposed) return;

    log('SSE connection closed', name: 'SSE');
    _isConnected = false;
    _notifyConnectionStatus();

    if (!_isReconnecting) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed) return;

    if (_reconnectAttempts >= _maxReconnectAttempts) {
      log(
        'Max reconnect attempts reached ($_maxReconnectAttempts). Giving up.',
        name: 'SSE',
      );
      _isReconnecting = false;
      _notifyConnectionStatus();
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
    _notifyConnectionStatus();

    int delay = (_initialReconnectDelay * (1 << (_reconnectAttempts - 1)))
        .clamp(_initialReconnectDelay, 30);

    log(
      'Scheduling SSE reconnect attempt $_reconnectAttempts/$_maxReconnectAttempts in ${delay}s',
      name: 'SSE',
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delay), () {
      if (!_isDisposed) {
        log('Attempting SSE reconnect...', name: 'SSE');
        connect();
      }
    });
  }

  void cancelReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _isReconnecting = false;
    _reconnectAttempts = 0;
  }

  void _notifyConnectionStatus() {
    onConnectionStatusChanged();
  }

  void dispose() {
    _isDisposed = true;
    _sseSubscription?.cancel();
    _reconnectTimer?.cancel();
    _isConnected = false;
    _isReconnecting = false;
    log('SSEConnectionManager disposed', name: 'SSE');
  }
}
