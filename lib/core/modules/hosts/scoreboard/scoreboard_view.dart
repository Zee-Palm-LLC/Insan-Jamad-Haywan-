import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/final_round/final_round_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/components/first_position_podium.dart';
import 'package:insan_jamd_hawan/core/controllers/scoreboard_controller.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class ScoreboardView extends StatelessWidget {
  const ScoreboardView({super.key});

  static const String path = '/scoreboard';
  static const String name = 'Scoreboard';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<ScoreboardController>(
      init: ScoreboardController(),
      builder: (controller) {
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
                      RoomCodeText(lobbyId: 'XY21234'),
                      SizedBox(height: 20.h),
                      // Scoreboard title
                      Text(
                        'Scoreboard',
                        style: AppTypography.kBold24.copyWith(
                          color: AppColors.kRed500,
                          fontSize: 48.sp,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      InkWell(
                        onTap: () {
                          context.push(FinalRoundView.path);
                        },
                        child: PositionPodium(
                          position: '1st',
                          badge: AppAssets.firstBadge,
                          image:
                              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
                          name: 'Sophia',
                          points: '+23',
                          totalPoints: '1250',
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 13.w,
                          vertical: 20.h,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: AppColors.kGreen100,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12.r),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.all(10.h),
                              child: Column(
                                children: [
                                  PositionPodium(
                                    isFirst: false,
                                    position: '2nd',
                                    badge: AppAssets.secondBadge,
                                    image:
                                        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
                                    name: 'Sophia',
                                    points: '+23',
                                    totalPoints: '1250',
                                  ),
                                  Divider(
                                    color: AppColors.kGray300,
                                    thickness: 1,
                                    height: 16.h,
                                  ),
                                  PositionPodium(
                                    isFirst: false,
                                    position: '3rd',
                                    badge: AppAssets.thirdBadge,
                                    image:
                                        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
                                    name: 'Sophia',
                                    points: '+23',
                                    totalPoints: '1250',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Column(
                                children: [
                                  ...List.generate(3, (idx) {
                                    final List<Map<String, dynamic>>
                                    positions = [
                                      {
                                        'position': '4th',
                                        'image':
                                            'https://images.unsplash.com/photo-1511367461989-f85a21fda167?auto=format&fit=crop&w=800&q=80',
                                        'name': 'Alex',
                                        'points': '+18',
                                        'totalPoints': '1190',
                                      },
                                      {
                                        'position': '5th',
                                        'image':
                                            'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=crop&w=800&q=80',
                                        'name': 'Taylor',
                                        'points': '+15',
                                        'totalPoints': '1140',
                                      },
                                      {
                                        'position': '6th',
                                        'image':
                                            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
                                        'name': 'Jordan',
                                        'points': '+12',
                                        'totalPoints': '1100',
                                      },
                                    ];
                                    final podium = positions[idx];
                                    return Column(
                                      children: [
                                        PositionPodium(
                                          isFirst: false,
                                          position: podium['position'],
                                          image: podium['image'],
                                          name: podium['name'],
                                          points: podium['points'],
                                          totalPoints: podium['totalPoints'],
                                        ),
                                        if (idx != 2)
                                          Divider(
                                            color: AppColors.kGray300,
                                            thickness: 1,
                                            height: 16.h,
                                          ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
