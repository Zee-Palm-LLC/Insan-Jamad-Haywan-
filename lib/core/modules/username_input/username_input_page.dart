import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/modules/players/main_menu/components/username_input_controller.dart';

class UsernameInputPage extends StatelessWidget {
  const UsernameInputPage({super.key});

  static const String path = '/username-input';
  static const String name = 'UsernameInput';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsernameInputController>(
      init: UsernameInputController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // Game Title
                  Text(
                    'Insan Jamd Hawan',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // Instructions
                  Text(
                    'Enter your name to continue',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Name Input
                  TextField(
                    controller: controller.nameController,
                    enabled: !controller.isLoading,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => controller.saveUsername(context),
                  ),

                  const SizedBox(height: 24),

                  // Continue Button
                  ElevatedButton(
                    onPressed: controller.isLoading
                        ? null
                        : () => controller.saveUsername(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Continue',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),

                  const Spacer(),

                  // Info Text
                  Text(
                    'Your name will be used as your player ID in the game',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
