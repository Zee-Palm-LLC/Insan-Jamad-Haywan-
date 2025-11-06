import 'package:cloud_firestore/cloud_firestore.dart';

class AmbiguousAnswerModel {
  final String id;
  final String sessionId;
  final int roundNumber;
  final String playerId;
  final String playerName;
  final String category;
  final String answer;
  final DateTime createdAt;
  final DateTime? votingEndsAt;
  final VotingStatus status;
  final Map<String, bool> votes;
  final int correctVotes;
  final int incorrectVotes;
  final bool? finalDecision;

  AmbiguousAnswerModel({
    required this.id,
    required this.sessionId,
    required this.roundNumber,
    required this.playerId,
    required this.playerName,
    required this.category,
    required this.answer,
    required this.createdAt,
    this.votingEndsAt,
    this.status = VotingStatus.pending,
    required this.votes,
    this.correctVotes = 0,
    this.incorrectVotes = 0,
    this.finalDecision,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'roundNumber': roundNumber,
      'playerId': playerId,
      'playerName': playerName,
      'category': category,
      'answer': answer,
      'createdAt': Timestamp.fromDate(createdAt),
      if (votingEndsAt != null)
        'votingEndsAt': Timestamp.fromDate(votingEndsAt!),
      'status': status.toJson(),
      'votes': votes,
      'correctVotes': correctVotes,
      'incorrectVotes': incorrectVotes,
      if (finalDecision != null) 'finalDecision': finalDecision,
    };
  }

  factory AmbiguousAnswerModel.fromJson(Map<String, dynamic> json) {
    return AmbiguousAnswerModel(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      roundNumber: json['roundNumber'] as int,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      category: json['category'] as String,
      answer: json['answer'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      votingEndsAt: json['votingEndsAt'] != null
          ? (json['votingEndsAt'] as Timestamp).toDate()
          : null,
      status: VotingStatus.fromJson(json['status'] as String? ?? 'pending'),
      votes:
          (json['votes'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as bool),
          ) ??
          {},
      correctVotes: json['correctVotes'] as int? ?? 0,
      incorrectVotes: json['incorrectVotes'] as int? ?? 0,
      finalDecision: json['finalDecision'] as bool?,
    );
  }

  factory AmbiguousAnswerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AmbiguousAnswerModel.fromJson(data);
  }

  AmbiguousAnswerModel copyWith({
    String? id,
    String? sessionId,
    int? roundNumber,
    String? playerId,
    String? playerName,
    String? category,
    String? answer,
    DateTime? createdAt,
    DateTime? votingEndsAt,
    VotingStatus? status,
    Map<String, bool>? votes,
    int? correctVotes,
    int? incorrectVotes,
    bool? finalDecision,
  }) {
    return AmbiguousAnswerModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      roundNumber: roundNumber ?? this.roundNumber,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      category: category ?? this.category,
      answer: answer ?? this.answer,
      createdAt: createdAt ?? this.createdAt,
      votingEndsAt: votingEndsAt ?? this.votingEndsAt,
      status: status ?? this.status,
      votes: votes ?? this.votes,
      correctVotes: correctVotes ?? this.correctVotes,
      incorrectVotes: incorrectVotes ?? this.incorrectVotes,
      finalDecision: finalDecision ?? this.finalDecision,
    );
  }
}

enum VotingStatus {
  pending,
  active,
  completed;

  String toJson() => name;

  static VotingStatus fromJson(String json) {
    return VotingStatus.values.firstWhere(
      (e) => e.name == json,
      orElse: () => VotingStatus.pending,
    );
  }
}
