import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/modules/get_started/get_started_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/answers_host/answers_host_view.dart';
import 'package:insan_jamd_hawan/core/modules/players/player_answers/player_answer_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/create_lobby/create_lobby_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/final_round/final_round_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/game_lobby/game_lobby_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/letter_generator/letter_generator_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/scoreboard_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoring/scoring_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/voting/voting_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/waiting_view/waiting_view.dart';
import 'package:insan_jamd_hawan/core/modules/main_menu/main_menu_page.dart';
import 'package:insan_jamd_hawan/core/modules/players/player_info/player_info.dart';
import 'package:insan_jamd_hawan/core/modules/players/player_wheel/player_wheel_view.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';

typedef R = AppRouter;

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: GetStartedView.path,
    redirect: _handleRedirect,
    routes: [
      GoRoute(
        path: GetStartedView.path,
        name: GetStartedView.name,
        builder: (context, state) => const GetStartedView(),
      ),
      GoRoute(
        path: WaitingView.path,
        name: WaitingView.name,
        builder: (context, state) => const WaitingView(),
      ),
      GoRoute(
        path: LobbyCreationPage.path,
        name: LobbyCreationPage.name,
        builder: (context, state) => const LobbyCreationPage(),
      ),
      GoRoute(
        path: LetterGeneratorView.path,
        name: LetterGeneratorView.name,
        builder: (context, state) => const LetterGeneratorView(),
      ),
      GoRoute(
        path: PlayerInfo.path,
        name: PlayerInfo.name,
        builder: (context, state) {
          return const PlayerInfo();
        },
      ),
      GoRoute(
        path: AnswersHostView.path,
        name: AnswersHostView.name,
        builder: (context, state) {
          final letter = state.pathParameters['letter'] ?? 'A';
          final extra = state.extra as Map<String, dynamic>?;

          if (extra == null) {
            return const Scaffold(
              body: Center(
                child: Text('Missing session data. Please start from lobby.'),
              ),
            );
          }

          return AnswersHostView(
            selectedAlphabet: letter,
            sessionId: extra['sessionId'] as String,
            roundNumber: extra['roundNumber'] as int,
            totalSeconds: extra['totalSeconds'] as int? ?? 60,
          );
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
      GoRoute(path: '/', redirect: (context, state) => MainMenuPage.path),
      GoRoute(
        path: MainMenuPage.path,
        name: MainMenuPage.name,
        builder: (context, state) => const MainMenuPage(),
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
        path: PlayerWheelView.path,
        name: PlayerWheelView.name,
        builder: (context, state) => const PlayerWheelView(),
      ),
      GoRoute(
        path: PlayerAnswerView.path,
        name: PlayerAnswerView.name,
        builder: (context, state) {
          final letter = state.uri.queryParameters['letter'] ?? 'A';
          final extra = state.extra as Map<String, dynamic>?;

          if (extra == null) {
            return const Scaffold(
              body: Center(
                child: Text('Missing session data. Please start from lobby.'),
              ),
            );
          }

          return PlayerAnswerView(
            selectedLetter: letter,
            sessionId: extra['sessionId'] as String,
            roundNumber: extra['roundNumber'] as int,
            totalSeconds: extra['totalSeconds'] as int? ?? 60,
          );
        },
      ),
    ],
  );

  static Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final playerId = await AppService.getPlayerId();
    final hasUsername =
        playerId != null &&
        playerId.isNotEmpty &&
        !playerId.startsWith('guest_');

    final isOnPlayerInfo = state.matchedLocation == PlayerInfo.path;

    if (!hasUsername && !isOnPlayerInfo) {
      print('[Router] No username found, redirecting to player-info');
      return PlayerInfo.path;
    }

    if (hasUsername && isOnPlayerInfo) {
      print('[Router] Username exists, redirecting to main menu');
      return MainMenuPage.path;
    }

    return null;
  }
}
