enum GameDifficulty { easy, medium, hard }

enum GamePhase { waiting, started, letterSelection, ended }

enum RoomStatus { connected, deleted, updated, waiting, error }

enum PlayerAction { submitAnswer, vote, chooseOption, skip }

enum SpecialRoundStatus { started, cancelled, completed, pending }

enum GameCategory {
  general,
  science,
  history,
  entertainment,
  sports,
  geography,
}

enum GameEvent {
  playerJoined,
  playerLeft,
  gameStarted,
  gameEnded,
  roundStarted,
  roundEnded,
  playerAction,
}
