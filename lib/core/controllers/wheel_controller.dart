import 'dart:developer';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/answer_controller.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/models/session/round_model.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/final_round/final_special_round_view.dart';
import 'package:insan_jamd_hawan/core/modules/hosts/letter_generator/letter_generator_view.dart';
import 'package:insan_jamd_hawan/core/modules/special_round/surprise_round_answer_view.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/services/firestore/firebase_firestore_service.dart';
import 'package:go_router/go_router.dart';
import '../../insan-jamd-hawan.dart';

class WheelController extends GetxController {
  bool isSpinning = false;
  String? selectedLetter;
  LobbyController get lobbyController => Get.find<LobbyController>();
  FirebaseFirestoreService get _db => FirebaseFirestoreService.instance;
  int currentRound = 0;
  int maxRoundSelectedByTheHost = 0;
  RxMap<String, String> roundStatus = RxMap({});

  @override
  void onReady() {
    _listenToCurrentSelectedLetter();
    _listenToCurrentRound();
    _listenToRoundStatus();
    _listenToSessionConfig();
    super.onReady();
  }

  void onLetterSelection(String val) {
    selectedLetter = val;
    update();
    if (lobbyController.lobby.id != null &&
        (lobbyController.lobby.id?.isEmpty ?? false)) {
      throw Exception("SessionID can't be null or empty");
    }
    _db.updateCurrentSelectedLetter(
      lobbyController.lobby.id!,
      selectedLetter ?? '',
    );
  }

  void resetController() {
    isSpinning = false;
    selectedLetter = null;
    update();
  }

  Future<RoundModel> createdNewRound({
    required int allocatedTime,
    required int wheelIndex,
    required List<RoundParticipant> participants,
  }) async {
    if (lobbyController.lobby.id != null &&
        (lobbyController.lobby.id?.isEmpty ?? false)) {
      throw Exception("SessionID can't be null or empty");
    }
    _db.updateStartCounting(lobbyController.lobby.id!, true);
    return await _db.addNewRound(
      sessionId: lobbyController.lobby.id!,
      selectedLetter: selectedLetter ?? '',
      allocatedTime: allocatedTime,
      participants: participants,
      wheelIndex: wheelIndex,
    );
  }

  void _listenToCurrentSelectedLetter() {
    FirebaseFirestoreService.instance
        .streamCurrentSelectedLetter(lobbyController.lobby.id!)
        .listen(
          (letter) {
            log(
              "This is the event that we got from stream from firebase for letter update $letter",
            );
            if (letter != null) {
              selectedLetter = letter;
              update();
            }
          },
          onError: (error) {
            log(
              'Error listening to current selected letter: $error',
              name: 'WaitingView',
            );
          },
        );
  }

  void _listenToCurrentRound() {
    FirebaseFirestoreService.instance
        .streamCurrentRound(lobbyController.lobby.id!)
        .listen(
          (round) {
            log(
              "This is the event that we got from stream from firebase for current round update $round",
            );
            if (round != null) {
              currentRound = round;
              update();
            }
          },
          onError: (error) {
            log(
              'Error listening to current round: $error',
              name: 'WheelController',
            );
          },
        );
  }

  void _listenToRoundStatus() {
    FirebaseFirestoreService.instance
        .streamRoundStatus(lobbyController.lobby.id!)
        .listen(
          (status) async {
            roundStatus.value = status ?? {};
            log(
              "This is the event that we got from stream from firebase for round status update $status",
            );
            String? pId = await AppService.getPlayerId();
            if ((status?.keys.contains("special_round") ??
                    false ||
                        (status?.values.contains("special_round") ?? false)) &&
                pId != lobbyController.lobby.host) {
              resetController();
              Get.find<AnswerController>().restController();
              navigatorKey.currentContext?.go(SurpriseRoundView.path);
              return;
            }
            if ((status?.values.contains("pending") ?? false) &&
                pId != lobbyController.lobby.host) {
              resetController();
              Get.find<AnswerController>().restController();
              navigatorKey.currentContext?.go(LetterGeneratorView.path);
            }
          },
          onError: (error) {
            log(
              'Error listening to round status: $error',
              name: 'WheelController',
            );
          },
        );
  }

  void updateRoundStatus(String status) {
    if (lobbyController.lobby.id != null &&
        (lobbyController.lobby.id?.isEmpty ?? false)) {
      throw Exception("SessionID can't be null or empty");
    }
    log(" We are updating the round status ${status} for round $currentRound");
    _db.updateRoundedStatus(lobbyController.lobby.id!, currentRound, status);
    update();
  }

  void startNextRound() {
    _db.updateRoundedStatus(lobbyController.lobby.id!, currentRound, "pending");
    resetController();
    if (lobbyController.lobby.id != null &&
        (lobbyController.lobby.id?.isNotEmpty ?? false)) {
      _db.updateCurrentSelectedLetter(lobbyController.lobby.id!, null);
    }
    Get.find<AnswerController>().restController();
    update();
  }

  void _listenToSessionConfig() {
    _db.streamSessionConfig(lobbyController.lobby.id!).listen((config) {
      log(
        "This is the event that we got from stream from firebase for session config update $config",
      );
      if (config != null) {
        maxRoundSelectedByTheHost = config['maxRounds'] ?? 0;
        update();
      }
    });
  }

  void updateIsWheelSpinning(bool? isWheelSpinning) {
    if (lobbyController.lobby.id != null &&
        (lobbyController.lobby.id?.isEmpty ?? false)) {
      throw Exception("SessionID can't be null or empty");
    }
    _db.updateIsWheelSpinning(lobbyController.lobby.id!, isWheelSpinning);
    update();
  }
}
