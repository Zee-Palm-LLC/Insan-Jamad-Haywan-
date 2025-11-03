// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_resource_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LobbyResourceModel _$LobbyResourceModelFromJson(Map<String, dynamic> json) {
  return _LobbyResourceModel.fromJson(json);
}

/// @nodoc
mixin _$LobbyResourceModel {
  @JsonKey(includeIfNull: false)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  PlayerStateModel? get playerState => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  LobbySettings? get settings => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get host => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get targetPlayerId => throw _privateConstructorUsedError;
  String get requesterId => throw _privateConstructorUsedError;

  /// Serializes this LobbyResourceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LobbyResourceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LobbyResourceModelCopyWith<LobbyResourceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LobbyResourceModelCopyWith<$Res> {
  factory $LobbyResourceModelCopyWith(
    LobbyResourceModel value,
    $Res Function(LobbyResourceModel) then,
  ) = _$LobbyResourceModelCopyWithImpl<$Res, LobbyResourceModel>;
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? status,
    @JsonKey(includeIfNull: false) PlayerStateModel? playerState,
    @JsonKey(includeIfNull: false) LobbySettings? settings,
    @JsonKey(includeIfNull: false) String? host,
    @JsonKey(includeIfNull: false) String? targetPlayerId,
    String requesterId,
  });

  $PlayerStateModelCopyWith<$Res>? get playerState;
  $LobbySettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class _$LobbyResourceModelCopyWithImpl<$Res, $Val extends LobbyResourceModel>
    implements $LobbyResourceModelCopyWith<$Res> {
  _$LobbyResourceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LobbyResourceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? playerState = freezed,
    Object? settings = freezed,
    Object? host = freezed,
    Object? targetPlayerId = freezed,
    Object? requesterId = null,
  }) {
    return _then(
      _value.copyWith(
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            playerState: freezed == playerState
                ? _value.playerState
                : playerState // ignore: cast_nullable_to_non_nullable
                      as PlayerStateModel?,
            settings: freezed == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as LobbySettings?,
            host: freezed == host
                ? _value.host
                : host // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetPlayerId: freezed == targetPlayerId
                ? _value.targetPlayerId
                : targetPlayerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            requesterId: null == requesterId
                ? _value.requesterId
                : requesterId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of LobbyResourceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerStateModelCopyWith<$Res>? get playerState {
    if (_value.playerState == null) {
      return null;
    }

    return $PlayerStateModelCopyWith<$Res>(_value.playerState!, (value) {
      return _then(_value.copyWith(playerState: value) as $Val);
    });
  }

  /// Create a copy of LobbyResourceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LobbySettingsCopyWith<$Res>? get settings {
    if (_value.settings == null) {
      return null;
    }

    return $LobbySettingsCopyWith<$Res>(_value.settings!, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LobbyResourceModelImplCopyWith<$Res>
    implements $LobbyResourceModelCopyWith<$Res> {
  factory _$$LobbyResourceModelImplCopyWith(
    _$LobbyResourceModelImpl value,
    $Res Function(_$LobbyResourceModelImpl) then,
  ) = __$$LobbyResourceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? status,
    @JsonKey(includeIfNull: false) PlayerStateModel? playerState,
    @JsonKey(includeIfNull: false) LobbySettings? settings,
    @JsonKey(includeIfNull: false) String? host,
    @JsonKey(includeIfNull: false) String? targetPlayerId,
    String requesterId,
  });

  @override
  $PlayerStateModelCopyWith<$Res>? get playerState;
  @override
  $LobbySettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class __$$LobbyResourceModelImplCopyWithImpl<$Res>
    extends _$LobbyResourceModelCopyWithImpl<$Res, _$LobbyResourceModelImpl>
    implements _$$LobbyResourceModelImplCopyWith<$Res> {
  __$$LobbyResourceModelImplCopyWithImpl(
    _$LobbyResourceModelImpl _value,
    $Res Function(_$LobbyResourceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LobbyResourceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? playerState = freezed,
    Object? settings = freezed,
    Object? host = freezed,
    Object? targetPlayerId = freezed,
    Object? requesterId = null,
  }) {
    return _then(
      _$LobbyResourceModelImpl(
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        playerState: freezed == playerState
            ? _value.playerState
            : playerState // ignore: cast_nullable_to_non_nullable
                  as PlayerStateModel?,
        settings: freezed == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as LobbySettings?,
        host: freezed == host
            ? _value.host
            : host // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetPlayerId: freezed == targetPlayerId
            ? _value.targetPlayerId
            : targetPlayerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        requesterId: null == requesterId
            ? _value.requesterId
            : requesterId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LobbyResourceModelImpl implements _LobbyResourceModel {
  const _$LobbyResourceModelImpl({
    @JsonKey(includeIfNull: false) this.status,
    @JsonKey(includeIfNull: false) this.playerState,
    @JsonKey(includeIfNull: false) this.settings,
    @JsonKey(includeIfNull: false) this.host,
    @JsonKey(includeIfNull: false) this.targetPlayerId,
    required this.requesterId,
  });

  factory _$LobbyResourceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LobbyResourceModelImplFromJson(json);

  @override
  @JsonKey(includeIfNull: false)
  final String? status;
  @override
  @JsonKey(includeIfNull: false)
  final PlayerStateModel? playerState;
  @override
  @JsonKey(includeIfNull: false)
  final LobbySettings? settings;
  @override
  @JsonKey(includeIfNull: false)
  final String? host;
  @override
  @JsonKey(includeIfNull: false)
  final String? targetPlayerId;
  @override
  final String requesterId;

  @override
  String toString() {
    return 'LobbyResourceModel(status: $status, playerState: $playerState, settings: $settings, host: $host, targetPlayerId: $targetPlayerId, requesterId: $requesterId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LobbyResourceModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.playerState, playerState) ||
                other.playerState == playerState) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.targetPlayerId, targetPlayerId) ||
                other.targetPlayerId == targetPlayerId) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    playerState,
    settings,
    host,
    targetPlayerId,
    requesterId,
  );

  /// Create a copy of LobbyResourceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LobbyResourceModelImplCopyWith<_$LobbyResourceModelImpl> get copyWith =>
      __$$LobbyResourceModelImplCopyWithImpl<_$LobbyResourceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LobbyResourceModelImplToJson(this);
  }
}

abstract class _LobbyResourceModel implements LobbyResourceModel {
  const factory _LobbyResourceModel({
    @JsonKey(includeIfNull: false) final String? status,
    @JsonKey(includeIfNull: false) final PlayerStateModel? playerState,
    @JsonKey(includeIfNull: false) final LobbySettings? settings,
    @JsonKey(includeIfNull: false) final String? host,
    @JsonKey(includeIfNull: false) final String? targetPlayerId,
    required final String requesterId,
  }) = _$LobbyResourceModelImpl;

  factory _LobbyResourceModel.fromJson(Map<String, dynamic> json) =
      _$LobbyResourceModelImpl.fromJson;

  @override
  @JsonKey(includeIfNull: false)
  String? get status;
  @override
  @JsonKey(includeIfNull: false)
  PlayerStateModel? get playerState;
  @override
  @JsonKey(includeIfNull: false)
  LobbySettings? get settings;
  @override
  @JsonKey(includeIfNull: false)
  String? get host;
  @override
  @JsonKey(includeIfNull: false)
  String? get targetPlayerId;
  @override
  String get requesterId;

  /// Create a copy of LobbyResourceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LobbyResourceModelImplCopyWith<_$LobbyResourceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
