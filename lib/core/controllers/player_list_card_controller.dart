import 'dart:async';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';

class PlayerListCardController extends GetxController {
  final List<String> joinedPlayers = [];
  List<String> _allPlayers = [];

  void initializePlayers(List<String> players) {
    _allPlayers = players;
    _simulateJoining();
  }

  void updatePlayers(List<String> players) {
    joinedPlayers.removeWhere((p) => !players.contains(p));
    _allPlayers = players;
    _simulateJoining();
  }

  Future<void> _simulateJoining() async {
    final newPlayers = _allPlayers
        .where((p) => !joinedPlayers.contains(p))
        .toList();

    for (final player in newPlayers) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!joinedPlayers.contains(player) && _allPlayers.contains(player)) {
        joinedPlayers.add(player);
        update();
        await AudioService.instance.playAudio(AudioType.lobbyJoin);
      }
    }
  }
}
