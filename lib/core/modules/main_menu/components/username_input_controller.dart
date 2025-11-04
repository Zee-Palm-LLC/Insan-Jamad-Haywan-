import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';

class UsernameInputController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  Future<void> saveUsername(BuildContext context) async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      AppToaster.showToast(
        'Please enter your name',
        type: ToastificationType.error,
      );
      return;
    }

    if (name.length < 2) {
      AppToaster.showToast(
        'Name must be at least 2 characters',
        type: ToastificationType.error,
      );
      return;
    }

    isLoading = true;
    update();

    try {
      await AppService.setPlayerId(name);
      print('[UsernameInputController] Username saved: $name');

      // Verify it was saved
      final saved = await AppService.getPlayerId();
      print('[UsernameInputController] Verification - saved username: $saved');

      if (context.mounted) {
        Navigator.of(context).pop(name);
      }
    } catch (e) {
      if (context.mounted) {
        AppToaster.showToast(
          'Failed to save name: $e',
          type: ToastificationType.error,
        );
        isLoading = false;
        update();
      }
    }
  }
}
