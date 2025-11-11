import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insan_jamd_hawan/core/models/session/game_config_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';

/// Main game session model
class GameSessionModel {
  final String sessionId;
  final String lobbyId;
  final String? roomId;
  final String gameType;
  final SessionStatus status;
  final GameConfigModel config;
  final String hostId;
  final String hostName;
  final DurationStatsModel actualDuration;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime createdAt;
  final DateTime lastUpdated;

  GameSessionModel({
    required this.sessionId,
    required this.lobbyId,
    this.roomId,
    required this.gameType,
    required this.status,
    required this.config,
    required this.hostId,
    required this.hostName,
    required this.actualDuration,
    this.startedAt,
    this.endedAt,
    required this.createdAt,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'lobbyId': lobbyId,
      if (roomId != null) 'roomId': roomId,
      'gameType': gameType,
      'status': status.toJson(),
      'config': config.toJson(),
      'hostId': hostId,
      'hostName': hostName,
      'actualDuration': actualDuration.toJson(),
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'endedAt': endedAt != null ? Timestamp.fromDate(endedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  factory GameSessionModel.fromJson(Map<String, dynamic> json) {
    return GameSessionModel(
      sessionId: json['sessionId'] as String,
      lobbyId: json['lobbyId'] as String,
      roomId: json['roomId'] as String?,
      gameType: json['gameType'] as String? ?? 'insan_jamd_hawan',
      status: SessionStatus.fromJson(json['status'] as String? ?? 'waiting'),
      config: GameConfigModel.fromJson(
        json['config'] as Map<String, dynamic>? ?? {},
      ),
      hostId: json['hostId'] as String,
      hostName: json['hostName'] as String,
      actualDuration: DurationStatsModel.fromJson(
        json['actualDuration'] as Map<String, dynamic>? ?? {},
      ),
      startedAt: json['startedAt'] != null
          ? (json['startedAt'] as Timestamp).toDate()
          : null,
      endedAt: json['endedAt'] != null
          ? (json['endedAt'] as Timestamp).toDate()
          : null,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastUpdated: (json['lastUpdated'] as Timestamp).toDate(),
    );
  }

  factory GameSessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    if (data['sessionId'] == null) {
      data['sessionId'] = doc.id;
    }
    return GameSessionModel.fromJson(data);
  }

  GameSessionModel copyWith({
    String? sessionId,
    String? lobbyId,
    String? roomId,
    String? gameType,
    SessionStatus? status,
    GameConfigModel? config,
    String? hostId,
    String? hostName,
    DurationStatsModel? actualDuration,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return GameSessionModel(
      sessionId: sessionId ?? this.sessionId,
      lobbyId: lobbyId ?? this.lobbyId,
      roomId: roomId ?? this.roomId,
      gameType: gameType ?? this.gameType,
      status: status ?? this.status,
      config: config ?? this.config,
      hostId: hostId ?? this.hostId,
      hostName: hostName ?? this.hostName,
      actualDuration: actualDuration ?? this.actualDuration,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
