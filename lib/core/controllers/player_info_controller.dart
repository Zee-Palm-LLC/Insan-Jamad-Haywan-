import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/image_picker_service.dart';

class PlayerInfoController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final ImagePickerService _imagePickerService = ImagePickerService();
  String? profileImagePath;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    _loadSavedProfileInfo();
  }

  Future<void> _loadSavedProfileInfo() async {
    final savedUsername = await AppService.getPlayerId();
    if (savedUsername != null && savedUsername.isNotEmpty) {
      usernameController.text = savedUsername;
    }

    final savedImagePath = await AppService.getProfileImage();
    if (savedImagePath != null && savedImagePath.isNotEmpty) {
      profileImagePath = savedImagePath;
      update();
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    super.onClose();
  }

  Future<void> pickProfileImage() async {
    final imagePath = await _imagePickerService.pickImageFromGallery();
    if (imagePath != null) {
      profileImagePath = imagePath;
      update();
    }
  }

  Future<void> savePlayerInfo(BuildContext context) async {
    final username = usernameController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your username')),
      );
      return;
    }

    isLoading = true;
    update();

    try {
      await AppService.setPlayerId(username);

      if (profileImagePath != null) {
        await AppService.setProfileImage(profileImagePath!);
      }

      if (context.mounted) {
        isLoading = false;
        update();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Player info saved successfully'),
            backgroundColor: Colors.green,
          ),
        );

        context.go('/main-menu');
      }
    } catch (e) {
      if (context.mounted) {
        isLoading = false;
        update();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving player info: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
