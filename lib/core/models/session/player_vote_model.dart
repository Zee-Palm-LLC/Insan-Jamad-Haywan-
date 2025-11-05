import 'package:cloud_firestore/cloud_firestore.dart';

/// Player vote model for a round
class PlayerVoteModel {
  final String playerId;
  final String playerName;
  final Map<String, String> votes;
  final DateTime submittedAt;
  final bool isSubmitted;

  PlayerVoteModel({
    required this.playerId,
    required this.playerName,
    required this.votes,
    required this.submittedAt,
    this.isSubmitted = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'votes': votes,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'isSubmitted': isSubmitted,
    };
  }

  factory PlayerVoteModel.fromJson(Map<String, dynamic> json) {
    return PlayerVoteModel(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      votes: (json['votes'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as String),
      ),
      submittedAt: (json['submittedAt'] as Timestamp).toDate(),
      isSubmitted: json['isSubmitted'] as bool? ?? true,
    );
  }

  factory PlayerVoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlayerVoteModel.fromJson(data);
  }

  PlayerVoteModel copyWith({
    String? playerId,
    String? playerName,
    Map<String, String>? votes,
    DateTime? submittedAt,
    bool? isSubmitted,
  }) {
    return PlayerVoteModel(
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      votes: votes ?? this.votes,
      submittedAt: submittedAt ?? this.submittedAt,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}
