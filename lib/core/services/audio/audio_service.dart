import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static AudioService get instance => _instance;
  static final AudioService _instance = AudioService._();

  AudioService._() {
    // Set up listener once to track when audio completes
    player.onPlayerComplete.listen((_) {
      _isPlaying = false;
    });
  }

  final player = AudioPlayer();
  bool _isPlaying = false;

  Future<void> playAudio(AudioType audioType) async {
    // if (AppHelpers.getIsSoundOn()) {
    try {
      if (_isPlaying) {
        try {
          await player.stop();
          await Future.delayed(const Duration(milliseconds: 50));
        } catch (e) {}
      }

      _isPlaying = true;
      await player.play(AssetSource(audioType.path, mimeType: 'audio/wav'));
    } catch (e, stackTrace) {
      _isPlaying = false;

      final errorMessage = e.toString();
      if (errorMessage.contains('AbortError') ||
          errorMessage.contains('play() request was interrupted') ||
          errorMessage.contains('The play() request was interrupted')) {
        return;
      }

      log(errorMessage, error: e, stackTrace: stackTrace, name: 'AudioService');
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
const String _playerJoinPop = 'audios/lobby_join.wav';
const String _gameStartWhoosh = 'audios/game_started.wav';
const String _answerRevealPop = 'audios/lobby_join.wav';
const String _pointsCash = 'audios/scoreboard.wav';
const String _narratorCreative = 'audios/game_started.wav';

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
  playerJoinPop,
  gameStartWhoosh,
  answerRevealPop,
  pointsCash,
  narratorCreative,
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
    AudioType.playerJoinPop => _playerJoinPop,
    AudioType.gameStartWhoosh => _gameStartWhoosh,
    AudioType.answerRevealPop => _answerRevealPop,
    AudioType.pointsCash => _pointsCash,
    AudioType.narratorCreative => _narratorCreative,
  };
}
