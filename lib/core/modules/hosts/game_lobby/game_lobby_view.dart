import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/data/enums/enums.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/player_list_card.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/letter_generator/letter_generator_view.dart';
import 'package:insan_jamd_hawan/core/modules/players/player_wheel/player_wheel_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class GameLobbyView extends StatefulWidget {
  const GameLobbyView({super.key, required this.controller});

  final LobbyController controller;

  @override
  State<GameLobbyView> createState() => _GameLobbyViewState();
}

class _GameLobbyViewState extends State<GameLobbyView> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handlePhaseChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handlePhaseChange);
    super.dispose();
  }

  Future<void> _handlePhaseChange() async {
    if (_hasNavigated) return;

    if (widget.controller.phase == GamePhase.started) {
      final myId = await AppService.getPlayerId();
      final hostId = widget.controller.currentRoom.host;
      final amHost = myId == hostId;

      if (!amHost && mounted) {
        log(
          'Player detected game start, navigating to wheel view',
          name: 'Navigation',
        );
        _hasNavigated = true;
        if (context.mounted) {
          context.push(PlayerWheelView.path, extra: widget.controller);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<LobbyController>(
      init: widget.controller,
      builder: (_) {
        final players = widget.controller.currentRoom.players ?? [];
        final lobbyId = widget.controller.currentRoom.id ?? '';
        final inviteCode = widget.controller.currentRoom.inviteCode;
        final hostId = widget.controller.currentRoom.host;

        return FutureBuilder<String?>(
          future: AppService.getPlayerId(),
          builder: (context, snapshot) {
            final myId = snapshot.data;
            final amHost = myId == hostId;

            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: isDesktop
                  ? null
                  : AppBar(
                      leading: Padding(
                        padding: EdgeInsets.all(10.h),
                        child: CustomIconButton(
                          icon: AppAssets.backIcon,
                          onTap: () =>
                              widget.controller.removePlayer(isKick: false),
                        ),
                      ),
                      actions: [
                        CustomIconButton(
                          icon: AppAssets.shareIcon,
                          onTap: () async {
                            final codeToShare = inviteCode ?? lobbyId;
                            await Clipboard.setData(
                              ClipboardData(text: codeToShare),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Room code copied to clipboard',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(width: 16.w),
                      ],
                    ),
              body: LobbyBg(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.h),
                  child: Center(
                    child: DesktopWrapper(
                      child: Column(
                        children: [
                          if (!isDesktop) SizedBox(height: 50.h),
                          GameLogo(),
                          SizedBox(height: 12.h),
                          RoomCodeText(
                            lobbyId: lobbyId,
                            inviteCode: inviteCode,
                            iSend: true,
                          ),
                          SizedBox(height: 34.h),
                          PlayerListCard(
                            players: players,
                            hostId: hostId,
                            selectedRounds:
                                widget.controller.selectedMaxRounds ?? 3,
                            selectedTime:
                                widget.controller.selectedTimePerRound ?? 60,
                            onRoundSelected: widget.controller.onMaxRoundChange,
                            onTimeSelected:
                                widget.controller.onTimePerRoundChange,
                            onKickPlayer: amHost
                                ? (playerId) => widget.controller.removePlayer(
                                    isKick: true,
                                    playerIdToKick: playerId,
                                  )
                                : null,
                          ),
                          SizedBox(height: 20.h),
                          if (amHost) ...[
                            PrimaryButton(
                              text: 'Start !',
                              width: 209.w,
                              onPressed: players.length < 2
                                  ? null
                                  : () async {
                                      await widget.controller.startGame();
                                      if (context.mounted) {
                                        context.push(
                                          LetterGeneratorView.path,
                                          extra: widget.controller,
                                        );
                                      }
                                    },
                            ),
                            SizedBox(height: 12.h),
                            PrimaryButton(
                              text: 'Leave Lobby',
                              width: 209.w,
                              onPressed: () =>
                                  widget.controller.removePlayer(isKick: false),
                            ),
                          ] else ...[
                            Container(
                              padding: EdgeInsets.all(16.h),
                              decoration: BoxDecoration(
                                color: AppColors.kGreen100,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.kPrimary,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.kPrimary,
                                    size: 48.w,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'You\'re in!',
                                    style: AppTypography.kBold24.copyWith(
                                      color: AppColors.kPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Wait for host to start the game',
                                    style: AppTypography.kRegular19.copyWith(
                                      color: AppColors.kGray600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            PrimaryButton(
                              text: 'Leave Lobby',
                              width: 209.w,
                              onPressed: () =>
                                  widget.controller.removePlayer(isKick: false),
                            ),
                          ],
                        ],
                      ),
                    ),
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
