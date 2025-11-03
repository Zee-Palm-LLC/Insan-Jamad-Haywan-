import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/data/constants/app_assets.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/player_list_card.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/primary_button.dart';

class GameLobbyView extends StatelessWidget {
  const GameLobbyView({super.key, required this.controller});

  final LobbyController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LobbyController>(
      init: controller,
      builder: (_) {
        final players = controller.currentRoom.players ?? [];
        final lobbyId = controller.currentRoom.id ?? '';
        final hostId = controller.currentRoom.host;

        return FutureBuilder<String?>(
          future: AppService.getPlayerId(),
          builder: (context, snapshot) {
            final myId = snapshot.data;
            final amHost = myId == hostId;

            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                leading: Padding(
                  padding: EdgeInsets.all(10.h),
                  child: CustomIconButton(
                    icon: AppAssets.backIcon,
                    onTap: () => context.pop(),
                  ),
                ),
                actions: [
                  CustomIconButton(icon: AppAssets.shareIcon, onTap: () {}),
                  SizedBox(width: 16.w),
                ],
              ),
              body: LobbyBg(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    children: [
                      SizedBox(height: 50.h),
                      GameLogo(),
                      SizedBox(height: 12.h),
                      RoomCodeText(lobbyId: lobbyId),
                      SizedBox(height: 34.h),
                      PlayerListCard(
                        players: players,
                        hostId: hostId,
                        selectedRounds: controller.selectedMaxRounds ?? 3,
                        selectedTime:
                            45, // TODO: Add time selection to controller
                        onRoundSelected: controller.onMaxRoundChange,
                        onTimeSelected: (time) {
                          // TODO: Add time selection to controller
                        },
                        onKickPlayer: amHost
                            ? (playerId) => controller.removePlayer(
                                isKick: true,
                                playerIdToKick: playerId,
                              )
                            : null,
                      ),
                      SizedBox(height: 20.h),
                      if (amHost)
                        PrimaryButton(
                          text: 'Start !',
                          width: 209.w,
                          onPressed: () {
                            // TODO: Implement start game
                            // controller.startGame();
                          },
                        )
                      else
                        PrimaryButton(
                          text: 'Leave Lobby',
                          width: 209.w,
                          onPressed: () =>
                              controller.removePlayer(isKick: false),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
