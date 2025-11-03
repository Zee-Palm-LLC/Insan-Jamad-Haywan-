// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerStateModel _$PlayerStateModelFromJson(Map<String, dynamic> json) {
  return _PlayerStateModel.fromJson(json);
}

/// @nodoc
mixin _$PlayerStateModel {
  String? get lastHeartbeat => throw _privateConstructorUsedError;
  List<RoundStatistics>? get roundsStatistics =>
      throw _privateConstructorUsedError;

  /// Serializes this PlayerStateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerStateModelCopyWith<PlayerStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStateModelCopyWith<$Res> {
  factory $PlayerStateModelCopyWith(
    PlayerStateModel value,
    $Res Function(PlayerStateModel) then,
  ) = _$PlayerStateModelCopyWithImpl<$Res, PlayerStateModel>;
  @useResult
  $Res call({String? lastHeartbeat, List<RoundStatistics>? roundsStatistics});
}

/// @nodoc
class _$PlayerStateModelCopyWithImpl<$Res, $Val extends PlayerStateModel>
    implements $PlayerStateModelCopyWith<$Res> {
  _$PlayerStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastHeartbeat = freezed,
    Object? roundsStatistics = freezed,
  }) {
    return _then(
      _value.copyWith(
            lastHeartbeat: freezed == lastHeartbeat
                ? _value.lastHeartbeat
                : lastHeartbeat // ignore: cast_nullable_to_non_nullable
                      as String?,
            roundsStatistics: freezed == roundsStatistics
                ? _value.roundsStatistics
                : roundsStatistics // ignore: cast_nullable_to_non_nullable
                      as List<RoundStatistics>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerStateModelImplCopyWith<$Res>
    implements $PlayerStateModelCopyWith<$Res> {
  factory _$$PlayerStateModelImplCopyWith(
    _$PlayerStateModelImpl value,
    $Res Function(_$PlayerStateModelImpl) then,
  ) = __$$PlayerStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? lastHeartbeat, List<RoundStatistics>? roundsStatistics});
}

/// @nodoc
class __$$PlayerStateModelImplCopyWithImpl<$Res>
    extends _$PlayerStateModelCopyWithImpl<$Res, _$PlayerStateModelImpl>
    implements _$$PlayerStateModelImplCopyWith<$Res> {
  __$$PlayerStateModelImplCopyWithImpl(
    _$PlayerStateModelImpl _value,
    $Res Function(_$PlayerStateModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastHeartbeat = freezed,
    Object? roundsStatistics = freezed,
  }) {
    return _then(
      _$PlayerStateModelImpl(
        lastHeartbeat: freezed == lastHeartbeat
            ? _value.lastHeartbeat
            : lastHeartbeat // ignore: cast_nullable_to_non_nullable
                  as String?,
        roundsStatistics: freezed == roundsStatistics
            ? _value._roundsStatistics
            : roundsStatistics // ignore: cast_nullable_to_non_nullable
                  as List<RoundStatistics>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerStateModelImpl implements _PlayerStateModel {
  const _$PlayerStateModelImpl({
    this.lastHeartbeat,
    final List<RoundStatistics>? roundsStatistics,
  }) : _roundsStatistics = roundsStatistics;

  factory _$PlayerStateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerStateModelImplFromJson(json);

  @override
  final String? lastHeartbeat;
  final List<RoundStatistics>? _roundsStatistics;
  @override
  List<RoundStatistics>? get roundsStatistics {
    final value = _roundsStatistics;
    if (value == null) return null;
    if (_roundsStatistics is EqualUnmodifiableListView)
      return _roundsStatistics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PlayerStateModel(lastHeartbeat: $lastHeartbeat, roundsStatistics: $roundsStatistics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStateModelImpl &&
            (identical(other.lastHeartbeat, lastHeartbeat) ||
                other.lastHeartbeat == lastHeartbeat) &&
            const DeepCollectionEquality().equals(
              other._roundsStatistics,
              _roundsStatistics,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    lastHeartbeat,
    const DeepCollectionEquality().hash(_roundsStatistics),
  );

  /// Create a copy of PlayerStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerStateModelImplCopyWith<_$PlayerStateModelImpl> get copyWith =>
      __$$PlayerStateModelImplCopyWithImpl<_$PlayerStateModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerStateModelImplToJson(this);
  }
}

abstract class _PlayerStateModel implements PlayerStateModel {
  const factory _PlayerStateModel({
    final String? lastHeartbeat,
    final List<RoundStatistics>? roundsStatistics,
  }) = _$PlayerStateModelImpl;

  factory _PlayerStateModel.fromJson(Map<String, dynamic> json) =
      _$PlayerStateModelImpl.fromJson;

  @override
  String? get lastHeartbeat;
  @override
  List<RoundStatistics>? get roundsStatistics;

  /// Create a copy of PlayerStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerStateModelImplCopyWith<_$PlayerStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
