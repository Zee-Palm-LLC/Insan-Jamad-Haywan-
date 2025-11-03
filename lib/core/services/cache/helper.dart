import 'package:insan_jamd_hawan/core/services/cache/storage_service.dart';
import 'package:insan_jamd_hawan/core/services/cache/stored_keys.dart';
import 'dart:math';

class AppService {
  static StorageService get storage => StorageService.instance;
  static AppService get instance => _instance;
  static final AppService _instance = AppService._();

  AppService._();

  static Future<bool> isPlayerIdSet() async {
    final playerId = storage.getString(StoredKeys.playerId);
    return playerId != null;
  }

  static Future<void> setPlayerId(String playerId) async {
    await storage.setString(StoredKeys.playerId, playerId);
  }

  static Future<void> clearPlayerId() async {
    await storage.remove(StoredKeys.playerId);
  }

  static Future<String?> getPlayerId() async {
    return storage.getString(StoredKeys.playerId);
  }

  static String? getPlayerName() {
    return storage.getString(StoredKeys.playerId);
  }

  static bool getIsSoundOn() {
    return storage.getString(StoredKeys.isSoundOn) == 'true';
  }

  static Future<void> setIsSoundOn(bool isSoundOn) async {
    await storage.setString(StoredKeys.isSoundOn, isSoundOn.toString());
  }

  static Future<String> ensurePlayerId() async {
    final existing = storage.getString(StoredKeys.playerId);
    if (existing != null && existing.isNotEmpty) return existing;

    final userId = storage.getString(StoredKeys.userId);
    final newId = userId ?? _generateGuestId();
    await storage.setString(StoredKeys.playerId, newId);
    return newId;
  }

  static String _generateGuestId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    String randPart = List.generate(
      8,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();
    return 'guest_${DateTime.now().millisecondsSinceEpoch}_$randPart';
  }
}
