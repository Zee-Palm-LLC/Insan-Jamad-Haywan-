import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/core/modules/players/main_menu/components/join_lobby_dialog.dart';
import 'package:insan_jamd_hawan/core/modules/players/main_menu/components/menu_button.dart';
import 'package:insan_jamd_hawan/core/modules/players/main_menu/components/player_tile.dart';
import 'package:insan_jamd_hawan/core/modules/players/main_menu/main_menu_controller.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/cards/desktop_wrapper.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  static const String path = '/main-menu';
  static const String name = 'MainMenu';

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return GetBuilder<MainMenuController>(
      init: MainMenuController(),
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
                      onTap: () {},
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
                      SizedBox(height: 48.h),
                      PlayerTile(
                        name: controller.playerName,
                        onTap: controller.showChangeNameDialog,
                      ),
                      SizedBox(height: 32.h),
                      Text(
                        'Enter into the lobby to start the game...',
                        style: AppTypography.kBold21.copyWith(height: 1.2),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Expanded(
                            child: MenuButton(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => JoinLobbyDialog(),
                                );
                              },
                              icon: AppAssets.joinLobby,
                              name: 'Join Lobby',
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: MenuButton(
                              onTap: () {
                                context.push('/create-lobby');
                              },
                              icon: AppAssets.createLobby,
                              name: 'Create Lobby',
                            ),
                          ),
                        ],
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
