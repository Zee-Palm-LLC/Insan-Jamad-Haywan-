import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/models/lobby/lobby_model.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/playflow/playflow_client.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';
import 'package:insan_jamd_hawan/core/utils/network_call.dart';

class JoinLobbyController extends GetxController {
  final codeController = TextEditingController();
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> ensurePlayerName(BuildContext context) async {
    final playerId = await AppService.getPlayerId();
    if (playerId == null || playerId.startsWith('guest_')) {}
  }

  Future<void> joinLobby(BuildContext context) async {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      AppToaster.showToast(
        'Invite code is required',
        type: ToastificationType.error,
      );
      return;
    }

    setLoading(true);

    await NetworkCall.networkCall(
      onComplete: (_) => setLoading(false),
      onError: (e, s) {
        setLoading(false);
        final errorMessage = e.toString().toLowerCase();
        String title = 'Failed to join';
        String subtitle = e.toString();

        // Handle specific error cases
        if (errorMessage.contains('already in') ||
            errorMessage.contains('duplicate') ||
            errorMessage.contains('already exists') ||
            errorMessage.contains('name')) {
          title = 'Duplicate Player Name';
          subtitle =
              'A player with this name is already in the lobby. '
              'Please change your player name and try again.';
        } else if (errorMessage.contains('not found') ||
            errorMessage.contains('invalid') ||
            errorMessage.contains('not available')) {
          title = 'Lobby Not Found';
          subtitle =
              'The invite code or lobby ID is invalid or the lobby no longer exists.';
        } else if (errorMessage.contains('full') ||
            errorMessage.contains('maximum')) {
          title = 'Lobby Full';
          subtitle = 'This lobby has reached the maximum number of players.';
        }

        AppToaster.showToast(
          title,
          subTitle: subtitle,
          type: ToastificationType.error,
        );
      },
      future: () async {
        String? playerId = await AppService.getPlayerId();
        if (playerId == null || playerId.startsWith('guest_')) {
          throw Exception('Please set your player name first');
        }

        // Try to check for duplicate name before joining
        String cleaned = code
            .trim()
            .replaceAll('insan-jamd-hawan-', '')
            .replaceAll('INSAN-JAMD-HAWAN-', '');
        final String withoutDashes = cleaned.replaceAll('-', '');
        final bool isUuid = cleaned.contains('-') && withoutDashes.length == 32;

        // If we have a UUID, try to get lobby players list first to check for duplicates
        if (isUuid) {
          try {
            final players = await PlayflowClient.instance.getPlayers(
              lobbyId: cleaned,
            );
            if (players != null && players.contains(playerId)) {
              throw Exception(
                'A player with the name "$playerId" is already in this lobby. '
                'Please change your player name before joining.',
              );
            }
          } catch (e) {
            // If getPlayers fails (lobby doesn't exist, no access, etc.),
            // proceed with join - backend will handle duplicate check
            if (!e.toString().contains('already in this lobby')) {
              // Only ignore if it's not a duplicate name error
            } else {
              rethrow;
            }
          }
        }

        final LobbyModel? lobby = await PlayflowClient.instance.joinGameRoom(
          code: code,
        );
        if (lobby == null) {
          throw Exception('Invalid invite code or lobby not available');
        }

        final controller = LobbyController(lobby: lobby);
        context.push('/lobby/${lobby.id}', extra: controller);
      },
    );
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }
}
