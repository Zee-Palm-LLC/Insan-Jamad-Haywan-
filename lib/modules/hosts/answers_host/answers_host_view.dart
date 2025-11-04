import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/modules/hosts/scoring/scoring_view.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class AnswersHostView extends StatefulWidget {
  const AnswersHostView({super.key, required this.selectedAlphabet});

  final String selectedAlphabet;

  static const String path = '/answers-host/:letter';
  static const String name = 'AnswersHost';

  @override
  State<AnswersHostView> createState() => _AnswersHostViewState();
}

class _AnswersHostViewState extends State<AnswersHostView> {
  int _seconds = 0;
  int _minutes = 0;
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isRunning) {
        setState(() {
          _seconds++;
          if (_seconds >= 60) {
            _minutes++;
            _seconds = 0;
          }
        });
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    _isRunning = false;
    super.dispose();
  }

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
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kLightYellow,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.kGray600),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(AppAssets.timerIcon),
                        SizedBox(width: 8.w),
                        Text(
                          '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
                          style: AppTypography.kRegular19.copyWith(
                            color: AppColors.kRed500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  InkWell(
                    onTap: () {
                      context.push(
                        ScoringView.path.replaceAll(
                          ':letter',
                          widget.selectedAlphabet,
                        ),
                      );
                    },
                    child: Container(
                      width: 200.h,
                      height: 200.h,
                      decoration: BoxDecoration(
                        color: AppColors.kPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          widget.selectedAlphabet,
                          style: AppTypography.kBold24.copyWith(
                            color: AppColors.kWhite,
                            fontSize: 80.sp,
                          ),
                        ),
                      ),
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
