import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insan_jamd_hawan/core/models/session/game_player_model.dart';
import 'package:insan_jamd_hawan/core/models/session/game_session_model.dart';
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/player_participation_model.dart';
import 'package:insan_jamd_hawan/core/models/session/round_model.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';
import 'package:insan_jamd_hawan/core/models/user/user_model.dart';

class FirebaseFirestoreService {
  final FirebaseApp firebaseApp;
  final String gameId;

  FirebaseFirestoreService._internal(this.firebaseApp, this.gameId);

  static FirebaseFirestoreService? _instance;

  static void initialize({
    required FirebaseApp app,
    String gameId = 'insan_jamd_hawan',
  }) {
    _instance = FirebaseFirestoreService._internal(app, gameId);
  }

  static FirebaseFirestoreService get instance {
    if (_instance == null) {
      throw Exception(
        'FirebaseFirestoreService has not been initialized. Call initialize() with a FirebaseApp first.',
      );
    }
    return _instance!;
  }

  FirebaseFirestore get _firestore =>
      FirebaseFirestore.instanceFor(app: firebaseApp);

  CollectionReference get _gamesCollection => _firestore.collection('games');

  DocumentReference get _gameDoc => _gamesCollection.doc(gameId);

  CollectionReference get _sessionsCollection =>
      _gameDoc.collection('sessions');

  DocumentReference _sessionDoc(String sessionId) =>
      _sessionsCollection.doc(sessionId);

  CollectionReference _playersCollection(String sessionId) =>
      _sessionDoc(sessionId).collection('players');

  DocumentReference _playerDoc(String sessionId, String playerId) =>
      _playersCollection(sessionId).doc(playerId);

  CollectionReference _roundsCollection(String sessionId) =>
      _sessionDoc(sessionId).collection('rounds');

  CollectionReference _rawRoundsCollections(String sessionId) => _firestore
      .collection('games')
      .doc(gameId)
      .collection('sessions')
      .doc(sessionId)
      .collection('rounds');

  DocumentReference _roundDoc(String sessionId, String roundNumber) =>
      _roundsCollection(sessionId).doc(roundNumber);

  CollectionReference _answersCollection(
    String sessionId,
    String roundNumber,
  ) => _roundDoc(sessionId, roundNumber).collection('answers');

  DocumentReference _answerDoc(
    String sessionId,
    String roundNumber,
    String playerId,
  ) => _answersCollection(sessionId, roundNumber).doc(playerId);

  CollectionReference get _gamePlayersCollection =>
      _gameDoc.collection('game_players');

  DocumentReference _gamePlayerDoc(String playerId) =>
      _gamePlayersCollection.doc(playerId);

  CollectionReference<UserModel> get users => _firestore
      .collection('users')
      .withConverter(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (UserModel user, _) => user.toJson(),
      );

  Future<void> createSession(GameSessionModel session) async {
    await _sessionDoc(session.sessionId).set(session.toJson());
  }

  Future<GameSessionModel?> getSession(String sessionId) async {
    final doc = await _sessionDoc(sessionId).get();
    if (!doc.exists) return null;
    return GameSessionModel.fromFirestore(doc);
  }

  Future<void> updateSession(
    String sessionId,
    Map<String, dynamic> updates,
  ) async {
    updates['lastUpdated'] = Timestamp.now();
    await _sessionDoc(sessionId).update(updates);
  }

  Future<void> updateSessionStatus(
    String sessionId,
    SessionStatus status,
  ) async {
    await updateSession(sessionId, {'status': status.toJson()});
  }

  Future<void> deleteSession(String sessionId) async {
    await _sessionDoc(sessionId).delete();
  }

  Stream<GameSessionModel?> listenToSession(String sessionId) {
    return _sessionDoc(sessionId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return GameSessionModel.fromFirestore(doc);
    });
  }

  Future<void> addPlayer(
    String sessionId,
    PlayerParticipationModel player,
  ) async {
    await _playerDoc(sessionId, player.playerId).set(player.toJson());
  }

  Future<PlayerParticipationModel?> getPlayer(
    String sessionId,
    String playerId,
  ) async {
    final doc = await _playerDoc(sessionId, playerId).get();
    if (!doc.exists) return null;
    return PlayerParticipationModel.fromFirestore(doc);
  }

  Future<void> updatePlayer(
    String sessionId,
    String playerId,
    Map<String, dynamic> updates,
  ) async {
    updates['lastHeartbeat'] = Timestamp.now();
    await _playerDoc(sessionId, playerId).update(updates);
  }

  Future<void> updatePlayerStatus(
    String sessionId,
    String playerId,
    PlayerStatus status,
  ) async {
    await updatePlayer(sessionId, playerId, {'status': status.toJson()});
  }

  Future<void> updatePlayerScore(
    String sessionId,
    String playerId,
    int totalScore,
    String? roundKey,
    int? roundScore,
  ) async {
    final updates = <String, dynamic>{'totalScore': totalScore};
    if (roundKey != null && roundScore != null) {
      updates['scoresByRound.$roundKey'] = roundScore;
    }
    await updatePlayer(sessionId, playerId, updates);
  }

  Future<void> updatePlayerHeartbeat(String sessionId, String playerId) async {
    await _playerDoc(
      sessionId,
      playerId,
    ).update({'lastHeartbeat': Timestamp.now(), 'isOnline': true});
  }

  Future<void> removePlayer(String sessionId, String playerId) async {
    await updatePlayer(sessionId, playerId, {
      'status': PlayerStatus.left.toJson(),
      'leftAt': Timestamp.now(),
      'isOnline': false,
    });
  }

  Future<List<PlayerParticipationModel>> getLeaderboard(
    String sessionId, {
    int? limit,
  }) async {
    Query query = _playersCollection(
      sessionId,
    ).orderBy('totalScore', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => PlayerParticipationModel.fromFirestore(doc))
        .toList();
  }

  Stream<List<PlayerParticipationModel>> listenToPlayers(String sessionId) {
    return _playersCollection(sessionId).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => PlayerParticipationModel.fromFirestore(doc))
          .toList(),
    );
  }

  Future<void> createRound(String sessionId, RoundModel round) async {
    await _roundDoc(
      sessionId,
      round.roundNumber.toString(),
    ).set(round.toJson());
  }

  Future<RoundModel?> getRound(String sessionId, int roundNumber) async {
    final doc = await _roundDoc(sessionId, roundNumber.toString()).get();
    if (!doc.exists) return null;
    return RoundModel.fromFirestore(doc);
  }

  Future<void> updateRound(
    String sessionId,
    int roundNumber,
    Map<String, dynamic> updates,
  ) async {
    await _roundDoc(sessionId, roundNumber.toString()).update(updates);
  }

  Future<void> updateRoundStatus(
    String sessionId,
    int roundNumber,
    RoundStatus status,
  ) async {
    await updateRound(sessionId, roundNumber, {'status': status.toJson()});
  }

  Future<List<RoundModel>> getAllRounds(String sessionId) async {
    final snapshot = await _roundsCollection(
      sessionId,
    ).orderBy('roundNumber', descending: false).get();
    return snapshot.docs.map((doc) => RoundModel.fromFirestore(doc)).toList();
  }

  Stream<RoundModel?> listenToRound(String sessionId, int roundNumber) {
    return _roundDoc(sessionId, roundNumber.toString()).snapshots().map((doc) {
      if (!doc.exists) return null;
      return RoundModel.fromFirestore(doc);
    });
  }

  Future<void> submitAnswer(
    String sessionId,
    int roundNumber,
    PlayerAnswerModel answer,
  ) async {
    await _answerDoc(
      sessionId,
      roundNumber.toString(),
      answer.playerId,
    ).set(answer.toJson());
  }

  Future<void> updateAnswerScoring(
    String sessionId,
    int roundNumber,
    String playerId,
    Map<String, dynamic> scoring,
  ) async {
    await _answerDoc(
      sessionId,
      roundNumber.toString(),
      playerId,
    ).update({'scoring': scoring});
  }

  Future<List<PlayerAnswerModel>> getAllAnswers(
    String sessionId,
    int roundNumber,
  ) async {
    final snapshot = await _answersCollection(
      sessionId,
      roundNumber.toString(),
    ).get();
    return snapshot.docs
        .map((doc) => PlayerAnswerModel.fromFirestore(doc))
        .toList();
  }

  Future<void> saveGamePlayer(GamePlayerModel player) async {
    await _gamePlayerDoc(player.playerId).set(player.toJson());
  }

  Future<GamePlayerModel?> getGamePlayer(String playerId) async {
    final doc = await _gamePlayerDoc(playerId).get();
    if (!doc.exists) return null;
    return GamePlayerModel.fromFirestore(doc);
  }

  Future<void> updateGamePlayerLastActive(String playerId) async {
    await _gamePlayerDoc(playerId).update({'lastActive': Timestamp.now()});
  }

  Future<void> updateGamePlayerImage(String playerId, String? imagePath) async {
    await _gamePlayerDoc(
      playerId,
    ).update({'profileImage': imagePath, 'lastActive': Timestamp.now()});
  }

  Future<bool> gamePlayerExists(String playerId) async {
    final doc = await _gamePlayerDoc(playerId).get();
    return doc.exists;
  }

  Future<GamePlayerModel> getOrCreateGamePlayer({
    required String username,
    String? profileImage,
  }) async {
    final existing = await getGamePlayer(username);
    if (existing != null) {
      await updateGamePlayerLastActive(username);
      return existing.updateLastActive();
    }

    final newPlayer = GamePlayerModel.fromUsername(
      username: username,
      profileImage: profileImage,
    );
    await saveGamePlayer(newPlayer);
    return newPlayer;
  }

  Future<RoundModel> addNewRound({
    required String sessionId,
    required String selectedLetter,
    required int allocatedTime,
    required List<RoundParticipant> participants,
    required int wheelIndex,
  }) async {
    try {
      final previousRoundsSnapshot = await _rawRoundsCollections(
        sessionId,
      ).get();
      final previousRoundsCount = previousRoundsSnapshot.size;
      final round = RoundModel(
        roundNumber: previousRoundsCount + 1,
        status: RoundStatus.pending,
        stats: RoundStatsModel(),
        wheelIndex: wheelIndex,
        wheelSpinTimestamp: DateTime.now(),
        selectedLetter: selectedLetter,
        participants: participants,
        timeConfig: RoundTimeConfig(
          allocatedTime: allocatedTime,
          startedAt: DateTime.now(),
          scheduledEndAt: DateTime.now().add(Duration(seconds: allocatedTime)),
        ),
      );
      await createRound(sessionId, round);
      await _sessionDoc(
        sessionId,
      ).update({'config.currentRound': previousRoundsCount + 1});
      log("New round created successfully");
      return round;
    } on Exception catch (e) {
      log("Error while creating round $e");
      rethrow;
    }
  }

  Future<void> submitAnswers(String sessionId, PlayerAnswerModel answer) async {
    try {
      final sessionSnapshot = await _sessionDoc(sessionId).get();
      final sessionData = sessionSnapshot.data() as Map<String, dynamic>?;
      if (sessionData == null) {
        throw Exception('Session not found');
      }
      final roundNumber = ((sessionData['config'] ?? {})['currentRound']) ?? 0;
      // Use currentRoundData if needed

      await _answerDoc(
        sessionId,
        roundNumber.toString(),
        answer.playerId,
      ).set(answer.toJson());
    } on Exception catch (e) {
      log("Error while setting answers $e");
      rethrow;
    }
  }

  //update currentSeletedLetter;

  Future<void> updateCurrentSelectedLetter(
    String sessionId,
    String? letter,
  ) async {
    try {
      await _sessionDoc(
        sessionId,
      ).update({'config.currentSelectedLetter': letter});
    } on Exception catch (e) {
      log("Error while setting the letter in config.currentSelectedLetter");
      throw Exception("Error $e");
    }
  }

  Stream<SessionStatus?> getSessionStatusStream(String sessionId) {
    return _sessionDoc(sessionId).snapshots().map((snap) {
      final data = snap.data() as Map<String, dynamic>?;
      if (data == null) return null;

      final statusString = (data['status'] ?? data['config']?['status'])
          ?.toString();
      if (statusString == null) return null;

      return SessionStatus.values.firstWhere(
        (e) => e.toString() == 'SessionStatus.$statusString',
        orElse: () => SessionStatus.waiting,
      );
    });
  }

  Stream<String?> streamCurrentSelectedLetter(String sessionId) {
    return _sessionDoc(sessionId).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) return null;
      final letter =
          (data['config'] as Map<String, dynamic>?)?['currentSelectedLetter'];
      return letter as String?;
    });
  }

  Stream<bool> streamStartCounting(String sessionId) {
    return _sessionDoc(sessionId).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) return false;
      final startCounting =
          (data['config'] as Map<String, dynamic>?)?['startCounting'];
      return startCounting == true;
    });
  }

  Future<void> updateStartCounting(String sessionId, bool startCounting) async {
    try {
      await _sessionDoc(
        sessionId,
      ).update({'config.startCounting': startCounting});
    } on Exception catch (e) {
      log("Error while updating startCounting $e");
      throw Exception("Error $e");
    }
  }

  Future<void> updateRoundedStatus(
    String sessionId,
    int roundNumber,
    //complete
    //pending
    //started
    String status,
  ) async {
    try {
      await _sessionDoc(sessionId).set({
        'roundStatus_${roundNumber.toString()}': status,
      }, SetOptions(merge: true));
    } on Exception catch (e) {
      log("Error while updating round status $e");
      throw Exception("Error $e");
    }
  }

  Stream<Map<String, String>?> streamRoundStatus(String sessionId) {
    return _sessionDoc(sessionId).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      log("This is the data that we get in the stream ${data}");
      if (data == null) return null;

      final Map<String, String> roundStatusMap = {};

      data.forEach((key, value) {
        if (key.startsWith('roundStatus_')) {
          if (value is String) {
            final roundNumber = key.substring('roundStatus_'.length);
            roundStatusMap[roundNumber] = value;
          }
        }
      });

      return roundStatusMap.isNotEmpty ? roundStatusMap : null;
    });
  }

  Stream<int?> streamCurrentRound(String sessionId) {
    return _sessionDoc(sessionId).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) return null;
      final currentRound =
          (data['config'] as Map<String, dynamic>?)?['currentRound'];
      if (currentRound is int) return currentRound;
      if (currentRound is String) {
        return int.tryParse(currentRound);
      }
      return null;
    });
  }

  Stream<List<PlayerAnswerModel>> streamAllAnswersForTheRound(
    String sessionId,
    int roundNumber,
  ) {
    try {
      return _sessionDoc(sessionId)
          .collection('rounds')
          .doc(roundNumber.toString())
          .collection('answers')
          .snapshots()
          .map((snapshot) {
            var data = snapshot.docs
                .map((doc) => PlayerAnswerModel.fromJson(doc.data()))
                .toList();
            log(
              "This is the data that we get from the firebase for the round $roundNumber $data",
            );
            return data;
          });
    } catch (e) {
      log('Error getting all player answers: $e');
      rethrow;
    }
  }

  Stream<Map<String, dynamic>?> streamSessionConfig(String sessionId) {
    return _sessionDoc(sessionId).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) return null;
      final config = data['config'];
      if (config is Map<String, dynamic>) return config;
      if (config is Map) {
        return Map<String, dynamic>.from(config);
      }
      return null;
    });
  }

  Stream<int> streamCountOfPlayersWhoSubmittedAnswers(
    String sessionId,
    int roundNumber,
  ) {
    try {
      var data = _answersCollection(sessionId, roundNumber.toString())
          .snapshots()
          .map((answersSnapshot) {
            final submittedPlayerIds = answersSnapshot.docs.toSet();
            return submittedPlayerIds.length;
          });
      log("This is the data that we have ${data.length}");
      return data;
    } catch (e) {
      log('Error streaming count of players who submitted answers: $e');
      rethrow;
    }
  }

  Stream<int> streamRoundRemainingTime(String sessionId, int roundNumber) {
    return _roundDoc(sessionId, roundNumber.toString()).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) {
        return 0;
      }

      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) {
        return 0;
      }

      final timeConfig = data['timeConfig'] as Map<String, dynamic>?;
      if (timeConfig == null) {
        return 0;
      }

      final scheduledEndAt = timeConfig['scheduledEndAt'];
      if (scheduledEndAt == null) {
        return 0;
      }

      DateTime endTime;
      if (scheduledEndAt is Timestamp) {
        endTime = scheduledEndAt.toDate();
      } else if (scheduledEndAt is DateTime) {
        endTime = scheduledEndAt;
      } else {
        return 0;
      }

      final now = DateTime.now();
      final difference = endTime.difference(now);
      final remainingSeconds = difference.inSeconds;

      // Return 0 if time has expired, otherwise return remaining seconds
      return remainingSeconds > 0 ? remainingSeconds : 0;
    });
  }

  Stream<bool> hasAnyAnswersSubmittedForTheRound(
    String sessionId,
    int roundNumber,
  ) {
    final answersCollection = _answersCollection(
      sessionId,
      roundNumber.toString(),
    );
    return answersCollection.snapshots().map(
      (snapshot) => snapshot.docs.isNotEmpty,
    );
  }

  /// Get the number of players in a session
  Future<int> getPlayerCount(String sessionId) async {
    try {
      final playersSnapshot = await _playersCollection(sessionId).get();
      return playersSnapshot.docs.length;
    } catch (e) {
      log('Error getting player count: $e', name: 'FirebaseFirestoreService');
      return 0;
    }
  }

  /// Stream the number of players in a session
  Stream<int> streamPlayerCount(String sessionId) {
    return _playersCollection(
      sessionId,
    ).snapshots().map((snapshot) => snapshot.docs.length);
  }

  Stream<GameSessionModel?> streamGameSession(String sessionId) {
    return _sessionDoc(sessionId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return GameSessionModel.fromFirestore(doc);
    });
  }

  Future<void> updateTimePerRound(
    String sessionId,
    int timePerRoundSeconds,
  ) async {
    try {
      await _sessionDoc(
        sessionId,
      ).update({'config.defaultTimePerRound': timePerRoundSeconds});
      log(
        'Updated timePerRound for session $sessionId to $timePerRoundSeconds',
        name: 'FirebaseFirestoreService',
      );
    } catch (e, s) {
      log(
        'Error updating timePerRound for session: $e',
        name: 'FirebaseFirestoreService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> updateMaxRounds(String sessionId, int maxRounds) async {
    try {
      await _sessionDoc(sessionId).update({'config.maxRounds': maxRounds});
      log(
        'Updated maxRounds for session $sessionId to $maxRounds',
        name: 'FirebaseFirestoreService',
      );
    } catch (e, s) {
      log(
        'Error updating maxRounds for session: $e',
        name: 'FirebaseFirestoreService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> submitCategoryVote({
    required String sessionId,
    required int roundNumber,
    required String answerPlayerId,
    required String category,
    required String voterId,
    required bool isClear,
  }) async {
    try {
      final answerDoc = _answerDoc(
        sessionId,
        roundNumber.toString(),
        answerPlayerId,
      );

      final answerSnapshot = await answerDoc.get();
      if (!answerSnapshot.exists) {
        throw Exception('Answer not found for player $answerPlayerId');
      }

      final answerData = answerSnapshot.data() as Map<String, dynamic>;
      final votes = answerData['votes'] as Map<String, dynamic>? ?? {};

      // Get or create the category votes list
      final categoryVotes = (votes[category] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList();

      // Remove any existing vote from this voter for this category
      categoryVotes.removeWhere((vote) => vote.startsWith('$voterId:'));

      // Add the new vote (format: "voterId:clear" or "voterId:unclear")
      categoryVotes.add('$voterId:${isClear ? "clear" : "unclear"}');

      // Update the votes in the answer document
      votes[category] = categoryVotes;

      await answerDoc.update({'votes': votes});

      log(
        'Vote submitted: $voterId voted ${isClear ? "clear" : "unclear"} for $answerPlayerId\'s $category',
        name: 'FirebaseFirestoreService',
      );
    } catch (e, s) {
      log(
        'Error submitting category vote: $e',
        name: 'FirebaseFirestoreService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Process voting results for all unclear answers and update scoring
  /// Returns true if any votes were processed
  Future<bool> processVotingResults({
    required String sessionId,
    required int roundNumber,
  }) async {
    try {
      final allAnswers = await getAllAnswers(sessionId, roundNumber);
      bool anyUpdates = false;

      for (final answer in allAnswers) {
        if (answer.scoring == null) continue;

        final updatedBreakdown = <String, CategoryScore>{};
        bool needsUpdate = false;

        for (final entry in answer.scoring!.breakdown.entries) {
          final category = entry.key;
          final categoryScore = entry.value;

          // Only process unclear answers
          if (categoryScore.status != AnswerEvaluationStatus.unclear) {
            updatedBreakdown[category] = categoryScore;
            continue;
          }

          // Get votes for this category
          final categoryVotes = answer.votes.votes[category] ?? [];

          if (categoryVotes.isEmpty) {
            // No votes, default to 0 points (unclear)
            updatedBreakdown[category] = CategoryScore(
              isCorrect: false,
              points: 0,
              status: AnswerEvaluationStatus.incorrect,
            );
            needsUpdate = true;
            continue;
          }

          // Count clear and unclear votes
          int clearVotes = 0;
          int unclearVotes = 0;

          for (final vote in categoryVotes) {
            if (vote.endsWith(':clear')) {
              clearVotes++;
            } else if (vote.endsWith(':unclear')) {
              unclearVotes++;
            }
          }

          // Determine final decision: more clear votes = 10 points, otherwise 0
          final isClear = clearVotes > unclearVotes;

          updatedBreakdown[category] = CategoryScore(
            isCorrect: isClear,
            points: isClear ? 10 : 0,
            status: isClear
                ? AnswerEvaluationStatus.correct
                : AnswerEvaluationStatus.incorrect,
          );
          needsUpdate = true;

          log(
            'Voting result for ${answer.playerName}\'s $category: '
            'clear=$clearVotes, unclear=$unclearVotes, final=${isClear ? "clear (10pts)" : "unclear (0pts)"}',
            name: 'FirebaseFirestoreService',
          );
        }

        if (needsUpdate) {
          // Recalculate total score
          int newTotalScore = 0;
          int newCorrectCount = 0;
          for (final score in updatedBreakdown.values) {
            newTotalScore += score.points;
            if (score.isCorrect) newCorrectCount++;
          }

          final updatedScoring = ScoringResult(
            correctAnswers: newCorrectCount,
            fooledPlayers: answer.scoring!.fooledPlayers,
            roundScore: newTotalScore,
            breakdown: updatedBreakdown,
          );

          await updateAnswerScoring(
            sessionId,
            roundNumber,
            answer.playerId,
            updatedScoring.toJson(),
          );

          // Update player's total score
          final participation = await getPlayer(sessionId, answer.playerId);
          if (participation != null) {
            final oldRoundScore =
                participation.scoresByRound[roundNumber.toString()] ?? 0;
            final scoreDifference = newTotalScore - oldRoundScore;
            final updatedTotalScore =
                participation.totalScore + scoreDifference;

            await updatePlayerScore(
              sessionId,
              answer.playerId,
              updatedTotalScore,
              roundNumber.toString(),
              newTotalScore,
            );
          }

          anyUpdates = true;
        }
      }

      return anyUpdates;
    } catch (e, s) {
      log(
        'Error processing voting results: $e',
        name: 'FirebaseFirestoreService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> updateIsWheelSpinning(
    String sessionId,
    bool? isWheelSpinning,
  ) async {
    try {
      await _sessionDoc(
        sessionId,
      ).update({'config.isWheelSpinning': isWheelSpinning});
    } on Exception catch (e) {
      log("Error while updating isWheelSpinning $e");
      throw Exception("Error $e");
    }
  }

  Future<GameSessionModel?> getCurrentGameSession(String sessionId) async {
    try {
      final docSnapshot = await _sessionDoc(sessionId).get();

      if (!docSnapshot.exists) {
        log('Session document does not exist: $sessionId');
        return null;
      }

      final data = docSnapshot.data() as Map<String, dynamic>?;
      if (data == null) {
        log('Session document data is null: $sessionId');
        return null;
      }

      return GameSessionModel.fromJson(data);
    } catch (e, s) {
      log(
        'Error getting current game session: $e',
        name: 'FirebaseFirestoreService',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
