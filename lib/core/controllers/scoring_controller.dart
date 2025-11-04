import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';

class ScoringController extends GetxController {
  final List<Map<String, dynamic>> shownFruitAnswers = [];
  final List<Map<String, dynamic>> shownAnimalAnswers = [];

  final List<Map<String, dynamic>> _fruitAnswers = [
    {
      'name': 'Ahmed',
      'answer': 'Apple',
      'points': 10,
      'color': AppColors.kGreen100,
    },
    {
      'name': 'Ahmed',
      'answer': 'Apricot',
      'points': 8,
      'color': AppColors.kBlue,
    },
    {
      'name': 'Ahmed',
      'answer': 'Avocado',
      'points': 7,
      'color': AppColors.kOrange,
    },
  ];

  final List<Map<String, dynamic>> _animalAnswers = [
    {
      'name': 'Ahmed',
      'answer': 'Ant',
      'points': 10,
      'color': AppColors.kGreen100,
    },
    {
      'name': 'Ahmed',
      'answer': 'Alligator',
      'points': 8,
      'color': AppColors.kBlue,
    },
    {
      'name': 'Ahmed',
      'answer': 'Anaconda',
      'points': 5,
      'color': AppColors.kPrimary,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _simulateAppearing();
  }

  Future<void> _simulateAppearing() async {
    // Show fruit answers first
    for (final answer in _fruitAnswers) {
      await Future.delayed(const Duration(milliseconds: 700));
      shownFruitAnswers.add(answer);
      update();
    }

    // Then show animal answers
    for (final answer in _animalAnswers) {
      await Future.delayed(const Duration(milliseconds: 700));
      shownAnimalAnswers.add(answer);
      update();
    }
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
}
