import 'package:insan_jamd_hawan/core/db/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/models/session/game_player_model.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';

class GamePlayerService {
  static final GamePlayerService instance = GamePlayerService._();
  GamePlayerService._();

  Future<Map<String, String?>> getCurrentPlayerInfo() async {
    final username = await AppService.getPlayerId();
    final profileImage = await AppService.getProfileImage();
    return {
      'username': username,
      'playerId': username,
      'profileImage': profileImage,
    };
  }

  Future<GamePlayerModel> savePlayerInfo({
    required String username,
    String? profileImage,
  }) async {
    await AppService.setPlayerId(username);
    if (profileImage != null) {
      await AppService.setProfileImage(profileImage);
    }

    final firestore = FirebaseFirestoreService.instance;
    final player = await firestore.getOrCreateGamePlayer(
      username: username,
      profileImage: profileImage,
    );

    return player;
  }

  Future<void> updateProfileImage(String imagePath) async {
    final username = await AppService.getPlayerId();
    if (username == null) {
      throw Exception('No username found. Please set username first.');
    }

    await AppService.setProfileImage(imagePath);

    final firestore = FirebaseFirestoreService.instance;
    await firestore.updateGamePlayerImage(username, imagePath);
  }

  Future<GamePlayerModel?> getPlayer(String playerId) async {
    final firestore = FirebaseFirestoreService.instance;
    return await firestore.getGamePlayer(playerId);
  }

  Future<GamePlayerModel?> syncLocalPlayerToFirestore() async {
    final username = await AppService.getPlayerId();
    if (username == null) return null;

    final profileImage = await AppService.getProfileImage();

    final firestore = FirebaseFirestoreService.instance;
    final player = await firestore.getOrCreateGamePlayer(
      username: username,
      profileImage: profileImage,
    );

    return player;
  }

  Future<void> updateLastActive() async {
    final username = await AppService.getPlayerId();
    if (username == null) return;

    final firestore = FirebaseFirestoreService.instance;
    await firestore.updateGamePlayerLastActive(username);
  }

  Future<void> clearPlayerData() async {
    await AppService.clearPlayerId();
    await AppService.clearProfileImage();
  }

  Future<String?> getCurrentUsername() async {
    return await AppService.getPlayerId();
  }

  Future<String?> getCurrentProfileImage() async {
    return await AppService.getProfileImage();
  }
}
