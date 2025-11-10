import 'dart:async';
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/modules/players/player_answers/player_answer_view.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';

class WaitingViewController extends GetxController {
  LobbyController get lobbyController => Get.find<LobbyController>();
  WheelController get wheelController => Get.find<WheelController>();

  bool isCountdownActive = false;
  int countdownValue = 3;
  String? get selectedLetter => wheelController.selectedLetter;
  String playerName = '';
  String? playerAvatar;

  @override
  void onInit() {
    super.onInit();
    _loadPlayerInfo();
    _listenToLobbyUpdates();
  }

  Future<void> _loadPlayerInfo() async {
    playerName = await AppService.getPlayerId() ?? 'Player';
    playerAvatar = await AppService.getProfileImage();
    update();
  }

  void _listenToLobbyUpdates() {
    _checkLobbyState();
  }

  void _checkLobbyState() {
    if (lobbyController.isCountdownActive && !isCountdownActive) {
      _handleCountdownStart();
    } else if (!lobbyController.isCountdownActive && isCountdownActive) {
      _handleCountdownComplete();
    } else if (lobbyController.isCountdownActive &&
        isCountdownActive &&
        lobbyController.countdownValue != countdownValue) {
      countdownValue = lobbyController.countdownValue;
      update();
    }

    if (lobbyController.currentLetter != wheelController.selectedLetter) {
      wheelController.selectedLetter = lobbyController.currentLetter;
      update();
    }
  }

  void syncWithLobby() {
    _checkLobbyState();
  }

  void _handleCountdownStart() {
    developer.log('Countdown started on waiting view', name: 'WaitingView');
    isCountdownActive = true;
    countdownValue = lobbyController.countdownValue;
    update();
  }

  void _handleCountdownComplete() {
    developer.log('Countdown completed on waiting view', name: 'WaitingView');
    isCountdownActive = false;
    update();

    if (selectedLetter != null) {
      final sessionId =
          lobbyController.lobby.id ?? lobbyController.currentRoom.id;
      final roundNumber =
          (lobbyController.currentRoom.settings?.currentRound ?? 0) + 1;
      final totalSeconds = lobbyController.selectedTimePerRound ?? 60;

      Future.delayed(const Duration(milliseconds: 500), () {
        try {
          final context = navigatorKey.currentContext;
          if (context != null && context.mounted) {
            GoRouter.of(context).go(PlayerAnswerView.path);
            developer.log(
              'Navigation successful to PlayerAnswerView',
              name: 'WaitingView',
            );
          } else {
            developer.log(
              'Navigator context is null or not mounted, cannot navigate',
              name: 'WaitingView',
            );
          }
        } catch (e, s) {
          developer.log(
            'Navigation error: $e',
            name: 'WaitingView',
            error: e,
            stackTrace: s,
          );
        }
      });
    }
  }

  String get lobbyCode {
    return lobbyController.currentRoom.inviteCode ?? 'XYZ124';
  }
}
