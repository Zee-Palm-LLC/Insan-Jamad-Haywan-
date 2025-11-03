import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_creation_controller.dart';

class LobbyCreationPage extends StatelessWidget {
  const LobbyCreationPage({super.key});

  static const String path = '/create-lobby';
  static const String name = 'CreateLobby';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LobbyCreationController>(
      init: LobbyCreationController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Lobby'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.group_add,
                        size: 80,
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                      ),

                      const SizedBox(height: 32),

                      Text(
                        'Create New Lobby',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 48),

                      _SettingCard(
                        icon: Icons.people,
                        title: 'Max Players',
                        child: DropdownButton<String>(
                          value: controller.maxPlayers,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: List.generate(7, (index) => index + 2)
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value.toString(),
                                  child: Text('$value Players'),
                                ),
                              )
                              .toList(),
                          onChanged: controller.isLoading
                              ? null
                              : (value) => controller.setMaxPlayers(value),
                        ),
                      ),

                      const SizedBox(height: 16),

                      _SettingCard(
                        icon: Icons.replay,
                        title: 'Max Rounds',
                        child: DropdownButton<String>(
                          value: controller.maxRounds,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: List.generate(8, (index) => index + 3)
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value.toString(),
                                  child: Text('$value Rounds'),
                                ),
                              )
                              .toList(),
                          onChanged: controller.isLoading
                              ? null
                              : (value) => controller.setMaxRounds(value),
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : () => controller.createLobby(context),
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
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Create Lobby',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Card(
                        color: Colors.green[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.green[700],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'You will be the host of this lobby and can start the game when ready',
                                  style: TextStyle(
                                    color: Colors.green[900],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
