import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';

/// Round model for a game session
class RoundModel {
  final int roundNumber;
  final String selectedLetter;
  final GameCategory? category;
  final RoundTimeConfig timeConfig;
  final RoundStatus status;
  final List<RoundParticipant> participants;
  final RoundStatsModel stats;
  final int wheelIndex;
  final DateTime wheelSpinTimestamp;

  RoundModel({
    required this.roundNumber,
    required this.selectedLetter,
    this.category,
    required this.timeConfig,
    required this.status,
    required this.participants,
    required this.stats,
    required this.wheelIndex,
    required this.wheelSpinTimestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'roundNumber': roundNumber,
      'selectedLetter': selectedLetter,
      if (category != null) 'category': category!.toJson(),
      'timeConfig': timeConfig.toJson(),
      'status': status.toJson(),
      'participants': participants.map((p) => p.toJson()).toList(),
      'stats': stats.toJson(),
      'wheelIndex': wheelIndex,
      'wheelSpinTimestamp': Timestamp.fromDate(wheelSpinTimestamp),
    };
  }

  factory RoundModel.fromJson(Map<String, dynamic> json) {
    return RoundModel(
      roundNumber: json['roundNumber'] as int,
      selectedLetter: json['selectedLetter'] as String,
      category: GameCategory.fromJson(json['category'] as String?),
      timeConfig: RoundTimeConfig.fromJson(
        json['timeConfig'] as Map<String, dynamic>,
      ),
      status: RoundStatus.fromJson(json['status'] as String? ?? 'pending'),
      participants:
          (json['participants'] as List<dynamic>?)
              ?.map((p) => RoundParticipant.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      stats: RoundStatsModel.fromJson(
        json['stats'] as Map<String, dynamic>? ?? {},
      ),
      wheelIndex: json['wheelIndex'] as int,
      wheelSpinTimestamp: (json['wheelSpinTimestamp'] as Timestamp).toDate(),
    );
  }

  factory RoundModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RoundModel.fromJson(data);
  }

  RoundModel copyWith({
    int? roundNumber,
    String? selectedLetter,
    GameCategory? category,
    RoundTimeConfig? timeConfig,
    RoundStatus? status,
    List<RoundParticipant>? participants,
    RoundStatsModel? stats,
    int? wheelIndex,
    DateTime? wheelSpinTimestamp,
  }) {
    return RoundModel(
      roundNumber: roundNumber ?? this.roundNumber,
      selectedLetter: selectedLetter ?? this.selectedLetter,
      category: category ?? this.category,
      timeConfig: timeConfig ?? this.timeConfig,
      status: status ?? this.status,
      participants: participants ?? this.participants,
      stats: stats ?? this.stats,
      wheelIndex: wheelIndex ?? this.wheelIndex,
      wheelSpinTimestamp: wheelSpinTimestamp ?? this.wheelSpinTimestamp,
    );
  }
}

/// Time configuration for a round
class RoundTimeConfig {
  final int allocatedTime;
  final DateTime startedAt;
  final DateTime scheduledEndAt;
  final DateTime? actualEndAt;
  final int? actualDuration;
  final int timeExtension;
  final bool wasTimeExtended;

  RoundTimeConfig({
    required this.allocatedTime,
    required this.startedAt,
    required this.scheduledEndAt,
    this.actualEndAt,
    this.actualDuration,
    this.timeExtension = 0,
    this.wasTimeExtended = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'allocatedTime': allocatedTime,
      'startedAt': Timestamp.fromDate(startedAt),
      'scheduledEndAt': Timestamp.fromDate(scheduledEndAt),
      if (actualEndAt != null) 'actualEndAt': Timestamp.fromDate(actualEndAt!),
      'actualDuration': actualDuration,
      'timeExtension': timeExtension,
      'wasTimeExtended': wasTimeExtended,
    };
  }

  factory RoundTimeConfig.fromJson(Map<String, dynamic> json) {
    return RoundTimeConfig(
      allocatedTime: json['allocatedTime'] as int,
      startedAt: (json['startedAt'] as Timestamp).toDate(),
      scheduledEndAt: (json['scheduledEndAt'] as Timestamp).toDate(),
      actualEndAt: json['actualEndAt'] != null
          ? (json['actualEndAt'] as Timestamp).toDate()
          : null,
      actualDuration: json['actualDuration'] as int?,
      timeExtension: json['timeExtension'] as int? ?? 0,
      wasTimeExtended: json['wasTimeExtended'] as bool? ?? false,
    );
  }

  RoundTimeConfig copyWith({
    int? allocatedTime,
    DateTime? startedAt,
    DateTime? scheduledEndAt,
    DateTime? actualEndAt,
    int? actualDuration,
    int? timeExtension,
    bool? wasTimeExtended,
  }) {
    return RoundTimeConfig(
      allocatedTime: allocatedTime ?? this.allocatedTime,
      startedAt: startedAt ?? this.startedAt,
      scheduledEndAt: scheduledEndAt ?? this.scheduledEndAt,
      actualEndAt: actualEndAt ?? this.actualEndAt,
      actualDuration: actualDuration ?? this.actualDuration,
      timeExtension: timeExtension ?? this.timeExtension,
      wasTimeExtended: wasTimeExtended ?? this.wasTimeExtended,
    );
  }
}

/// Participant in a round
class RoundParticipant {
  final String playerId;
  final String playerName;
  final bool wasActive;
  final bool answered;
  final DateTime? submittedAt;

  RoundParticipant({
    required this.playerId,
    required this.playerName,
    required this.wasActive,
    required this.answered,
    this.submittedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'wasActive': wasActive,
      'answered': answered,
      if (submittedAt != null) 'submittedAt': Timestamp.fromDate(submittedAt!),
    };
  }

  factory RoundParticipant.fromJson(Map<String, dynamic> json) {
    return RoundParticipant(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      wasActive: json['wasActive'] as bool? ?? false,
      answered: json['answered'] as bool? ?? false,
      submittedAt: json['submittedAt'] != null
          ? (json['submittedAt'] as Timestamp).toDate()
          : null,
    );
  }
}

/// Statistics for a round
class RoundStatsModel {
  final int totalAnswers;
  final double? averageSubmissionTime;
  final double? fastestSubmission;
  final double? slowestSubmission;

  RoundStatsModel({
    this.totalAnswers = 0,
    this.averageSubmissionTime,
    this.fastestSubmission,
    this.slowestSubmission,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalAnswers': totalAnswers,
      'averageSubmissionTime': averageSubmissionTime,
      'fastestSubmission': fastestSubmission,
      'slowestSubmission': slowestSubmission,
    };
  }

  factory RoundStatsModel.fromJson(Map<String, dynamic> json) {
    return RoundStatsModel(
      totalAnswers: json['totalAnswers'] as int? ?? 0,
      averageSubmissionTime: (json['averageSubmissionTime'] as num?)
          ?.toDouble(),
      fastestSubmission: (json['fastestSubmission'] as num?)?.toDouble(),
      slowestSubmission: (json['slowestSubmission'] as num?)?.toDouble(),
    );
  }

  RoundStatsModel copyWith({
    int? totalAnswers,
    double? averageSubmissionTime,
    double? fastestSubmission,
    double? slowestSubmission,
  }) {
    return RoundStatsModel(
      totalAnswers: totalAnswers ?? this.totalAnswers,
      averageSubmissionTime:
          averageSubmissionTime ?? this.averageSubmissionTime,
      fastestSubmission: fastestSubmission ?? this.fastestSubmission,
      slowestSubmission: slowestSubmission ?? this.slowestSubmission,
    );
  }
}
