import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Service for picking images that supports both web and mobile platforms
class ImagePickerService {
  static final ImagePickerService _instance = ImagePickerService._internal();
  factory ImagePickerService() => _instance;
  ImagePickerService._internal();

  final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery (works on both web and mobile)
  /// Returns the file path (or blob/data URL on web) or null if cancelled/error
  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return null;

      // On web, image.path is a blob URL or data URL
      // On mobile, image.path is a file path
      return image.path;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  /// Pick an image from camera (mobile only)
  /// Returns the file path or null if cancelled/error
  Future<String?> pickImageFromCamera() async {
    try {
      if (kIsWeb) {
        // Camera not supported on web
        return null;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) return null;

      return image.path;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }

  /// Get image file from path (for mobile only)
  /// On web, use Image.network() or Image.memory() instead
  File? getImageFile(String path) {
    if (kIsWeb) return null;
    return File(path);
  }

  /// Get image bytes from XFile (works on both web and mobile)
  /// Useful for uploading or converting images
  Future<Uint8List?> getImageBytesFromPath(String path) async {
    try {
      if (kIsWeb) {
        // On web, path might be a blob URL or data URL
        // For blob URLs, use Image.network() directly
        // For data URLs, extract the base64 part
        if (path.startsWith('data:')) {
          final base64String = path.split(',')[1];
          return base64Decode(base64String);
        }
        // For blob URLs, return null as they can't be read directly
        // Use Image.network() instead
        return null;
      } else {
        // On mobile, read from file
        final file = File(path);
        return await file.readAsBytes();
      }
    } catch (e) {
      debugPrint('Error getting image bytes: $e');
      return null;
    }
  }

  /// Pick image with source selection dialog
  /// Returns the file path or null if cancelled/error
  Future<String?> pickImage({bool showCameraOption = true}) async {
    if (kIsWeb || !showCameraOption) {
      // Web only supports gallery, or if camera option is disabled
      return pickImageFromGallery();
    }

    // For mobile, you can show a dialog to choose between gallery and camera
    // For now, we'll default to gallery
    // You can extend this to show a dialog/bottom sheet
    return pickImageFromGallery();
  }
}

