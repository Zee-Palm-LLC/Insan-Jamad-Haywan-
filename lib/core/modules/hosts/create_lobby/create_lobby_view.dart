import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_creation_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/rounds_selector_card.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/time_selector_card.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/animations/page_animation.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/animated_bg.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/custom_paint/hand_drawn_divider.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class LobbyCreationPage extends StatelessWidget {
  const LobbyCreationPage({super.key});

  static const String path = '/create-lobby';
  static const String name = 'CreateLobby';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<LobbyCreationController>(
      init: LobbyCreationController(),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isDesktop) SizedBox(height: 50.h),
                      PageAnimation(
                        delay: const Duration(milliseconds: 100),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        startScale: 0.9,
                        child: GameLogo(),
                      ),
                      SizedBox(height: 12.h),
                      PageAnimation(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        startScale: 0.95,
                        child: Text(
                          'Create New Lobby',
                          style: AppTypography.kBold24,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 34.h),

                      // Settings Card
                      PageAnimation(
                        delay: const Duration(milliseconds: 300),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        startScale: 0.95,
                        child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.kGreen100,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.all(16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Game Settings', style: AppTypography.kBold21),
                            SizedBox(height: 16.h),

                            // Lobby Name Input
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.all(16.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lobby Name',
                                    style: AppTypography.kBold21,
                                  ),
                                  SizedBox(height: 12.h),
                                  TextField(
                                    cursorColor: AppColors.kPrimary,
                                    controller: controller.lobbyNameController,
                                    enabled: !controller.isLoading,
                                    decoration: InputDecoration(
                                      hintText: 'Enter lobby name',
                                    ),
                                    style: AppTypography.kRegular19.copyWith(
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 18.h),

                            // Max Players
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 5.h,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Max Players',
                                    style: AppTypography.kBold21,
                                  ),
                                  DropdownButton<String>(
                                    value: controller.maxPlayers,
                                    underline: const SizedBox(),
                                    items:
                                        List.generate(7, (index) => index + 2)
                                            .map(
                                              (value) => DropdownMenuItem(
                                                value: value.toString(),
                                                child: Text(
                                                  value.toString(),
                                                  style:
                                                      AppTypography.kRegular19,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                    onChanged: controller.isLoading
                                        ? null
                                        : (value) =>
                                              controller.setMaxPlayers(value),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 18.h),
                            Row(
                              children: [
                                Text(
                                  'No. of Rounds',
                                  style: AppTypography.kBold21,
                                ),
                                const Spacer(),
                                ...[3, 5, 7].map(
                                  (round) => Padding(
                                    padding: EdgeInsets.only(left: 8.w),
                                    child: RoundSelectorCard(
                                      onTap: () => controller.setMaxRounds(
                                        round.toString(),
                                      ),
                                      isSelected:
                                          controller.maxRounds ==
                                          round.toString(),
                                      round: round.toString(),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10.h),
                            HandDrawnDivider(
                              color: AppColors.kGray300,
                              thickness: 1,
                              height: 16.h,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Time per round',
                              style: AppTypography.kBold21,
                            ),
                            SizedBox(height: 10.h),
                            Wrap(
                              spacing: 8.w,
                              children: [45, 60, 90]
                                  .map(
                                    (time) => TimeSelectorCard(
                                      onTap: () => controller.setTimerPerRound(
                                        time.toString(),
                                      ),
                                      time: time.toString(),
                                      isSelected:
                                          controller.timerPerRound ==
                                          time.toString(),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      ),

                      SizedBox(height: 20.h),

                      // Create Button
                      PageAnimation(
                        delay: const Duration(milliseconds: 400),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        startScale: 0.95,
                        child: PrimaryButton(
                        audioType: AudioType.whooshChime,
                        text: controller.isLoading
                            ? 'Creating...'
                            : 'Create Lobby',
                        width: double.infinity,
                        onPressed: controller.isLoading
                            ? () {}
                            : () => controller.createLobby(context),
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
