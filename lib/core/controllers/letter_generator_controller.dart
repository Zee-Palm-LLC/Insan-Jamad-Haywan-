// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:insan_jamd_hawan/core/controllers/fortune_wheel_controller.dart';
// import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
// import 'package:insan_jamd_hawan/core/modules/hosts/answers_host/answers_host_view.dart';
// import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
// import 'package:insan_jamd_hawan/core/models/session/round_model.dart';
// import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
// import 'package:insan_jamd_hawan/insan-jamd-hawan.dart';
// import 'dart:developer' as developer;

// class LetterGeneratorController extends GetxController {
//   String? selectedLetter;
//   bool countdownStarted = false;
//   FortuneWheelController? _wheelController;

//   LobbyController? get lobbyController {
//     try {
//       return Get.find<LobbyController>();
//     } catch (e) {
//       return null;
//     }
//   }

//   void setWheelController(FortuneWheelController controller) {
//     _wheelController = controller;
//   }

//   Future<void> handleSpinComplete(String letter) async {
//     selectedLetter = letter;
//     countdownStarted = false;
//     update();
//     await _createFirestoreRound(letter);
//   }

//   Future<void> startCountdown() async {
//     developer.log(
//       'Continue button clicked - selectedLetter: $selectedLetter, countdownStarted: $countdownStarted',
//       name: 'LetterGenerator',
//     );

//     if (selectedLetter == null || countdownStarted) {
//       developer.log(
//         'Cannot start countdown: selectedLetter=$selectedLetter, countdownStarted=$countdownStarted',
//         name: 'LetterGenerator',
//       );
//       return;
//     }

//     developer.log('Starting countdown...', name: 'LetterGenerator');
//     countdownStarted = true;
//     update();

//     FortuneWheelController? wheelController = _wheelController;

//     if (wheelController == null) {
//       try {
//         wheelController = Get.find<FortuneWheelController>();
//         _wheelController = wheelController;
//       } catch (e) {
//         developer.log(
//           'Error finding FortuneWheelController: $e',
//           name: 'LetterGenerator',
//           error: e,
//         );
//         countdownStarted = false;
//         update();
//         return;
//       }
//     }

//     if (wheelController.selectedAlphabet != null &&
//         !wheelController.showCountdown) {
//       await wheelController.triggerCountdown();
//     } else {
//       developer.log(
//         'Cannot trigger countdown: selectedAlphabet=${wheelController.selectedAlphabet}, showCountdown=${wheelController.showCountdown}',
//         name: 'LetterGenerator',
//       );
//       countdownStarted = false;
//       update();
//     }
//   }

//   void handleCountdownComplete(String letter) {
//     developer.log(
//       'Countdown complete - navigating to answers view for letter: $letter',
//       name: 'LetterGenerator',
//     );

//     if (lobbyController == null) {
//       developer.log(
//         'LobbyController is null, cannot navigate',
//         name: 'LetterGenerator',
//       );
//       return;
//     }

//     final sessionId = lobbyController!.lobby.id;
//     if (sessionId == null) {
//       developer.log(
//         'Session ID is null, cannot navigate',
//         name: 'LetterGenerator',
//       );
//       return;
//     }

//     final roundNumber =
//         (lobbyController!.currentRoom.settings?.currentRound ?? 0) + 1;
//     final totalSeconds = lobbyController!.selectedTimePerRound ?? 60;

//     developer.log(
//       'Navigating to AnswersHostView - sessionId: $sessionId, roundNumber: $roundNumber, letter: $letter',
//       name: 'LetterGenerator',
//     );

//     try {
//       final context = navigatorKey.currentContext;
//       if (context != null && context.mounted) {
//         final router = GoRouter.of(context);
//         router.push(
//           AnswersHostView.path.replaceAll(':letter', letter),
//           extra: {
//             'sessionId': sessionId,
//             'roundNumber': roundNumber,
//             'selectedLetter': letter,
//             'totalSeconds': totalSeconds,
//           },
//         );
//         developer.log('Navigation successful', name: 'LetterGenerator');
//       } else {
//         developer.log(
//           'Navigator context is null or not mounted, cannot navigate',
//           name: 'LetterGenerator',
//         );
//         try {
//           Get.toNamed(
//             AnswersHostView.path.replaceAll(':letter', letter),
//             arguments: {
//               'sessionId': sessionId,
//               'roundNumber': roundNumber,
//               'selectedLetter': letter,
//               'totalSeconds': totalSeconds,
//             },
//           );
//           developer.log(
//             'Navigation successful via GetX fallback',
//             name: 'LetterGenerator',
//           );
//         } catch (e2) {
//           developer.log(
//             'All navigation methods failed: $e2',
//             name: 'LetterGenerator',
//             error: e2,
//           );
//         }
//       }
//     } catch (e, s) {
//       developer.log(
//         'Navigation error: $e',
//         name: 'LetterGenerator',
//         error: e,
//         stackTrace: s,
//       );
//     }
//   }

//   Future<void> _createFirestoreRound(String letter) async {
//     try {
//       if (lobbyController == null || lobbyController!.lobby.id == null) {
//         developer.log(
//           'Cannot create round: lobby controller or ID is null',
//           name: 'LetterGenerator',
//         );
//         return;
//       }

//       final sessionId = lobbyController!.lobby.id!;

//       final currentRound =
//           (lobbyController!.currentRoom.settings?.currentRound ?? 0) + 1;
//       final timePerRound = lobbyController!.selectedTimePerRound ?? 60;

//       final activePlayers = lobbyController!.currentRoom.players ?? [];

//       final now = DateTime.now();
//       final scheduledEnd = now.add(Duration(seconds: timePerRound));

//       final round = RoundModel(
//         roundNumber: currentRound,
//         selectedLetter: letter,
//         category: null,
//         timeConfig: RoundTimeConfig(
//           allocatedTime: timePerRound,
//           startedAt: now,
//           scheduledEndAt: scheduledEnd,
//           actualEndAt: null,
//           actualDuration: null,
//           timeExtension: 0,
//           wasTimeExtended: false,
//         ),
//         status: RoundStatus.answering,
//         participants: activePlayers
//             .map(
//               (playerId) => RoundParticipant(
//                 playerId: playerId,
//                 playerName: playerId,
//                 wasActive: true,
//                 answered: false,
//                 submittedAt: null,
//               ),
//             )
//             .toList(),
//         stats: RoundStatsModel(
//           totalAnswers: 0,
//           averageSubmissionTime: null,
//           fastestSubmission: null,
//           slowestSubmission: null,
//         ),
//         wheelIndex: 0,
//         wheelSpinTimestamp: now,
//       );

//       await FirebaseFirestoreService.instance.createRound(sessionId, round);

//       developer.log(
//         'Firestore round created: Round $currentRound, Letter: $letter',
//         name: 'LetterGenerator',
//       );
//     } catch (e, s) {
//       developer.log(
//         'Error creating Firestore round: $e',
//         name: 'LetterGenerator',
//         error: e,
//         stackTrace: s,
//       );
//     }
//   }
// }
