import 'package:firebase_core/firebase_core.dart';
import 'package:insan_jamd_hawan/core/db/firebase_firestore_service.dart';

class GameConfig {
  static void init({
    required FirebaseApp firebaseApp,
    String gameId = 'insan_jamd_hawan',
  }) {
    FirebaseFirestoreService.initialize(app: firebaseApp, gameId: gameId);
  }
}
