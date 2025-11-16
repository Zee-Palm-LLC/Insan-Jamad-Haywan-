import 'dart:math';
import 'package:insan_jamd_hawan/core/data/enums/enums.dart';
import 'package:insan_jamd_hawan/core/data/constants/game_constants.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';
import 'dart:developer' as dev;

class SpecialRoundService {
  final FirebaseFirestoreService _db = FirebaseFirestoreService.instance;
  final Random _random = Random();

  Future<void> updateSpecialRoundStatus(
    String sessionId,
    SpecialRoundStatus status,
    String? letter,
    String? category,
  ) async {
    await _db.updateSession(sessionId, {
      'config.specialRoundStatus': status.name,
      'config.specialRoundLetter': letter,
      'config.specialRoundCategory': category,
    });
  }

  Future<SpecialRoundModel> getRandomLetterAndCategory(String sessionId) async {
    final randomLetter = String.fromCharCode(65 + _random.nextInt(26));
    final randomCategoryIndex = _random.nextInt(
      GameConstants.categories.length,
    );
    final randomCategory = GameConstants.categories[randomCategoryIndex];
    dev.log(
      'Random letter in special round service: $randomLetter, Random category: $randomCategory',
    );
    await updateSpecialRoundStatus(
      sessionId,
      SpecialRoundStatus.started,
      randomLetter,
      randomCategory,
    );
    return SpecialRoundModel(
      letter: randomLetter,
      category: randomCategory,
      status: SpecialRoundStatus.started,
    );
  }
}

class SpecialRoundModel {
  final String letter;
  final String category;
  final SpecialRoundStatus status;
  SpecialRoundModel({
    required this.letter,
    required this.category,
    required this.status,
  });
}
