// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LobbyConfigModelImpl _$$LobbyConfigModelImplFromJson(
  Map<String, dynamic> json,
) => _$LobbyConfigModelImpl(
  name: json['name'] as String?,
  maxPlayers: (json['maxPlayers'] as num?)?.toInt(),
  isPrivate: json['isPrivate'] as bool?,
  useInviteCode: json['useInviteCode'] as bool?,
  allowLateJoin: json['allowLateJoin'] as bool?,
  region: json['region'] as String?,
  settings: json['settings'] as Map<String, dynamic>?,
  host: json['host'] as String?,
);

Map<String, dynamic> _$$LobbyConfigModelImplToJson(
  _$LobbyConfigModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'name': value,
  if (instance.maxPlayers case final value?) 'maxPlayers': value,
  if (instance.isPrivate case final value?) 'isPrivate': value,
  if (instance.useInviteCode case final value?) 'useInviteCode': value,
  if (instance.allowLateJoin case final value?) 'allowLateJoin': value,
  if (instance.region case final value?) 'region': value,
  if (instance.settings case final value?) 'settings': value,
  if (instance.host case final value?) 'host': value,
};
