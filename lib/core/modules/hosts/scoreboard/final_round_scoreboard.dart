import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/components/final_scoreboard_list.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/components/final_scoreboard_podium.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class FinalRoundScoreboard extends StatelessWidget {
  const FinalRoundScoreboard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: isDesktop
          ? null
          : AppBar(
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
      body: AnimatedBg(
        showHorizontalLines: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.h),
          child: Center(
            child: DesktopWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isDesktop) SizedBox(height: 50.h),
                  GameLogo(),
                  SizedBox(height: 12.h),
                  RoomCodeText(lobbyId: 'XY21234', iSend: true),
                  SizedBox(height: 40.h),
                  // Title
                  Text(
                    'Final Round\nScoreboard',
                    textAlign: TextAlign.center,
                    style: AppTypography.kBold24.copyWith(
                      color: AppColors.kRed500,
                      height: 1.2,
                      fontSize: 34.sp,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  FinalScoreboardPodium(
                    players: [
                      PodiumPlayer(
                        rank: 1,
                        name: 'Maxwell',
                        score: '+7,120',
                        avatarUrl:
                            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
                        color: AppColors.kPrimary,
                        badge: AppAssets.firstBadge,
                        textColor: AppColors.kWhite,
                      ),
                      PodiumPlayer(
                        rank: 2,
                        name: 'Camelia',
                        score: '+6,500',
                        avatarUrl:
                            'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
                        color: Color(0xFFFED643),
                        badge: AppAssets.secondBadge,
                        textColor: AppColors.kBlack,
                      ),
                      PodiumPlayer(
                        rank: 3,
                        name: 'Wilson',
                        score: '+4,800',
                        avatarUrl:
                            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=688',
                        color: Color(0xFFBED6E2),
                        badge: AppAssets.thirdBadge,
                        textColor: AppColors.kBlack,
                      ),
                    ],
                  ),
                  FinalScoreboardList(
                    players: [
                      ScoreboardListPlayer(
                        rank: '4th',
                        name: 'Sophia',
                        totalPoints: '1250 pts',
                        pointsGained: '+23',
                        avatarUrl:
                            'https://plus.unsplash.com/premium_photo-1678197937465-bdbc4ed95815?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
                      ),
                      ScoreboardListPlayer(
                        rank: '5th',
                        name: 'Sophia',
                        totalPoints: '1250 pts',
                        pointsGained: '+23',
                        avatarUrl:
                            'https://plus.unsplash.com/premium_photo-1678197937465-bdbc4ed95815?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
