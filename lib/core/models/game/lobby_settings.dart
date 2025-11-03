import 'package:freezed_annotation/freezed_annotation.dart';

part 'lobby_settings.freezed.dart';
part 'lobby_settings.g.dart';

@freezed
class LobbySettings with _$LobbySettings {
  const factory LobbySettings({final GameSettings? settings}) = _LobbySettings;

  factory LobbySettings.fromJson(Map<String, dynamic> json) =>
      _$LobbySettingsFromJson(json);
}

@freezed
class GameSettings with _$GameSettings {
  const factory GameSettings({
    @Default(GameStatus.waiting) final GameStatus status,
    @Default(2) final int maxRounds,
    @Default(0) final int currentRound,
    @Default(ScoreConfig(correctGuess: 100, fooledOther: 50))
    final ScoreConfig scoreConfig,
    final List<String>? roundStatus,
  }) = _GameSettings;

  factory GameSettings.fromJson(Map<String, dynamic> json) =>
      _$GameSettingsFromJson(json);
}

@freezed
class ScoreConfig with _$ScoreConfig {
  const factory ScoreConfig({final int? correctGuess, final int? fooledOther}) =
      _ScoreConfig;

  factory ScoreConfig.fromJson(Map<String, dynamic> json) =>
      _$ScoreConfigFromJson(json);
}

enum GameStatus {
  @JsonValue('started')
  started,
  @JsonValue('waiting')
  waiting,
  @JsonValue('ended')
  ended,
}
