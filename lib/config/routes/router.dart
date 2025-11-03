import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/app.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/game_lobby_view.dart';
import 'package:insan_jamd_hawan/modules/main_menu/main_menu_page.dart';
import 'package:insan_jamd_hawan/modules/join_lobby/join_lobby_page.dart';
import 'package:insan_jamd_hawan/modules/create_lobby/lobby_creation_page.dart';
import 'package:insan_jamd_hawan/modules/solo_game/solo_game_page.dart';

typedef R = AppRouter;

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: MainMenuPage.path,
    routes: [
      GoRoute(path: '/', redirect: (context, state) => MainMenuPage.path),
      GoRoute(
        path: MainMenuPage.path,
        name: MainMenuPage.name,
        builder: (context, state) => const MainMenuPage(),
      ),

      GoRoute(
        path: JoinLobbyPage.path,
        name: JoinLobbyPage.name,
        builder: (context, state) => const JoinLobbyPage(),
      ),

      GoRoute(
        path: LobbyCreationPage.path,
        name: LobbyCreationPage.name,
        builder: (context, state) => const LobbyCreationPage(),
      ),

      GoRoute(
        path: '/lobby/:id',
        name: 'GameLobby',
        builder: (context, state) {
          final controller = state.extra as LobbyController?;
          if (controller == null) {
            return const Scaffold(body: Center(child: Text('Lobby not found')));
          }
          return GameLobbyView(controller: controller);
        },
      ),

      GoRoute(
        path: SoloGamePage.path,
        name: SoloGamePage.name,
        builder: (context, state) => const SoloGamePage(),
      ),
    ],
  );
}
