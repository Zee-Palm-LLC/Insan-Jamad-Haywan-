// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LobbyModel _$LobbyModelFromJson(Map<String, dynamic> json) {
  return _LobbyModel.fromJson(json);
}

/// @nodoc
mixin _$LobbyModel {
  @JsonKey(includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get host => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  int? get maxPlayers => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  int? get currentPlayers => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get region => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get isPrivate => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get useInviteCode => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get inviteCode => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get allowLateJoin => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  GameSettings? get settings => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  List<String>? get players => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  Map<String, PlayerStateModel>? get lobbyStateRealTime =>
      throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  GameServerModel? get gameServer => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  int? get timeout => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get matchmakingMode => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get matchmakingTicketId => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  DateTime? get matchmakingStartedAt => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  MatchmakingDataModel? get matchmakingData =>
      throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this LobbyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LobbyModelCopyWith<LobbyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LobbyModelCopyWith<$Res> {
  factory $LobbyModelCopyWith(
    LobbyModel value,
    $Res Function(LobbyModel) then,
  ) = _$LobbyModelCopyWithImpl<$Res, LobbyModel>;
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? id,
    @JsonKey(includeIfNull: false) String? name,
    @JsonKey(includeIfNull: false) String? host,
    @JsonKey(includeIfNull: false) int? maxPlayers,
    @JsonKey(includeIfNull: false) int? currentPlayers,
    @JsonKey(includeIfNull: false) String? region,
    @JsonKey(includeIfNull: false) String? status,
    @JsonKey(includeIfNull: false) bool? isPrivate,
    @JsonKey(includeIfNull: false) bool? useInviteCode,
    @JsonKey(includeIfNull: false) String? inviteCode,
    @JsonKey(includeIfNull: false) bool? allowLateJoin,
    @JsonKey(includeIfNull: false) GameSettings? settings,
    @JsonKey(includeIfNull: false) List<String>? players,
    @JsonKey(includeIfNull: false)
    Map<String, PlayerStateModel>? lobbyStateRealTime,
    @JsonKey(includeIfNull: false) GameServerModel? gameServer,
    @JsonKey(includeIfNull: false) int? timeout,
    @JsonKey(includeIfNull: false) String? matchmakingMode,
    @JsonKey(includeIfNull: false) String? matchmakingTicketId,
    @JsonKey(includeIfNull: false) DateTime? matchmakingStartedAt,
    @JsonKey(includeIfNull: false) MatchmakingDataModel? matchmakingData,
    @JsonKey(includeIfNull: false) DateTime? createdAt,
    @JsonKey(includeIfNull: false) DateTime? updatedAt,
  });

  $GameSettingsCopyWith<$Res>? get settings;
  $GameServerModelCopyWith<$Res>? get gameServer;
  $MatchmakingDataModelCopyWith<$Res>? get matchmakingData;
}

/// @nodoc
class _$LobbyModelCopyWithImpl<$Res, $Val extends LobbyModel>
    implements $LobbyModelCopyWith<$Res> {
  _$LobbyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? host = freezed,
    Object? maxPlayers = freezed,
    Object? currentPlayers = freezed,
    Object? region = freezed,
    Object? status = freezed,
    Object? isPrivate = freezed,
    Object? useInviteCode = freezed,
    Object? inviteCode = freezed,
    Object? allowLateJoin = freezed,
    Object? settings = freezed,
    Object? players = freezed,
    Object? lobbyStateRealTime = freezed,
    Object? gameServer = freezed,
    Object? timeout = freezed,
    Object? matchmakingMode = freezed,
    Object? matchmakingTicketId = freezed,
    Object? matchmakingStartedAt = freezed,
    Object? matchmakingData = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            host: freezed == host
                ? _value.host
                : host // ignore: cast_nullable_to_non_nullable
                      as String?,
            maxPlayers: freezed == maxPlayers
                ? _value.maxPlayers
                : maxPlayers // ignore: cast_nullable_to_non_nullable
                      as int?,
            currentPlayers: freezed == currentPlayers
                ? _value.currentPlayers
                : currentPlayers // ignore: cast_nullable_to_non_nullable
                      as int?,
            region: freezed == region
                ? _value.region
                : region // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPrivate: freezed == isPrivate
                ? _value.isPrivate
                : isPrivate // ignore: cast_nullable_to_non_nullable
                      as bool?,
            useInviteCode: freezed == useInviteCode
                ? _value.useInviteCode
                : useInviteCode // ignore: cast_nullable_to_non_nullable
                      as bool?,
            inviteCode: freezed == inviteCode
                ? _value.inviteCode
                : inviteCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            allowLateJoin: freezed == allowLateJoin
                ? _value.allowLateJoin
                : allowLateJoin // ignore: cast_nullable_to_non_nullable
                      as bool?,
            settings: freezed == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as GameSettings?,
            players: freezed == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            lobbyStateRealTime: freezed == lobbyStateRealTime
                ? _value.lobbyStateRealTime
                : lobbyStateRealTime // ignore: cast_nullable_to_non_nullable
                      as Map<String, PlayerStateModel>?,
            gameServer: freezed == gameServer
                ? _value.gameServer
                : gameServer // ignore: cast_nullable_to_non_nullable
                      as GameServerModel?,
            timeout: freezed == timeout
                ? _value.timeout
                : timeout // ignore: cast_nullable_to_non_nullable
                      as int?,
            matchmakingMode: freezed == matchmakingMode
                ? _value.matchmakingMode
                : matchmakingMode // ignore: cast_nullable_to_non_nullable
                      as String?,
            matchmakingTicketId: freezed == matchmakingTicketId
                ? _value.matchmakingTicketId
                : matchmakingTicketId // ignore: cast_nullable_to_non_nullable
                      as String?,
            matchmakingStartedAt: freezed == matchmakingStartedAt
                ? _value.matchmakingStartedAt
                : matchmakingStartedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            matchmakingData: freezed == matchmakingData
                ? _value.matchmakingData
                : matchmakingData // ignore: cast_nullable_to_non_nullable
                      as MatchmakingDataModel?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameSettingsCopyWith<$Res>? get settings {
    if (_value.settings == null) {
      return null;
    }

    return $GameSettingsCopyWith<$Res>(_value.settings!, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameServerModelCopyWith<$Res>? get gameServer {
    if (_value.gameServer == null) {
      return null;
    }

    return $GameServerModelCopyWith<$Res>(_value.gameServer!, (value) {
      return _then(_value.copyWith(gameServer: value) as $Val);
    });
  }

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchmakingDataModelCopyWith<$Res>? get matchmakingData {
    if (_value.matchmakingData == null) {
      return null;
    }

    return $MatchmakingDataModelCopyWith<$Res>(_value.matchmakingData!, (
      value,
    ) {
      return _then(_value.copyWith(matchmakingData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LobbyModelImplCopyWith<$Res>
    implements $LobbyModelCopyWith<$Res> {
  factory _$$LobbyModelImplCopyWith(
    _$LobbyModelImpl value,
    $Res Function(_$LobbyModelImpl) then,
  ) = __$$LobbyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? id,
    @JsonKey(includeIfNull: false) String? name,
    @JsonKey(includeIfNull: false) String? host,
    @JsonKey(includeIfNull: false) int? maxPlayers,
    @JsonKey(includeIfNull: false) int? currentPlayers,
    @JsonKey(includeIfNull: false) String? region,
    @JsonKey(includeIfNull: false) String? status,
    @JsonKey(includeIfNull: false) bool? isPrivate,
    @JsonKey(includeIfNull: false) bool? useInviteCode,
    @JsonKey(includeIfNull: false) String? inviteCode,
    @JsonKey(includeIfNull: false) bool? allowLateJoin,
    @JsonKey(includeIfNull: false) GameSettings? settings,
    @JsonKey(includeIfNull: false) List<String>? players,
    @JsonKey(includeIfNull: false)
    Map<String, PlayerStateModel>? lobbyStateRealTime,
    @JsonKey(includeIfNull: false) GameServerModel? gameServer,
    @JsonKey(includeIfNull: false) int? timeout,
    @JsonKey(includeIfNull: false) String? matchmakingMode,
    @JsonKey(includeIfNull: false) String? matchmakingTicketId,
    @JsonKey(includeIfNull: false) DateTime? matchmakingStartedAt,
    @JsonKey(includeIfNull: false) MatchmakingDataModel? matchmakingData,
    @JsonKey(includeIfNull: false) DateTime? createdAt,
    @JsonKey(includeIfNull: false) DateTime? updatedAt,
  });

  @override
  $GameSettingsCopyWith<$Res>? get settings;
  @override
  $GameServerModelCopyWith<$Res>? get gameServer;
  @override
  $MatchmakingDataModelCopyWith<$Res>? get matchmakingData;
}

/// @nodoc
class __$$LobbyModelImplCopyWithImpl<$Res>
    extends _$LobbyModelCopyWithImpl<$Res, _$LobbyModelImpl>
    implements _$$LobbyModelImplCopyWith<$Res> {
  __$$LobbyModelImplCopyWithImpl(
    _$LobbyModelImpl _value,
    $Res Function(_$LobbyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? host = freezed,
    Object? maxPlayers = freezed,
    Object? currentPlayers = freezed,
    Object? region = freezed,
    Object? status = freezed,
    Object? isPrivate = freezed,
    Object? useInviteCode = freezed,
    Object? inviteCode = freezed,
    Object? allowLateJoin = freezed,
    Object? settings = freezed,
    Object? players = freezed,
    Object? lobbyStateRealTime = freezed,
    Object? gameServer = freezed,
    Object? timeout = freezed,
    Object? matchmakingMode = freezed,
    Object? matchmakingTicketId = freezed,
    Object? matchmakingStartedAt = freezed,
    Object? matchmakingData = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$LobbyModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        host: freezed == host
            ? _value.host
            : host // ignore: cast_nullable_to_non_nullable
                  as String?,
        maxPlayers: freezed == maxPlayers
            ? _value.maxPlayers
            : maxPlayers // ignore: cast_nullable_to_non_nullable
                  as int?,
        currentPlayers: freezed == currentPlayers
            ? _value.currentPlayers
            : currentPlayers // ignore: cast_nullable_to_non_nullable
                  as int?,
        region: freezed == region
            ? _value.region
            : region // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPrivate: freezed == isPrivate
            ? _value.isPrivate
            : isPrivate // ignore: cast_nullable_to_non_nullable
                  as bool?,
        useInviteCode: freezed == useInviteCode
            ? _value.useInviteCode
            : useInviteCode // ignore: cast_nullable_to_non_nullable
                  as bool?,
        inviteCode: freezed == inviteCode
            ? _value.inviteCode
            : inviteCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        allowLateJoin: freezed == allowLateJoin
            ? _value.allowLateJoin
            : allowLateJoin // ignore: cast_nullable_to_non_nullable
                  as bool?,
        settings: freezed == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as GameSettings?,
        players: freezed == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        lobbyStateRealTime: freezed == lobbyStateRealTime
            ? _value._lobbyStateRealTime
            : lobbyStateRealTime // ignore: cast_nullable_to_non_nullable
                  as Map<String, PlayerStateModel>?,
        gameServer: freezed == gameServer
            ? _value.gameServer
            : gameServer // ignore: cast_nullable_to_non_nullable
                  as GameServerModel?,
        timeout: freezed == timeout
            ? _value.timeout
            : timeout // ignore: cast_nullable_to_non_nullable
                  as int?,
        matchmakingMode: freezed == matchmakingMode
            ? _value.matchmakingMode
            : matchmakingMode // ignore: cast_nullable_to_non_nullable
                  as String?,
        matchmakingTicketId: freezed == matchmakingTicketId
            ? _value.matchmakingTicketId
            : matchmakingTicketId // ignore: cast_nullable_to_non_nullable
                  as String?,
        matchmakingStartedAt: freezed == matchmakingStartedAt
            ? _value.matchmakingStartedAt
            : matchmakingStartedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        matchmakingData: freezed == matchmakingData
            ? _value.matchmakingData
            : matchmakingData // ignore: cast_nullable_to_non_nullable
                  as MatchmakingDataModel?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LobbyModelImpl implements _LobbyModel {
  const _$LobbyModelImpl({
    @JsonKey(includeIfNull: false) this.id,
    @JsonKey(includeIfNull: false) this.name,
    @JsonKey(includeIfNull: false) this.host,
    @JsonKey(includeIfNull: false) this.maxPlayers,
    @JsonKey(includeIfNull: false) this.currentPlayers,
    @JsonKey(includeIfNull: false) this.region,
    @JsonKey(includeIfNull: false) this.status,
    @JsonKey(includeIfNull: false) this.isPrivate,
    @JsonKey(includeIfNull: false) this.useInviteCode,
    @JsonKey(includeIfNull: false) this.inviteCode,
    @JsonKey(includeIfNull: false) this.allowLateJoin,
    @JsonKey(includeIfNull: false) this.settings,
    @JsonKey(includeIfNull: false) final List<String>? players,
    @JsonKey(includeIfNull: false)
    final Map<String, PlayerStateModel>? lobbyStateRealTime,
    @JsonKey(includeIfNull: false) this.gameServer,
    @JsonKey(includeIfNull: false) this.timeout,
    @JsonKey(includeIfNull: false) this.matchmakingMode,
    @JsonKey(includeIfNull: false) this.matchmakingTicketId,
    @JsonKey(includeIfNull: false) this.matchmakingStartedAt,
    @JsonKey(includeIfNull: false) this.matchmakingData,
    @JsonKey(includeIfNull: false) this.createdAt,
    @JsonKey(includeIfNull: false) this.updatedAt,
  }) : _players = players,
       _lobbyStateRealTime = lobbyStateRealTime;

  factory _$LobbyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LobbyModelImplFromJson(json);

  @override
  @JsonKey(includeIfNull: false)
  final String? id;
  @override
  @JsonKey(includeIfNull: false)
  final String? name;
  @override
  @JsonKey(includeIfNull: false)
  final String? host;
  @override
  @JsonKey(includeIfNull: false)
  final int? maxPlayers;
  @override
  @JsonKey(includeIfNull: false)
  final int? currentPlayers;
  @override
  @JsonKey(includeIfNull: false)
  final String? region;
  @override
  @JsonKey(includeIfNull: false)
  final String? status;
  @override
  @JsonKey(includeIfNull: false)
  final bool? isPrivate;
  @override
  @JsonKey(includeIfNull: false)
  final bool? useInviteCode;
  @override
  @JsonKey(includeIfNull: false)
  final String? inviteCode;
  @override
  @JsonKey(includeIfNull: false)
  final bool? allowLateJoin;
  @override
  @JsonKey(includeIfNull: false)
  final GameSettings? settings;
  final List<String>? _players;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get players {
    final value = _players;
    if (value == null) return null;
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, PlayerStateModel>? _lobbyStateRealTime;
  @override
  @JsonKey(includeIfNull: false)
  Map<String, PlayerStateModel>? get lobbyStateRealTime {
    final value = _lobbyStateRealTime;
    if (value == null) return null;
    if (_lobbyStateRealTime is EqualUnmodifiableMapView)
      return _lobbyStateRealTime;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(includeIfNull: false)
  final GameServerModel? gameServer;
  @override
  @JsonKey(includeIfNull: false)
  final int? timeout;
  @override
  @JsonKey(includeIfNull: false)
  final String? matchmakingMode;
  @override
  @JsonKey(includeIfNull: false)
  final String? matchmakingTicketId;
  @override
  @JsonKey(includeIfNull: false)
  final DateTime? matchmakingStartedAt;
  @override
  @JsonKey(includeIfNull: false)
  final MatchmakingDataModel? matchmakingData;
  @override
  @JsonKey(includeIfNull: false)
  final DateTime? createdAt;
  @override
  @JsonKey(includeIfNull: false)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'LobbyModel(id: $id, name: $name, host: $host, maxPlayers: $maxPlayers, currentPlayers: $currentPlayers, region: $region, status: $status, isPrivate: $isPrivate, useInviteCode: $useInviteCode, inviteCode: $inviteCode, allowLateJoin: $allowLateJoin, settings: $settings, players: $players, lobbyStateRealTime: $lobbyStateRealTime, gameServer: $gameServer, timeout: $timeout, matchmakingMode: $matchmakingMode, matchmakingTicketId: $matchmakingTicketId, matchmakingStartedAt: $matchmakingStartedAt, matchmakingData: $matchmakingData, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LobbyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.maxPlayers, maxPlayers) ||
                other.maxPlayers == maxPlayers) &&
            (identical(other.currentPlayers, currentPlayers) ||
                other.currentPlayers == currentPlayers) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.useInviteCode, useInviteCode) ||
                other.useInviteCode == useInviteCode) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.allowLateJoin, allowLateJoin) ||
                other.allowLateJoin == allowLateJoin) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            const DeepCollectionEquality().equals(
              other._lobbyStateRealTime,
              _lobbyStateRealTime,
            ) &&
            (identical(other.gameServer, gameServer) ||
                other.gameServer == gameServer) &&
            (identical(other.timeout, timeout) || other.timeout == timeout) &&
            (identical(other.matchmakingMode, matchmakingMode) ||
                other.matchmakingMode == matchmakingMode) &&
            (identical(other.matchmakingTicketId, matchmakingTicketId) ||
                other.matchmakingTicketId == matchmakingTicketId) &&
            (identical(other.matchmakingStartedAt, matchmakingStartedAt) ||
                other.matchmakingStartedAt == matchmakingStartedAt) &&
            (identical(other.matchmakingData, matchmakingData) ||
                other.matchmakingData == matchmakingData) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    host,
    maxPlayers,
    currentPlayers,
    region,
    status,
    isPrivate,
    useInviteCode,
    inviteCode,
    allowLateJoin,
    settings,
    const DeepCollectionEquality().hash(_players),
    const DeepCollectionEquality().hash(_lobbyStateRealTime),
    gameServer,
    timeout,
    matchmakingMode,
    matchmakingTicketId,
    matchmakingStartedAt,
    matchmakingData,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LobbyModelImplCopyWith<_$LobbyModelImpl> get copyWith =>
      __$$LobbyModelImplCopyWithImpl<_$LobbyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LobbyModelImplToJson(this);
  }
}

abstract class _LobbyModel implements LobbyModel {
  const factory _LobbyModel({
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
  }) = _$LobbyModelImpl;

  factory _LobbyModel.fromJson(Map<String, dynamic> json) =
      _$LobbyModelImpl.fromJson;

  @override
  @JsonKey(includeIfNull: false)
  String? get id;
  @override
  @JsonKey(includeIfNull: false)
  String? get name;
  @override
  @JsonKey(includeIfNull: false)
  String? get host;
  @override
  @JsonKey(includeIfNull: false)
  int? get maxPlayers;
  @override
  @JsonKey(includeIfNull: false)
  int? get currentPlayers;
  @override
  @JsonKey(includeIfNull: false)
  String? get region;
  @override
  @JsonKey(includeIfNull: false)
  String? get status;
  @override
  @JsonKey(includeIfNull: false)
  bool? get isPrivate;
  @override
  @JsonKey(includeIfNull: false)
  bool? get useInviteCode;
  @override
  @JsonKey(includeIfNull: false)
  String? get inviteCode;
  @override
  @JsonKey(includeIfNull: false)
  bool? get allowLateJoin;
  @override
  @JsonKey(includeIfNull: false)
  GameSettings? get settings;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get players;
  @override
  @JsonKey(includeIfNull: false)
  Map<String, PlayerStateModel>? get lobbyStateRealTime;
  @override
  @JsonKey(includeIfNull: false)
  GameServerModel? get gameServer;
  @override
  @JsonKey(includeIfNull: false)
  int? get timeout;
  @override
  @JsonKey(includeIfNull: false)
  String? get matchmakingMode;
  @override
  @JsonKey(includeIfNull: false)
  String? get matchmakingTicketId;
  @override
  @JsonKey(includeIfNull: false)
  DateTime? get matchmakingStartedAt;
  @override
  @JsonKey(includeIfNull: false)
  MatchmakingDataModel? get matchmakingData;
  @override
  @JsonKey(includeIfNull: false)
  DateTime? get createdAt;
  @override
  @JsonKey(includeIfNull: false)
  DateTime? get updatedAt;

  /// Create a copy of LobbyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LobbyModelImplCopyWith<_$LobbyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlayerPositionModel _$PlayerPositionModelFromJson(Map<String, dynamic> json) {
  return _PlayerPositionModel.fromJson(json);
}

/// @nodoc
mixin _$PlayerPositionModel {
  double? get x => throw _privateConstructorUsedError;
  double? get y => throw _privateConstructorUsedError;

  /// Serializes this PlayerPositionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerPositionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerPositionModelCopyWith<PlayerPositionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerPositionModelCopyWith<$Res> {
  factory $PlayerPositionModelCopyWith(
    PlayerPositionModel value,
    $Res Function(PlayerPositionModel) then,
  ) = _$PlayerPositionModelCopyWithImpl<$Res, PlayerPositionModel>;
  @useResult
  $Res call({double? x, double? y});
}

/// @nodoc
class _$PlayerPositionModelCopyWithImpl<$Res, $Val extends PlayerPositionModel>
    implements $PlayerPositionModelCopyWith<$Res> {
  _$PlayerPositionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerPositionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? x = freezed, Object? y = freezed}) {
    return _then(
      _value.copyWith(
            x: freezed == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as double?,
            y: freezed == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerPositionModelImplCopyWith<$Res>
    implements $PlayerPositionModelCopyWith<$Res> {
  factory _$$PlayerPositionModelImplCopyWith(
    _$PlayerPositionModelImpl value,
    $Res Function(_$PlayerPositionModelImpl) then,
  ) = __$$PlayerPositionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double? x, double? y});
}

/// @nodoc
class __$$PlayerPositionModelImplCopyWithImpl<$Res>
    extends _$PlayerPositionModelCopyWithImpl<$Res, _$PlayerPositionModelImpl>
    implements _$$PlayerPositionModelImplCopyWith<$Res> {
  __$$PlayerPositionModelImplCopyWithImpl(
    _$PlayerPositionModelImpl _value,
    $Res Function(_$PlayerPositionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerPositionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? x = freezed, Object? y = freezed}) {
    return _then(
      _$PlayerPositionModelImpl(
        x: freezed == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as double?,
        y: freezed == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerPositionModelImpl implements _PlayerPositionModel {
  const _$PlayerPositionModelImpl({this.x, this.y});

  factory _$PlayerPositionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerPositionModelImplFromJson(json);

  @override
  final double? x;
  @override
  final double? y;

  @override
  String toString() {
    return 'PlayerPositionModel(x: $x, y: $y)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerPositionModelImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y);

  /// Create a copy of PlayerPositionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerPositionModelImplCopyWith<_$PlayerPositionModelImpl> get copyWith =>
      __$$PlayerPositionModelImplCopyWithImpl<_$PlayerPositionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerPositionModelImplToJson(this);
  }
}

abstract class _PlayerPositionModel implements PlayerPositionModel {
  const factory _PlayerPositionModel({final double? x, final double? y}) =
      _$PlayerPositionModelImpl;

  factory _PlayerPositionModel.fromJson(Map<String, dynamic> json) =
      _$PlayerPositionModelImpl.fromJson;

  @override
  double? get x;
  @override
  double? get y;

  /// Create a copy of PlayerPositionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerPositionModelImplCopyWith<_$PlayerPositionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameServerModel _$GameServerModelFromJson(Map<String, dynamic> json) {
  return _GameServerModel.fromJson(json);
}

/// @nodoc
mixin _$GameServerModel {
  @JsonKey(name: 'instance_id')
  String? get instanceId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'network_ports')
  List<NetworkPortModel>? get networkPorts =>
      throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'startup_args')
  String? get startupArgs => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_type')
  String? get serviceType => throw _privateConstructorUsedError;
  @JsonKey(name: 'compute_size')
  String? get computeSize => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;
  @JsonKey(name: 'version_tag')
  String? get versionTag => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime? get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'stopped_at')
  DateTime? get stoppedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'custom_data')
  GameServerCustomDataModel? get customData =>
      throw _privateConstructorUsedError;
  int? get ttl => throw _privateConstructorUsedError;

  /// Serializes this GameServerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameServerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameServerModelCopyWith<GameServerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameServerModelCopyWith<$Res> {
  factory $GameServerModelCopyWith(
    GameServerModel value,
    $Res Function(GameServerModel) then,
  ) = _$GameServerModelCopyWithImpl<$Res, GameServerModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'instance_id') String? instanceId,
    String? name,
    @JsonKey(name: 'network_ports') List<NetworkPortModel>? networkPorts,
    String? status,
    @JsonKey(name: 'startup_args') String? startupArgs,
    @JsonKey(name: 'service_type') String? serviceType,
    @JsonKey(name: 'compute_size') String? computeSize,
    String? region,
    @JsonKey(name: 'version_tag') String? versionTag,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'stopped_at') DateTime? stoppedAt,
    @JsonKey(name: 'custom_data') GameServerCustomDataModel? customData,
    int? ttl,
  });

  $GameServerCustomDataModelCopyWith<$Res>? get customData;
}

/// @nodoc
class _$GameServerModelCopyWithImpl<$Res, $Val extends GameServerModel>
    implements $GameServerModelCopyWith<$Res> {
  _$GameServerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameServerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instanceId = freezed,
    Object? name = freezed,
    Object? networkPorts = freezed,
    Object? status = freezed,
    Object? startupArgs = freezed,
    Object? serviceType = freezed,
    Object? computeSize = freezed,
    Object? region = freezed,
    Object? versionTag = freezed,
    Object? startedAt = freezed,
    Object? stoppedAt = freezed,
    Object? customData = freezed,
    Object? ttl = freezed,
  }) {
    return _then(
      _value.copyWith(
            instanceId: freezed == instanceId
                ? _value.instanceId
                : instanceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            networkPorts: freezed == networkPorts
                ? _value.networkPorts
                : networkPorts // ignore: cast_nullable_to_non_nullable
                      as List<NetworkPortModel>?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            startupArgs: freezed == startupArgs
                ? _value.startupArgs
                : startupArgs // ignore: cast_nullable_to_non_nullable
                      as String?,
            serviceType: freezed == serviceType
                ? _value.serviceType
                : serviceType // ignore: cast_nullable_to_non_nullable
                      as String?,
            computeSize: freezed == computeSize
                ? _value.computeSize
                : computeSize // ignore: cast_nullable_to_non_nullable
                      as String?,
            region: freezed == region
                ? _value.region
                : region // ignore: cast_nullable_to_non_nullable
                      as String?,
            versionTag: freezed == versionTag
                ? _value.versionTag
                : versionTag // ignore: cast_nullable_to_non_nullable
                      as String?,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            stoppedAt: freezed == stoppedAt
                ? _value.stoppedAt
                : stoppedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            customData: freezed == customData
                ? _value.customData
                : customData // ignore: cast_nullable_to_non_nullable
                      as GameServerCustomDataModel?,
            ttl: freezed == ttl
                ? _value.ttl
                : ttl // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }

  /// Create a copy of GameServerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameServerCustomDataModelCopyWith<$Res>? get customData {
    if (_value.customData == null) {
      return null;
    }

    return $GameServerCustomDataModelCopyWith<$Res>(_value.customData!, (
      value,
    ) {
      return _then(_value.copyWith(customData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameServerModelImplCopyWith<$Res>
    implements $GameServerModelCopyWith<$Res> {
  factory _$$GameServerModelImplCopyWith(
    _$GameServerModelImpl value,
    $Res Function(_$GameServerModelImpl) then,
  ) = __$$GameServerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'instance_id') String? instanceId,
    String? name,
    @JsonKey(name: 'network_ports') List<NetworkPortModel>? networkPorts,
    String? status,
    @JsonKey(name: 'startup_args') String? startupArgs,
    @JsonKey(name: 'service_type') String? serviceType,
    @JsonKey(name: 'compute_size') String? computeSize,
    String? region,
    @JsonKey(name: 'version_tag') String? versionTag,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'stopped_at') DateTime? stoppedAt,
    @JsonKey(name: 'custom_data') GameServerCustomDataModel? customData,
    int? ttl,
  });

  @override
  $GameServerCustomDataModelCopyWith<$Res>? get customData;
}

/// @nodoc
class __$$GameServerModelImplCopyWithImpl<$Res>
    extends _$GameServerModelCopyWithImpl<$Res, _$GameServerModelImpl>
    implements _$$GameServerModelImplCopyWith<$Res> {
  __$$GameServerModelImplCopyWithImpl(
    _$GameServerModelImpl _value,
    $Res Function(_$GameServerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameServerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instanceId = freezed,
    Object? name = freezed,
    Object? networkPorts = freezed,
    Object? status = freezed,
    Object? startupArgs = freezed,
    Object? serviceType = freezed,
    Object? computeSize = freezed,
    Object? region = freezed,
    Object? versionTag = freezed,
    Object? startedAt = freezed,
    Object? stoppedAt = freezed,
    Object? customData = freezed,
    Object? ttl = freezed,
  }) {
    return _then(
      _$GameServerModelImpl(
        instanceId: freezed == instanceId
            ? _value.instanceId
            : instanceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        networkPorts: freezed == networkPorts
            ? _value._networkPorts
            : networkPorts // ignore: cast_nullable_to_non_nullable
                  as List<NetworkPortModel>?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        startupArgs: freezed == startupArgs
            ? _value.startupArgs
            : startupArgs // ignore: cast_nullable_to_non_nullable
                  as String?,
        serviceType: freezed == serviceType
            ? _value.serviceType
            : serviceType // ignore: cast_nullable_to_non_nullable
                  as String?,
        computeSize: freezed == computeSize
            ? _value.computeSize
            : computeSize // ignore: cast_nullable_to_non_nullable
                  as String?,
        region: freezed == region
            ? _value.region
            : region // ignore: cast_nullable_to_non_nullable
                  as String?,
        versionTag: freezed == versionTag
            ? _value.versionTag
            : versionTag // ignore: cast_nullable_to_non_nullable
                  as String?,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        stoppedAt: freezed == stoppedAt
            ? _value.stoppedAt
            : stoppedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        customData: freezed == customData
            ? _value.customData
            : customData // ignore: cast_nullable_to_non_nullable
                  as GameServerCustomDataModel?,
        ttl: freezed == ttl
            ? _value.ttl
            : ttl // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameServerModelImpl implements _GameServerModel {
  const _$GameServerModelImpl({
    @JsonKey(name: 'instance_id') this.instanceId,
    this.name,
    @JsonKey(name: 'network_ports') final List<NetworkPortModel>? networkPorts,
    this.status,
    @JsonKey(name: 'startup_args') this.startupArgs,
    @JsonKey(name: 'service_type') this.serviceType,
    @JsonKey(name: 'compute_size') this.computeSize,
    this.region,
    @JsonKey(name: 'version_tag') this.versionTag,
    @JsonKey(name: 'started_at') this.startedAt,
    @JsonKey(name: 'stopped_at') this.stoppedAt,
    @JsonKey(name: 'custom_data') this.customData,
    this.ttl,
  }) : _networkPorts = networkPorts;

  factory _$GameServerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameServerModelImplFromJson(json);

  @override
  @JsonKey(name: 'instance_id')
  final String? instanceId;
  @override
  final String? name;
  final List<NetworkPortModel>? _networkPorts;
  @override
  @JsonKey(name: 'network_ports')
  List<NetworkPortModel>? get networkPorts {
    final value = _networkPorts;
    if (value == null) return null;
    if (_networkPorts is EqualUnmodifiableListView) return _networkPorts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? status;
  @override
  @JsonKey(name: 'startup_args')
  final String? startupArgs;
  @override
  @JsonKey(name: 'service_type')
  final String? serviceType;
  @override
  @JsonKey(name: 'compute_size')
  final String? computeSize;
  @override
  final String? region;
  @override
  @JsonKey(name: 'version_tag')
  final String? versionTag;
  @override
  @JsonKey(name: 'started_at')
  final DateTime? startedAt;
  @override
  @JsonKey(name: 'stopped_at')
  final DateTime? stoppedAt;
  @override
  @JsonKey(name: 'custom_data')
  final GameServerCustomDataModel? customData;
  @override
  final int? ttl;

  @override
  String toString() {
    return 'GameServerModel(instanceId: $instanceId, name: $name, networkPorts: $networkPorts, status: $status, startupArgs: $startupArgs, serviceType: $serviceType, computeSize: $computeSize, region: $region, versionTag: $versionTag, startedAt: $startedAt, stoppedAt: $stoppedAt, customData: $customData, ttl: $ttl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameServerModelImpl &&
            (identical(other.instanceId, instanceId) ||
                other.instanceId == instanceId) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(
              other._networkPorts,
              _networkPorts,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startupArgs, startupArgs) ||
                other.startupArgs == startupArgs) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.computeSize, computeSize) ||
                other.computeSize == computeSize) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.versionTag, versionTag) ||
                other.versionTag == versionTag) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.stoppedAt, stoppedAt) ||
                other.stoppedAt == stoppedAt) &&
            (identical(other.customData, customData) ||
                other.customData == customData) &&
            (identical(other.ttl, ttl) || other.ttl == ttl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    instanceId,
    name,
    const DeepCollectionEquality().hash(_networkPorts),
    status,
    startupArgs,
    serviceType,
    computeSize,
    region,
    versionTag,
    startedAt,
    stoppedAt,
    customData,
    ttl,
  );

  /// Create a copy of GameServerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameServerModelImplCopyWith<_$GameServerModelImpl> get copyWith =>
      __$$GameServerModelImplCopyWithImpl<_$GameServerModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GameServerModelImplToJson(this);
  }
}

abstract class _GameServerModel implements GameServerModel {
  const factory _GameServerModel({
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
  }) = _$GameServerModelImpl;

  factory _GameServerModel.fromJson(Map<String, dynamic> json) =
      _$GameServerModelImpl.fromJson;

  @override
  @JsonKey(name: 'instance_id')
  String? get instanceId;
  @override
  String? get name;
  @override
  @JsonKey(name: 'network_ports')
  List<NetworkPortModel>? get networkPorts;
  @override
  String? get status;
  @override
  @JsonKey(name: 'startup_args')
  String? get startupArgs;
  @override
  @JsonKey(name: 'service_type')
  String? get serviceType;
  @override
  @JsonKey(name: 'compute_size')
  String? get computeSize;
  @override
  String? get region;
  @override
  @JsonKey(name: 'version_tag')
  String? get versionTag;
  @override
  @JsonKey(name: 'started_at')
  DateTime? get startedAt;
  @override
  @JsonKey(name: 'stopped_at')
  DateTime? get stoppedAt;
  @override
  @JsonKey(name: 'custom_data')
  GameServerCustomDataModel? get customData;
  @override
  int? get ttl;

  /// Create a copy of GameServerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameServerModelImplCopyWith<_$GameServerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NetworkPortModel _$NetworkPortModelFromJson(Map<String, dynamic> json) {
  return _NetworkPortModel.fromJson(json);
}

/// @nodoc
mixin _$NetworkPortModel {
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'internal_port')
  int? get internalPort => throw _privateConstructorUsedError;
  @JsonKey(name: 'external_port')
  int? get externalPort => throw _privateConstructorUsedError;
  String? get protocol => throw _privateConstructorUsedError;
  String? get host => throw _privateConstructorUsedError;
  @JsonKey(name: 'tls_enabled')
  bool? get tlsEnabled => throw _privateConstructorUsedError;

  /// Serializes this NetworkPortModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NetworkPortModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetworkPortModelCopyWith<NetworkPortModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkPortModelCopyWith<$Res> {
  factory $NetworkPortModelCopyWith(
    NetworkPortModel value,
    $Res Function(NetworkPortModel) then,
  ) = _$NetworkPortModelCopyWithImpl<$Res, NetworkPortModel>;
  @useResult
  $Res call({
    String? name,
    @JsonKey(name: 'internal_port') int? internalPort,
    @JsonKey(name: 'external_port') int? externalPort,
    String? protocol,
    String? host,
    @JsonKey(name: 'tls_enabled') bool? tlsEnabled,
  });
}

/// @nodoc
class _$NetworkPortModelCopyWithImpl<$Res, $Val extends NetworkPortModel>
    implements $NetworkPortModelCopyWith<$Res> {
  _$NetworkPortModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetworkPortModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? internalPort = freezed,
    Object? externalPort = freezed,
    Object? protocol = freezed,
    Object? host = freezed,
    Object? tlsEnabled = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            internalPort: freezed == internalPort
                ? _value.internalPort
                : internalPort // ignore: cast_nullable_to_non_nullable
                      as int?,
            externalPort: freezed == externalPort
                ? _value.externalPort
                : externalPort // ignore: cast_nullable_to_non_nullable
                      as int?,
            protocol: freezed == protocol
                ? _value.protocol
                : protocol // ignore: cast_nullable_to_non_nullable
                      as String?,
            host: freezed == host
                ? _value.host
                : host // ignore: cast_nullable_to_non_nullable
                      as String?,
            tlsEnabled: freezed == tlsEnabled
                ? _value.tlsEnabled
                : tlsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NetworkPortModelImplCopyWith<$Res>
    implements $NetworkPortModelCopyWith<$Res> {
  factory _$$NetworkPortModelImplCopyWith(
    _$NetworkPortModelImpl value,
    $Res Function(_$NetworkPortModelImpl) then,
  ) = __$$NetworkPortModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? name,
    @JsonKey(name: 'internal_port') int? internalPort,
    @JsonKey(name: 'external_port') int? externalPort,
    String? protocol,
    String? host,
    @JsonKey(name: 'tls_enabled') bool? tlsEnabled,
  });
}

/// @nodoc
class __$$NetworkPortModelImplCopyWithImpl<$Res>
    extends _$NetworkPortModelCopyWithImpl<$Res, _$NetworkPortModelImpl>
    implements _$$NetworkPortModelImplCopyWith<$Res> {
  __$$NetworkPortModelImplCopyWithImpl(
    _$NetworkPortModelImpl _value,
    $Res Function(_$NetworkPortModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NetworkPortModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? internalPort = freezed,
    Object? externalPort = freezed,
    Object? protocol = freezed,
    Object? host = freezed,
    Object? tlsEnabled = freezed,
  }) {
    return _then(
      _$NetworkPortModelImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        internalPort: freezed == internalPort
            ? _value.internalPort
            : internalPort // ignore: cast_nullable_to_non_nullable
                  as int?,
        externalPort: freezed == externalPort
            ? _value.externalPort
            : externalPort // ignore: cast_nullable_to_non_nullable
                  as int?,
        protocol: freezed == protocol
            ? _value.protocol
            : protocol // ignore: cast_nullable_to_non_nullable
                  as String?,
        host: freezed == host
            ? _value.host
            : host // ignore: cast_nullable_to_non_nullable
                  as String?,
        tlsEnabled: freezed == tlsEnabled
            ? _value.tlsEnabled
            : tlsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkPortModelImpl implements _NetworkPortModel {
  const _$NetworkPortModelImpl({
    this.name,
    @JsonKey(name: 'internal_port') this.internalPort,
    @JsonKey(name: 'external_port') this.externalPort,
    this.protocol,
    this.host,
    @JsonKey(name: 'tls_enabled') this.tlsEnabled,
  });

  factory _$NetworkPortModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkPortModelImplFromJson(json);

  @override
  final String? name;
  @override
  @JsonKey(name: 'internal_port')
  final int? internalPort;
  @override
  @JsonKey(name: 'external_port')
  final int? externalPort;
  @override
  final String? protocol;
  @override
  final String? host;
  @override
  @JsonKey(name: 'tls_enabled')
  final bool? tlsEnabled;

  @override
  String toString() {
    return 'NetworkPortModel(name: $name, internalPort: $internalPort, externalPort: $externalPort, protocol: $protocol, host: $host, tlsEnabled: $tlsEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkPortModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.internalPort, internalPort) ||
                other.internalPort == internalPort) &&
            (identical(other.externalPort, externalPort) ||
                other.externalPort == externalPort) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.tlsEnabled, tlsEnabled) ||
                other.tlsEnabled == tlsEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    internalPort,
    externalPort,
    protocol,
    host,
    tlsEnabled,
  );

  /// Create a copy of NetworkPortModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkPortModelImplCopyWith<_$NetworkPortModelImpl> get copyWith =>
      __$$NetworkPortModelImplCopyWithImpl<_$NetworkPortModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkPortModelImplToJson(this);
  }
}

abstract class _NetworkPortModel implements NetworkPortModel {
  const factory _NetworkPortModel({
    final String? name,
    @JsonKey(name: 'internal_port') final int? internalPort,
    @JsonKey(name: 'external_port') final int? externalPort,
    final String? protocol,
    final String? host,
    @JsonKey(name: 'tls_enabled') final bool? tlsEnabled,
  }) = _$NetworkPortModelImpl;

  factory _NetworkPortModel.fromJson(Map<String, dynamic> json) =
      _$NetworkPortModelImpl.fromJson;

  @override
  String? get name;
  @override
  @JsonKey(name: 'internal_port')
  int? get internalPort;
  @override
  @JsonKey(name: 'external_port')
  int? get externalPort;
  @override
  String? get protocol;
  @override
  String? get host;
  @override
  @JsonKey(name: 'tls_enabled')
  bool? get tlsEnabled;

  /// Create a copy of NetworkPortModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkPortModelImplCopyWith<_$NetworkPortModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameServerCustomDataModel _$GameServerCustomDataModelFromJson(
  Map<String, dynamic> json,
) {
  return _GameServerCustomDataModel.fromJson(json);
}

/// @nodoc
mixin _$GameServerCustomDataModel {
  String? get gameMode => throw _privateConstructorUsedError;
  String? get mapName => throw _privateConstructorUsedError;
  int? get teamSize => throw _privateConstructorUsedError;
  int? get scoreLimit => throw _privateConstructorUsedError;

  /// Serializes this GameServerCustomDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameServerCustomDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameServerCustomDataModelCopyWith<GameServerCustomDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameServerCustomDataModelCopyWith<$Res> {
  factory $GameServerCustomDataModelCopyWith(
    GameServerCustomDataModel value,
    $Res Function(GameServerCustomDataModel) then,
  ) = _$GameServerCustomDataModelCopyWithImpl<$Res, GameServerCustomDataModel>;
  @useResult
  $Res call({
    String? gameMode,
    String? mapName,
    int? teamSize,
    int? scoreLimit,
  });
}

/// @nodoc
class _$GameServerCustomDataModelCopyWithImpl<
  $Res,
  $Val extends GameServerCustomDataModel
>
    implements $GameServerCustomDataModelCopyWith<$Res> {
  _$GameServerCustomDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameServerCustomDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameMode = freezed,
    Object? mapName = freezed,
    Object? teamSize = freezed,
    Object? scoreLimit = freezed,
  }) {
    return _then(
      _value.copyWith(
            gameMode: freezed == gameMode
                ? _value.gameMode
                : gameMode // ignore: cast_nullable_to_non_nullable
                      as String?,
            mapName: freezed == mapName
                ? _value.mapName
                : mapName // ignore: cast_nullable_to_non_nullable
                      as String?,
            teamSize: freezed == teamSize
                ? _value.teamSize
                : teamSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            scoreLimit: freezed == scoreLimit
                ? _value.scoreLimit
                : scoreLimit // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameServerCustomDataModelImplCopyWith<$Res>
    implements $GameServerCustomDataModelCopyWith<$Res> {
  factory _$$GameServerCustomDataModelImplCopyWith(
    _$GameServerCustomDataModelImpl value,
    $Res Function(_$GameServerCustomDataModelImpl) then,
  ) = __$$GameServerCustomDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? gameMode,
    String? mapName,
    int? teamSize,
    int? scoreLimit,
  });
}

/// @nodoc
class __$$GameServerCustomDataModelImplCopyWithImpl<$Res>
    extends
        _$GameServerCustomDataModelCopyWithImpl<
          $Res,
          _$GameServerCustomDataModelImpl
        >
    implements _$$GameServerCustomDataModelImplCopyWith<$Res> {
  __$$GameServerCustomDataModelImplCopyWithImpl(
    _$GameServerCustomDataModelImpl _value,
    $Res Function(_$GameServerCustomDataModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameServerCustomDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameMode = freezed,
    Object? mapName = freezed,
    Object? teamSize = freezed,
    Object? scoreLimit = freezed,
  }) {
    return _then(
      _$GameServerCustomDataModelImpl(
        gameMode: freezed == gameMode
            ? _value.gameMode
            : gameMode // ignore: cast_nullable_to_non_nullable
                  as String?,
        mapName: freezed == mapName
            ? _value.mapName
            : mapName // ignore: cast_nullable_to_non_nullable
                  as String?,
        teamSize: freezed == teamSize
            ? _value.teamSize
            : teamSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        scoreLimit: freezed == scoreLimit
            ? _value.scoreLimit
            : scoreLimit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameServerCustomDataModelImpl implements _GameServerCustomDataModel {
  const _$GameServerCustomDataModelImpl({
    this.gameMode,
    this.mapName,
    this.teamSize,
    this.scoreLimit,
  });

  factory _$GameServerCustomDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameServerCustomDataModelImplFromJson(json);

  @override
  final String? gameMode;
  @override
  final String? mapName;
  @override
  final int? teamSize;
  @override
  final int? scoreLimit;

  @override
  String toString() {
    return 'GameServerCustomDataModel(gameMode: $gameMode, mapName: $mapName, teamSize: $teamSize, scoreLimit: $scoreLimit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameServerCustomDataModelImpl &&
            (identical(other.gameMode, gameMode) ||
                other.gameMode == gameMode) &&
            (identical(other.mapName, mapName) || other.mapName == mapName) &&
            (identical(other.teamSize, teamSize) ||
                other.teamSize == teamSize) &&
            (identical(other.scoreLimit, scoreLimit) ||
                other.scoreLimit == scoreLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, gameMode, mapName, teamSize, scoreLimit);

  /// Create a copy of GameServerCustomDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameServerCustomDataModelImplCopyWith<_$GameServerCustomDataModelImpl>
  get copyWith =>
      __$$GameServerCustomDataModelImplCopyWithImpl<
        _$GameServerCustomDataModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameServerCustomDataModelImplToJson(this);
  }
}

abstract class _GameServerCustomDataModel implements GameServerCustomDataModel {
  const factory _GameServerCustomDataModel({
    final String? gameMode,
    final String? mapName,
    final int? teamSize,
    final int? scoreLimit,
  }) = _$GameServerCustomDataModelImpl;

  factory _GameServerCustomDataModel.fromJson(Map<String, dynamic> json) =
      _$GameServerCustomDataModelImpl.fromJson;

  @override
  String? get gameMode;
  @override
  String? get mapName;
  @override
  int? get teamSize;
  @override
  int? get scoreLimit;

  /// Create a copy of GameServerCustomDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameServerCustomDataModelImplCopyWith<_$GameServerCustomDataModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MatchmakingDataModel _$MatchmakingDataModelFromJson(Map<String, dynamic> json) {
  return _MatchmakingDataModel.fromJson(json);
}

/// @nodoc
mixin _$MatchmakingDataModel {
  int? get mmr => throw _privateConstructorUsedError;
  String? get tier => throw _privateConstructorUsedError;

  /// Serializes this MatchmakingDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchmakingDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchmakingDataModelCopyWith<MatchmakingDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchmakingDataModelCopyWith<$Res> {
  factory $MatchmakingDataModelCopyWith(
    MatchmakingDataModel value,
    $Res Function(MatchmakingDataModel) then,
  ) = _$MatchmakingDataModelCopyWithImpl<$Res, MatchmakingDataModel>;
  @useResult
  $Res call({int? mmr, String? tier});
}

/// @nodoc
class _$MatchmakingDataModelCopyWithImpl<
  $Res,
  $Val extends MatchmakingDataModel
>
    implements $MatchmakingDataModelCopyWith<$Res> {
  _$MatchmakingDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchmakingDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mmr = freezed, Object? tier = freezed}) {
    return _then(
      _value.copyWith(
            mmr: freezed == mmr
                ? _value.mmr
                : mmr // ignore: cast_nullable_to_non_nullable
                      as int?,
            tier: freezed == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchmakingDataModelImplCopyWith<$Res>
    implements $MatchmakingDataModelCopyWith<$Res> {
  factory _$$MatchmakingDataModelImplCopyWith(
    _$MatchmakingDataModelImpl value,
    $Res Function(_$MatchmakingDataModelImpl) then,
  ) = __$$MatchmakingDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? mmr, String? tier});
}

/// @nodoc
class __$$MatchmakingDataModelImplCopyWithImpl<$Res>
    extends _$MatchmakingDataModelCopyWithImpl<$Res, _$MatchmakingDataModelImpl>
    implements _$$MatchmakingDataModelImplCopyWith<$Res> {
  __$$MatchmakingDataModelImplCopyWithImpl(
    _$MatchmakingDataModelImpl _value,
    $Res Function(_$MatchmakingDataModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchmakingDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mmr = freezed, Object? tier = freezed}) {
    return _then(
      _$MatchmakingDataModelImpl(
        mmr: freezed == mmr
            ? _value.mmr
            : mmr // ignore: cast_nullable_to_non_nullable
                  as int?,
        tier: freezed == tier
            ? _value.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchmakingDataModelImpl implements _MatchmakingDataModel {
  const _$MatchmakingDataModelImpl({this.mmr, this.tier});

  factory _$MatchmakingDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchmakingDataModelImplFromJson(json);

  @override
  final int? mmr;
  @override
  final String? tier;

  @override
  String toString() {
    return 'MatchmakingDataModel(mmr: $mmr, tier: $tier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchmakingDataModelImpl &&
            (identical(other.mmr, mmr) || other.mmr == mmr) &&
            (identical(other.tier, tier) || other.tier == tier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mmr, tier);

  /// Create a copy of MatchmakingDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchmakingDataModelImplCopyWith<_$MatchmakingDataModelImpl>
  get copyWith =>
      __$$MatchmakingDataModelImplCopyWithImpl<_$MatchmakingDataModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchmakingDataModelImplToJson(this);
  }
}

abstract class _MatchmakingDataModel implements MatchmakingDataModel {
  const factory _MatchmakingDataModel({final int? mmr, final String? tier}) =
      _$MatchmakingDataModelImpl;

  factory _MatchmakingDataModel.fromJson(Map<String, dynamic> json) =
      _$MatchmakingDataModelImpl.fromJson;

  @override
  int? get mmr;
  @override
  String? get tier;

  /// Create a copy of MatchmakingDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchmakingDataModelImplCopyWith<_$MatchmakingDataModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
