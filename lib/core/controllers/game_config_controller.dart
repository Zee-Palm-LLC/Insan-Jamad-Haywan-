import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/config/game_config.dart';

class GameConfigController extends GetxController {
  bool isInitialized = false;
  late FirebaseApp firebaseApp;
  GameConfigController({required this.firebaseApp});

  @override
  void onInit() {
    super.onInit();
    initialize(firebaseApp: firebaseApp);
  }

  Future<void> initialize({required FirebaseApp firebaseApp}) async {
    try {
      GameConfig.init(firebaseApp: firebaseApp);
      isInitialized = true;
      update();
    } catch (e) {
      throw Exception("Failed to initialize game");
    }
  }
}
