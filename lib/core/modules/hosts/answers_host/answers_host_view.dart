import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/answers_host_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/scoring_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class AnswersHostView extends StatefulWidget {
  const AnswersHostView({super.key, required this.selectedAlphabet});

  final String selectedAlphabet;

  static const String path = '/answers-host/:letter';
  static const String name = 'AnswersHost';

  @override
  State<AnswersHostView> createState() => _AnswersHostViewState();
}

class _AnswersHostViewState extends State<AnswersHostView>
    with TickerProviderStateMixin {
  String? _countdownValue;
  bool _showLetter = false;
  late AnimationController _countdownController;
  late AnimationController _letterController;
  late Animation<double> _letterScaleAnimation;
  late Animation<double> _letterFadeAnimation;

  @override
  void initState() {
    super.initState();
    _countdownController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _letterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _letterScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _letterController,
        curve: Curves.elasticOut,
      ),
    );
    _letterFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _letterController,
        curve: Curves.easeIn,
      ),
    );
    _startCountdown();
  }

  void _startCountdown() {
    final countdownSequence = ['03', '02', '01', 'Go!'];
    int currentIndex = 0;

    void showNext() {
      if (currentIndex < countdownSequence.length && mounted) {
        setState(() {
          _countdownValue = countdownSequence[currentIndex];
        });
        _countdownController.forward(from: 0.0);
        currentIndex++;
        if (currentIndex < countdownSequence.length) {
          Future.delayed(const Duration(milliseconds: 1000), showNext);
        } else {
          // After "Go!", show letter
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _countdownValue = null;
                _showLetter = true;
              });
              _letterController.forward();
            }
          });
        }
      }
    }

    Future.delayed(const Duration(milliseconds: 300), showNext);
  }

  @override
  void dispose() {
    _countdownController.dispose();
    _letterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<AnswersHostController>(
      init: AnswersHostController(),
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
                              controller.formattedTime,
                              style: AppTypography.kRegular19.copyWith(
                                color: AppColors.kRed500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                      if (_countdownValue != null)
                        _buildCountdownAnimation(),
                      if (_showLetter) ...[
                        _buildLetterContainer(),
                        SizedBox(height: 30.h),
                        _buildContinueButton(),
                      ],
                      if (_countdownValue == null && !_showLetter)
                        SizedBox(height: 200.h),
                      if (isDesktop) SizedBox(height: 50.h),
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

  Widget _buildCountdownAnimation() {
    return AnimatedBuilder(
      animation: _countdownController,
      builder: (context, child) {
        // Scale animation: zoom in then zoom out
        final scale = _countdownController.value < 0.5
            ? 0.0 + (_countdownController.value * 2) * 1.5 // Zoom in: 0 to 1.5
            : 1.5 - ((_countdownController.value - 0.5) * 2) * 0.5; // Zoom out: 1.5 to 1.0

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: _countdownController.value < 0.3
                ? _countdownController.value / 0.3
                : 1.0 - ((_countdownController.value - 0.3) / 0.7),
            child: Container(
              width: 200.h,
              height: 200.h,
              alignment: Alignment.center,
              child: Text(
                _countdownValue!,
                style: AppTypography.kBold24.copyWith(
                  color: _countdownValue == 'Go!'
                      ? AppColors.kPrimary
                      : AppColors.kRed500,
                  fontSize: _countdownValue == 'Go!' ? 60.sp : 80.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLetterContainer() {
    return AnimatedBuilder(
      animation: Listenable.merge([_letterScaleAnimation, _letterFadeAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _letterFadeAnimation,
          child: ScaleTransition(
            scale: _letterScaleAnimation,
            child: InkWell(
              onTap: () {
                context.push(
                  ScoringView.path.replaceAll(
                    'A',
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ], 
                ),
                child: Center(
                  child: Text('A',
                    style: AppTypography.kBold24.copyWith(
                      color: AppColors.kWhite,
                      fontSize: 80.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton() {
    return PrimaryButton(
      text: 'Continue',
      width: 200.w,
      animated: _showLetter,
      delay: const Duration(milliseconds: 300), // Delay after letter appears
      duration: const Duration(milliseconds: 600),
      onPressed: () {
        context.push(
          ScoringView.path.replaceAll(
            'A',
            widget.selectedAlphabet,
          ),
        );
      },
    );
  }
}
