import 'package:cloud_firestore/cloud_firestore.dart';

/// Game player model for storing player information
/// Note: This is separate from UserModel (Freezed) which is for Mash platform
class GamePlayerModel {
  final String playerId; // username is used as playerId
  final String username; // same as playerId for consistency
  final String? profileImage; // optional profile image URL/path
  final DateTime createdAt;
  final DateTime lastActive;

  GamePlayerModel({
    required this.playerId,
    required this.username,
    this.profileImage,
    required this.createdAt,
    required this.lastActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'username': username,
      if (profileImage != null) 'profileImage': profileImage,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
    };
  }

  factory GamePlayerModel.fromJson(Map<String, dynamic> json) {
    return GamePlayerModel(
      playerId: json['playerId'] as String,
      username: json['username'] as String,
      profileImage: json['profileImage'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastActive: (json['lastActive'] as Timestamp).toDate(),
    );
  }

  factory GamePlayerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GamePlayerModel.fromJson(data);
  }

  GamePlayerModel copyWith({
    String? playerId,
    String? username,
    String? profileImage,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return GamePlayerModel(
      playerId: playerId ?? this.playerId,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  /// Helper to create from username (username = playerId)
  factory GamePlayerModel.fromUsername({
    required String username,
    String? profileImage,
  }) {
    final now = DateTime.now();
    return GamePlayerModel(
      playerId: username, // username IS the playerId
      username: username,
      profileImage: profileImage,
      createdAt: now,
      lastActive: now,
    );
  }

  /// Update last active timestamp
  GamePlayerModel updateLastActive() {
    return copyWith(lastActive: DateTime.now());
  }
}
