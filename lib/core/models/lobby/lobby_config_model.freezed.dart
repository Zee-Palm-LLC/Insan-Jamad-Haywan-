// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LobbyConfigModel _$LobbyConfigModelFromJson(Map<String, dynamic> json) {
  return _LobbyConfigModel.fromJson(json);
}

/// @nodoc
mixin _$LobbyConfigModel {
  @JsonKey(includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  int? get maxPlayers => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get isPrivate => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get useInviteCode => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get allowLateJoin => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get region => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  Map<String, dynamic>? get settings => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get host => throw _privateConstructorUsedError;

  /// Serializes this LobbyConfigModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LobbyConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LobbyConfigModelCopyWith<LobbyConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LobbyConfigModelCopyWith<$Res> {
  factory $LobbyConfigModelCopyWith(
    LobbyConfigModel value,
    $Res Function(LobbyConfigModel) then,
  ) = _$LobbyConfigModelCopyWithImpl<$Res, LobbyConfigModel>;
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? name,
    @JsonKey(includeIfNull: false) int? maxPlayers,
    @JsonKey(includeIfNull: false) bool? isPrivate,
    @JsonKey(includeIfNull: false) bool? useInviteCode,
    @JsonKey(includeIfNull: false) bool? allowLateJoin,
    @JsonKey(includeIfNull: false) String? region,
    @JsonKey(includeIfNull: false) Map<String, dynamic>? settings,
    @JsonKey(includeIfNull: false) String? host,
  });
}

/// @nodoc
class _$LobbyConfigModelCopyWithImpl<$Res, $Val extends LobbyConfigModel>
    implements $LobbyConfigModelCopyWith<$Res> {
  _$LobbyConfigModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LobbyConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? maxPlayers = freezed,
    Object? isPrivate = freezed,
    Object? useInviteCode = freezed,
    Object? allowLateJoin = freezed,
    Object? region = freezed,
    Object? settings = freezed,
    Object? host = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            maxPlayers: freezed == maxPlayers
                ? _value.maxPlayers
                : maxPlayers // ignore: cast_nullable_to_non_nullable
                      as int?,
            isPrivate: freezed == isPrivate
                ? _value.isPrivate
                : isPrivate // ignore: cast_nullable_to_non_nullable
                      as bool?,
            useInviteCode: freezed == useInviteCode
                ? _value.useInviteCode
                : useInviteCode // ignore: cast_nullable_to_non_nullable
                      as bool?,
            allowLateJoin: freezed == allowLateJoin
                ? _value.allowLateJoin
                : allowLateJoin // ignore: cast_nullable_to_non_nullable
                      as bool?,
            region: freezed == region
                ? _value.region
                : region // ignore: cast_nullable_to_non_nullable
                      as String?,
            settings: freezed == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            host: freezed == host
                ? _value.host
                : host // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LobbyConfigModelImplCopyWith<$Res>
    implements $LobbyConfigModelCopyWith<$Res> {
  factory _$$LobbyConfigModelImplCopyWith(
    _$LobbyConfigModelImpl value,
    $Res Function(_$LobbyConfigModelImpl) then,
  ) = __$$LobbyConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? name,
    @JsonKey(includeIfNull: false) int? maxPlayers,
    @JsonKey(includeIfNull: false) bool? isPrivate,
    @JsonKey(includeIfNull: false) bool? useInviteCode,
    @JsonKey(includeIfNull: false) bool? allowLateJoin,
    @JsonKey(includeIfNull: false) String? region,
    @JsonKey(includeIfNull: false) Map<String, dynamic>? settings,
    @JsonKey(includeIfNull: false) String? host,
  });
}

/// @nodoc
class __$$LobbyConfigModelImplCopyWithImpl<$Res>
    extends _$LobbyConfigModelCopyWithImpl<$Res, _$LobbyConfigModelImpl>
    implements _$$LobbyConfigModelImplCopyWith<$Res> {
  __$$LobbyConfigModelImplCopyWithImpl(
    _$LobbyConfigModelImpl _value,
    $Res Function(_$LobbyConfigModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LobbyConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? maxPlayers = freezed,
    Object? isPrivate = freezed,
    Object? useInviteCode = freezed,
    Object? allowLateJoin = freezed,
    Object? region = freezed,
    Object? settings = freezed,
    Object? host = freezed,
  }) {
    return _then(
      _$LobbyConfigModelImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        maxPlayers: freezed == maxPlayers
            ? _value.maxPlayers
            : maxPlayers // ignore: cast_nullable_to_non_nullable
                  as int?,
        isPrivate: freezed == isPrivate
            ? _value.isPrivate
            : isPrivate // ignore: cast_nullable_to_non_nullable
                  as bool?,
        useInviteCode: freezed == useInviteCode
            ? _value.useInviteCode
            : useInviteCode // ignore: cast_nullable_to_non_nullable
                  as bool?,
        allowLateJoin: freezed == allowLateJoin
            ? _value.allowLateJoin
            : allowLateJoin // ignore: cast_nullable_to_non_nullable
                  as bool?,
        region: freezed == region
            ? _value.region
            : region // ignore: cast_nullable_to_non_nullable
                  as String?,
        settings: freezed == settings
            ? _value._settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        host: freezed == host
            ? _value.host
            : host // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LobbyConfigModelImpl implements _LobbyConfigModel {
  const _$LobbyConfigModelImpl({
    @JsonKey(includeIfNull: false) this.name,
    @JsonKey(includeIfNull: false) this.maxPlayers,
    @JsonKey(includeIfNull: false) this.isPrivate,
    @JsonKey(includeIfNull: false) this.useInviteCode,
    @JsonKey(includeIfNull: false) this.allowLateJoin,
    @JsonKey(includeIfNull: false) this.region,
    @JsonKey(includeIfNull: false) final Map<String, dynamic>? settings,
    @JsonKey(includeIfNull: false) this.host,
  }) : _settings = settings;

  factory _$LobbyConfigModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LobbyConfigModelImplFromJson(json);

  @override
  @JsonKey(includeIfNull: false)
  final String? name;
  @override
  @JsonKey(includeIfNull: false)
  final int? maxPlayers;
  @override
  @JsonKey(includeIfNull: false)
  final bool? isPrivate;
  @override
  @JsonKey(includeIfNull: false)
  final bool? useInviteCode;
  @override
  @JsonKey(includeIfNull: false)
  final bool? allowLateJoin;
  @override
  @JsonKey(includeIfNull: false)
  final String? region;
  final Map<String, dynamic>? _settings;
  @override
  @JsonKey(includeIfNull: false)
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(includeIfNull: false)
  final String? host;

  @override
  String toString() {
    return 'LobbyConfigModel(name: $name, maxPlayers: $maxPlayers, isPrivate: $isPrivate, useInviteCode: $useInviteCode, allowLateJoin: $allowLateJoin, region: $region, settings: $settings, host: $host)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LobbyConfigModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.maxPlayers, maxPlayers) ||
                other.maxPlayers == maxPlayers) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.useInviteCode, useInviteCode) ||
                other.useInviteCode == useInviteCode) &&
            (identical(other.allowLateJoin, allowLateJoin) ||
                other.allowLateJoin == allowLateJoin) &&
            (identical(other.region, region) || other.region == region) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.host, host) || other.host == host));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    maxPlayers,
    isPrivate,
    useInviteCode,
    allowLateJoin,
    region,
    const DeepCollectionEquality().hash(_settings),
    host,
  );

  /// Create a copy of LobbyConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LobbyConfigModelImplCopyWith<_$LobbyConfigModelImpl> get copyWith =>
      __$$LobbyConfigModelImplCopyWithImpl<_$LobbyConfigModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LobbyConfigModelImplToJson(this);
  }
}

abstract class _LobbyConfigModel implements LobbyConfigModel {
  const factory _LobbyConfigModel({
    @JsonKey(includeIfNull: false) final String? name,
    @JsonKey(includeIfNull: false) final int? maxPlayers,
    @JsonKey(includeIfNull: false) final bool? isPrivate,
    @JsonKey(includeIfNull: false) final bool? useInviteCode,
    @JsonKey(includeIfNull: false) final bool? allowLateJoin,
    @JsonKey(includeIfNull: false) final String? region,
    @JsonKey(includeIfNull: false) final Map<String, dynamic>? settings,
    @JsonKey(includeIfNull: false) final String? host,
  }) = _$LobbyConfigModelImpl;

  factory _LobbyConfigModel.fromJson(Map<String, dynamic> json) =
      _$LobbyConfigModelImpl.fromJson;

  @override
  @JsonKey(includeIfNull: false)
  String? get name;
  @override
  @JsonKey(includeIfNull: false)
  int? get maxPlayers;
  @override
  @JsonKey(includeIfNull: false)
  bool? get isPrivate;
  @override
  @JsonKey(includeIfNull: false)
  bool? get useInviteCode;
  @override
  @JsonKey(includeIfNull: false)
  bool? get allowLateJoin;
  @override
  @JsonKey(includeIfNull: false)
  String? get region;
  @override
  @JsonKey(includeIfNull: false)
  Map<String, dynamic>? get settings;
  @override
  @JsonKey(includeIfNull: false)
  String? get host;

  /// Create a copy of LobbyConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LobbyConfigModelImplCopyWith<_$LobbyConfigModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
