// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_resource_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LobbyResourceModelImpl _$$LobbyResourceModelImplFromJson(
  Map<String, dynamic> json,
) => _$LobbyResourceModelImpl(
  status: json['status'] as String?,
  playerState: json['playerState'] == null
      ? null
      : PlayerStateModel.fromJson(json['playerState'] as Map<String, dynamic>),
  settings: json['settings'] == null
      ? null
      : LobbySettings.fromJson(json['settings'] as Map<String, dynamic>),
  host: json['host'] as String?,
  targetPlayerId: json['targetPlayerId'] as String?,
  requesterId: json['requesterId'] as String,
);

Map<String, dynamic> _$$LobbyResourceModelImplToJson(
  _$LobbyResourceModelImpl instance,
) => <String, dynamic>{
  if (instance.status case final value?) 'status': value,
  if (instance.playerState case final value?) 'playerState': value,
  if (instance.settings case final value?) 'settings': value,
  if (instance.host case final value?) 'host': value,
  if (instance.targetPlayerId case final value?) 'targetPlayerId': value,
  'requesterId': instance.requesterId,
};
