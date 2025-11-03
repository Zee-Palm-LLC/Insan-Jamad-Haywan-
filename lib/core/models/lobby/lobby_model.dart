import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insan_jamd_hawan/core/models/game/lobby_settings.dart';
import 'package:insan_jamd_hawan/core/models/game/player_state_model.dart';

part 'lobby_model.freezed.dart';
part 'lobby_model.g.dart';

@freezed
class LobbyModel with _$LobbyModel {
  const factory LobbyModel({
    @JsonKey(includeIfNull: false) final String? id,
    @JsonKey(includeIfNull: false) final String? name,
    @JsonKey(includeIfNull: false) final String? host,
    @JsonKey(includeIfNull: false) final int? maxPlayers,
    @JsonKey(includeIfNull: false) final int? currentPlayers,
    @JsonKey(includeIfNull: false) final String? region,
    @JsonKey(includeIfNull: false) final String? status,
    @JsonKey(includeIfNull: false) final bool? isPrivate,
    @JsonKey(includeIfNull: false) final bool? useInviteCode,
    @JsonKey(includeIfNull: false) final String? inviteCode,
    @JsonKey(includeIfNull: false) final bool? allowLateJoin,
    @JsonKey(includeIfNull: false) final GameSettings? settings,
    @JsonKey(includeIfNull: false) final List<String>? players,
    @JsonKey(includeIfNull: false)
    final Map<String, PlayerStateModel>? lobbyStateRealTime,
    @JsonKey(includeIfNull: false) final GameServerModel? gameServer,
    @JsonKey(includeIfNull: false) final int? timeout,
    @JsonKey(includeIfNull: false) final String? matchmakingMode,
    @JsonKey(includeIfNull: false) final String? matchmakingTicketId,
    @JsonKey(includeIfNull: false) final DateTime? matchmakingStartedAt,
    @JsonKey(includeIfNull: false) final MatchmakingDataModel? matchmakingData,
    @JsonKey(includeIfNull: false) final DateTime? createdAt,
    @JsonKey(includeIfNull: false) final DateTime? updatedAt,
  }) = _LobbyModel;

  factory LobbyModel.fromJson(Map<String, dynamic> json) =>
      _$LobbyModelFromJson(json);
}

@freezed
class PlayerPositionModel with _$PlayerPositionModel {
  const factory PlayerPositionModel({final double? x, final double? y}) =
      _PlayerPositionModel;

  factory PlayerPositionModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerPositionModelFromJson(json);
}

@freezed
class GameServerModel with _$GameServerModel {
  const factory GameServerModel({
    @JsonKey(name: 'instance_id') final String? instanceId,
    final String? name,
    @JsonKey(name: 'network_ports') final List<NetworkPortModel>? networkPorts,
    final String? status,
    @JsonKey(name: 'startup_args') final String? startupArgs,
    @JsonKey(name: 'service_type') final String? serviceType,
    @JsonKey(name: 'compute_size') final String? computeSize,
    final String? region,
    @JsonKey(name: 'version_tag') final String? versionTag,
    @JsonKey(name: 'started_at') final DateTime? startedAt,
    @JsonKey(name: 'stopped_at') final DateTime? stoppedAt,
    @JsonKey(name: 'custom_data') final GameServerCustomDataModel? customData,
    final int? ttl,
  }) = _GameServerModel;

  factory GameServerModel.fromJson(Map<String, dynamic> json) =>
      _$GameServerModelFromJson(json);
}

@freezed
class NetworkPortModel with _$NetworkPortModel {
  const factory NetworkPortModel({
    final String? name,
    @JsonKey(name: 'internal_port') final int? internalPort,
    @JsonKey(name: 'external_port') final int? externalPort,
    final String? protocol,
    final String? host,
    @JsonKey(name: 'tls_enabled') final bool? tlsEnabled,
  }) = _NetworkPortModel;

  factory NetworkPortModel.fromJson(Map<String, dynamic> json) =>
      _$NetworkPortModelFromJson(json);
}

@freezed
class GameServerCustomDataModel with _$GameServerCustomDataModel {
  const factory GameServerCustomDataModel({
    final String? gameMode,
    final String? mapName,
    final int? teamSize,
    final int? scoreLimit,
  }) = _GameServerCustomDataModel;

  factory GameServerCustomDataModel.fromJson(Map<String, dynamic> json) =>
      _$GameServerCustomDataModelFromJson(json);
}

@freezed
class MatchmakingDataModel with _$MatchmakingDataModel {
  const factory MatchmakingDataModel({final int? mmr, final String? tier}) =
      _MatchmakingDataModel;

  factory MatchmakingDataModel.fromJson(Map<String, dynamic> json) =>
      _$MatchmakingDataModelFromJson(json);
}
