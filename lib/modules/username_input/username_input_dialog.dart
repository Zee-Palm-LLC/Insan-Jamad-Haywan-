import 'package:flutter/material.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';

class UsernameInputDialog extends StatefulWidget {
  const UsernameInputDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const UsernameInputDialog(),
    );
  }

  @override
  State<UsernameInputDialog> createState() => _UsernameInputDialogState();
}

class _UsernameInputDialogState extends State<UsernameInputDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveUsername() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      AppToaster.showToast(
        'Please enter your name',
        type: ToastificationType.error,
      );
      return;
    }

    if (name.length < 2) {
      AppToaster.showToast(
        'Name must be at least 2 characters',
        type: ToastificationType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AppService.setPlayerId(name);

      if (mounted) {
        Navigator.of(context).pop(name);
      }
    } catch (e) {
      if (mounted) {
        AppToaster.showToast(
          'Failed to save name: $e',
          type: ToastificationType.error,
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              'Welcome to Insan Jamd Hawan',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Enter your name to continue',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Name Input
            TextField(
              controller: _nameController,
              enabled: !_isLoading,
              autofocus: true,
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
              onSubmitted: (_) => _saveUsername(),
            ),

            const SizedBox(height: 16),

            // Info Text
            Text(
              'Your name will be used as your player ID',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Continue Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveUsername,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
