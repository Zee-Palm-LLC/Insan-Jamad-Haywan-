import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/app_colors.dart';
import 'package:insan_jamd_hawan/data/constants/app_typography.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/animated_player_tile.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/rounds_selector_card.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/time_selector_card.dart';
import 'package:insan_jamd_hawan/modules/widgets/custom_paint/hand_drawn_divider.dart';
import 'package:insan_jamd_hawan/services/audio_service.dart'; // your existing file

class PlayerListCard extends StatefulWidget {
  const PlayerListCard({
    super.key,
    required this.players,
    required this.hostId,
    required this.selectedRounds,
    required this.selectedTime,
    required this.onRoundSelected,
    required this.onTimeSelected,
    this.onKickPlayer,
  });

  final List<String> players;
  final String? hostId;
  final int selectedRounds;
  final int selectedTime;
  final Function(int?) onRoundSelected;
  final Function(int) onTimeSelected;
  final Function(String)? onKickPlayer;

  @override
  State<PlayerListCard> createState() => _PlayerListCardState();
}

class _PlayerListCardState extends State<PlayerListCard>
    with TickerProviderStateMixin {
  final List<String> _joinedPlayers = [];

  @override
  void initState() {
    super.initState();
    _simulateJoining();
  }

  @override
  void didUpdateWidget(PlayerListCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.players != widget.players) {
      _joinedPlayers.removeWhere((p) => !widget.players.contains(p));
      _simulateJoining();
    }
  }

  Future<void> _simulateJoining() async {
    final newPlayers = widget.players
        .where((p) => !_joinedPlayers.contains(p))
        .toList();

    for (final player in newPlayers) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted &&
          !_joinedPlayers.contains(player) &&
          widget.players.contains(player)) {
        setState(() => _joinedPlayers.add(player));
        await AudioService.instance.playAudio(AudioType.lobbyJoin);
      }
    }
  }

  String _getPlayerAvatar(String name) {
    final hash = name.hashCode.abs();
    final index = hash % 4;
    final images = [
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
      'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
      'https://plus.unsplash.com/premium_photo-1678197937465-bdbc4ed95815?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=688',
    ];
    return images[index];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kGreen100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Players', style: AppTypography.kBold21),
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.all(16.h),
            child: Column(
              children: [
                for (int i = 0; i < _joinedPlayers.length; i++) ...[
                  AnimatedPlayerTile(
                    index: i + 1,
                    name: _joinedPlayers[i],
                    imagePath: _getPlayerAvatar(_joinedPlayers[i]),
                    color: AppColors.kRed500,
                    isHost: _joinedPlayers[i] == widget.hostId,
                    onKick:
                        widget.onKickPlayer != null &&
                            _joinedPlayers[i] != widget.hostId
                        ? () => widget.onKickPlayer!(_joinedPlayers[i])
                        : null,
                  ),
                  if (i != _joinedPlayers.length - 1)
                    HandDrawnDivider(
                      color: AppColors.kGray300,
                      thickness: 1,
                      height: 16.h,
                    ),
                ],
              ],
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Text('No. of Rounds', style: AppTypography.kBold21),
              const Spacer(),
              ...[3, 5, 7].map(
                (round) => Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: RoundSelectorCard(
                    onTap: () => widget.onRoundSelected(round),
                    isSelected: widget.selectedRounds == round,
                    round: round.toString(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          HandDrawnDivider(color: AppColors.kGray300, thickness: 1, height: 16.h),
          SizedBox(height: 10.h),
          Text('Time per round', style: AppTypography.kBold21),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            children: [45, 60, 90]
                .map(
                  (time) => TimeSelectorCard(
                    onTap: () => widget.onTimeSelected(time),
                    time: time.toString(),
                    isSelected: widget.selectedTime == time,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
