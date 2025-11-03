import 'package:insan_jamd_hawan/core/models/game/lobby_settings.dart';
import 'package:insan_jamd_hawan/core/models/game/player_state_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lobby_resource_model.freezed.dart';
part 'lobby_resource_model.g.dart';

@freezed
class LobbyResourceModel with _$LobbyResourceModel {
  const factory LobbyResourceModel({
    @JsonKey(includeIfNull: false) final String? status,
    @JsonKey(includeIfNull: false) final PlayerStateModel? playerState,
    @JsonKey(includeIfNull: false) final LobbySettings? settings,
    @JsonKey(includeIfNull: false) final String? host,
    @JsonKey(includeIfNull: false) final String? targetPlayerId,
    required final String requesterId,
  }) = _LobbyResourceModel;

  factory LobbyResourceModel.fromJson(Map<String, dynamic> json) =>
      _$LobbyResourceModelFromJson(json);
}
