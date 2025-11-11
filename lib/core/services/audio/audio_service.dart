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
  final timerPlayer = AudioPlayer(); // Separate player for timer ticks
  bool _isPlaying = false;

  Future<void> playAudio(AudioType audioType) async {
    // if (AppHelpers.getIsSoundOn()) {
    // For timer ticking sounds, use separate player to allow continuous ticking
    final isTimerTick = audioType == AudioType.timer;
    final audioPlayer = isTimerTick ? timerPlayer : player;
    
    try {
      if (!isTimerTick && _isPlaying) {
        try {
          await player.stop();
          await Future.delayed(const Duration(milliseconds: 50));
        } catch (e) {}
      }

      // Determine mime type based on file extension
      final path = audioType.path;
      final mimeType = path.endsWith('.mp3') ? 'audio/mpeg' : 'audio/wav';

      if (!isTimerTick) {
        _isPlaying = true;
      }
      
      await audioPlayer.play(AssetSource(path, mimeType: mimeType));
    } catch (e, stackTrace) {
      if (!isTimerTick) {
        _isPlaying = false;
      }

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
const String _whooshChime = 'audios/whoosh_chime.mp3';
const String _narratorCreative = 'audios/game_started.wav';
const String _spinnningWheel = 'audios/spinnning_wheel.mp3';
const String _letterA = 'audios/a.mp3';
const String _letterB = 'audios/b.mp3';
const String _letterC = 'audios/c.mp3';
const String _letterD = 'audios/d.mp3';
const String _letterE = 'audios/e.mp3';
const String _letterF = 'audios/f.mp3';
const String _letterG = 'audios/g.mp3';
const String _letterH = 'audios/h.mp3';
const String _letterI = 'audios/i.mp3';
const String _letterJ = 'audios/j.mp3';
const String _letterK = 'audios/k.mp3';
const String _letterL = 'audios/l.mp3';
const String _letterM = 'audios/m.mp3';
const String _letterN = 'audios/n.mp3';
const String _letterO = 'audios/o.mp3';
const String _letterP = 'audios/p.mp3';
const String _letterQ = 'audios/q.mp3';
const String _letterR = 'audios/r.mp3';
const String _letterS = 'audios/s.mp3';
const String _letterT = 'audios/t.mp3';
const String _letterU = 'audios/u.mp3';
const String _letterV = 'audios/v.mp3';
const String _letterW = 'audios/w.mp3';
const String _letterX = 'audios/x.mp3';
const String _letterY = 'audios/y.mp3';
const String _letterZ = 'audios/z.mp3';
const String _timer = 'audios/timer.mp3';
const String _stop = 'audios/stop.mp3';
const String _timerFinished = 'audios/timer_finish.mp3';

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
  whooshChime,
  spinnningWheel,
  letterA,
  letterB,
  letterC,
  letterD,
  letterE,
  letterF,
  letterG,
  letterH,
  letterI,
  letterJ,
  letterK,
  letterL,
  letterM,
  letterN,
  letterO,
  letterP,
  letterQ,
  letterR,
  letterS,
  letterT,
  letterU,
  letterV,
  letterW,
  letterX,
  letterY,
  letterZ,
  timer,
  stop,
  timerFinished,
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
    AudioType.whooshChime => _whooshChime,
    AudioType.spinnningWheel => _spinnningWheel,
    AudioType.letterA => _letterA,
    AudioType.letterB => _letterB,
    AudioType.letterC => _letterC,
    AudioType.letterD => _letterD,
    AudioType.letterE => _letterE,
    AudioType.letterF => _letterF,
    AudioType.letterG => _letterG,
    AudioType.letterH => _letterH,
    AudioType.letterI => _letterI,
    AudioType.letterJ => _letterJ,
    AudioType.letterK => _letterK,
    AudioType.letterL => _letterL,
    AudioType.letterM => _letterM,
    AudioType.letterN => _letterN,
    AudioType.letterO => _letterO,
    AudioType.letterP => _letterP,
    AudioType.letterQ => _letterQ,
    AudioType.letterR => _letterR,
    AudioType.letterS => _letterS,
    AudioType.letterT => _letterT,
    AudioType.letterU => _letterU,
    AudioType.letterV => _letterV,
    AudioType.letterW => _letterW,
    AudioType.letterX => _letterX,
    AudioType.letterY => _letterY,
    AudioType.letterZ => _letterZ,
    AudioType.timer => _timer,
    AudioType.stop => _stop,
    AudioType.timerFinished => _timerFinished,
  };
}
