import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insan_jamd_hawan/core/models/user/user_model.dart';
import 'package:insan_jamd_hawan/main.dart';

class FirebaseFirestoreService {
  FirebaseFirestoreService._privateConstructor();
  static final FirebaseFirestoreService _instance =
      FirebaseFirestoreService._privateConstructor();
  static FirebaseFirestoreService get instance => _instance;

  static FirebaseFirestore get _firestore {
    if (mashFirebaseApp != null) {
      return FirebaseFirestore.instanceFor(app: mashFirebaseApp!);
    }
    return FirebaseFirestore.instance;
  }

  CollectionReference get gameResults => _firestore
      .collection('insan_jamd_hawan_results')
      .withConverter(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data as Map<String, dynamic>,
      );

  CollectionReference<UserModel> get users => _firestore
      .collection('users')
      .withConverter(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (UserModel user, _) => user.toJson(),
      );
}
