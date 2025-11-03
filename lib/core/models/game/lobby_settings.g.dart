// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LobbySettingsImpl _$$LobbySettingsImplFromJson(Map<String, dynamic> json) =>
    _$LobbySettingsImpl(
      settings: json['settings'] == null
          ? null
          : GameSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LobbySettingsImplToJson(_$LobbySettingsImpl instance) =>
    <String, dynamic>{'settings': instance.settings};

_$GameSettingsImpl _$$GameSettingsImplFromJson(Map<String, dynamic> json) =>
    _$GameSettingsImpl(
      status:
          $enumDecodeNullable(_$GameStatusEnumMap, json['status']) ??
          GameStatus.waiting,
      maxRounds: (json['maxRounds'] as num?)?.toInt() ?? 2,
      currentRound: (json['currentRound'] as num?)?.toInt() ?? 0,
      scoreConfig: json['scoreConfig'] == null
          ? const ScoreConfig(correctGuess: 100, fooledOther: 50)
          : ScoreConfig.fromJson(json['scoreConfig'] as Map<String, dynamic>),
      roundStatus: (json['roundStatus'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$GameSettingsImplToJson(_$GameSettingsImpl instance) =>
    <String, dynamic>{
      'status': _$GameStatusEnumMap[instance.status]!,
      'maxRounds': instance.maxRounds,
      'currentRound': instance.currentRound,
      'scoreConfig': instance.scoreConfig,
      'roundStatus': instance.roundStatus,
    };

const _$GameStatusEnumMap = {
  GameStatus.started: 'started',
  GameStatus.waiting: 'waiting',
  GameStatus.ended: 'ended',
};

_$ScoreConfigImpl _$$ScoreConfigImplFromJson(Map<String, dynamic> json) =>
    _$ScoreConfigImpl(
      correctGuess: (json['correctGuess'] as num?)?.toInt(),
      fooledOther: (json['fooledOther'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ScoreConfigImplToJson(_$ScoreConfigImpl instance) =>
    <String, dynamic>{
      'correctGuess': instance.correctGuess,
      'fooledOther': instance.fooledOther,
    };
