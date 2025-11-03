// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoundStatisticsImpl _$$RoundStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$RoundStatisticsImpl(
  fakeAnswer: json['fakeAnswer'] as String?,
  correctAnswer: json['correctAnswer'] as String?,
  useDecoy: json['useDecoy'] as bool? ?? false,
  score: (json['score'] as num?)?.toInt(),
);

Map<String, dynamic> _$$RoundStatisticsImplToJson(
  _$RoundStatisticsImpl instance,
) => <String, dynamic>{
  'fakeAnswer': instance.fakeAnswer,
  'correctAnswer': instance.correctAnswer,
  'useDecoy': instance.useDecoy,
  'score': instance.score,
};
