// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerStateModelImpl _$$PlayerStateModelImplFromJson(
  Map<String, dynamic> json,
) => _$PlayerStateModelImpl(
  lastHeartbeat: json['lastHeartbeat'] as String?,
  roundsStatistics: (json['roundsStatistics'] as List<dynamic>?)
      ?.map((e) => RoundStatistics.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PlayerStateModelImplToJson(
  _$PlayerStateModelImpl instance,
) => <String, dynamic>{
  'lastHeartbeat': instance.lastHeartbeat,
  'roundsStatistics': instance.roundsStatistics,
};
