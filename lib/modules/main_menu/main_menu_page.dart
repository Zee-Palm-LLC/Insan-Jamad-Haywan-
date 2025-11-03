import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/modules/username_input/username_input_dialog.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  static const String path = '/main-menu';
  static const String name = 'MainMenu';

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  String _playerName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUsername();
    });
  }

  Future<void> _checkUsername() async {
    final name = await AppService.getPlayerId();
    final hasUsername =
        name != null && name.isNotEmpty && !name.startsWith('guest_');

    if (!hasUsername && mounted) {
      final result = await UsernameInputDialog.show(context);
      if (result != null && mounted) {
        await _loadPlayerName();
      }
      // Note: Dialog is barrierDismissible: false, so result should never be null
    } else {
      await _loadPlayerName();
    }
  }

  Future<void> _loadPlayerName() async {
    final name = await AppService.getPlayerId();
    if (mounted) {
      setState(() {
        _playerName = name ?? 'Player';
      });
    }
  }

  Future<void> _showChangeNameDialog() async {
    final result = await UsernameInputDialog.show(context);
    if (result != null && mounted) {
      await _loadPlayerName();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  Text(
                    'Insan Jamd Hawan',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Welcome, $_playerName!',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 64),

                  _MenuButton(
                    icon: Icons.login,
                    label: 'Join Lobby',
                    subtitle: 'Enter a code to join',
                    onPressed: () => context.push('/join-lobby'),
                  ),

                  const SizedBox(height: 16),

                  _MenuButton(
                    icon: Icons.add_circle_outline,
                    label: 'Create Lobby',
                    subtitle: 'Start a new game',
                    onPressed: () => context.push('/create-lobby'),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: _showChangeNameDialog,
                    child: Text(
                      'Change Name',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
