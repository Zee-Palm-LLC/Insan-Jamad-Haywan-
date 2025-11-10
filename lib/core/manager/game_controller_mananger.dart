import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/answer_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';

class GameControllerManager {
  static putAllGameControllers() {
    Get.put(WheelController(), permanent: true);
    Get.put(AnswerController(), permanent: true);
  }

  static deleteAllGameController() {
    Get.delete<WheelController>();
    Get.delete<AnswerController>();
  }

  static restAllControllers() {
    if (Get.isRegistered<WheelController>()) {
      Get.find<WheelController>().resetController();
      Get.find<AnswerController>().restController();
    }
  }
}
