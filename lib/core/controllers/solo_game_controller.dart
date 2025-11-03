import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SoloGameController extends GetxController {
  int currentQuestion = 0;
  int score = 0;
  bool gameStarted = false;

  final List<Map<String, dynamic>> questions = const [
    {
      'question': 'What is the capital of France?',
      'options': ['London', 'Berlin', 'Paris', 'Madrid'],
      'correct': 2,
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      'correct': 1,
    },
    {
      'question': 'What is 2 + 2?',
      'options': ['3', '4', '5', '6'],
      'correct': 1,
    },
  ];

  void startGame() {
    gameStarted = true;
    update();
  }

  void resetGame() {
    currentQuestion = 0;
    score = 0;
    gameStarted = false;
    update();
  }

  void answerQuestion(int selectedIndex) {
    final question = questions[currentQuestion];
    if (selectedIndex == question['correct']) {
      score++;
      // TODO: Save stats to user account via lobby system
      // This can be done by updating player state in the lobby
    }
    currentQuestion++;
    update();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
