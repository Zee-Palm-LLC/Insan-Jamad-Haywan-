import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/answer_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/custom_paint/handdrawn_border.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class AnswersHostView extends StatefulWidget {
  const AnswersHostView({
    super.key,
    required this.selectedAlphabet,
    required this.sessionId,
    required this.roundNumber,
    this.totalSeconds = 60,
  });

  final String selectedAlphabet;
  final String sessionId;
  final int roundNumber;
  final int totalSeconds;

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
      CurvedAnimation(parent: _letterController, curve: Curves.elasticOut),
    );
    _letterFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _letterController, curve: Curves.easeIn));
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
    return GetBuilder<AnswerController>(
      init: AnswerController(
        sessionId: widget.sessionId,
        roundNumber: widget.roundNumber,
        selectedLetter: widget.selectedAlphabet,
        totalSeconds: widget.totalSeconds,
        isHostView: true,
      ),
      builder: (controller) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: isDesktop
                ? null
                : AppBar(
                    automaticallyImplyLeading: false,
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
                        RoomCodeText(lobbyId: widget.sessionId),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                          ],
                        ),
                        SizedBox(height: 12.h),
                        // Always show timer progress (global timer)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            value: controller.timerProgress,
                            backgroundColor: AppColors.kGray300,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              controller.timerColor,
                            ),
                            minHeight: 8.h,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Container(
                          width: 120.h,
                          height: 120.h,
                          decoration: BoxDecoration(
                            color: AppColors.kPrimary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.kWhite,
                              width: 2.w,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.selectedAlphabet,
                              style: AppTypography.kBold24.copyWith(
                                color: AppColors.kWhite,
                                fontSize: 60.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        if (controller.isHost && !controller.hostHasAnswered)
                          Container(
                            margin: EdgeInsets.only(bottom: 20.h),
                            padding: EdgeInsets.all(16.h),
                            decoration: BoxDecoration(
                              color: AppColors.kLightYellow.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.kPrimary,
                                width: 2.w,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Your Answers',
                                  style: AppTypography.kBold21.copyWith(
                                    color: AppColors.kPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.h),
                                _buildAnswerField(
                                  label: 'Name',
                                  controller: controller.nameController,
                                  enabled:
                                      controller.isInputEnabled &&
                                      !controller.hasSubmitted,
                                ),
                                SizedBox(height: 12.h),
                                _buildAnswerField(
                                  label: 'Object',
                                  controller: controller.objectController,
                                  enabled:
                                      controller.isInputEnabled &&
                                      !controller.hasSubmitted,
                                ),
                                SizedBox(height: 12.h),
                                _buildAnswerField(
                                  label: 'Animal',
                                  controller: controller.animalController,
                                  enabled:
                                      controller.isInputEnabled &&
                                      !controller.hasSubmitted,
                                ),
                                SizedBox(height: 12.h),
                                _buildAnswerField(
                                  label: 'Plant',
                                  controller: controller.plantController,
                                  enabled:
                                      controller.isInputEnabled &&
                                      !controller.hasSubmitted,
                                ),
                                SizedBox(height: 12.h),
                                _buildAnswerField(
                                  label: 'Country',
                                  controller: controller.countryController,
                                  enabled:
                                      controller.isInputEnabled &&
                                      !controller.hasSubmitted,
                                ),
                                SizedBox(height: 12.h),
                                // Double Points Toggle (Host is a player too)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: controller.doublePoints,
                                      onChanged:
                                          controller.isInputEnabled &&
                                              !controller.hasSubmitted &&
                                              !controller.isSubmitting &&
                                              !controller.roundCompleted &&
                                              !controller.timerExpired
                                          ? (value) =>
                                                controller.toggleDoublePoints()
                                          : null,
                                      activeColor: AppColors.kPrimary,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Double my points',
                                      style: AppTypography.kRegular19.copyWith(
                                        color:
                                            controller.isInputEnabled &&
                                                !controller.hasSubmitted
                                            ? AppColors.kBlack
                                            : AppColors.kGray500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: PrimaryButton(
                                        onPressed:
                                            controller.isInputEnabled &&
                                                !controller.hasSubmitted &&
                                                !controller.isSubmitting &&
                                                !controller.roundCompleted &&
                                                !controller.timerExpired
                                            ? () => controller
                                                  .showStopConfirmation(context)
                                            : null,
                                        text: controller.roundStopped
                                            ? 'Stopped'
                                            : 'Stop !',
                                        color: AppColors.kRed500,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: PrimaryButton(
                                        text: controller.hasSubmitted
                                            ? 'Submitted'
                                            : controller.isSubmitting
                                            ? 'Submitting...'
                                            : 'Submit',
                                        width: double.infinity,
                                        onPressed:
                                            controller.isInputEnabled &&
                                                !controller.hasSubmitted &&
                                                !controller.isSubmitting &&
                                                !controller.roundCompleted &&
                                                !controller.timerExpired
                                            ? () => controller.submitAnswers(
                                                context,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        if (controller.isHost && controller.hostHasAnswered)
                          Container(
                            margin: EdgeInsets.only(bottom: 20.h),
                            padding: EdgeInsets.all(16.h),
                            decoration: BoxDecoration(
                              color: AppColors.kGreen100.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.kPrimary,
                                width: 2.w,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.kPrimary,
                                  size: 32.sp,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Your answers have been submitted',
                                  style: AppTypography.kBold21.copyWith(
                                    color: AppColors.kPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Waiting for other players...',
                                  style: AppTypography.kRegular19.copyWith(
                                    color: AppColors.kGray600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                        if (isDesktop) SizedBox(height: 50.h),
                      ],
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

  Widget _buildAnswerField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
  }) {
    return Container(
      decoration: ShapeDecoration(
        color: enabled
            ? AppColors.kWhite.withOpacity(0.9)
            : AppColors.kGray300.withOpacity(0.5),
        shape: HandStyleBorder(
          side: BorderSide(
            color: enabled ? AppColors.kBlack : AppColors.kGray500,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(2.r),
          roughness: 0.5,
        ),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        textAlign: TextAlign.center,
        maxLength: 50,
        buildCounter:
            (_, {required currentLength, required isFocused, maxLength}) =>
                null,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(
            color: enabled ? AppColors.kGray600 : AppColors.kGray500,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
        style: AppTypography.kRegular19.copyWith(
          fontSize: 16.sp,
          color: enabled ? AppColors.kBlack : AppColors.kGray600,
        ),
      ),
    );
  }

  Widget _buildPlayerAvatar(String? avatarPath) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppColors.kGray300,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.kGray500),
      ),
      child: avatarPath != null
          ? ClipOval(
              child: kIsWeb
                  ? (avatarPath.startsWith('blob:') ||
                            avatarPath.startsWith('data:') ||
                            avatarPath.startsWith('http://') ||
                            avatarPath.startsWith('https://'))
                        ? Image.network(
                            avatarPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholder();
                            },
                          )
                        : _buildPlaceholder()
                  : Image.file(
                      File(avatarPath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                    ),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.kGray300,
      child: Icon(Icons.person, size: 24.sp, color: AppColors.kGray600),
    );
  }
}
