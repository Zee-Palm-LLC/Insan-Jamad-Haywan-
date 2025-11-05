import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';

class FortuneWheelController extends GetxController {
  late List<String> alphabets;
  final StreamController<int> wheelController =
      StreamController<int>.broadcast();
  int selectedIndex = 0;
  String? selectedAlphabet;
  bool isSpinning = false;
  bool showCountdown = false;
  int countdownValue = 3;

  final bool isHost;
  final LobbyController? lobbyController;

  Function(String letter)? onSpinComplete;
  Function(String letter)? onCountdownComplete;

  int? _lastSyncedIndex;
  bool? _lastSyncedSpinning;
  int? _lastSyncedCountdown;

  FortuneWheelController({this.isHost = true, this.lobbyController});

  static const int _fixedSeed = 12345;

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

    // Sync wheel spinning state (only trigger once)
    if (lobbyController!.isWheelSpinning && _lastSyncedSpinning != true) {
      _lastSyncedSpinning = true;
      dev.log('Player: Received spin start command', name: 'WheelSync');
      _handleRemoteSpin();
    }

    // Sync selected letter and index (only when changed and not spinning)
    if (lobbyController!.wheelSelectedIndex != null &&
        lobbyController!.wheelSelectedIndex != _lastSyncedIndex &&
        !lobbyController!.isWheelSpinning) {
      _lastSyncedIndex = lobbyController!.wheelSelectedIndex;
      _lastSyncedSpinning = false;

      dev.log(
        'Player: Received letter: ${lobbyController!.currentLetter} at index ${lobbyController!.wheelSelectedIndex}',
        name: 'WheelSync',
      );

      selectedIndex = lobbyController!.wheelSelectedIndex!;
      selectedAlphabet = lobbyController!.currentLetter;
      isSpinning = false;

      // Trigger the wheel to spin to this index
      if (!wheelController.isClosed) {
        wheelController.add(selectedIndex);
      }
      update();
    }

    // Sync countdown state
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
    if (isHost || isSpinning) return;

    isSpinning = true;
    update();

    // Play narrator audio first
    await AudioService.instance.playAudio(AudioType.narratorChooseLetter);
    await Future.delayed(const Duration(milliseconds: 500));

    // Play wheel spin sound
    await AudioService.instance.playAudio(AudioType.wheelSpin);
  }

  Future<void> spinWheel() async {
    if (isSpinning || !isHost || wheelController.isClosed) return;

    isSpinning = true;
    update();

    // Broadcast spin start to all players
    if (lobbyController != null) {
      await lobbyController!.broadcastWheelSpinStart();
    }

    await AudioService.instance.playAudio(AudioType.narratorChooseLetter);
    await Future.delayed(const Duration(milliseconds: 500));

    final randomIndex = Random().nextInt(alphabets.length);
    selectedIndex = randomIndex;
    update();

    AudioService.instance.playAudio(AudioType.wheelSpin);

    if (!wheelController.isClosed) {
      wheelController.add(randomIndex);
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
    final letter = alphabets[selectedIndex];
    selectedAlphabet = letter;
    update();

    await Future.delayed(const Duration(milliseconds: 300));
    await AudioService.instance.playAudio(AudioType.narratorTheLetterIs);

    await Future.delayed(const Duration(milliseconds: 800));

    if (isHost && lobbyController != null) {
      await lobbyController!.broadcastSelectedLetter(letter, selectedIndex);
    }

    onSpinComplete?.call(letter);

    await Future.delayed(const Duration(milliseconds: 1500));

    if (isHost) {
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

      onCountdownComplete?.call(letter);
    }
  }

  @override
  void onClose() {
    wheelController.close();
    super.onClose();
  }
}
