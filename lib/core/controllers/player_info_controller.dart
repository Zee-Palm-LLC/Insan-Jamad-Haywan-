import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/services/image_picker_service.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';

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
      AppToaster.showToast(
        'Please enter your username',
        type: ToastificationType.error,
      );
      return;
    }

    if (username.length < 2) {
      AppToaster.showToast(
        'Name must be at least 2 characters',
        type: ToastificationType.error,
      );
      return;
    }

    try {
      final currentPlayerId = await AppService.getPlayerId();
      final isDuplicate = await _checkDuplicateName(username, currentPlayerId);

      if (isDuplicate) {
        AppToaster.showToast(
          'Name Already Taken',
          subTitle:
              'This name is already in use. Please choose a different name.',
          type: ToastificationType.error,
        );
        return;
      }
    } catch (e) {
      developer.log(
        'Error checking duplicate name: $e',
        name: 'PlayerInfoController',
      );
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
        AppToaster.showToast(
          'Success',
          subTitle: 'Player info saved successfully',
          type: ToastificationType.success,
        );

        context.go('/main-menu');
      }
    } catch (e) {
      if (context.mounted) {
        isLoading = false;
        update();
        AppToaster.showToast(
          'Error',
          subTitle: 'Failed to save player info: $e',
          type: ToastificationType.error,
        );
      }
    }
  }

  Future<bool> _checkDuplicateName(
    String username,
    String? currentPlayerId,
  ) async {
    try {
      final exists = await FirebaseFirestoreService.instance.gamePlayerExists(
        username,
      );

      if (exists && username != currentPlayerId) {
        return true;
      }

      return false;
    } catch (e) {
      print('Error checking duplicate name: $e');
      return false;
    }
  }
}
