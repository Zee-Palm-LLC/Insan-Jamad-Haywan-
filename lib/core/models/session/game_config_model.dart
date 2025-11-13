class GameConfigModel {
  final int maxRounds;
  final int currentRound;
  final int defaultTimePerRound;
  final List<int> timePerRoundVariations;
  final ScoreConfigModel scoreConfig;
  final String? currentSelectedLetter;
  final bool? startCounting;
  final Map<String, String>? roundStatus;
  final bool? isWheelSpinning;

  GameConfigModel({
    required this.maxRounds,
    required this.defaultTimePerRound,
    required this.timePerRoundVariations,
    required this.scoreConfig,
    required this.currentRound,
    this.currentSelectedLetter,
    this.startCounting,
    this.roundStatus,
    this.isWheelSpinning,
  });

  Map<String, dynamic> toJson() {
    return {
      'maxRounds': maxRounds,
      'defaultTimePerRound': defaultTimePerRound,
      'timePerRoundVariations': timePerRoundVariations,
      'scoreConfig': scoreConfig.toJson(),
      'currentRound': currentRound,
      'currentSelectedLetter': currentSelectedLetter,
      'startCounting': startCounting,
      'roundStatus': roundStatus?.map((key, value) => MapEntry(key, value)),
      'isWheelSpinning': isWheelSpinning,
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
      currentRound: json['currentRound'] as int? ?? 0,
      currentSelectedLetter: json['currentSelectedLetter'] as String?,
      startCounting: json['startCounting'] as bool? ?? false,
      roundStatus: json['roundStatus'] as Map<String, String>?,
      scoreConfig: ScoreConfigModel.fromJson(
        json['scoreConfig'] as Map<String, dynamic>? ?? {},
      ),
      isWheelSpinning: json['isWheelSpinning'] as bool? ?? false,
    );
  }

  GameConfigModel copyWith({
    int? maxRounds,
    int? defaultTimePerRound,
    List<int>? timePerRoundVariations,
    ScoreConfigModel? scoreConfig,
    int? currentRound,
    bool? isWheelSpinning,
  }) {
    return GameConfigModel(
      maxRounds: maxRounds ?? this.maxRounds,
      defaultTimePerRound: defaultTimePerRound ?? this.defaultTimePerRound,
      timePerRoundVariations:
          timePerRoundVariations ?? this.timePerRoundVariations,
      scoreConfig: scoreConfig ?? this.scoreConfig,
      currentRound: currentRound ?? this.currentRound,
      isWheelSpinning: isWheelSpinning ?? this.isWheelSpinning,
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
