import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_config_model.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_model.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/playflow/playflow_client.dart';
import 'package:insan_jamd_hawan/core/utils/network_call.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';

class LobbyCreationController extends GetxController {
  final lobbyNameController = TextEditingController();
  String maxPlayers = '4';
  String maxRounds = '3';
  String timerPerRound = '60';
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    // Generate unique lobby name with timestamp to avoid duplicates
    final timestamp = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(7);
    lobbyNameController.text = 'Lobby $timestamp';
  }

  void setMaxPlayers(String? value) {
    maxPlayers = value ?? '4';
    update();
  }

  void setMaxRounds(String? value) {
    maxRounds = value ?? '3';
    update();
  }

  void setTimerPerRound(String? value) {
    timerPerRound = value ?? '60';
    update();
  }

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> ensurePlayerName(BuildContext context) async {
    final playerId = await AppService.getPlayerId();
    if (playerId == null || playerId.startsWith('guest_')) {}
  }

  Future<void> createLobby(BuildContext context) async {
    // First check if player name is set
    String? playerId = await AppService.getPlayerId();
    if (playerId == null || playerId.isEmpty || playerId.startsWith('guest_')) {
      AppToaster.showToast(
        'Username Required',
        subTitle: 'Please set your username first from the main menu',
        type: ToastificationType.error,
      );
      // Navigate back to player info page
      if (context.mounted) {
        context.go('/player-info');
      }
      return;
    }

    if (lobbyNameController.text.trim().isEmpty) {
      AppToaster.showToast(
        'Error',
        subTitle: 'Please enter a lobby name',
        type: ToastificationType.error,
      );
      return;
    }

    setLoading(true);
    await NetworkCall.networkCall(
      onComplete: (_) => setLoading(false),
      onError: (e, s) {
        setLoading(false);
        developer.log(
          'Lobby creation error: $e',
          name: 'LobbyCreation',
          error: e,
          stackTrace: s,
        );

        final msg = e.toString().toLowerCase();
        String errorTitle = 'Error';
        String errorSubtitle = e.toString();

        if (msg.contains('duplicate') ||
            msg.contains('already exists') ||
            msg.contains('name') ||
            msg.contains('lobby') && msg.contains('username')) {
          errorTitle = 'Lobby Already Exists';
          errorSubtitle =
              'You already have an active lobby or this name is taken. Please wait a moment and try again with a different name.';
        } else if (msg.contains('500') || msg.contains('internal server')) {
          errorTitle = 'Server Error';
          errorSubtitle =
              'Server encountered an error. Please try again or check server logs.';
        }

        AppToaster.showToast(
          errorTitle,
          subTitle: errorSubtitle,
          type: ToastificationType.error,
        );
      },
      future: () async {
        String? playerId = await AppService.getPlayerId();
        if (playerId == null || playerId.startsWith('guest_')) {
          throw Exception('Please set your player name first');
        }

        // Clean up any existing lobby before creating a new one
        try {
          final existingLobby = await PlayflowClient.instance.getGameRoom();
          if (existingLobby != null && existingLobby.id != null) {
            developer.log(
              'Found existing lobby ${existingLobby.id}, cleaning up before creating new one...',
              name: 'LobbyCreation',
            );
            if (existingLobby.host == playerId) {
              await PlayflowClient.instance.deleteLobby(
                lobbyId: existingLobby.id!,
              );
            } else {
              await PlayflowClient.instance.kickPlayer(
                lobbyId: existingLobby.id!,
                playerIdToKick: playerId,
                isKick: false,
              );
            }
            // Wait a moment for server to process the deletion
            await Future.delayed(const Duration(milliseconds: 500));
          }
        } catch (e) {
          developer.log(
            'No existing lobby found or error checking (this is fine): $e',
            name: 'LobbyCreation',
          );
        }

        LobbyConfigModel config = LobbyConfigModel(
          name: lobbyNameController.text.trim(),
          maxPlayers: int.tryParse(maxPlayers) ?? 4,
          isPrivate: false,
          // Note: useInviteCode causes 500 error - backend doesn't support it in this config
          allowLateJoin: false,
          region: 'us-west',
          host: playerId,
        );

        developer.log(
          'Creating lobby with config: ${config.toJson()}',
          name: 'LobbyCreation',
        );

        LobbyModel? lobby = await PlayflowClient.instance.createGameRoom(
          config: config,
        );

        if (lobby == null) {
          developer.log('Lobby creation returned null', name: 'LobbyCreation');
          throw Exception('Failed to create lobby');
        }

        developer.log(
          'Lobby created: id=${lobby.id}, inviteCode=${lobby.inviteCode}, players=${lobby.players}',
          name: 'LobbyCreation',
        );

        // Optimistically ensure host appears in players
        final List<String> initialPlayers = List<String>.from(
          lobby.players ?? [],
        );
        if (!initialPlayers.contains(playerId)) initialPlayers.add(playerId);
        final LobbyModel updatedLobby = lobby.copyWith(players: initialPlayers);

        final controller = LobbyController(lobby: updatedLobby);
        controller.onMaxRoundChange(int.tryParse(maxRounds) ?? 3);
        controller.onTimePerRoundChange(int.tryParse(timerPerRound) ?? 60);

        // Navigate to game lobby
        if (context.mounted) {
          context.push('/lobby/${lobby.id}', extra: controller);
        }
      },
    );
  }

  @override
  void onClose() {
    lobbyNameController.dispose();
    super.onClose();
  }
}
