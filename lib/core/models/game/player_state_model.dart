import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insan_jamd_hawan/core/models/game/round_statistics.dart';

part 'player_state_model.freezed.dart';
part 'player_state_model.g.dart';

@freezed
class PlayerStateModel with _$PlayerStateModel {
  const factory PlayerStateModel({
    final String? lastHeartbeat,
    final List<RoundStatistics>? roundsStatistics,
  }) = _PlayerStateModel;

  factory PlayerStateModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateModelFromJson(json);
}
