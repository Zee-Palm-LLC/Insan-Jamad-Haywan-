import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/solo_game_controller.dart';

class SoloGamePage extends StatelessWidget {
  const SoloGamePage({super.key});

  static const String path = '/solo-game';
  static const String name = 'SoloGame';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoloGameController>(
      init: SoloGameController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Solo Game'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                controller.resetGame();
                context.pop();
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: !controller.gameStarted
                  ? _StartScreen(onStart: controller.startGame)
                  : controller.currentQuestion < controller.questions.length
                  ? _QuestionScreen(controller: controller)
                  : _ResultScreen(controller: controller),
            ),
          ),
        );
      },
    );
  }
}

class _StartScreen extends StatelessWidget {
  final VoidCallback onStart;

  const _StartScreen({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.sports_esports,
          size: 100,
          color: Theme.of(context).primaryColor.withOpacity(0.7),
        ),
        const SizedBox(height: 32),
        Text(
          'Solo Game Mode',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Test your knowledge!',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: onStart,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Start Game', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

class _QuestionScreen extends StatelessWidget {
  final SoloGameController controller;

  const _QuestionScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    final question = controller.questions[controller.currentQuestion];
    final options = question['options'] as List<String>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${controller.currentQuestion + 1}/${controller.questions.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Score: ${controller.score}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Question
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              question['question'] as String,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Options
        Expanded(
          child: ListView.separated(
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _OptionButton(
                option: options[index],
                onPressed: () => controller.answerQuestion(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String option;
  final VoidCallback onPressed;

  const _OptionButton({required this.option, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(option, style: const TextStyle(fontSize: 16)),
    );
  }
}

class _ResultScreen extends StatelessWidget {
  final SoloGameController controller;

  const _ResultScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    final percentage = (controller.score / controller.questions.length * 100)
        .round();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          percentage >= 70 ? Icons.emoji_events : Icons.thumb_up,
          size: 100,
          color: percentage >= 70 ? Colors.amber : Colors.blue,
        ),
        const SizedBox(height: 32),
        Text(
          'Game Over!',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Score: ${controller.score}/${controller.questions.length}',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '$percentage%',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: controller.resetGame,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Play Again', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            controller.resetGame();
            context.pop();
          },
          child: const Text('Back to Menu'),
        ),
      ],
    );
  }
}
