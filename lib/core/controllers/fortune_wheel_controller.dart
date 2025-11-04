import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';

class FortuneWheelController extends GetxController {
  late List<String> alphabets;
  final StreamController<int> wheelController = StreamController<int>();
  int selectedIndex = 0;
  String? selectedAlphabet;
  bool isSpinning = false;
  bool showCountdown = false;
  int countdownValue = 3;

  Function(String letter)? onSpinComplete;
  Function(String letter)? onCountdownComplete;

  @override
  void onInit() {
    super.onInit();
    // Generate alphabets and shuffle them randomly each time
    alphabets = List.generate(26, (i) => String.fromCharCode(65 + i));
    alphabets.shuffle(Random());
  }

  Future<void> spinWheel() async {
    if (isSpinning) return;

    isSpinning = true;
    update();

    await AudioService.instance.playAudio(AudioType.narratorChooseLetter);
    await Future.delayed(const Duration(milliseconds: 500));

    final randomIndex = Random().nextInt(alphabets.length);
    selectedIndex = randomIndex;
    update();

    AudioService.instance.playAudio(AudioType.wheelSpin);
    wheelController.add(randomIndex);
  }

  Future<void> handleSpinComplete() async {
    final letter = alphabets[selectedIndex];
    selectedAlphabet = letter;
    update();

    await Future.delayed(const Duration(milliseconds: 300));
    await AudioService.instance.playAudio(AudioType.narratorTheLetterIs);

    await Future.delayed(const Duration(milliseconds: 800));

    onSpinComplete?.call(letter);

    await Future.delayed(const Duration(milliseconds: 1500));

    showCountdown = true;
    countdownValue = 3;
    update();

    for (int i = 3; i > 0; i--) {
      countdownValue = i;
      update();
      await AudioService.instance.playAudio(AudioType.countdown);
      await Future.delayed(const Duration(seconds: 1));
    }

    showCountdown = false;
    update();

    onCountdownComplete?.call(letter);
  }

  @override
  void onClose() {
    wheelController.close();
    super.onClose();
  }
}
