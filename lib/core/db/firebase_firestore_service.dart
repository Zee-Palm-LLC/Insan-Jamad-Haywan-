import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insan_jamd_hawan/core/models/user/user_model.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseFirestoreService {
  final FirebaseApp firebaseApp;
  FirebaseFirestoreService._internal(this.firebaseApp);

  static FirebaseFirestoreService? _instance;

  static void initialize({required FirebaseApp app}) {
    _instance = FirebaseFirestoreService._internal(app);
  }

  static FirebaseFirestoreService get instance {
    if (_instance == null) {
      throw Exception('FirebaseFirestoreService has not been initialized. Call initialize() with a FirebaseApp first.');
    }
    return _instance!;
  }

  FirebaseFirestore get _firestore => FirebaseFirestore.instanceFor(app: firebaseApp);

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
