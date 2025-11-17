import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/wheel_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/components/final_scoreboard_list.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/scoreboard/components/final_scoreboard_podium.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';

class ScoreboardController extends GetxController {
  // Regular scoreboard data
  final List<Map<String, dynamic>> shownPlayers = [];

  // Final scoreboard data
  List<PodiumPlayer> podiumPlayers = [];
  List<ScoreboardListPlayer> listPlayers = [];

  bool isLoading = true;
  String? error;
  bool isFinalRound = false;

  LobbyController get lobbyController => Get.find<LobbyController>();
  WheelController get wheelController => Get.find<WheelController>();
  FirebaseFirestoreService get _firestore => FirebaseFirestoreService.instance;

  @override
  void onInit() {
    super.onInit();
    loadScoreboardData();
  }

  Future<void> loadScoreboardData() async {
    try {
      isLoading = true;
      error = null;
      update();

      final sessionId = lobbyController.lobby.id;
      if (sessionId == null || sessionId.isEmpty) {
        throw Exception('Session ID is not available');
      }

      final session = await _firestore.getSession(sessionId);
      if (session == null) {
        throw Exception('Session not found');
      }

      final currentRound = session.config.currentRound;
      final maxRounds = session.config.maxRounds;
      isFinalRound = currentRound >= maxRounds;

      log(
        'Scoreboard: currentRound=$currentRound, maxRounds=$maxRounds, isFinalRound=$isFinalRound',
      );

      final players = await _firestore.getLeaderboard(sessionId);
      log('Scoreboard: Retrieved ${players.length} players from leaderboard');

      if (isFinalRound) {
        await _loadFinalRoundData(sessionId, players);
      } else {
        await _loadRegularRoundData(sessionId, players);
      }

      isLoading = false;
      log(
        'Scoreboard data loaded. isLoading=$isLoading, podiumPlayers=${podiumPlayers.length}, listPlayers=${listPlayers.length}',
      );
      update();
      log('Update() called after loading data');
    } catch (e, stackTrace) {
      log(
        'Error loading scoreboard data: $e',
        error: e,
        stackTrace: stackTrace,
      );
      error = e.toString();
      isLoading = false;
      update();
    }
  }

  Future<void> _loadRegularRoundData(String sessionId, List players) async {
    final currentRound = wheelController.currentRound;

    final roundAnswers = await _firestore.getAllAnswers(
      sessionId,
      currentRound,
    );

    final roundScoresMap = <String, int>{};
    for (final answer in roundAnswers) {
      roundScoresMap[answer.playerId] = answer.scoring?.roundScore ?? 0;
    }

    final List<Map<String, dynamic>> playersData = [];
    for (int i = 0; i < players.length; i++) {
      final player = players[i];
      final rank = i + 1;
      final pointsGained = roundScoresMap[player.playerId] ?? 0;

      playersData.add({
        'playerId': player.playerId,
        'name': player.playerName,
        'avatarUrl': player.playerAvatar ?? '',
        'totalPoints': player.totalScore,
        'pointsGained': pointsGained,
        'rank': rank,
      });
    }

    shownPlayers.clear();
    for (final player in playersData) {
      await Future.delayed(const Duration(milliseconds: 300));
      shownPlayers.add(player);
      update();
    }
  }

  Future<void> _loadFinalRoundData(String sessionId, List players) async {
    log('Loading final round data. Players count: ${players.length}');
    log(
      'Players: ${players.map((p) => '${p.playerName} (${p.playerId}): totalScore=${p.totalScore}, scoresByRound=${p.scoresByRound}').join(', ')}',
    );

    final allRounds = await _firestore.getAllRounds(sessionId);
    log('Total rounds: ${allRounds.length}');

    final totalPointsGainedMap = <String, int>{};
    
    // Calculate points from regular rounds
    for (final round in allRounds) {
      final roundAnswers = await _firestore.getAllAnswers(
        sessionId,
        round.roundNumber,
      );
      for (final answer in roundAnswers) {
        final roundScore = answer.scoring?.roundScore ?? 0;
        totalPointsGainedMap[answer.playerId] =
            (totalPointsGainedMap[answer.playerId] ?? 0) + roundScore;
      }
    }
    
    // Add points from special round
    try {
      final specialRoundAnswers = await _firestore.getAllSpecialRoundAnswers(sessionId);
      log('Special round answers found: ${specialRoundAnswers.length}');
      for (final answer in specialRoundAnswers) {
        final roundScore = answer.scoring?.roundScore ?? 0;
        totalPointsGainedMap[answer.playerId] =
            (totalPointsGainedMap[answer.playerId] ?? 0) + roundScore;
        log('Added special round score for ${answer.playerId}: $roundScore');
      }
    } catch (e) {
      log('No special round answers or error fetching them: $e');
    }
    
    log('Total points gained map (including special round): $totalPointsGainedMap');

    podiumPlayers = [];
    for (int i = 0; i < players.length && i < 3; i++) {
      final player = players[i];

      int totalPointsGained = totalPointsGainedMap[player.playerId] ?? 0;
      if (totalPointsGained == 0 && player.scoresByRound.isNotEmpty) {
        for (final roundScore in player.scoresByRound.values) {
          totalPointsGained += roundScore as int;
        }
      }

      log(
        'Player ${player.playerName}: totalScore=${player.totalScore}, totalPointsGained=$totalPointsGained',
      );

      String badge;
      Color color;
      Color textColor;

      if (i == 0) {
        badge = AppAssets.firstBadge;
        color = AppColors.kPrimary;
        textColor = AppColors.kWhite;
      } else if (i == 1) {
        badge = AppAssets.secondBadge;
        color = const Color(0xFFFED643);
        textColor = AppColors.kBlack;
      } else {
        badge = AppAssets.thirdBadge;
        color = const Color(0xFFBED6E2);
        textColor = AppColors.kBlack;
      }

      podiumPlayers.add(
        PodiumPlayer(
          totalScore: player.totalScore,
          rank: i + 1,
          name: player.playerName,
          score:
              '+${totalPointsGained.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          avatarUrl: player.playerAvatar ?? '',
          color: color,
          badge: badge,
          textColor: textColor,
        ),
      );
    }

    log('Podium players count: ${podiumPlayers.length}');
    log(
      'Podium players: ${podiumPlayers.map((p) => '${p.name} (rank ${p.rank})').join(', ')}',
    );

    listPlayers = [];
    for (int i = 3; i < players.length; i++) {
      final player = players[i];

      int totalPointsGained = totalPointsGainedMap[player.playerId] ?? 0;
      if (totalPointsGained == 0 && player.scoresByRound.isNotEmpty) {
        for (final roundScore in player.scoresByRound.values) {
          totalPointsGained += roundScore as int;
        }
      }

      listPlayers.add(
        ScoreboardListPlayer(
          rank: '${i + 1}th',
          name: player.playerName,
          totalPoints: '${player.totalScore} pts',
          pointsGained: '+$totalPointsGained',
          avatarUrl: player.playerAvatar ?? '',
        ),
      );
    }

    shownPlayers.clear();
    for (int i = 0; i < players.length; i++) {
      final player = players[i];
      int totalPointsGained = totalPointsGainedMap[player.playerId] ?? 0;
      if (totalPointsGained == 0 && player.scoresByRound.isNotEmpty) {
        for (final roundScore in player.scoresByRound.values) {
          totalPointsGained += roundScore as int;
        }
      }

      shownPlayers.add({
        'playerId': player.playerId,
        'name': player.playerName,
        'avatarUrl': player.playerAvatar ?? '',
        'totalPoints': player.totalScore,
        'pointsGained': totalPointsGained,
        'rank': i + 1,
      });
    }
  }

  String getPositionText(int rank) {
    if (rank == 1) return '1st';
    if (rank == 2) return '2nd';
    if (rank == 3) return '3rd';
    return '${rank}th';
  }
}
