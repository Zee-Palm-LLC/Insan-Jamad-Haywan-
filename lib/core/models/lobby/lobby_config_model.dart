import 'package:freezed_annotation/freezed_annotation.dart';

part 'lobby_config_model.freezed.dart';
part 'lobby_config_model.g.dart';

@freezed
class LobbyConfigModel with _$LobbyConfigModel {
  const factory LobbyConfigModel({
    final String? name,
    final int? maxPlayers,
    final bool? isPrivate,
    final bool? useInviteCode,
    final bool? allowLateJoin,
    final String? region,
    final Map<String, dynamic>? settings,
    final String? host,
  }) = _LobbyConfigModel;

  factory LobbyConfigModel.fromJson(Map<String, dynamic> json) =>
      _$LobbyConfigModelFromJson(json);
}
