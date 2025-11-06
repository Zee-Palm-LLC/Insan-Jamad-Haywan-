import 'dart:async';
import 'dart:developer' as developer;
import 'package:insan_jamd_hawan/core/models/session/round_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/services/answer_evaluation_service.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';

class RoundStatusMonitorService {
  final FirebaseFirestoreService _firestore = FirebaseFirestoreService.instance;
  final AnswerEvaluationService _evaluationService =
      AnswerEvaluationService.instance;
  StreamSubscription<RoundModel?>? _subscription;

  Function()? onRoundCompleted;
  Function(String selectedLetter)? onVotingRequired;

  void startListening({
    required String sessionId,
    required int roundNumber,
    required Function() onCompleted,
    Function(String selectedLetter)? onVoting,
  }) {
    onRoundCompleted = onCompleted;
    onVotingRequired = onVoting;

    _subscription = _firestore
        .listenToRound(sessionId, roundNumber)
        .listen(
          (round) {
            if (round == null) return;

            if (round.status == RoundStatus.voting) {
              developer.log(
                'Round $roundNumber requires voting - triggering navigation',
                name: 'RoundStatusMonitorService',
              );
              onVotingRequired?.call(round.selectedLetter);
            } else if (round.status == RoundStatus.completed) {
              developer.log(
                'Round $roundNumber completed - triggering navigation',
                name: 'RoundStatusMonitorService',
              );
              onRoundCompleted?.call();
            }
          },
          onError: (error) {
            developer.log(
              'Error listening to round updates: $error',
              name: 'RoundStatusMonitorService',
              error: error,
            );
          },
        );

    developer.log(
      'Started listening to round $roundNumber status',
      name: 'RoundStatusMonitorService',
    );
  }

  Future<void> markRoundCompleted({
    required String sessionId,
    required int roundNumber,
  }) async {
    await _firestore.updateRoundStatus(
      sessionId,
      roundNumber,
      RoundStatus.completed,
    );

    developer.log(
      'Round $roundNumber marked as completed',
      name: 'RoundStatusMonitorService',
    );

    try {
      final round = await _firestore.getRound(sessionId, roundNumber);
      if (round != null) {
        await _evaluationService.evaluateRound(
          sessionId: sessionId,
          roundNumber: roundNumber,
          selectedLetter: round.selectedLetter,
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error triggering evaluation for round $roundNumber: $e',
        name: 'RoundStatusMonitorService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    developer.log(
      'Stopped listening to round status',
      name: 'RoundStatusMonitorService',
    );
  }

  void dispose() {
    stopListening();
  }
}
