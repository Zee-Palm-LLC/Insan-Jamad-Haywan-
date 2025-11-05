import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';

class FinalScoreboardPodium extends StatelessWidget {
  final List<PodiumPlayer> players;

  const FinalScoreboardPodium({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    if (players.length < 3) {
      return const SizedBox.shrink();
    }
    final sortedPlayers = List<PodiumPlayer>.from(players);
    sortedPlayers.sort((a, b) => a.rank.compareTo(b.rank));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildPodiumCard(player: sortedPlayers[1]),
        _buildPodiumCard(player: sortedPlayers[0]),
        _buildPodiumCard(player: sortedPlayers[2]),
      ],
    );
  }

  Widget _buildPodiumCard({required PodiumPlayer player}) {
    final double height = player.rank == 1
        ? 250.h
        : player.rank == 2
        ? 190.h
        : 160.h;

    final double avatarSize = player.rank == 2
        ? 55.w
        : player.rank == 3
        ? 50
        : 70.w;
    final double avatarHalf = avatarSize / 2; // Half the avatar size

    return SizedBox(
      width: 120.w,
      height: height + avatarHalf, // Add space for avatar half extending above
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: 120.w,
              height: height,
              decoration: BoxDecoration(
                color: player.color,
                borderRadius: player.rank == 2
                    ? BorderRadius.only(
                        topLeft: Radius.circular(44.r),
                        bottomLeft: Radius.circular(24.r),
                      )
                    : player.rank == 3
                    ? BorderRadius.only(
                        topRight: Radius.circular(44.r),
                        bottomRight: Radius.circular(24.r),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    player.score,
                    style: AppTypography.kBold21.copyWith(
                      color: player.textColor,
                      fontSize: 20.sp,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Medal
                  Image.asset(player.badge, width: 40.w, height: 40.w),
                  SizedBox(height: 8.h),
                  // Name
                  Text(
                    player.name,
                    style: AppTypography.kBold16.copyWith(
                      color: player.textColor,
                      fontSize: 20.sp,
                      height: 1,
                    ),
                  ),
                  if (player.rank == 1) ...[
                    const Spacer()
                  ] else ...[SizedBox(height: 15.h)],
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: (120.w - avatarSize) / 2,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.kGray500, width: 2.w),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Image.network(
                  player.avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.kGray300,
                      child: Icon(
                        Icons.person,
                        size: 30.sp,
                        color: AppColors.kGray600,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PodiumPlayer {
  final int rank;
  final String name;
  final String score;
  final String avatarUrl;
  final Color color;
  final String badge;
  final Color textColor;

  PodiumPlayer({
    required this.rank,
    required this.name,
    required this.score,
    required this.avatarUrl,
    required this.color,
    required this.badge,
    required this.textColor,
  });
}
