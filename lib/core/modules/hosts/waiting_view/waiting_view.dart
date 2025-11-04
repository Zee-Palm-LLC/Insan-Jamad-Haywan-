import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class WaitingView extends StatelessWidget {
  const WaitingView({super.key});

  static String path = '/waiting';
  static String name = 'Waiting';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
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
                children: [
                  if (!isDesktop) SizedBox(height: 50.h),
                  GameLogo(),
                  SizedBox(height: 12.h),
                  RoomCodeText(
                    lobbyId: 'Xyz3141',
                    inviteCode: 'Xyz3456',
                    iSend: true,
                  ),
                  SizedBox(height: 34.h),
                  Container(
                    height: 238.h,
                    width: 238.h,
                    decoration: BoxDecoration(
                      color: AppColors.kGray300,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.kPrimary),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    'Maxwell',
                    style: AppTypography.kBold24.copyWith(fontSize: 34.sp),
                  ),
                  Text(
                    'You are in! Wait for host to start game...',
                    textAlign: TextAlign.center,
                    style: AppTypography.kBold24.copyWith(
                      height: 1.2,
                      color: AppColors.kPrimary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  PrimaryButton(text: 'Loading ...', onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
