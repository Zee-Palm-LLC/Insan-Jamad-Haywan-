import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';

/// Player participation in a game session
class PlayerParticipationModel {
  final String playerId;
  final String playerName;
  final String? playerAvatar;
  final DateTime joinedAt;
  final DateTime? leftAt;
  final PlayerStatus status;
  final DateTime? disconnectedAt;
  final DateTime? reconnectedAt;
  final Map<String, RoundParticipation> roundParticipation;
  final int? totalTimeInGame;
  final double? averageTimePerRound;
  final int totalScore;
  final Map<String, int> scoresByRound;
  final int roundsPlayed;
  final int roundsCompleted;
  final double? averageScorePerRound;
  final int? finalRank;
  final DateTime lastHeartbeat;
  final bool isOnline;
  final bool hasUsedDoublePoints;

  PlayerParticipationModel({
    required this.playerId,
    required this.playerName,
    this.playerAvatar,
    required this.joinedAt,
    this.leftAt,
    required this.status,
    this.disconnectedAt,
    this.reconnectedAt,
    required this.roundParticipation,
    this.totalTimeInGame,
    this.averageTimePerRound,
    this.totalScore = 0,
    required this.scoresByRound,
    this.roundsPlayed = 0,
    this.roundsCompleted = 0,
    this.averageScorePerRound,
    this.finalRank,
    required this.lastHeartbeat,
    this.isOnline = true,
    this.hasUsedDoublePoints = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      if (playerAvatar != null) 'playerAvatar': playerAvatar,
      'joinedAt': Timestamp.fromDate(joinedAt),
      if (leftAt != null) 'leftAt': Timestamp.fromDate(leftAt!),
      'status': status.toJson(),
      if (disconnectedAt != null)
        'disconnectedAt': Timestamp.fromDate(disconnectedAt!),
      if (reconnectedAt != null)
        'reconnectedAt': Timestamp.fromDate(reconnectedAt!),
      'roundParticipation': roundParticipation.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'totalTimeInGame': totalTimeInGame,
      'averageTimePerRound': averageTimePerRound,
      'totalScore': totalScore,
      'scoresByRound': scoresByRound,
      'roundsPlayed': roundsPlayed,
      'roundsCompleted': roundsCompleted,
      'averageScorePerRound': averageScorePerRound,
      'finalRank': finalRank,
      'lastHeartbeat': Timestamp.fromDate(lastHeartbeat),
      'isOnline': isOnline,
      'hasUsedDoublePoints': hasUsedDoublePoints,
    };
  }

  factory PlayerParticipationModel.fromJson(Map<String, dynamic> json) {
    return PlayerParticipationModel(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      playerAvatar: json['playerAvatar'] as String?,
      joinedAt: (json['joinedAt'] as Timestamp).toDate(),
      leftAt: json['leftAt'] != null
          ? (json['leftAt'] as Timestamp).toDate()
          : null,
      status: PlayerStatus.fromJson(json['status'] as String? ?? 'active'),
      disconnectedAt: json['disconnectedAt'] != null
          ? (json['disconnectedAt'] as Timestamp).toDate()
          : null,
      reconnectedAt: json['reconnectedAt'] != null
          ? (json['reconnectedAt'] as Timestamp).toDate()
          : null,
      roundParticipation:
          (json['roundParticipation'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              RoundParticipation.fromJson(value as Map<String, dynamic>),
            ),
          ) ??
          {},
      totalTimeInGame: json['totalTimeInGame'] as int?,
      averageTimePerRound: (json['averageTimePerRound'] as num?)?.toDouble(),
      totalScore: json['totalScore'] as int? ?? 0,
      scoresByRound:
          (json['scoresByRound'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as int),
          ) ??
          {},
      roundsPlayed: json['roundsPlayed'] as int? ?? 0,
      roundsCompleted: json['roundsCompleted'] as int? ?? 0,
      averageScorePerRound: (json['averageScorePerRound'] as num?)?.toDouble(),
      finalRank: json['finalRank'] as int?,
      lastHeartbeat: (json['lastHeartbeat'] as Timestamp).toDate(),
      isOnline: json['isOnline'] as bool? ?? true,
      hasUsedDoublePoints: json['hasUsedDoublePoints'] as bool? ?? false,
    );
  }

  factory PlayerParticipationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlayerParticipationModel.fromJson(data);
  }

  PlayerParticipationModel copyWith({
    String? playerId,
    String? playerName,
    String? playerAvatar,
    DateTime? joinedAt,
    DateTime? leftAt,
    PlayerStatus? status,
    DateTime? disconnectedAt,
    DateTime? reconnectedAt,
    Map<String, RoundParticipation>? roundParticipation,
    int? totalTimeInGame,
    double? averageTimePerRound,
    int? totalScore,
    Map<String, int>? scoresByRound,
    int? roundsPlayed,
    int? roundsCompleted,
    double? averageScorePerRound,
    int? finalRank,
    DateTime? lastHeartbeat,
    bool? isOnline,
    bool? hasUsedDoublePoints,
  }) {
    return PlayerParticipationModel(
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      playerAvatar: playerAvatar ?? this.playerAvatar,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
      status: status ?? this.status,
      disconnectedAt: disconnectedAt ?? this.disconnectedAt,
      reconnectedAt: reconnectedAt ?? this.reconnectedAt,
      roundParticipation: roundParticipation ?? this.roundParticipation,
      totalTimeInGame: totalTimeInGame ?? this.totalTimeInGame,
      averageTimePerRound: averageTimePerRound ?? this.averageTimePerRound,
      totalScore: totalScore ?? this.totalScore,
      scoresByRound: scoresByRound ?? this.scoresByRound,
      roundsPlayed: roundsPlayed ?? this.roundsPlayed,
      roundsCompleted: roundsCompleted ?? this.roundsCompleted,
      averageScorePerRound: averageScorePerRound ?? this.averageScorePerRound,
      finalRank: finalRank ?? this.finalRank,
      lastHeartbeat: lastHeartbeat ?? this.lastHeartbeat,
      isOnline: isOnline ?? this.isOnline,
      hasUsedDoublePoints: hasUsedDoublePoints ?? this.hasUsedDoublePoints,
    );
  }
}

/// Round participation details
class RoundParticipation {
  final bool joined;
  final bool completed;

  RoundParticipation({required this.joined, required this.completed});

  Map<String, dynamic> toJson() {
    return {'joined': joined, 'completed': completed};
  }

  factory RoundParticipation.fromJson(Map<String, dynamic> json) {
    return RoundParticipation(
      joined: json['joined'] as bool? ?? false,
      completed: json['completed'] as bool? ?? false,
    );
  }
}
