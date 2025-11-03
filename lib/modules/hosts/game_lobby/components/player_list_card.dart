import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/app_colors.dart';
import 'package:insan_jamd_hawan/data/constants/app_typography.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/animated_player_tile.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/rounds_selector_card.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/time_selector_card.dart';
import 'package:insan_jamd_hawan/services/audio_service.dart'; // your existing file

class PlayerListCard extends StatefulWidget {
  const PlayerListCard({super.key});

  @override
  State<PlayerListCard> createState() => _PlayerListCardState();
}

class _PlayerListCardState extends State<PlayerListCard>
    with TickerProviderStateMixin {
  final List<Map<String, String>> players = [
    {
      'name': 'Sophia',
      'image':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
    },
    {
      'name': 'Liam',
      'image':
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
    },
    {
      'name': 'Noah',
      'image':
          'https://plus.unsplash.com/premium_photo-1678197937465-bdbc4ed95815?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
    },
    {
      'name': 'Emma',
      'image':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=688',
    },
  ];

  final List<Map<String, String>> joinedPlayers = [];
  int selectedRounds = 3;
  int selectedTime = 45;

  @override
  void initState() {
    super.initState();
    _simulateJoining();
  }

  Future<void> _simulateJoining() async {
    for (int i = 0; i < players.length; i++) {
      await Future.delayed(Duration(milliseconds: 700 * i));
      if (mounted) {
        setState(() => joinedPlayers.add(players[i]));
      }
      await AudioService.instance.playAudio(AudioType.lobbyJoin);
    }
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
                for (int i = 0; i < joinedPlayers.length; i++) ...[
                  AnimatedPlayerTile(
                    index: i + 1,
                    name: joinedPlayers[i]['name']!,
                    imagePath: joinedPlayers[i]['image']!,
                    color: AppColors.kRed500,
                  ),
                  if (i != joinedPlayers.length - 1)
                    Divider(
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
                    onTap: () {
                      setState(() {
                        selectedRounds = round;
                      });
                    },
                    isSelected: selectedRounds == round,
                    round: round.toString(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(color: AppColors.kGray300, thickness: 1, height: 16.h),
          SizedBox(height: 10.h),
          Text('Time per round', style: AppTypography.kBold21),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            children: [45, 60, 90]
                .map(
                  (time) => TimeSelectorCard(
                    onTap: () {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    time: time.toString(),
                    isSelected: selectedTime == time,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
