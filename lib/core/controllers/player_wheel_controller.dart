import 'dart:developer';

import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';

class PlayerWheelController extends GetxController {
  String? selectedLetter;
  final LobbyController? lobbyController;

  PlayerWheelController({this.lobbyController});

  Future<void> handleSpinComplete(String letter) async {
    selectedLetter = letter;
    log('Player: Letter "$letter" selected', name: 'PlayerWheel');
    update();
  }

  void handleCountdownComplete(String letter) {
    log('Player: Countdown complete for letter "$letter"', name: 'PlayerWheel');
    // Navigate to player answer screen after countdown
    final context = Get.context;
    if (context != null) {
      // For now, just stay on the same screen
      // TODO: Implement player answer view navigation
      // context.push('/player-answer/$letter');
    }
  }
}
