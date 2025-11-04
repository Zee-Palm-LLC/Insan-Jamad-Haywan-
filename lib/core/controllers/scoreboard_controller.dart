import 'package:get/get.dart';

class ScoreboardController extends GetxController {
  final List<Map<String, dynamic>> shownPlayers = [];

  final List<Map<String, dynamic>> _players = [
    {'name': 'Sophia', 'totalPoints': 1250, 'pointsGained': 23, 'rank': 1},
    {'name': 'Ethan', 'totalPoints': 654, 'pointsGained': 22, 'rank': 2},
    {'name': 'Carter', 'totalPoints': 432, 'pointsGained': 19, 'rank': 3},
    {'name': 'Ethan', 'totalPoints': 654, 'pointsGained': 22, 'rank': 4},
    {'name': 'Carter', 'totalPoints': 432, 'pointsGained': 19, 'rank': 5},
    {'name': 'Liam John', 'totalPoints': 580, 'pointsGained': 27, 'rank': 6},
  ];

  @override
  void onInit() {
    super.onInit();
    _simulateAppearing();
  }

  Future<void> _simulateAppearing() async {
    for (final player in _players) {
      await Future.delayed(const Duration(milliseconds: 700));
      shownPlayers.add(player);
      update();
    }
  }
}
