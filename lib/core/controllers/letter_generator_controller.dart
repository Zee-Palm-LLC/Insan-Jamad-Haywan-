import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/answers_host/answers_host_view.dart';

class LetterGeneratorController extends GetxController {
  String? selectedLetter;
  final LobbyController? lobbyController;

  LetterGeneratorController({this.lobbyController});

  Future<void> handleSpinComplete(String letter) async {
    selectedLetter = letter;
    update();
    // Broadcasting is now handled by FortuneWheelController
  }

  void handleCountdownComplete(String letter) {
    // Navigate to answers screen after countdown
    final context = Get.context;
    if (context != null) {
      context.push(AnswersHostView.path.replaceAll(':letter', letter));
    }
  }
}
