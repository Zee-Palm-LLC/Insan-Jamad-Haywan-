import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/modules/main_menu/components/username_input_dialog.dart';

class MainMenuController extends GetxController {
  String playerName = '';

  @override
  void onReady() {
    super.onReady();
    // Load player name when ready (router already checked username exists)
    loadPlayerName();
  }

  Future<void> loadPlayerName() async {
    final name = await AppService.getPlayerId();
    playerName = name ?? 'Player';
    update();
  }

  Future<void> showChangeNameDialog() async {
    final context = Get.context;
    if (context != null && context.mounted) {
      final result = await UsernameInputDialog.show(context);
      if (result != null) {
        await loadPlayerName();
      }
    }
  }
}
