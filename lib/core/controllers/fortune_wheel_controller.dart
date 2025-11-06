import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';

class FortuneWheelController extends GetxController {
  StreamController<int>? _wheelController;
  Stream<int>? _wheelStream;
  late List<String> alphabets;
  final StreamController<int> wheelController =
      StreamController<int>.broadcast();
  int selectedIndex = 0;
  String? selectedAlphabet;
  bool isSpinning = false;
  bool showCountdown = false;
  int countdownValue = 3;

  final bool isHost;
  bool _isDisposed = false;

  Function(String letter)? onSpinComplete;
  Function(String letter)? onCountdownComplete;

  int? _lastSyncedIndex;
  bool? _lastSyncedSpinning;
  int? _lastSyncedCountdown;

  FortuneWheelController({this.isHost = true});

  LobbyController? get lobbyController {
    try {
      return Get.find<LobbyController>();
    } catch (e) {
      return null;
    }
  }

  static const int _fixedSeed = 12345;

  Stream<int> get wheelControllerStream {
    _wheelController ??= StreamController<int>.broadcast();
    _wheelStream ??= _wheelController!.stream;
    return _wheelStream!;
  }

  @override
  void onInit() {
    super.onInit();

    alphabets = List.generate(26, (i) => String.fromCharCode(65 + i));
    alphabets.shuffle(Random(_fixedSeed));

    if (!isHost && lobbyController != null) {
      _syncWithLobby();
    }
  }

  void syncWithLobby() {
    _syncWithLobby();
  }

  void _syncWithLobby() {
    if (lobbyController == null || isHost) return;

    if (lobbyController!.isWheelSpinning && _lastSyncedSpinning != true) {
      _lastSyncedSpinning = true;
      dev.log('Player: Received spin start command', name: 'WheelSync');
      _handleRemoteSpin();
    }

    if (lobbyController!.wheelSelectedIndex != null &&
        lobbyController!.wheelSelectedIndex != _lastSyncedIndex) {
      _lastSyncedIndex = lobbyController!.wheelSelectedIndex;

      dev.log(
        'Player: Received letter: ${lobbyController!.currentLetter} at index ${lobbyController!.wheelSelectedIndex}',
        name: 'WheelSync',
      );

      selectedIndex = lobbyController!.wheelSelectedIndex!;
      selectedAlphabet = lobbyController!.currentLetter;

      if (isSpinning) {
        isSpinning = false;
      }

      if (!wheelController.isClosed) {
        wheelController.add(selectedIndex);
      }

      _lastSyncedSpinning = false;
      update();
    }

    if (lobbyController!.isCountdownActive && !showCountdown) {
      dev.log(
        'Player: Countdown started - ${lobbyController!.countdownValue}',
        name: 'WheelSync',
      );
      showCountdown = true;
      countdownValue = lobbyController!.countdownValue;
      _lastSyncedCountdown = countdownValue;
      update();
    } else if (!lobbyController!.isCountdownActive && showCountdown) {
      dev.log('Player: Countdown completed', name: 'WheelSync');
      showCountdown = false;
      _lastSyncedCountdown = null;
      update();
      if (selectedAlphabet != null) {
        onCountdownComplete?.call(selectedAlphabet!);
      }
    } else if (lobbyController!.isCountdownActive &&
        showCountdown &&
        lobbyController!.countdownValue != _lastSyncedCountdown) {
      countdownValue = lobbyController!.countdownValue;
      _lastSyncedCountdown = countdownValue;
      update();
    }
  }

  Future<void> _handleRemoteSpin() async {
    if (isHost || isSpinning || wheelController.isClosed) return;

    isSpinning = true;
    update();

    try {
      await AudioService.instance.playAudio(AudioType.narratorChooseLetter);
      if (_isDisposed) return;

      await Future.delayed(const Duration(milliseconds: 500));
      if (_isDisposed) return;

      AudioService.instance.playAudio(AudioType.wheelSpin);
    } catch (e) {
      dev.log('Error playing audio: $e', name: 'WheelSpin');
    }
  }

  Future<void> spinWheel() async {
    if (isSpinning ||
        !isHost ||
        wheelController.isClosed ||
        showCountdown ||
        selectedAlphabet != null) {
      dev.log(
        'Cannot spin: isSpinning=$isSpinning, isHost=$isHost, showCountdown=$showCountdown, selectedAlphabet=$selectedAlphabet',
        name: 'WheelSpin',
      );
      return;
    }

    isSpinning = true;
    update();

    if (lobbyController != null) {
      await lobbyController!.broadcastWheelSpinStart();
    }

    await AudioService.instance.playAudio(AudioType.narratorChooseLetter);
    await Future.delayed(const Duration(milliseconds: 500));

    // Randomly select a letter
    final randomIndex = Random().nextInt(alphabets.length);
    selectedIndex = randomIndex;
    update();

    if (_isDisposed || _wheelController == null || _wheelController!.isClosed) {
      isSpinning = false;
      update();
      return;
    }

    AudioService.instance.playAudio(AudioType.wheelSpin);

    if (!wheelController.isClosed) {
      _wheelController!.add(selectedIndex);
    }
  }

  void triggerRemoteSpin(int index) {
    if (isHost || wheelController.isClosed) return;

    selectedIndex = index;
    if (!wheelController.isClosed) {
      wheelController.add(index);
    }
  }

  Future<void> handleSpinComplete() async {
    if (_isDisposed) return;

    try {
      final letter = alphabets[selectedIndex];
      selectedAlphabet = letter;
      isSpinning = false;
      update();

      if (_isDisposed) return;
      await Future.delayed(const Duration(milliseconds: 300));
      if (_isDisposed) return;
      await AudioService.instance.playAudio(AudioType.narratorTheLetterIs);

      if (_isDisposed) return;
      await Future.delayed(const Duration(milliseconds: 800));

      if (isHost && lobbyController != null) {
        await lobbyController!.broadcastSelectedLetter(letter, selectedIndex);
      }

      if (_isDisposed) return;
      onSpinComplete?.call(letter);
    } catch (e) {
      dev.log('Error in handleSpinComplete: $e', name: 'WheelSpin');
      // Reset state if error occurs
      isSpinning = false;
      update();
    }
  }

  Future<void> triggerCountdown() async {
    dev.log(
      'triggerCountdown called - selectedAlphabet: $selectedAlphabet, showCountdown: $showCountdown, isHost: $isHost',
      name: 'FortuneWheel',
    );

    if (selectedAlphabet == null || showCountdown) {
      dev.log(
        'Cannot trigger countdown: selectedAlphabet=$selectedAlphabet, showCountdown=$showCountdown',
        name: 'FortuneWheel',
      );
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (isHost) {
      // Ensure spinning is false before starting countdown
      isSpinning = false;
      showCountdown = true;
      countdownValue = 3;
      update();

      for (int i = 3; i > 0; i--) {
        countdownValue = i;
        update();

        if (lobbyController != null) {
          await lobbyController!.broadcastCountdown(i);
        }

        await AudioService.instance.playAudio(AudioType.countdown);
        await Future.delayed(const Duration(seconds: 1));
      }

      showCountdown = false;
      update();

      if (lobbyController != null) {
        await lobbyController!.broadcastCountdownComplete();
      }

      dev.log(
        'Countdown complete - calling onCountdownComplete with letter: $selectedAlphabet',
        name: 'FortuneWheel',
      );

      if (onCountdownComplete != null) {
        onCountdownComplete!(selectedAlphabet!);
      } else {
        dev.log('onCountdownComplete callback is null!', name: 'FortuneWheel');
      }
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    _wheelController?.close();
    _wheelController = null;
    _wheelStream = null;
    super.onClose();
  }
}
