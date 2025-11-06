import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';

class FortuneWheelController extends GetxController {
  late List<String> alphabets;
  StreamController<int>? _wheelController;
  Stream<int>? _wheelStream;
  int selectedIndex = 0;
  String? selectedAlphabet;
  bool isSpinning = false;
  bool showCountdown = false;
  int countdownValue = 3;
  bool _isDisposed = false;

  Function(String letter)? onSpinComplete;
  Function(String letter)? onCountdownComplete;

  Stream<int> get wheelControllerStream {
    _wheelController ??= StreamController<int>.broadcast();
    _wheelStream ??= _wheelController!.stream;
    return _wheelStream!;
  }

  @override
  void onInit() {
    super.onInit();
    // Generate alphabets and shuffle them randomly each time
    alphabets = List.generate(26, (i) => String.fromCharCode(65 + i));
    alphabets.shuffle(Random());
    // Initialize stream controller
    _wheelController ??= StreamController<int>.broadcast();
    _wheelStream ??= _wheelController!.stream;
  }

  Future<void> spinWheel() async {
    if (isSpinning || _isDisposed) return;
    if (_wheelController == null || _wheelController!.isClosed) return;

    isSpinning = true;
    update();

    try {
      await AudioService.instance.playAudio(AudioType.narratorChooseLetter);
      if (_isDisposed) return;

      await Future.delayed(const Duration(milliseconds: 500));
      if (_isDisposed) return;

      final randomIndex = Random().nextInt(alphabets.length);
      selectedIndex = randomIndex;
      update();

      if (_isDisposed || _wheelController == null || _wheelController!.isClosed) {
        isSpinning = false;
        update();
        return;
      }

      AudioService.instance.playAudio(AudioType.wheelSpin);
      _wheelController!.add(randomIndex);
    } catch (e) {
      // Reset state if error occurs
      isSpinning = false;
      update();
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

      if (_isDisposed) return;
      onSpinComplete?.call(letter);

      // Note: Countdown logic removed as per UI requirements
      // If you need it, uncomment and add disposal checks
    } catch (e) {
      // Reset state if error occurs
      isSpinning = false;
      update();
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
