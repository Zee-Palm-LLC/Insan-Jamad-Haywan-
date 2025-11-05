// Enums for session-related models

enum SessionStatus {
  waiting,
  started,
  ended,
  abandoned;

  String toJson() => name;

  static SessionStatus fromJson(String json) {
    return SessionStatus.values.firstWhere(
      (e) => e.name == json,
      orElse: () => SessionStatus.waiting,
    );
  }
}

enum PlayerStatus {
  active,
  left,
  kicked,
  disconnected;

  String toJson() => name;

  static PlayerStatus fromJson(String json) {
    return PlayerStatus.values.firstWhere(
      (e) => e.name == json,
      orElse: () => PlayerStatus.active,
    );
  }
}

enum RoundStatus {
  pending,
  answering,
  scoring,
  voting,
  completed,
  timeout;

  String toJson() => name;

  static RoundStatus fromJson(String json) {
    return RoundStatus.values.firstWhere(
      (e) => e.name == json,
      orElse: () => RoundStatus.pending,
    );
  }
}

enum GameCategory {
  general,
  science,
  history,
  entertainment,
  sports,
  geography;

  String toJson() => name;

  static GameCategory? fromJson(String? json) {
    if (json == null) return null;
    return GameCategory.values.firstWhere(
      (e) => e.name == json,
      orElse: () => GameCategory.general,
    );
  }
}
