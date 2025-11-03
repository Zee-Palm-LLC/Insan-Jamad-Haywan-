import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';

class AudioService {
  static AudioService get instance => _instance;
  static final AudioService _instance = AudioService._();

  AudioService._();

  final player = AudioPlayer();

  Future<void> playAudio(AudioType audioType) async {
    log('playAudio: ${audioType.path}', name: 'AudioService');
    log('isSoundOn: ${AppService.getIsSoundOn()}', name: 'AudioService');
    if (AppService.getIsSoundOn()) {
      try {
        await player.play(AssetSource(audioType.path, mimeType: 'audio/wav'));
      } catch (e, stackTrace) {
        log(
          e.toString(),
          error: e,
          stackTrace: stackTrace,
          name: 'AudioService',
        );
      }
    }
  }
}

const String _clickSound = 'sounds/click.wav';
const String _gameStarted = 'sounds/game_started.wav';
const String _lobbyJoin = 'sounds/lobby_join.wav';
const String _lobbyLeave = 'sounds/lobby_leave.wav';
const String _scoreboard = 'sounds/scoreboard.wav';

enum AudioType { click, gameStarted, lobbyJoin, lobbyLeave, scoreboard }

extension AudioTypeExtension on AudioType {
  String get path => switch (this) {
    AudioType.click => _clickSound,
    AudioType.gameStarted => _gameStarted,
    AudioType.lobbyJoin => _lobbyJoin,
    AudioType.lobbyLeave => _lobbyLeave,
    AudioType.scoreboard => _scoreboard,
  };
}
