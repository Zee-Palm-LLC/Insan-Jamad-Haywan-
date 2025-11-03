// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'round_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoundStatistics _$RoundStatisticsFromJson(Map<String, dynamic> json) {
  return _RoundStatistics.fromJson(json);
}

/// @nodoc
mixin _$RoundStatistics {
  String? get fakeAnswer => throw _privateConstructorUsedError;
  String? get correctAnswer => throw _privateConstructorUsedError;
  bool? get useDecoy => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;

  /// Serializes this RoundStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoundStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoundStatisticsCopyWith<RoundStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoundStatisticsCopyWith<$Res> {
  factory $RoundStatisticsCopyWith(
    RoundStatistics value,
    $Res Function(RoundStatistics) then,
  ) = _$RoundStatisticsCopyWithImpl<$Res, RoundStatistics>;
  @useResult
  $Res call({
    String? fakeAnswer,
    String? correctAnswer,
    bool? useDecoy,
    int? score,
  });
}

/// @nodoc
class _$RoundStatisticsCopyWithImpl<$Res, $Val extends RoundStatistics>
    implements $RoundStatisticsCopyWith<$Res> {
  _$RoundStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoundStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fakeAnswer = freezed,
    Object? correctAnswer = freezed,
    Object? useDecoy = freezed,
    Object? score = freezed,
  }) {
    return _then(
      _value.copyWith(
            fakeAnswer: freezed == fakeAnswer
                ? _value.fakeAnswer
                : fakeAnswer // ignore: cast_nullable_to_non_nullable
                      as String?,
            correctAnswer: freezed == correctAnswer
                ? _value.correctAnswer
                : correctAnswer // ignore: cast_nullable_to_non_nullable
                      as String?,
            useDecoy: freezed == useDecoy
                ? _value.useDecoy
                : useDecoy // ignore: cast_nullable_to_non_nullable
                      as bool?,
            score: freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoundStatisticsImplCopyWith<$Res>
    implements $RoundStatisticsCopyWith<$Res> {
  factory _$$RoundStatisticsImplCopyWith(
    _$RoundStatisticsImpl value,
    $Res Function(_$RoundStatisticsImpl) then,
  ) = __$$RoundStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? fakeAnswer,
    String? correctAnswer,
    bool? useDecoy,
    int? score,
  });
}

/// @nodoc
class __$$RoundStatisticsImplCopyWithImpl<$Res>
    extends _$RoundStatisticsCopyWithImpl<$Res, _$RoundStatisticsImpl>
    implements _$$RoundStatisticsImplCopyWith<$Res> {
  __$$RoundStatisticsImplCopyWithImpl(
    _$RoundStatisticsImpl _value,
    $Res Function(_$RoundStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoundStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fakeAnswer = freezed,
    Object? correctAnswer = freezed,
    Object? useDecoy = freezed,
    Object? score = freezed,
  }) {
    return _then(
      _$RoundStatisticsImpl(
        fakeAnswer: freezed == fakeAnswer
            ? _value.fakeAnswer
            : fakeAnswer // ignore: cast_nullable_to_non_nullable
                  as String?,
        correctAnswer: freezed == correctAnswer
            ? _value.correctAnswer
            : correctAnswer // ignore: cast_nullable_to_non_nullable
                  as String?,
        useDecoy: freezed == useDecoy
            ? _value.useDecoy
            : useDecoy // ignore: cast_nullable_to_non_nullable
                  as bool?,
        score: freezed == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoundStatisticsImpl implements _RoundStatistics {
  const _$RoundStatisticsImpl({
    this.fakeAnswer,
    this.correctAnswer,
    this.useDecoy = false,
    this.score,
  });

  factory _$RoundStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoundStatisticsImplFromJson(json);

  @override
  final String? fakeAnswer;
  @override
  final String? correctAnswer;
  @override
  @JsonKey()
  final bool? useDecoy;
  @override
  final int? score;

  @override
  String toString() {
    return 'RoundStatistics(fakeAnswer: $fakeAnswer, correctAnswer: $correctAnswer, useDecoy: $useDecoy, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoundStatisticsImpl &&
            (identical(other.fakeAnswer, fakeAnswer) ||
                other.fakeAnswer == fakeAnswer) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            (identical(other.useDecoy, useDecoy) ||
                other.useDecoy == useDecoy) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fakeAnswer, correctAnswer, useDecoy, score);

  /// Create a copy of RoundStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoundStatisticsImplCopyWith<_$RoundStatisticsImpl> get copyWith =>
      __$$RoundStatisticsImplCopyWithImpl<_$RoundStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RoundStatisticsImplToJson(this);
  }
}

abstract class _RoundStatistics implements RoundStatistics {
  const factory _RoundStatistics({
    final String? fakeAnswer,
    final String? correctAnswer,
    final bool? useDecoy,
    final int? score,
  }) = _$RoundStatisticsImpl;

  factory _RoundStatistics.fromJson(Map<String, dynamic> json) =
      _$RoundStatisticsImpl.fromJson;

  @override
  String? get fakeAnswer;
  @override
  String? get correctAnswer;
  @override
  bool? get useDecoy;
  @override
  int? get score;

  /// Create a copy of RoundStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoundStatisticsImplCopyWith<_$RoundStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
