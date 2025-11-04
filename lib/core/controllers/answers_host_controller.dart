import 'package:get/get.dart';

class AnswersHostController extends GetxController {
  int seconds = 0;
  int minutes = 0;
  bool isRunning = true;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (isRunning) {
        seconds++;
        if (seconds == 60) {
          seconds = 0;
          minutes++;
        }
        update();
        _startTimer();
      }
    });
  }

  void stopTimer() {
    isRunning = false;
    update();
  }

  String get formattedTime {
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
}

