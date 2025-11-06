import 'dart:developer';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/modules/players/player_answers/player_answer_view.dart';
import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';

class PlayerWheelController extends GetxController {
  String? selectedLetter;

  LobbyController? get lobbyController {
    try {
      return Get.find<LobbyController>();
    } catch (e) {
      return null;
    }
  }

  Future<void> handleSpinComplete(String letter) async {
    selectedLetter = letter;
    log('Player: Letter "$letter" selected', name: 'PlayerWheel');
    update();
  }

  void handleCountdownComplete(String letter) {
    log('Player: Countdown complete for letter "$letter"', name: 'PlayerWheel');

    if (selectedLetter != null && lobbyController != null) {
      final sessionId = lobbyController!.lobby.id!;
      final roundNumber =
          (lobbyController!.currentRoom.settings?.currentRound ?? 0) + 1;
      final totalSeconds = lobbyController!.selectedTimePerRound ?? 60;

      Future.delayed(const Duration(milliseconds: 500), () {
        try {
          final context = navigatorKey.currentContext;
          if (context != null && context.mounted) {
            GoRouter.of(context).go(
              '${PlayerAnswerView.path}?letter=$selectedLetter',
              extra: {
                'sessionId': sessionId,
                'roundNumber': roundNumber,
                'selectedLetter': selectedLetter,
                'totalSeconds': totalSeconds,
              },
            );
            log(
              'Navigation successful to PlayerAnswerView',
              name: 'PlayerWheel',
            );
          } else {
            log(
              'Navigator context is null or not mounted, cannot navigate',
              name: 'PlayerWheel',
            );
          }
        } catch (e, s) {
          log(
            'Navigation error: $e',
            name: 'PlayerWheel',
            error: e,
            stackTrace: s,
          );
        }
      });
    }
  }
}
