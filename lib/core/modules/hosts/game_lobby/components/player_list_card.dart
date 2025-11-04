import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/data/constants/app_colors.dart';
import 'package:insan_jamd_hawan/core/data/constants/app_typography.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/animated_player_tile.dart';
import 'package:insan_jamd_hawan/core/controllers/player_list_card_controller.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/rounds_selector_card.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/time_selector_card.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/custom_paint/hand_drawn_divider.dart';

class PlayerListCard extends StatelessWidget {
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

  Color _getPlayerColor(int index) {
    final colors = [
      AppColors.kPrimary,
      AppColors.kBlue,
      AppColors.kOrange,
      AppColors.kRed500,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayerListCardController>(
      init: PlayerListCardController()..initializePlayers(players),
      builder: (controller) {
        // Update players when they change
        if (controller.joinedPlayers.isNotEmpty &&
            players.length != controller.joinedPlayers.length) {
          controller.updatePlayers(players);
        }

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
                    for (
                      int i = 0;
                      i < controller.joinedPlayers.length;
                      i++
                    ) ...[
                      AnimatedPlayerTile(
                        index: i + 1,
                        name: controller.joinedPlayers[i],
                        imagePath:
                            '', // No longer used - showing initials instead
                        color: _getPlayerColor(i),
                        isHost: controller.joinedPlayers[i] == hostId,
                        onKick:
                            onKickPlayer != null &&
                                controller.joinedPlayers[i] != hostId
                            ? () => onKickPlayer!(controller.joinedPlayers[i])
                            : null,
                      ),
                      if (i != controller.joinedPlayers.length - 1)
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
                        onTap: () => onRoundSelected(round),
                        isSelected: selectedRounds == round,
                        round: round.toString(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              HandDrawnDivider(
                color: AppColors.kGray300,
                thickness: 1,
                height: 16.h,
              ),
              SizedBox(height: 10.h),
              Text('Time per round', style: AppTypography.kBold21),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                children: [45, 60, 90]
                    .map(
                      (time) => TimeSelectorCard(
                        onTap: () => onTimeSelected(time),
                        time: time.toString(),
                        isSelected: selectedTime == time,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
