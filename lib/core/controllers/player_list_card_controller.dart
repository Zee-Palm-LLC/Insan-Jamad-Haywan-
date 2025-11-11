import 'dart:async';

import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';

class PlayerListCardController extends GetxController {
  final List<String> joinedPlayers = [];
  List<String> _allPlayers = [];
  bool _isSimulating = false;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  void initializePlayers(List<String> players) {
    if (_isInitialized) return;
    _isInitialized = true;
    _allPlayers = players;
    _simulateJoining();
  }

  void updatePlayers(List<String> players) {
    final newPlayers = players
        .where((p) => !joinedPlayers.contains(p))
        .toList();
    if (newPlayers.isEmpty) {
      joinedPlayers.removeWhere((p) => !players.contains(p));
      _allPlayers = players;
      return;
    }

    joinedPlayers.removeWhere((p) => !players.contains(p));

    _allPlayers = players;
    if (!_isSimulating) {
      _simulateJoining();
    }
  }

  Future<void> _simulateJoining() async {
    if (_isSimulating) return;

    final newPlayers = _allPlayers
        .where((p) => !joinedPlayers.contains(p))
        .toList();

    if (newPlayers.isEmpty) return;

    _isSimulating = true;

    for (final player in newPlayers) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!joinedPlayers.contains(player) && _allPlayers.contains(player)) {
        joinedPlayers.add(player);
        update();
        // await AudioService.instance.playAudio(AudioType.lobbyJoin);
      }
    }

    _isSimulating = false;
  }

  @override
  void onClose() {
    _isSimulating = false;
    AudioService.instance.player.stop();
    super.onClose();
  }
}
