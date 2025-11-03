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
    lobbyNameController.text = 'My Game Lobby';
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
        final msg = e.toString().toLowerCase();
        if (msg.contains('duplicate') ||
            msg.contains('already exists') ||
            msg.contains('name')) {
          AppToaster.showToast(
            'Duplicate Name',
            subTitle:
                'A lobby with this name already exists. Please choose a different name.',
            type: ToastificationType.error,
          );
        } else {
          AppToaster.showToast(
            'Error',
            subTitle: e.toString(),
            type: ToastificationType.error,
          );
        }
      },
      future: () async {
        String? playerId = await AppService.getPlayerId();
        if (playerId == null || playerId.startsWith('guest_')) {
          throw Exception('Please set your player name first');
        }

        LobbyConfigModel config = LobbyConfigModel(
          name: lobbyNameController.text.trim(),
          maxPlayers: int.tryParse(maxPlayers) ?? 4,
          isPrivate: false,
          allowLateJoin: false,
          region: 'us-west',
          host: playerId,
        );

        LobbyModel? lobby = await PlayflowClient.instance.createGameRoom(
          config: config,
        );
        if (lobby == null) throw Exception('Failed to create lobby');

        // Optimistically ensure host appears in players
        final List<String> initialPlayers = List<String>.from(
          lobby.players ?? [],
        );
        if (!initialPlayers.contains(playerId)) initialPlayers.add(playerId);
        final LobbyModel updatedLobby = lobby.copyWith(players: initialPlayers);

        final controller = LobbyController(lobby: updatedLobby);
        controller.onMaxRoundChange(int.tryParse(maxRounds) ?? 3);
        context.push('/lobby/${lobby.id}', extra: controller);
      },
    );
  }

  @override
  void onClose() {
    lobbyNameController.dispose();
    super.onClose();
  }
}
