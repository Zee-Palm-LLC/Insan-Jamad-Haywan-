import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/data/enums/enums.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/letter_generator/letter_generator_view.dart';
import 'package:insan_jamd_hawan/core/modules/special_round/surprise_round_answer_view.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/services/firestore/special_round_service.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class SurpriseRoundView extends StatefulWidget {
  const SurpriseRoundView({super.key});

  static const String path = '/final-round';
  static const String name = 'FinalRound';

  @override
  State<SurpriseRoundView> createState() => _SurpriseRoundViewState();
}

class _SurpriseRoundViewState extends State<SurpriseRoundView> {
  bool isHost = false;
  bool showLoading = false;
  LobbyController get lobbyController => Get.find<LobbyController>();
  void checkIsHost() async {
    setState(() {
      showLoading = true;
    });
    final playerId = await AppService.getPlayerId();
    if (playerId == lobbyController.lobby.host) {
      isHost = true;
      setState(() {
        showLoading = false;
      });
      SpecialRoundService().getRandomLetterAndCategory(
        lobbyController.lobby.id ?? 'N/A',
      );
    } else {
      setState(() {
        showLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkIsHost();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.pop();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // appBar: isDesktop
        //     ? null
        //     : AppBar(
        //         leading: Padding(
        //           padding: EdgeInsets.all(10.h),
        //           child: CustomIconButton(
        //             icon: AppAssets.backIcon,
        //             onTap: () => context.pop(),
        //           ),
        //         ),
        //         actions: [
        //           CustomIconButton(icon: AppAssets.shareIcon, onTap: () {}),
        //           SizedBox(width: 16.w),
        //         ],
        //       ),
        body: LobbyBg(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.h),
            child: Center(
              child: DesktopWrapper(
                child: showLoading
                    ? Center(child: CircularProgressIndicator())
                    : StreamBuilder(
                        stream: FirebaseFirestoreService.instance
                            .streamGameSession(
                              lobbyController.lobby.id ?? 'N/A',
                            ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.data == null) {
                            return Center(child: Text('No data found'));
                          }
                          final specialRound = snapshot.data?.config;
                          if (specialRound == null ||
                              specialRound.specialRoundLetter == null ||
                              specialRound.specialRoundCategory == null) {
                            return Center(
                              child: Text(
                                'Host has not started the surprise round yet',
                              ),
                            );
                          }
                          if (specialRound.specialRoundStatus ==
                                  SpecialRoundStatus.started &&
                              specialRound.specialRoundLetter != null &&
                              specialRound.specialRoundCategory != null) {
                            return SizedBox(
                              height: context.height,
                              width: context.width,
                              child: SurpriseRoundAnswerView(
                                specialRoundLetter:
                                    specialRound.specialRoundLetter,
                                specialRoundCategory:
                                    specialRound.specialRoundCategory,
                              ),
                            );
                          }
                          return Column(
                            children: [
                              if (!isDesktop) SizedBox(height: 50.h),
                              GameLogo(),
                              SizedBox(height: 12.h),
                              RoomCodeText(
                                lobbyId: lobbyController.lobby.id ?? 'N/A',
                              ),
                              SizedBox(height: 40.h),
                              Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(24.h),
                                decoration: BoxDecoration(
                                  color: AppColors.kLightYellow,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: Color(
                                      0xFF493505,
                                    ).withValues(alpha: 0.6),
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _buildDoubleBorderText(
                                      'Final Round',
                                      fontSize: 40.sp,
                                    ),
                                    Text(
                                      'الجولة الأخيرة',
                                      style: AppTypography.kBold21.copyWith(
                                        color: AppColors.kOrange,
                                        fontSize: 24.sp,
                                      ),
                                    ),

                                    SizedBox(height: 20.h),
                                    Text(
                                      'You only have 30 seconds & a surprise category & a surprise letter',
                                      style: AppTypography.kRegular19,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Points are doubled',
                                      style: AppTypography.kRegular19,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  Text(
                                    'Letter is',
                                    style: AppTypography.kRegular19,
                                  ),
                                  SizedBox(width: 12.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.kYellow,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: AppColors.kGray600,
                                      ),
                                    ),
                                    child: Text(
                                      specialRound.specialRoundLetter ?? 'A',
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
                                      border: Border.all(
                                        color: AppColors.kGray600,
                                      ),
                                    ),
                                    child: Text(
                                      specialRound.specialRoundCategory ??
                                          'Animals',
                                      style: AppTypography.kBold21,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 54.h),
                              PrimaryButton(
                                text: 'Start Surprise Round',
                                onPressed: () async {
                                  await FirebaseFirestoreService.instance
                                      .updateSurpriseRoundedStatus(
                                        lobbyController.lobby.id ?? 'N/A',
                                        'special_round',
                                        "special_round",
                                      );
                                  context.go(SurpriseRoundAnswerView.path);
                                },
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ),
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
