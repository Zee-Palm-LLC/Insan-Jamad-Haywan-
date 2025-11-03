// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LobbySettings _$LobbySettingsFromJson(Map<String, dynamic> json) {
  return _LobbySettings.fromJson(json);
}

/// @nodoc
mixin _$LobbySettings {
  GameSettings? get settings => throw _privateConstructorUsedError;

  /// Serializes this LobbySettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LobbySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LobbySettingsCopyWith<LobbySettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LobbySettingsCopyWith<$Res> {
  factory $LobbySettingsCopyWith(
    LobbySettings value,
    $Res Function(LobbySettings) then,
  ) = _$LobbySettingsCopyWithImpl<$Res, LobbySettings>;
  @useResult
  $Res call({GameSettings? settings});

  $GameSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class _$LobbySettingsCopyWithImpl<$Res, $Val extends LobbySettings>
    implements $LobbySettingsCopyWith<$Res> {
  _$LobbySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LobbySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? settings = freezed}) {
    return _then(
      _value.copyWith(
            settings: freezed == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as GameSettings?,
          )
          as $Val,
    );
  }

  /// Create a copy of LobbySettings
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
}

/// @nodoc
abstract class _$$LobbySettingsImplCopyWith<$Res>
    implements $LobbySettingsCopyWith<$Res> {
  factory _$$LobbySettingsImplCopyWith(
    _$LobbySettingsImpl value,
    $Res Function(_$LobbySettingsImpl) then,
  ) = __$$LobbySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GameSettings? settings});

  @override
  $GameSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class __$$LobbySettingsImplCopyWithImpl<$Res>
    extends _$LobbySettingsCopyWithImpl<$Res, _$LobbySettingsImpl>
    implements _$$LobbySettingsImplCopyWith<$Res> {
  __$$LobbySettingsImplCopyWithImpl(
    _$LobbySettingsImpl _value,
    $Res Function(_$LobbySettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LobbySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? settings = freezed}) {
    return _then(
      _$LobbySettingsImpl(
        settings: freezed == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as GameSettings?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LobbySettingsImpl implements _LobbySettings {
  const _$LobbySettingsImpl({this.settings});

  factory _$LobbySettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LobbySettingsImplFromJson(json);

  @override
  final GameSettings? settings;

  @override
  String toString() {
    return 'LobbySettings(settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LobbySettingsImpl &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, settings);

  /// Create a copy of LobbySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LobbySettingsImplCopyWith<_$LobbySettingsImpl> get copyWith =>
      __$$LobbySettingsImplCopyWithImpl<_$LobbySettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LobbySettingsImplToJson(this);
  }
}

abstract class _LobbySettings implements LobbySettings {
  const factory _LobbySettings({final GameSettings? settings}) =
      _$LobbySettingsImpl;

  factory _LobbySettings.fromJson(Map<String, dynamic> json) =
      _$LobbySettingsImpl.fromJson;

  @override
  GameSettings? get settings;

  /// Create a copy of LobbySettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LobbySettingsImplCopyWith<_$LobbySettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameSettings _$GameSettingsFromJson(Map<String, dynamic> json) {
  return _GameSettings.fromJson(json);
}

/// @nodoc
mixin _$GameSettings {
  GameStatus get status => throw _privateConstructorUsedError;
  int get maxRounds => throw _privateConstructorUsedError;
  int get currentRound => throw _privateConstructorUsedError;
  ScoreConfig get scoreConfig => throw _privateConstructorUsedError;
  List<String>? get roundStatus => throw _privateConstructorUsedError;

  /// Serializes this GameSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameSettingsCopyWith<GameSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSettingsCopyWith<$Res> {
  factory $GameSettingsCopyWith(
    GameSettings value,
    $Res Function(GameSettings) then,
  ) = _$GameSettingsCopyWithImpl<$Res, GameSettings>;
  @useResult
  $Res call({
    GameStatus status,
    int maxRounds,
    int currentRound,
    ScoreConfig scoreConfig,
    List<String>? roundStatus,
  });

  $ScoreConfigCopyWith<$Res> get scoreConfig;
}

/// @nodoc
class _$GameSettingsCopyWithImpl<$Res, $Val extends GameSettings>
    implements $GameSettingsCopyWith<$Res> {
  _$GameSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? maxRounds = null,
    Object? currentRound = null,
    Object? scoreConfig = null,
    Object? roundStatus = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as GameStatus,
            maxRounds: null == maxRounds
                ? _value.maxRounds
                : maxRounds // ignore: cast_nullable_to_non_nullable
                      as int,
            currentRound: null == currentRound
                ? _value.currentRound
                : currentRound // ignore: cast_nullable_to_non_nullable
                      as int,
            scoreConfig: null == scoreConfig
                ? _value.scoreConfig
                : scoreConfig // ignore: cast_nullable_to_non_nullable
                      as ScoreConfig,
            roundStatus: freezed == roundStatus
                ? _value.roundStatus
                : roundStatus // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScoreConfigCopyWith<$Res> get scoreConfig {
    return $ScoreConfigCopyWith<$Res>(_value.scoreConfig, (value) {
      return _then(_value.copyWith(scoreConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameSettingsImplCopyWith<$Res>
    implements $GameSettingsCopyWith<$Res> {
  factory _$$GameSettingsImplCopyWith(
    _$GameSettingsImpl value,
    $Res Function(_$GameSettingsImpl) then,
  ) = __$$GameSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    GameStatus status,
    int maxRounds,
    int currentRound,
    ScoreConfig scoreConfig,
    List<String>? roundStatus,
  });

  @override
  $ScoreConfigCopyWith<$Res> get scoreConfig;
}

/// @nodoc
class __$$GameSettingsImplCopyWithImpl<$Res>
    extends _$GameSettingsCopyWithImpl<$Res, _$GameSettingsImpl>
    implements _$$GameSettingsImplCopyWith<$Res> {
  __$$GameSettingsImplCopyWithImpl(
    _$GameSettingsImpl _value,
    $Res Function(_$GameSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? maxRounds = null,
    Object? currentRound = null,
    Object? scoreConfig = null,
    Object? roundStatus = freezed,
  }) {
    return _then(
      _$GameSettingsImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as GameStatus,
        maxRounds: null == maxRounds
            ? _value.maxRounds
            : maxRounds // ignore: cast_nullable_to_non_nullable
                  as int,
        currentRound: null == currentRound
            ? _value.currentRound
            : currentRound // ignore: cast_nullable_to_non_nullable
                  as int,
        scoreConfig: null == scoreConfig
            ? _value.scoreConfig
            : scoreConfig // ignore: cast_nullable_to_non_nullable
                  as ScoreConfig,
        roundStatus: freezed == roundStatus
            ? _value._roundStatus
            : roundStatus // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameSettingsImpl implements _GameSettings {
  const _$GameSettingsImpl({
    this.status = GameStatus.waiting,
    this.maxRounds = 2,
    this.currentRound = 0,
    this.scoreConfig = const ScoreConfig(correctGuess: 100, fooledOther: 50),
    final List<String>? roundStatus,
  }) : _roundStatus = roundStatus;

  factory _$GameSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameSettingsImplFromJson(json);

  @override
  @JsonKey()
  final GameStatus status;
  @override
  @JsonKey()
  final int maxRounds;
  @override
  @JsonKey()
  final int currentRound;
  @override
  @JsonKey()
  final ScoreConfig scoreConfig;
  final List<String>? _roundStatus;
  @override
  List<String>? get roundStatus {
    final value = _roundStatus;
    if (value == null) return null;
    if (_roundStatus is EqualUnmodifiableListView) return _roundStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GameSettings(status: $status, maxRounds: $maxRounds, currentRound: $currentRound, scoreConfig: $scoreConfig, roundStatus: $roundStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSettingsImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.maxRounds, maxRounds) ||
                other.maxRounds == maxRounds) &&
            (identical(other.currentRound, currentRound) ||
                other.currentRound == currentRound) &&
            (identical(other.scoreConfig, scoreConfig) ||
                other.scoreConfig == scoreConfig) &&
            const DeepCollectionEquality().equals(
              other._roundStatus,
              _roundStatus,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    maxRounds,
    currentRound,
    scoreConfig,
    const DeepCollectionEquality().hash(_roundStatus),
  );

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameSettingsImplCopyWith<_$GameSettingsImpl> get copyWith =>
      __$$GameSettingsImplCopyWithImpl<_$GameSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameSettingsImplToJson(this);
  }
}

abstract class _GameSettings implements GameSettings {
  const factory _GameSettings({
    final GameStatus status,
    final int maxRounds,
    final int currentRound,
    final ScoreConfig scoreConfig,
    final List<String>? roundStatus,
  }) = _$GameSettingsImpl;

  factory _GameSettings.fromJson(Map<String, dynamic> json) =
      _$GameSettingsImpl.fromJson;

  @override
  GameStatus get status;
  @override
  int get maxRounds;
  @override
  int get currentRound;
  @override
  ScoreConfig get scoreConfig;
  @override
  List<String>? get roundStatus;

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameSettingsImplCopyWith<_$GameSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScoreConfig _$ScoreConfigFromJson(Map<String, dynamic> json) {
  return _ScoreConfig.fromJson(json);
}

/// @nodoc
mixin _$ScoreConfig {
  int? get correctGuess => throw _privateConstructorUsedError;
  int? get fooledOther => throw _privateConstructorUsedError;

  /// Serializes this ScoreConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScoreConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoreConfigCopyWith<ScoreConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreConfigCopyWith<$Res> {
  factory $ScoreConfigCopyWith(
    ScoreConfig value,
    $Res Function(ScoreConfig) then,
  ) = _$ScoreConfigCopyWithImpl<$Res, ScoreConfig>;
  @useResult
  $Res call({int? correctGuess, int? fooledOther});
}

/// @nodoc
class _$ScoreConfigCopyWithImpl<$Res, $Val extends ScoreConfig>
    implements $ScoreConfigCopyWith<$Res> {
  _$ScoreConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScoreConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? correctGuess = freezed, Object? fooledOther = freezed}) {
    return _then(
      _value.copyWith(
            correctGuess: freezed == correctGuess
                ? _value.correctGuess
                : correctGuess // ignore: cast_nullable_to_non_nullable
                      as int?,
            fooledOther: freezed == fooledOther
                ? _value.fooledOther
                : fooledOther // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScoreConfigImplCopyWith<$Res>
    implements $ScoreConfigCopyWith<$Res> {
  factory _$$ScoreConfigImplCopyWith(
    _$ScoreConfigImpl value,
    $Res Function(_$ScoreConfigImpl) then,
  ) = __$$ScoreConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? correctGuess, int? fooledOther});
}

/// @nodoc
class __$$ScoreConfigImplCopyWithImpl<$Res>
    extends _$ScoreConfigCopyWithImpl<$Res, _$ScoreConfigImpl>
    implements _$$ScoreConfigImplCopyWith<$Res> {
  __$$ScoreConfigImplCopyWithImpl(
    _$ScoreConfigImpl _value,
    $Res Function(_$ScoreConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScoreConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? correctGuess = freezed, Object? fooledOther = freezed}) {
    return _then(
      _$ScoreConfigImpl(
        correctGuess: freezed == correctGuess
            ? _value.correctGuess
            : correctGuess // ignore: cast_nullable_to_non_nullable
                  as int?,
        fooledOther: freezed == fooledOther
            ? _value.fooledOther
            : fooledOther // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScoreConfigImpl implements _ScoreConfig {
  const _$ScoreConfigImpl({this.correctGuess, this.fooledOther});

  factory _$ScoreConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoreConfigImplFromJson(json);

  @override
  final int? correctGuess;
  @override
  final int? fooledOther;

  @override
  String toString() {
    return 'ScoreConfig(correctGuess: $correctGuess, fooledOther: $fooledOther)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreConfigImpl &&
            (identical(other.correctGuess, correctGuess) ||
                other.correctGuess == correctGuess) &&
            (identical(other.fooledOther, fooledOther) ||
                other.fooledOther == fooledOther));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, correctGuess, fooledOther);

  /// Create a copy of ScoreConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreConfigImplCopyWith<_$ScoreConfigImpl> get copyWith =>
      __$$ScoreConfigImplCopyWithImpl<_$ScoreConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoreConfigImplToJson(this);
  }
}

abstract class _ScoreConfig implements ScoreConfig {
  const factory _ScoreConfig({
    final int? correctGuess,
    final int? fooledOther,
  }) = _$ScoreConfigImpl;

  factory _ScoreConfig.fromJson(Map<String, dynamic> json) =
      _$ScoreConfigImpl.fromJson;

  @override
  int? get correctGuess;
  @override
  int? get fooledOther;

  /// Create a copy of ScoreConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoreConfigImplCopyWith<_$ScoreConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
