import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/services/audio/audio_service.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';

class ScoringController extends GetxController {
  final String sessionId;
  final int roundNumber;
  final String selectedLetter;

  final FirebaseFirestoreService _firestore = FirebaseFirestoreService.instance;

  final Map<String, List<Map<String, dynamic>>> _categoryAnswers = {
    'Name': [],
    'Object': [],
    'Animal': [],
    'Plant': [],
    'Country': [],
  };

  final Map<String, List<Map<String, dynamic>>> shownCategoryAnswers = {
    'Name': [],
    'Object': [],
    'Animal': [],
    'Plant': [],
    'Country': [],
  };

  bool _isRevealing = false;
  bool _hasStarted = false;
  final List<String> _categoryOrder = [
    'Name',
    'Object',
    'Animal',
    'Plant',
    'Country',
  ];

  ScoringController({
    required this.sessionId,
    required this.roundNumber,
    required this.selectedLetter,
  });

  @override
  void onInit() {
    super.onInit();
    _loadAnswers();
  }

  Future<void> _loadAnswers() async {
    int retryCount = 0;
    const maxRetries = 10;
    const retryDelay = Duration(milliseconds: 500);

    while (retryCount < maxRetries) {
      try {
        final allAnswers = await _firestore.getAllAnswers(
          sessionId,
          roundNumber,
        );

        developer.log(
          'Loaded ${allAnswers.length} answers for round $roundNumber',
          name: 'ScoringController',
        );

        bool hasScoringData = false;
        for (final answer in allAnswers) {
          if (answer.scoring != null) {
            hasScoringData = true;
            developer.log(
              'Found scoring data for player ${answer.playerName}',
              name: 'ScoringController',
            );
            break;
          }
        }

        if (!hasScoringData && retryCount < maxRetries - 1) {
          developer.log(
            'No scoring data found, retrying... (${retryCount + 1}/$maxRetries)',
            name: 'ScoringController',
          );
          await Future.delayed(retryDelay);
          retryCount++;
          continue;
        }

        for (final answer in allAnswers) {
          if (answer.scoring == null) {
            developer.log(
              'No scoring data for player ${answer.playerName}',
              name: 'ScoringController',
            );
            continue;
          }

          final breakdown = answer.scoring!.breakdown;

          for (final category in _categoryOrder) {
            final categoryAnswer = answer.answers[category];
            if (categoryAnswer == null || categoryAnswer.trim().isEmpty) {
              continue;
            }

            final categoryScore = breakdown[category];
            if (categoryScore == null) {
              developer.log(
                'No category score for ${answer.playerName} - $category',
                name: 'ScoringController',
              );
              continue;
            }

            _categoryAnswers[category]!.add({
              'playerId': answer.playerId,
              'name': answer.playerName,
              'answer': categoryAnswer,
              'points': categoryScore.points,
              'status': categoryScore.status,
              'color': _getColorForStatus(categoryScore.status),
            });
          }
        }

        for (final category in _categoryOrder) {
          _categoryAnswers[category]!.sort(
            (a, b) => (b['points'] as int).compareTo(a['points'] as int),
          );
          developer.log(
            'Category $category: ${_categoryAnswers[category]!.length} answers',
            name: 'ScoringController',
          );
        }

        if (!_hasStarted) {
          _hasStarted = true;
          await _startRevealSequence();
        }

        break;
      } catch (e, stackTrace) {
        developer.log(
          'Error loading answers: $e',
          name: 'ScoringController',
          error: e,
          stackTrace: stackTrace,
        );
        if (retryCount < maxRetries - 1) {
          await Future.delayed(retryDelay);
          retryCount++;
        } else {
          rethrow;
        }
      }
    }
  }

  Color _getColorForStatus(AnswerEvaluationStatus status) {
    switch (status) {
      case AnswerEvaluationStatus.correct:
        return AppColors.kGreen100;
      case AnswerEvaluationStatus.duplicate:
        return AppColors.kPrimary;
      case AnswerEvaluationStatus.incorrect:
      case AnswerEvaluationStatus.unclear:
        return AppColors.kGray300;
    }
  }

  Future<void> _startRevealSequence() async {
    if (_isRevealing) return;
    _isRevealing = true;

    await AudioService.instance.playAudio(AudioType.narratorCreative);
    await Future.delayed(const Duration(milliseconds: 2000));

    for (final category in _categoryOrder) {
      final answers = _categoryAnswers[category]!;
      if (answers.isEmpty) continue;

      await _revealCategory(category, answers);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    _isRevealing = false;
    update();
  }

  Future<void> _revealCategory(
    String category,
    List<Map<String, dynamic>> answers,
  ) async {
    for (int i = 0; i < answers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 700));
      await AudioService.instance.playAudio(AudioType.answerRevealPop);

      shownCategoryAnswers[category]!.add(answers[i]);
      update();

      await Future.delayed(const Duration(milliseconds: 300));
      if (answers[i]['points'] as int > 0) {
        await AudioService.instance.playAudio(AudioType.pointsCash);
      }
    }
  }

  List<Map<String, dynamic>> getCategoryAnswers(String category) {
    return shownCategoryAnswers[category] ?? [];
  }

  bool hasCategoryAnswers(String category) {
    final hasAnswers = (shownCategoryAnswers[category]?.isNotEmpty ?? false);
    developer.log(
      'hasCategoryAnswers($category): $hasAnswers (shown: ${shownCategoryAnswers[category]?.length ?? 0}, total: ${_categoryAnswers[category]?.length ?? 0})',
      name: 'ScoringController',
    );
    return hasAnswers;
  }

  String getPlayerAvatar(String name) {
    final hash = name.hashCode.abs();
    final index = hash % 4;
    final images = [
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
      'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
      'https://plus.unsplash.com/premium_photo-1678197937465-bdbc4ed95815?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=688',
    ];
    return images[index];
  }

  int getTotalRoundScore() {
    int total = 0;
    for (final category in _categoryOrder) {
      for (final answer in shownCategoryAnswers[category] ?? []) {
        total += answer['points'] as int;
      }
    }
    return total;
  }
}
