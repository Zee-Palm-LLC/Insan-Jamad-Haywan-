import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insan_jamd_hawan/app.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/cache/storage_service.dart';
import 'package:insan_jamd_hawan/core/services/playflow/playflow_client.dart';
import 'package:insan_jamd_hawan/data/constants/app_theme.dart';
import 'package:insan_jamd_hawan/firebase_options.dart';

late FirebaseApp? mashFirebaseApp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);

  // Initialize StorageService (SharedPreferences)
  await StorageService.instance.init();

  // Initialize Firebase with Mash Platform project
  try {
    mashFirebaseApp = await Firebase.initializeApp(
      name: 'mash-platform',
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (kDebugMode) {
      developer.log(
        'Firebase initialized successfully: ${mashFirebaseApp?.name}',
        name: 'main',
      );
      developer.log(
        'Project ID: ${mashFirebaseApp?.options.projectId}',
        name: 'main',
      );
    }
  } catch (e) {
    if (kDebugMode) {
      developer.log(
        'Firebase initialization failed: $e',
        name: 'main',
        error: e,
      );
    }
    mashFirebaseApp = null;
  }

  // Clean up any existing lobby on app startup (if player has a name)
  await _cleanupExistingLobby();

  runApp(const InsanJamdHawan());
}

/// Clean up any existing lobby the player might be in
Future<void> _cleanupExistingLobby() async {
  try {
    final playerId = await AppService.getPlayerId();
    if (playerId == null || playerId.startsWith('guest_')) {
      return; // No player ID set or guest ID, skip cleanup
    }

    // Try to get current lobby for player - if this succeeds, player is in a lobby
    try {
      final lobby = await PlayflowClient.instance.getGameRoom();
      if (lobby != null && lobby.id != null) {
        developer.log(
          'Found existing lobby ${lobby.id}, cleaning up...',
          name: 'cleanupLobby',
        );

        // If player is the host, delete the lobby
        if (lobby.host == playerId) {
          await PlayflowClient.instance.deleteLobby(lobbyId: lobby.id!);
          developer.log(
            'Deleted lobby ${lobby.id} (player was host)',
            name: 'cleanupLobby',
          );
        } else {
          // Otherwise, remove player from lobby
          await PlayflowClient.instance.kickPlayer(
            lobbyId: lobby.id!,
            playerIdToKick: playerId,
            isKick: false, // false = leave, true = kick
          );
          developer.log('Left lobby ${lobby.id}', name: 'cleanupLobby');
        }
      }
    } catch (e) {
      // If getGameRoom fails (404, etc.), player is not in a lobby - that's fine
      if (kDebugMode) {
        developer.log(
          'Player not in any lobby or error checking: $e',
          name: 'cleanupLobby',
        );
      }
    }
  } catch (e, stackTrace) {
    developer.log(
      'Error during lobby cleanup: $e',
      error: e,
      stackTrace: stackTrace,
      name: 'cleanupLobby',
    );
    // Don't throw - cleanup failure shouldn't prevent app startup
  }
}
