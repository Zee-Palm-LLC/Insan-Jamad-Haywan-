import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insan_jamd_hawan/core/models/session/ambiguous_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/game_player_model.dart';
import 'package:insan_jamd_hawan/core/models/session/game_session_model.dart';
import 'package:insan_jamd_hawan/core/models/session/game_summary_model.dart';
import 'package:insan_jamd_hawan/core/models/session/player_answer_model.dart';
import 'package:insan_jamd_hawan/core/models/session/player_participation_model.dart';
import 'package:insan_jamd_hawan/core/models/session/player_vote_model.dart';
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

  CollectionReference _votesCollection(String sessionId, String roundNumber) =>
      _roundDoc(sessionId, roundNumber).collection('votes');

  DocumentReference _voteDoc(
    String sessionId,
    String roundNumber,
    String playerId,
  ) => _votesCollection(sessionId, roundNumber).doc(playerId);

  CollectionReference _ambiguousAnswersCollection(
    String sessionId,
    String roundNumber,
  ) => _roundDoc(sessionId, roundNumber).collection('ambiguous_answers');

  DocumentReference _ambiguousAnswerDoc(
    String sessionId,
    String roundNumber,
    String ambiguousAnswerId,
  ) => _ambiguousAnswersCollection(
    sessionId,
    roundNumber,
  ).doc(ambiguousAnswerId);

  DocumentReference _summaryDoc(String sessionId) =>
      _sessionDoc(sessionId).collection('summary').doc('data');

  CollectionReference get _gamePlayersCollection =>
      _gameDoc.collection('game_players');

  DocumentReference _gamePlayerDoc(String playerId) =>
      _gamePlayersCollection.doc(playerId);

  CollectionReference get gameResults => _firestore
      .collection('insan_jamd_hawan_results')
      .withConverter(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data as Map<String, dynamic>,
      );

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

  Future<List<PlayerParticipationModel>> getAllPlayers(String sessionId) async {
    final snapshot = await _playersCollection(sessionId).get();
    return snapshot.docs
        .map((doc) => PlayerParticipationModel.fromFirestore(doc))
        .toList();
  }

  Future<List<PlayerParticipationModel>> getActivePlayers(
    String sessionId,
  ) async {
    final snapshot = await _playersCollection(sessionId)
        .where('status', isEqualTo: PlayerStatus.active.toJson())
        .where('isOnline', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => PlayerParticipationModel.fromFirestore(doc))
        .toList();
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

  Stream<List<RoundModel>> listenToRounds(String sessionId) {
    return _roundsCollection(sessionId)
        .orderBy('roundNumber', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RoundModel.fromFirestore(doc))
              .toList(),
        );
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

  Future<PlayerAnswerModel?> getAnswer(
    String sessionId,
    int roundNumber,
    String playerId,
  ) async {
    final doc = await _answerDoc(
      sessionId,
      roundNumber.toString(),
      playerId,
    ).get();
    if (!doc.exists) return null;
    return PlayerAnswerModel.fromFirestore(doc);
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

  Future<void> updateAnswerVotes(
    String sessionId,
    int roundNumber,
    String playerId,
    Map<String, dynamic> votes,
  ) async {
    await _answerDoc(
      sessionId,
      roundNumber.toString(),
      playerId,
    ).update({'votes': votes});
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

  Stream<List<PlayerAnswerModel>> listenToAnswers(
    String sessionId,
    int roundNumber,
  ) {
    return _answersCollection(
      sessionId,
      roundNumber.toString(),
    ).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => PlayerAnswerModel.fromFirestore(doc))
          .toList(),
    );
  }

  Future<void> submitVote(
    String sessionId,
    int roundNumber,
    PlayerVoteModel vote,
  ) async {
    await _voteDoc(
      sessionId,
      roundNumber.toString(),
      vote.playerId,
    ).set(vote.toJson());
  }

  Future<PlayerVoteModel?> getVote(
    String sessionId,
    int roundNumber,
    String playerId,
  ) async {
    final doc = await _voteDoc(
      sessionId,
      roundNumber.toString(),
      playerId,
    ).get();
    if (!doc.exists) return null;
    return PlayerVoteModel.fromFirestore(doc);
  }

  Future<List<PlayerVoteModel>> getAllVotes(
    String sessionId,
    int roundNumber,
  ) async {
    final snapshot = await _votesCollection(
      sessionId,
      roundNumber.toString(),
    ).get();
    return snapshot.docs
        .map((doc) => PlayerVoteModel.fromFirestore(doc))
        .toList();
  }

  Stream<List<PlayerVoteModel>> listenToVotes(
    String sessionId,
    int roundNumber,
  ) {
    return _votesCollection(sessionId, roundNumber.toString()).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => PlayerVoteModel.fromFirestore(doc))
          .toList(),
    );
  }

  Future<void> updateSummary(String sessionId, GameSummaryModel summary) async {
    await _summaryDoc(sessionId).set(summary.toJson());
  }

  Future<GameSummaryModel?> getSummary(String sessionId) async {
    final doc = await _summaryDoc(sessionId).get();
    if (!doc.exists) return null;
    return GameSummaryModel.fromFirestore(doc);
  }

  Stream<GameSummaryModel?> listenToSummary(String sessionId) {
    return _summaryDoc(sessionId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return GameSummaryModel.fromFirestore(doc);
    });
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

  Future<void> createAmbiguousAnswer(
    AmbiguousAnswerModel ambiguousAnswer,
  ) async {
    await _ambiguousAnswerDoc(
      ambiguousAnswer.sessionId,
      ambiguousAnswer.roundNumber.toString(),
      ambiguousAnswer.id,
    ).set(ambiguousAnswer.toJson());
  }

  Future<AmbiguousAnswerModel?> getAmbiguousAnswer(
    String sessionId,
    int roundNumber,
    String ambiguousAnswerId,
  ) async {
    final doc = await _ambiguousAnswerDoc(
      sessionId,
      roundNumber.toString(),
      ambiguousAnswerId,
    ).get();
    if (!doc.exists) return null;
    return AmbiguousAnswerModel.fromFirestore(doc);
  }

  Future<List<AmbiguousAnswerModel>> getAllAmbiguousAnswers(
    String sessionId,
    int roundNumber,
  ) async {
    final snapshot = await _ambiguousAnswersCollection(
      sessionId,
      roundNumber.toString(),
    ).get();
    return snapshot.docs
        .map((doc) => AmbiguousAnswerModel.fromFirestore(doc))
        .toList();
  }

  Future<void> updateAmbiguousAnswerVote(
    String sessionId,
    int roundNumber,
    String ambiguousAnswerId,
    String voterId,
    bool isCorrect,
    int correctVotes,
    int incorrectVotes,
  ) async {
    await _ambiguousAnswerDoc(
      sessionId,
      roundNumber.toString(),
      ambiguousAnswerId,
    ).update({
      'votes.$voterId': isCorrect,
      'correctVotes': correctVotes,
      'incorrectVotes': incorrectVotes,
    });
  }

  Future<void> completeAmbiguousAnswerVoting(
    String sessionId,
    int roundNumber,
    String ambiguousAnswerId,
    bool finalDecision,
  ) async {
    await _ambiguousAnswerDoc(
      sessionId,
      roundNumber.toString(),
      ambiguousAnswerId,
    ).update({
      'status': VotingStatus.completed.toJson(),
      'finalDecision': finalDecision,
    });
  }

  Stream<List<AmbiguousAnswerModel>> listenToAmbiguousAnswers(
    String sessionId,
    int roundNumber,
  ) {
    return _ambiguousAnswersCollection(
      sessionId,
      roundNumber.toString(),
    ).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => AmbiguousAnswerModel.fromFirestore(doc))
          .toList(),
    );
  }

  Future<void> deleteSessionWithSubcollections(String sessionId) async {
    final batch = _firestore.batch();

    final players = await _playersCollection(sessionId).get();
    for (final doc in players.docs) {
      batch.delete(doc.reference);
    }

    final rounds = await _roundsCollection(sessionId).get();
    for (final roundDoc in rounds.docs) {
      final answers = await _answersCollection(sessionId, roundDoc.id).get();
      for (final answerDoc in answers.docs) {
        batch.delete(answerDoc.reference);
      }

      final votes = await _votesCollection(sessionId, roundDoc.id).get();
      for (final voteDoc in votes.docs) {
        batch.delete(voteDoc.reference);
      }

      batch.delete(roundDoc.reference);
    }

    batch.delete(_summaryDoc(sessionId));

    batch.delete(_sessionDoc(sessionId));

    await batch.commit();
  }
}
