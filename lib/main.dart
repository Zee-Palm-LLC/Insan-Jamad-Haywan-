import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/cache/storage_service.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'package:insan_jamd_hawan/core/services/openai/openai_client.dart';
import 'package:insan_jamd_hawan/core/services/playflow/playflow_client.dart';
import 'package:insan_jamd_hawan/core/data/constants/app_theme.dart';
import 'package:insan_jamd_hawan/firebase_options.dart';
import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';

late FirebaseApp insanJamdHawanFirebaseApp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  await StorageService.instance.init();

  insanJamdHawanFirebaseApp = await Firebase.initializeApp(
    name: 'mash-platform',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _signInAnonymously();

  FirebaseFirestoreService.initialize(app: insanJamdHawanFirebaseApp);

  try {
    OpenAIClient.instance.initialize();
    developer.log('OpenAI client initialized successfully', name: 'main');
  } catch (e, stackTrace) {
    developer.log(
      'Failed to initialize OpenAI client: $e',
      name: 'main',
      error: e,
      stackTrace: stackTrace,
    );
  }

  await _cleanupExistingLobby();
  runApp(const InsanJamdHawan());
}

Future<void> _signInAnonymously() async {
  try {
    final auth = FirebaseAuth.instanceFor(app: insanJamdHawanFirebaseApp);

    if (auth.currentUser != null) {
      developer.log(
        'Already signed in as: ${auth.currentUser!.uid}',
        name: 'FirebaseAuth',
      );
      return;
    }

    final userCredential = await auth.signInAnonymously();
    developer.log(
      'Signed in anonymously: ${userCredential.user?.uid}',
      name: 'FirebaseAuth',
    );
  } catch (e, stackTrace) {
    developer.log(
      'Error signing in anonymously: $e',
      error: e,
      stackTrace: stackTrace,
      name: 'FirebaseAuth',
    );
  }
}

Future<void> _cleanupExistingLobby() async {
  try {
    final playerId = await AppService.getPlayerId();
    if (playerId == null || playerId.startsWith('guest_')) {
      return;
    }
    try {
      final lobby = await PlayflowClient.instance.getGameRoom();
      if (lobby != null && lobby.id != null) {
        developer.log(
          'Found existing lobby ${lobby.id}, cleaning up...',
          name: 'cleanupLobby',
        );
        if (lobby.host == playerId) {
          await PlayflowClient.instance.deleteLobby(lobbyId: lobby.id!);
          developer.log(
            'Deleted lobby ${lobby.id} (player was host)',
            name: 'cleanupLobby',
          );
        } else {
          await PlayflowClient.instance.kickPlayer(
            lobbyId: lobby.id!,
            playerIdToKick: playerId,
            isKick: false,
          );
          developer.log('Left lobby ${lobby.id}', name: 'cleanupLobby');
        }
      }
    } catch (e) {
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
  }
}
