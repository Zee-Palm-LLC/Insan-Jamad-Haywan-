import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/modules/hosts/scoreboard/scoreboard_view.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class VotingView extends StatelessWidget {
  const VotingView({
    super.key,
    required this.selectedAlphabet,
    this.playerName,
    this.playerAnswer,
  });

  final String selectedAlphabet;
  final String? playerName;
  final String? playerAnswer;

  static const String path = '/voting/:letter';
  static const String name = 'Voting';

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Letter', style: AppTypography.kRegular24),
                      SizedBox(width: 8.w),
                      InkWell(
                        onTap: () {
                          context.push(ScoreboardView.path);
                        },
                        child: Container(
                          height: 50.h,
                          width: 74.w,
                          decoration: BoxDecoration(
                            color: AppColors.kPrimary,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(top: 6.h),
                          child: Text(
                            'A',
                            style: AppTypography.kRegular41.copyWith(
                              color: AppColors.kWhite,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.kGreen100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.all(16.h),
                    child: Text(
                      ' Player 1 entered “Aman” which is creative but we are not certain. Vote on your phone',
                      style: AppTypography.kBold24.copyWith(
                        fontSize: 20.sp,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (isDesktop) SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
