import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/modules/hosts/scoreboard/scoreboard_view.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/primary_button.dart';

class FinalRoundView extends StatelessWidget {
  const FinalRoundView({
    super.key,
    this.isPlayer = true,
    this.selectedAlphabet,
    this.category,
  });

  final bool isPlayer;
  final String? selectedAlphabet;
  final String? category;

  static const String path = '/final-round';
  static const String name = 'FinalRound';

  @override
  Widget build(BuildContext context) {
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
              RoomCodeText(lobbyId: 'XY21234'),
              SizedBox(height: 40.h),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(24.h),
                decoration: BoxDecoration(
                  color: AppColors.kLightYellow,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Color(0xFF493505).withValues(alpha: 0.6),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    _buildDoubleBorderText('Final Round', fontSize: 40.sp),
                    Text(
                      'الجولة الأخيرة',
                      style: AppTypography.kBold21.copyWith(
                        color: AppColors.kOrange,
                        fontSize: 24.sp,
                      ),
                    ),
                    if (isPlayer) ...[
                      SizedBox(height: 20.h),
                      Text(
                        'You only have 30 seconds & a surprise category',
                        style: AppTypography.kRegular19,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Points are doubled',
                        style: AppTypography.kRegular19,
                      ),
                    ],
                  ],
                ),
              ),
              if (!isPlayer) ...[
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text('Letter is', style: AppTypography.kRegular19),
                    SizedBox(width: 12.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kYellow,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.kGray600),
                      ),
                      child: Text(
                        selectedAlphabet ?? 'A',
                        style: AppTypography.kBold21,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Text(
                      'Surprise Category is',
                      style: AppTypography.kRegular19,
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kYellow,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.kGray600),
                      ),
                      child: Text(
                        category ?? 'Animals',
                        style: AppTypography.kBold21,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 54.h),
                PrimaryButton(
                  text: 'See Final Scoreboard',
                  onPressed: () {
                    context.push(ScoreboardView.path);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoubleBorderText(String text, {required double fontSize}) {
    return Stack(
      children: [
        Text(
          text,
          style: AppTypography.kBold24.copyWith(
            fontSize: fontSize,
            height: 1,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 8
              ..color = AppColors.kOrange,
          ),
        ),
        Text(
          text,
          style: AppTypography.kBold24.copyWith(
            fontSize: fontSize,
            height: 1,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..color = AppColors.kCreamyOrange,
          ),
        ),
        Text(
          text,
          style: AppTypography.kBold24.copyWith(
            fontSize: fontSize,
            height: 1,
            color: AppColors.kOrange,
          ),
        ),
      ],
    );
  }
}
