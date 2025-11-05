/// Configuration for a game session
class GameConfigModel {
  final int maxRounds;
  final int defaultTimePerRound;
  final List<int> timePerRoundVariations;
  final ScoreConfigModel scoreConfig;

  GameConfigModel({
    required this.maxRounds,
    required this.defaultTimePerRound,
    required this.timePerRoundVariations,
    required this.scoreConfig,
  });

  Map<String, dynamic> toJson() {
    return {
      'maxRounds': maxRounds,
      'defaultTimePerRound': defaultTimePerRound,
      'timePerRoundVariations': timePerRoundVariations,
      'scoreConfig': scoreConfig.toJson(),
    };
  }

  factory GameConfigModel.fromJson(Map<String, dynamic> json) {
    return GameConfigModel(
      maxRounds: json['maxRounds'] as int? ?? 3,
      defaultTimePerRound: json['defaultTimePerRound'] as int? ?? 60,
      timePerRoundVariations:
          (json['timePerRoundVariations'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [30, 45, 60, 90],
      scoreConfig: ScoreConfigModel.fromJson(
        json['scoreConfig'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  GameConfigModel copyWith({
    int? maxRounds,
    int? defaultTimePerRound,
    List<int>? timePerRoundVariations,
    ScoreConfigModel? scoreConfig,
  }) {
    return GameConfigModel(
      maxRounds: maxRounds ?? this.maxRounds,
      defaultTimePerRound: defaultTimePerRound ?? this.defaultTimePerRound,
      timePerRoundVariations:
          timePerRoundVariations ?? this.timePerRoundVariations,
      scoreConfig: scoreConfig ?? this.scoreConfig,
    );
  }
}

/// Score configuration for the game
class ScoreConfigModel {
  final int correctGuess;
  final int fooledOther;

  ScoreConfigModel({required this.correctGuess, required this.fooledOther});

  Map<String, dynamic> toJson() {
    return {'correctGuess': correctGuess, 'fooledOther': fooledOther};
  }

  factory ScoreConfigModel.fromJson(Map<String, dynamic> json) {
    return ScoreConfigModel(
      correctGuess: json['correctGuess'] as int? ?? 100,
      fooledOther: json['fooledOther'] as int? ?? 50,
    );
  }

  ScoreConfigModel copyWith({int? correctGuess, int? fooledOther}) {
    return ScoreConfigModel(
      correctGuess: correctGuess ?? this.correctGuess,
      fooledOther: fooledOther ?? this.fooledOther,
    );
  }
}

/// Duration statistics for a game session
class DurationStatsModel {
  final int? totalGameTime;
  final double? averageRoundTime;
  final int? longestRound;
  final int? shortestRound;

  DurationStatsModel({
    this.totalGameTime,
    this.averageRoundTime,
    this.longestRound,
    this.shortestRound,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalGameTime': totalGameTime,
      'averageRoundTime': averageRoundTime,
      'longestRound': longestRound,
      'shortestRound': shortestRound,
    };
  }

  factory DurationStatsModel.fromJson(Map<String, dynamic> json) {
    return DurationStatsModel(
      totalGameTime: json['totalGameTime'] as int?,
      averageRoundTime: (json['averageRoundTime'] as num?)?.toDouble(),
      longestRound: json['longestRound'] as int?,
      shortestRound: json['shortestRound'] as int?,
    );
  }

  DurationStatsModel copyWith({
    int? totalGameTime,
    double? averageRoundTime,
    int? longestRound,
    int? shortestRound,
  }) {
    return DurationStatsModel(
      totalGameTime: totalGameTime ?? this.totalGameTime,
      averageRoundTime: averageRoundTime ?? this.averageRoundTime,
      longestRound: longestRound ?? this.longestRound,
      shortestRound: shortestRound ?? this.shortestRound,
    );
  }
}
