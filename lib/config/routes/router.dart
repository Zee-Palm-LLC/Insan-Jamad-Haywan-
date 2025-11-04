import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/app.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/modules/create_lobby/lobby_creation_page.dart';
import 'package:insan_jamd_hawan/modules/hosts/answers_host/answers_host_view.dart';
import 'package:insan_jamd_hawan/modules/hosts/final_round/final_round_view.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/game_lobby_view.dart';
import 'package:insan_jamd_hawan/modules/hosts/letter_generator/letter_generator_view.dart';
import 'package:insan_jamd_hawan/modules/hosts/scoreboard/scoreboard_view.dart';
import 'package:insan_jamd_hawan/modules/hosts/scoring/scoring_view.dart';
import 'package:insan_jamd_hawan/modules/hosts/voting/voting_view.dart';
import 'package:insan_jamd_hawan/modules/join_lobby/join_lobby_page.dart';
import 'package:insan_jamd_hawan/modules/main_menu/main_menu_page.dart';
import 'package:insan_jamd_hawan/modules/solo_game/solo_game_page.dart';

typedef R = AppRouter;

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: MainMenuPage.path,
    routes: [
      // Host Pages
      GoRoute(
        path: LetterGeneratorView.path,
        name: LetterGeneratorView.name,
        builder: (context, state) {
          final controller = state.extra as LobbyController?;
          return LetterGeneratorView(controller: controller);
        },
      ),
      GoRoute(
        path: AnswersHostView.path,
        name: AnswersHostView.name,
        builder: (context, state) {
          final letter = state.pathParameters['letter'] ?? 'A';
          return AnswersHostView(selectedAlphabet: letter);
        },
      ),
      GoRoute(
        path: ScoringView.path,
        name: ScoringView.name,
        builder: (context, state) {
          final letter = state.pathParameters['letter'] ?? 'A';
          return ScoringView(selectedAlphabet: letter);
        },
      ),
      GoRoute(
        path: VotingView.path,
        name: VotingView.name,
        builder: (context, state) {
          final letter = state.pathParameters['letter'] ?? 'A';
          return VotingView(selectedAlphabet: letter);
        },
      ),
      GoRoute(
        path: ScoreboardView.path,
        name: ScoreboardView.name,
        builder: (context, state) => const ScoreboardView(),
      ),
      GoRoute(
        path: FinalRoundView.path,
        name: FinalRoundView.name,
        builder: (context, state) {
          final isPlayer = state.uri.queryParameters['isPlayer'] == 'true';
          final letter = state.uri.queryParameters['letter'];
          final category = state.uri.queryParameters['category'];
          return FinalRoundView(
            isPlayer: isPlayer,
            selectedAlphabet: letter,
            category: category,
          );
        },
      ),
      // Player Pages
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
