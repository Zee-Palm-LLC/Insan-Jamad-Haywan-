import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';

class VotingController extends GetxController {
  final String selectedAlphabet;
  final String sessionId;
  final int roundNumber;

  VotingController({
    required this.selectedAlphabet,
    required this.sessionId,
    required this.roundNumber,
  });

  // Track selected words by category
  final Map<String, String> selectedWords = {};
  bool hasSelectedAll = false;
  bool isSubmitting = false;

  @override
  void onInit() {
    super.onInit();
    _checkSelectionStatus();
  }

  void selectWord(String category, String word) {
    selectedWords[category] = word;
    _checkSelectionStatus();
    update();
  }

  void _checkSelectionStatus() {
    const requiredCategories = ['Name', 'Object', 'Animal', 'Plant', 'Country'];
    hasSelectedAll = requiredCategories.every(
      (category) =>
          selectedWords.containsKey(category) &&
          selectedWords[category]!.isNotEmpty,
    );
  }

  Future<void> submitVotes() async {
    if (!hasSelectedAll || isSubmitting) {
      return;
    }

    try {
      isSubmitting = true;
      update();

      final playerId = await AppService.getPlayerId();
      if (playerId == null) {
        throw Exception('Player ID not found');
      }

      // TODO: Submit votes to Firestore

      developer.log(
        'Votes submitted for round $roundNumber',
        name: 'VotingController',
      );

      // Navigate to next screen (scoreboard or next round)
      // This will be handled by the view
    } catch (e) {
      developer.log(
        'Error submitting votes: $e',
        name: 'VotingController',
        error: e,
      );
      isSubmitting = false;
      update();
    }
  }
}
