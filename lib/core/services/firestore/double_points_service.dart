import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/answer_controller.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';

class DoublePointsService {
  final FirebaseFirestoreService _db = FirebaseFirestoreService.instance;
  final LobbyController lobbyController = Get.find<LobbyController>();
  final AnswerController answerController = Get.find<AnswerController>();
  RxBool _canUseDoublePoints = false.obs;
  RxBool doublePoints = false.obs;

  DoublePointsService() {
    checkDoublePointsAvailability(
      onCheck: (canUseDoublePoints) {
        _canUseDoublePoints.value = canUseDoublePoints;
        update();
      },
    );
  }

  Future<void> checkDoublePointsAvailability({
    required Function(bool) onCheck,
  }) async {
    try {
      String? playerId = await AppService.getPlayerId();
      if (playerId == null) {
        _canUseDoublePoints.value = false;
        onCheck(false);
        return;
      }

      final sessionId = lobbyController.lobby.id ?? "";
      if (sessionId.isEmpty) {
        _canUseDoublePoints.value = false;
        onCheck(false);
        return;
      }

      final participation = await _db.getPlayer(sessionId, playerId);
      if (participation == null) {
        return;
      } else {
        _canUseDoublePoints.value = (participation.hasUsedDoublePoints == true
            ? false
            : true);
        onCheck(_canUseDoublePoints.value);
        log(
          'Double points availability checked: $_canUseDoublePoints.value '
          '(player: $playerId, hasUsedDoublePoints: ${participation?.hasUsedDoublePoints})',
          name: 'AnswerController',
        );
        onCheck(_canUseDoublePoints.value);
        return;
      }
    } catch (e) {
      log(
        'Error checking double points availability: $e',
        name: 'AnswerController',
      );
      _canUseDoublePoints.value = false;
      onCheck(false);
    }
  }

  void toggleDoublePoints() {
    if (!_canUseDoublePoints.value) {
      AppToaster.showToast(
        "Double Points Already Used",
        subTitle:
            "You have already used your double points option in a previous round.",
        type: ToastificationType.warning,
      );
      return;
    }

    doublePoints.value = !doublePoints.value;
    log('Double points toggled: $doublePoints.value', name: 'AnswerController');
    checkDoublePointsAvailability(
      onCheck: (canUseDoublePoints) {
        _canUseDoublePoints.value = canUseDoublePoints;
        update();
      },
    );
  }

  bool get canUseDoublePoints => _canUseDoublePoints.value;
  void update() {
    answerController.update();
  }

  void reset() {
    _canUseDoublePoints.value = false;
    doublePoints.value = false;
    update();
  }
}
