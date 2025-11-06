import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';

/// Player answer model for a round
class PlayerAnswerModel {
  final String playerId;
  final String playerName;
  final Map<String, String> answers;
  final DateTime submittedAt;
  final int timeRemaining;
  final bool usedDoublePoints;
  final ScoringResult? scoring;
  final VotesReceived votes;
  final bool isSubmitted;

  PlayerAnswerModel({
    required this.playerId,
    required this.playerName,
    required this.answers,
    required this.submittedAt,
    required this.timeRemaining,
    this.usedDoublePoints = false,
    this.scoring,
    required this.votes,
    this.isSubmitted = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'answers': answers,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'timeRemaining': timeRemaining,
      'usedDoublePoints': usedDoublePoints,
      if (scoring != null) 'scoring': scoring!.toJson(),
      'votes': votes.toJson(),
      'isSubmitted': isSubmitted,
    };
  }

  factory PlayerAnswerModel.fromJson(Map<String, dynamic> json) {
    return PlayerAnswerModel(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      answers: (json['answers'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as String),
      ),
      submittedAt: (json['submittedAt'] as Timestamp).toDate(),
      timeRemaining: json['timeRemaining'] as int,
      usedDoublePoints: json['usedDoublePoints'] as bool? ?? false,
      scoring: json['scoring'] != null
          ? ScoringResult.fromJson(json['scoring'] as Map<String, dynamic>)
          : null,
      votes: VotesReceived.fromJson(
        json['votes'] as Map<String, dynamic>? ?? {},
      ),
      isSubmitted: json['isSubmitted'] as bool? ?? true,
    );
  }

  factory PlayerAnswerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlayerAnswerModel.fromJson(data);
  }

  PlayerAnswerModel copyWith({
    String? playerId,
    String? playerName,
    Map<String, String>? answers,
    DateTime? submittedAt,
    int? timeRemaining,
    bool? usedDoublePoints,
    ScoringResult? scoring,
    VotesReceived? votes,
    bool? isSubmitted,
  }) {
    return PlayerAnswerModel(
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      answers: answers ?? this.answers,
      submittedAt: submittedAt ?? this.submittedAt,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      usedDoublePoints: usedDoublePoints ?? this.usedDoublePoints,
      scoring: scoring ?? this.scoring,
      votes: votes ?? this.votes,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}

/// Scoring result for an answer
class ScoringResult {
  final int correctAnswers;
  final int fooledPlayers;
  final int roundScore;
  final Map<String, CategoryScore> breakdown;

  ScoringResult({
    required this.correctAnswers,
    required this.fooledPlayers,
    required this.roundScore,
    required this.breakdown,
  });

  Map<String, dynamic> toJson() {
    return {
      'correctAnswers': correctAnswers,
      'fooledPlayers': fooledPlayers,
      'roundScore': roundScore,
      'breakdown': breakdown.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  factory ScoringResult.fromJson(Map<String, dynamic> json) {
    return ScoringResult(
      correctAnswers: json['correctAnswers'] as int,
      fooledPlayers: json['fooledPlayers'] as int,
      roundScore: json['roundScore'] as int,
      breakdown: (json['breakdown'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          CategoryScore.fromJson(value as Map<String, dynamic>),
        ),
      ),
    );
  }

  ScoringResult copyWith({
    int? correctAnswers,
    int? fooledPlayers,
    int? roundScore,
    Map<String, CategoryScore>? breakdown,
  }) {
    return ScoringResult(
      correctAnswers: correctAnswers ?? this.correctAnswers,
      fooledPlayers: fooledPlayers ?? this.fooledPlayers,
      roundScore: roundScore ?? this.roundScore,
      breakdown: breakdown ?? this.breakdown,
    );
  }
}

/// Score for a specific category
class CategoryScore {
  final bool isCorrect;
  final int points;
  final AnswerEvaluationStatus status;

  CategoryScore({
    required this.isCorrect,
    required this.points,
    this.status = AnswerEvaluationStatus.incorrect,
  });

  Map<String, dynamic> toJson() {
    return {
      'isCorrect': isCorrect,
      'points': points,
      'status': status.toJson(),
    };
  }

  factory CategoryScore.fromJson(Map<String, dynamic> json) {
    return CategoryScore(
      isCorrect: json['isCorrect'] as bool,
      points: json['points'] as int,
      status: json['status'] != null
          ? AnswerEvaluationStatus.fromJson(json['status'] as String)
          : (json['isCorrect'] as bool
                ? AnswerEvaluationStatus.correct
                : AnswerEvaluationStatus.incorrect),
    );
  }
}

/// Votes received for an answer
class VotesReceived {
  final Map<String, List<String>> votes;

  VotesReceived({required this.votes});

  Map<String, dynamic> toJson() {
    return votes;
  }

  factory VotesReceived.fromJson(Map<String, dynamic> json) {
    return VotesReceived(
      votes: json.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => e as String).toList(),
        ),
      ),
    );
  }

  VotesReceived copyWith({Map<String, List<String>>? votes}) {
    return VotesReceived(votes: votes ?? this.votes);
  }
}
