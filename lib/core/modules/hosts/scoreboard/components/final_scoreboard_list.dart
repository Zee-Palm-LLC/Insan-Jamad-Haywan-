import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/data/helpers/app_helpers.dart';

class FinalScoreboardList extends StatelessWidget {
  final List<ScoreboardListPlayer> players;

  const FinalScoreboardList({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.kGreen100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: players.asMap().entries.map((entry) {
          final idx = entry.key;
          final player = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: idx == players.length - 1 ? 0.h : 12.h,
            ),
            child: _buildListCard(player),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListCard(ScoreboardListPlayer player) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          // Rank
          Text(
            player.rank,
            style: AppTypography.kBold16.copyWith(
              color: AppColors.kBlack,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(width: 16.w),
          // Avatar
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.kGray500, width: 2.w),
              color: AppColors.kGray300,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: player.avatarUrl.isNotEmpty
                  ? Image.network(
                      player.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildInitials(player.name);
                      },
                    )
                  : _buildInitials(player.name),
            ),
          ),

          SizedBox(width: 12.w),
          // Name and Total Points
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: AppTypography.kBold16.copyWith(
                    color: AppColors.kRed500,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  player.totalPoints,
                  style: AppTypography.kRegular19.copyWith(
                    color: AppColors.kBlack,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          // Points Gained
          Text(
            player.pointsGained,
            style: AppTypography.kBold21.copyWith(
              color: AppColors.kPrimary,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitials(String name) {
    return Container(
      color: AppColors.kGray300,
      alignment: Alignment.center,
      child: Text(
        AppHelpers.getInitials(name),
        style: AppTypography.kBold16.copyWith(
          color: AppColors.kGray600,
          fontSize: 18.sp,
        ),
      ),
    );
  }
}

class ScoreboardListPlayer {
  final String rank;
  final String name;
  final String totalPoints;
  final String pointsGained;
  final String avatarUrl;

  ScoreboardListPlayer({
    required this.rank,
    required this.name,
    required this.totalPoints,
    required this.pointsGained,
    required this.avatarUrl,
  });
}
