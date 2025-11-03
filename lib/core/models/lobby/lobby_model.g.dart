// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LobbyModelImpl _$$LobbyModelImplFromJson(
  Map<String, dynamic> json,
) => _$LobbyModelImpl(
  id: json['id'] as String?,
  name: json['name'] as String?,
  host: json['host'] as String?,
  maxPlayers: (json['maxPlayers'] as num?)?.toInt(),
  currentPlayers: (json['currentPlayers'] as num?)?.toInt(),
  region: json['region'] as String?,
  status: json['status'] as String?,
  isPrivate: json['isPrivate'] as bool?,
  useInviteCode: json['useInviteCode'] as bool?,
  inviteCode: json['inviteCode'] as String?,
  allowLateJoin: json['allowLateJoin'] as bool?,
  settings: json['settings'] == null
      ? null
      : GameSettings.fromJson(json['settings'] as Map<String, dynamic>),
  players: (json['players'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  lobbyStateRealTime: (json['lobbyStateRealTime'] as Map<String, dynamic>?)
      ?.map(
        (k, e) =>
            MapEntry(k, PlayerStateModel.fromJson(e as Map<String, dynamic>)),
      ),
  gameServer: json['gameServer'] == null
      ? null
      : GameServerModel.fromJson(json['gameServer'] as Map<String, dynamic>),
  timeout: (json['timeout'] as num?)?.toInt(),
  matchmakingMode: json['matchmakingMode'] as String?,
  matchmakingTicketId: json['matchmakingTicketId'] as String?,
  matchmakingStartedAt: json['matchmakingStartedAt'] == null
      ? null
      : DateTime.parse(json['matchmakingStartedAt'] as String),
  matchmakingData: json['matchmakingData'] == null
      ? null
      : MatchmakingDataModel.fromJson(
          json['matchmakingData'] as Map<String, dynamic>,
        ),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$LobbyModelImplToJson(_$LobbyModelImpl instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.host case final value?) 'host': value,
      if (instance.maxPlayers case final value?) 'maxPlayers': value,
      if (instance.currentPlayers case final value?) 'currentPlayers': value,
      if (instance.region case final value?) 'region': value,
      if (instance.status case final value?) 'status': value,
      if (instance.isPrivate case final value?) 'isPrivate': value,
      if (instance.useInviteCode case final value?) 'useInviteCode': value,
      if (instance.inviteCode case final value?) 'inviteCode': value,
      if (instance.allowLateJoin case final value?) 'allowLateJoin': value,
      if (instance.settings case final value?) 'settings': value,
      if (instance.players case final value?) 'players': value,
      if (instance.lobbyStateRealTime case final value?)
        'lobbyStateRealTime': value,
      if (instance.gameServer case final value?) 'gameServer': value,
      if (instance.timeout case final value?) 'timeout': value,
      if (instance.matchmakingMode case final value?) 'matchmakingMode': value,
      if (instance.matchmakingTicketId case final value?)
        'matchmakingTicketId': value,
      if (instance.matchmakingStartedAt?.toIso8601String() case final value?)
        'matchmakingStartedAt': value,
      if (instance.matchmakingData case final value?) 'matchmakingData': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
    };

_$PlayerPositionModelImpl _$$PlayerPositionModelImplFromJson(
  Map<String, dynamic> json,
) => _$PlayerPositionModelImpl(
  x: (json['x'] as num?)?.toDouble(),
  y: (json['y'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$PlayerPositionModelImplToJson(
  _$PlayerPositionModelImpl instance,
) => <String, dynamic>{'x': instance.x, 'y': instance.y};

_$GameServerModelImpl _$$GameServerModelImplFromJson(
  Map<String, dynamic> json,
) => _$GameServerModelImpl(
  instanceId: json['instance_id'] as String?,
  name: json['name'] as String?,
  networkPorts: (json['network_ports'] as List<dynamic>?)
      ?.map((e) => NetworkPortModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: json['status'] as String?,
  startupArgs: json['startup_args'] as String?,
  serviceType: json['service_type'] as String?,
  computeSize: json['compute_size'] as String?,
  region: json['region'] as String?,
  versionTag: json['version_tag'] as String?,
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  stoppedAt: json['stopped_at'] == null
      ? null
      : DateTime.parse(json['stopped_at'] as String),
  customData: json['custom_data'] == null
      ? null
      : GameServerCustomDataModel.fromJson(
          json['custom_data'] as Map<String, dynamic>,
        ),
  ttl: (json['ttl'] as num?)?.toInt(),
);

Map<String, dynamic> _$$GameServerModelImplToJson(
  _$GameServerModelImpl instance,
) => <String, dynamic>{
  'instance_id': instance.instanceId,
  'name': instance.name,
  'network_ports': instance.networkPorts,
  'status': instance.status,
  'startup_args': instance.startupArgs,
  'service_type': instance.serviceType,
  'compute_size': instance.computeSize,
  'region': instance.region,
  'version_tag': instance.versionTag,
  'started_at': instance.startedAt?.toIso8601String(),
  'stopped_at': instance.stoppedAt?.toIso8601String(),
  'custom_data': instance.customData,
  'ttl': instance.ttl,
};

_$NetworkPortModelImpl _$$NetworkPortModelImplFromJson(
  Map<String, dynamic> json,
) => _$NetworkPortModelImpl(
  name: json['name'] as String?,
  internalPort: (json['internal_port'] as num?)?.toInt(),
  externalPort: (json['external_port'] as num?)?.toInt(),
  protocol: json['protocol'] as String?,
  host: json['host'] as String?,
  tlsEnabled: json['tls_enabled'] as bool?,
);

Map<String, dynamic> _$$NetworkPortModelImplToJson(
  _$NetworkPortModelImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'internal_port': instance.internalPort,
  'external_port': instance.externalPort,
  'protocol': instance.protocol,
  'host': instance.host,
  'tls_enabled': instance.tlsEnabled,
};

_$GameServerCustomDataModelImpl _$$GameServerCustomDataModelImplFromJson(
  Map<String, dynamic> json,
) => _$GameServerCustomDataModelImpl(
  gameMode: json['gameMode'] as String?,
  mapName: json['mapName'] as String?,
  teamSize: (json['teamSize'] as num?)?.toInt(),
  scoreLimit: (json['scoreLimit'] as num?)?.toInt(),
);

Map<String, dynamic> _$$GameServerCustomDataModelImplToJson(
  _$GameServerCustomDataModelImpl instance,
) => <String, dynamic>{
  'gameMode': instance.gameMode,
  'mapName': instance.mapName,
  'teamSize': instance.teamSize,
  'scoreLimit': instance.scoreLimit,
};

_$MatchmakingDataModelImpl _$$MatchmakingDataModelImplFromJson(
  Map<String, dynamic> json,
) => _$MatchmakingDataModelImpl(
  mmr: (json['mmr'] as num?)?.toInt(),
  tier: json['tier'] as String?,
);

Map<String, dynamic> _$$MatchmakingDataModelImplToJson(
  _$MatchmakingDataModelImpl instance,
) => <String, dynamic>{'mmr': instance.mmr, 'tier': instance.tier};
