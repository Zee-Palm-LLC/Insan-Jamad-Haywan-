import 'package:cloud_firestore/cloud_firestore.dart';

class GameSummaryModel {
  final List<PlayerSummary> players;
  final List<RoundSummary> rounds;
  final GameStats stats;
  final DateTime lastUpdated;

  GameSummaryModel({
    required this.players,
    required this.rounds,
    required this.stats,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'players': players.map((p) => p.toJson()).toList(),
      'rounds': rounds.map((r) => r.toJson()).toList(),
      'stats': stats.toJson(),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  factory GameSummaryModel.fromJson(Map<String, dynamic> json) {
    return GameSummaryModel(
      players: (json['players'] as List<dynamic>)
          .map((p) => PlayerSummary.fromJson(p as Map<String, dynamic>))
          .toList(),
      rounds: (json['rounds'] as List<dynamic>)
          .map((r) => RoundSummary.fromJson(r as Map<String, dynamic>))
          .toList(),
      stats: GameStats.fromJson(json['stats'] as Map<String, dynamic>),
      lastUpdated: (json['lastUpdated'] as Timestamp).toDate(),
    );
  }

  factory GameSummaryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GameSummaryModel.fromJson(data);
  }

  GameSummaryModel copyWith({
    List<PlayerSummary>? players,
    List<RoundSummary>? rounds,
    GameStats? stats,
    DateTime? lastUpdated,
  }) {
    return GameSummaryModel(
      players: players ?? this.players,
      rounds: rounds ?? this.rounds,
      stats: stats ?? this.stats,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Player summary
class PlayerSummary {
  final String playerId;
  final String playerName;
  final int totalScore;
  final int rank;
  final int roundsPlayed;
  final int roundsCompleted;
  final double participationRate;
  final double averageTimePerRound;
  final int totalTimeInGame;

  PlayerSummary({
    required this.playerId,
    required this.playerName,
    required this.totalScore,
    required this.rank,
    required this.roundsPlayed,
    required this.roundsCompleted,
    required this.participationRate,
    required this.averageTimePerRound,
    required this.totalTimeInGame,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'totalScore': totalScore,
      'rank': rank,
      'roundsPlayed': roundsPlayed,
      'roundsCompleted': roundsCompleted,
      'participationRate': participationRate,
      'averageTimePerRound': averageTimePerRound,
      'totalTimeInGame': totalTimeInGame,
    };
  }

  factory PlayerSummary.fromJson(Map<String, dynamic> json) {
    return PlayerSummary(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      totalScore: json['totalScore'] as int,
      rank: json['rank'] as int,
      roundsPlayed: json['roundsPlayed'] as int,
      roundsCompleted: json['roundsCompleted'] as int,
      participationRate: (json['participationRate'] as num).toDouble(),
      averageTimePerRound: (json['averageTimePerRound'] as num).toDouble(),
      totalTimeInGame: json['totalTimeInGame'] as int,
    );
  }
}

/// Round summary
class RoundSummary {
  final int roundNumber;
  final int duration;
  final int participants;
  final double averageSubmissionTime;
  final String status;

  RoundSummary({
    required this.roundNumber,
    required this.duration,
    required this.participants,
    required this.averageSubmissionTime,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'roundNumber': roundNumber,
      'duration': duration,
      'participants': participants,
      'averageSubmissionTime': averageSubmissionTime,
      'status': status,
    };
  }

  factory RoundSummary.fromJson(Map<String, dynamic> json) {
    return RoundSummary(
      roundNumber: json['roundNumber'] as int,
      duration: json['duration'] as int,
      participants: json['participants'] as int,
      averageSubmissionTime: (json['averageSubmissionTime'] as num).toDouble(),
      status: json['status'] as String,
    );
  }
}

/// Game statistics
class GameStats {
  final int totalRounds;
  final int completedRounds;
  final int totalDuration;
  final double averageRoundDuration;
  final int longestRound;
  final int shortestRound;
  final int totalPlayersEver;
  final int finalPlayerCount;
  final double playerRetentionRate;

  GameStats({
    required this.totalRounds,
    required this.completedRounds,
    required this.totalDuration,
    required this.averageRoundDuration,
    required this.longestRound,
    required this.shortestRound,
    required this.totalPlayersEver,
    required this.finalPlayerCount,
    required this.playerRetentionRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalRounds': totalRounds,
      'completedRounds': completedRounds,
      'totalDuration': totalDuration,
      'averageRoundDuration': averageRoundDuration,
      'longestRound': longestRound,
      'shortestRound': shortestRound,
      'totalPlayersEver': totalPlayersEver,
      'finalPlayerCount': finalPlayerCount,
      'playerRetentionRate': playerRetentionRate,
    };
  }

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      totalRounds: json['totalRounds'] as int,
      completedRounds: json['completedRounds'] as int,
      totalDuration: json['totalDuration'] as int,
      averageRoundDuration: (json['averageRoundDuration'] as num).toDouble(),
      longestRound: json['longestRound'] as int,
      shortestRound: json['shortestRound'] as int,
      totalPlayersEver: json['totalPlayersEver'] as int,
      finalPlayerCount: json['finalPlayerCount'] as int,
      playerRetentionRate: (json['playerRetentionRate'] as num).toDouble(),
    );
  }

  GameStats copyWith({
    int? totalRounds,
    int? completedRounds,
    int? totalDuration,
    double? averageRoundDuration,
    int? longestRound,
    int? shortestRound,
    int? totalPlayersEver,
    int? finalPlayerCount,
    double? playerRetentionRate,
  }) {
    return GameStats(
      totalRounds: totalRounds ?? this.totalRounds,
      completedRounds: completedRounds ?? this.completedRounds,
      totalDuration: totalDuration ?? this.totalDuration,
      averageRoundDuration: averageRoundDuration ?? this.averageRoundDuration,
      longestRound: longestRound ?? this.longestRound,
      shortestRound: shortestRound ?? this.shortestRound,
      totalPlayersEver: totalPlayersEver ?? this.totalPlayersEver,
      finalPlayerCount: finalPlayerCount ?? this.finalPlayerCount,
      playerRetentionRate: playerRetentionRate ?? this.playerRetentionRate,
    );
  }
}
