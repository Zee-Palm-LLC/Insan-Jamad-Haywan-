import 'package:insan_jamd_hawan/core/db/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/models/user/user_model.dart';
import 'package:insan_jamd_hawan/core/services/cache/storage_service.dart';
import 'package:insan_jamd_hawan/core/services/cache/stored_keys.dart';

class UserRepository {
  UserRepository._privateConstructor();
  static final UserRepository _instance = UserRepository._privateConstructor();
  static UserRepository get instance => _instance;

  final FirebaseFirestoreService _firestoreService =
      FirebaseFirestoreService.instance;

  Future<void> createUser({required UserModel user}) async {
    await _firestoreService.users.doc(user.id).set(user);
  }

  Future<UserModel?> getUser([String? defaultUserId]) async {
    final userId =
        defaultUserId ?? StorageService.instance.getString(StoredKeys.userId);
    if (userId == null) {
      return null;
    }
    final user = await _firestoreService.users.doc(userId).get();
    return user.data();
  }
}
