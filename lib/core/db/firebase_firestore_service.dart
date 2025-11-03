import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insan_jamd_hawan/core/models/user/user_model.dart';
import 'package:insan_jamd_hawan/main.dart';

class FirebaseFirestoreService {
  FirebaseFirestoreService._privateConstructor();
  static final FirebaseFirestoreService _instance =
      FirebaseFirestoreService._privateConstructor();
  static FirebaseFirestoreService get instance => _instance;

  /// Get Firestore instance for the Mash Platform Firebase project
  static FirebaseFirestore get _firestore {
    if (mashFirebaseApp != null) {
      return FirebaseFirestore.instanceFor(app: mashFirebaseApp!);
    }
    // Fallback to default instance if mashFirebaseApp is not initialized
    return FirebaseFirestore.instance;
  }

  /// Collection for Insan Jamd Hawan game results
  CollectionReference get gameResults => _firestore
      .collection('insan_jamd_hawan_results')
      .withConverter(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data as Map<String, dynamic>,
      );

  /// Collection for users (if needed)
  CollectionReference<UserModel> get users => _firestore
      .collection('users')
      .withConverter(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (UserModel user, _) => user.toJson(),
      );
}
