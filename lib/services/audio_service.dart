import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static AudioService get instance => _instance;
  static final AudioService _instance = AudioService._();

  AudioService._();

  final player = AudioPlayer();

  Future<void> playAudio(AudioType audioType) async {
    // if (AppHelpers.getIsSoundOn()) {
    try {
      await player.play(AssetSource(audioType.path, mimeType: 'audio/wav'));
    } catch (e, stackTrace) {
      log(e.toString(), error: e, stackTrace: stackTrace, name: 'AudioService');
    }
    // }
  }
}

const String _clickSound = 'audios/click.wav';
const String _gameStarted = 'audios/game_started.wav';
const String _lobbyJoin = 'audios/lobby_join.wav';
const String _lobbyLeave = 'audios/lobby_leave.wav';
const String _scoreboard = 'audios/scoreboard.wav';
const String _narratorChooseLetter = 'audios/narrator_choose_letter.wav';
const String _narratorTheLetterIs = 'audios/narrator_the_letter_is.wav';
const String _wheelSpin = 'audios/wheel_spin.wav';
const String _countdown = 'audios/countdown.wav';

enum AudioType {
  click,
  gameStarted,
  lobbyJoin,
  lobbyLeave,
  scoreboard,
  narratorChooseLetter,
  narratorTheLetterIs,
  wheelSpin,
  countdown,
}

extension AudioTypeExtension on AudioType {
  String get path => switch (this) {
    AudioType.click => _clickSound,
    AudioType.gameStarted => _gameStarted,
    AudioType.lobbyJoin => _lobbyJoin,
    AudioType.lobbyLeave => _lobbyLeave,
    AudioType.scoreboard => _scoreboard,
    AudioType.narratorChooseLetter => _narratorChooseLetter,
    AudioType.narratorTheLetterIs => _narratorTheLetterIs,
    AudioType.wheelSpin => _wheelSpin,
    AudioType.countdown => _countdown,
  };
}
