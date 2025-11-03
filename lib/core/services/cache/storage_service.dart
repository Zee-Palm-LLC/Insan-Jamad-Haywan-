import 'package:insan_jamd_hawan/core/services/cache/stored_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late SharedPreferences _sharedPreferences;

  StorageService._();

  static StorageService get instance => _instance;
  static final StorageService _instance = StorageService._();

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setString(StoredKeys.isSoundOn, 'true');
  }

  Future<void> setString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  Future<void> remove(String key) async {
    await _sharedPreferences.remove(key);
  }

  Future<void> clear() async {
    await _sharedPreferences.clear();
  }
}
