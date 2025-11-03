import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';

class LobbyWaitingPage extends StatelessWidget {
  const LobbyWaitingPage({super.key, required this.controller});

  static const String path = '/lobby/:id';
  static const String name = 'LobbyWaiting';

  final LobbyController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LobbyController>(
      init: controller,
      builder: (_) {
        final players = controller.currentRoom.players ?? const <String>[];
        final lobbyId = controller.currentRoom.id ?? '';
        final hostId = controller.currentRoom.host;
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.currentRoom.name ?? 'Lobby'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Lobby meta
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lobby ID',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 4),
                              SelectableText(
                                lobbyId,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.people_alt_outlined),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${players.length}/${controller.currentRoom.maxPlayers ?? '-'} players',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Players list
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.separated(
                              itemCount: players.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final p = players[index];
                                final isHost = p == hostId;
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      p.isNotEmpty ? p[0].toUpperCase() : '?',
                                    ),
                                  ),
                                  title: Text(p),
                                  subtitle: isHost ? const Text('Host') : null,
                                  trailing: FutureBuilder<String?>(
                                    future: AppService.getPlayerId(),
                                    builder: (context, snapshot) {
                                      final me = snapshot.data;
                                      final amHost = me == hostId;
                                      final canKick = amHost && p != hostId;
                                      if (!canKick) return const SizedBox();
                                      return IconButton(
                                        tooltip: 'Kick',
                                        icon: const Icon(
                                          Icons.person_remove_alt_1_outlined,
                                        ),
                                        onPressed: () =>
                                            controller.removePlayer(
                                              isKick: true,
                                              playerIdToKick: p,
                                            ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Actions
                      FutureBuilder<String?>(
                        future: AppService.getPlayerId(),
                        builder: (context, snapshot) {
                          final me = snapshot.data;
                          final amHost = me == hostId;
                          if (amHost) {
                            return Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: controller.deleteRoom,
                                    icon: const Icon(Icons.delete_outline),
                                    label: const Text('Delete Lobby'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO: implement game start hook
                                      // controller.startGame();
                                    },
                                    icon: const Icon(Icons.play_arrow_rounded),
                                    label: const Text('Start Game'),
                                  ),
                                ),
                              ],
                            );
                          }
                          return ElevatedButton.icon(
                            onPressed: () =>
                                controller.removePlayer(isKick: false),
                            icon: const Icon(Icons.logout),
                            label: const Text('Leave Lobby'),
                          );
                        },
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
