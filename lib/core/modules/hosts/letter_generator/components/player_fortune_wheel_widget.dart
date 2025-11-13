import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:insan_jamd_hawan/core/controllers/lobby_controller.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/data/helpers/wheel_helper.dart';
import 'package:insan_jamd_hawan/core/modules/widgets/animations/confetti_animation.dart';
import 'package:insan_jamd_hawan/core/services/firebase_firestore_service.dart';
import 'dart:developer' as dev;

class PlayerFortuneWheelWidget extends StatefulWidget {
  const PlayerFortuneWheelWidget({super.key});

  @override
  State<PlayerFortuneWheelWidget> createState() =>
      _PlayerFortuneWheelWidgetState();
}

class _PlayerFortuneWheelWidgetState extends State<PlayerFortuneWheelWidget> {
  StreamController<int>? _controller;
  final Random _random = Random();
  Timer? _spinningTimer;
  Timer? _smoothStopTimer;
  int _currentIndex = 0;
  StreamSubscription? _firebaseSubscription;

  bool _isSpinning = false;
  String? _letter;

  LobbyController get controller => Get.find<LobbyController>();

  @override
  void initState() {
    super.initState();
    _controller = StreamController<int>.broadcast();
    _currentIndex = 0;

    // Listen to Firebase stream
    _firebaseSubscription = FirebaseFirestoreService.instance
        .streamGameSession(controller.lobby.id!)
        .listen((session) {
          if (!mounted) return;

          final newIsSpinning = session?.config.isWheelSpinning ?? false;
          final newLetter = session?.config.currentSelectedLetter;

          dev.log(
            '[PlayerFortuneWheel] Firebase update - isSpinning: $newIsSpinning, letter: $newLetter',
          );

          // Only update if values changed
          if (_isSpinning != newIsSpinning || _letter != newLetter) {
            setState(() {
              _isSpinning = newIsSpinning;
              _letter = newLetter;
            });
            _handleStateChange();
          }
        });
  }

  void _handleStateChange() {
    dev.log(
      '[PlayerFortuneWheel] _handleStateChange - isSpinning: $_isSpinning, letter: $_letter',
    );

    // If we have a letter, we want a smooth stop (do NOT cancel timer immediately)
    if (_letter != null) {
      _startSmoothStop(_letter!);
      return;
    }

    // No letter yet → either start or stop spinning based on flag
    _spinningTimer?.cancel();

    if (_isSpinning == true) {
      dev.log('[PlayerFortuneWheel] Starting spinning');
      _startSpinning();
    } else {
      dev.log('[PlayerFortuneWheel] Stopping spinning');
      _stopSpinning();
    }
  }

  void _startSpinning() {
    dev.log('[PlayerFortuneWheel] _startSpinning called');

    // If we already have a letter, do NOT start random spinning
    if (_letter != null) {
      dev.log(
        '[PlayerFortuneWheel] Not starting spinning because letter is already set: $_letter',
      );
      return;
    }

    // Ensure controller exists and is not closed
    if (_controller == null || _controller!.isClosed) {
      _controller = StreamController<int>.broadcast();
    }

    _spinningTimer?.cancel();

    _spinningTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted || !_isSpinning || _letter != null) {
        dev.log(
          '[PlayerFortuneWheel] Timer stopped - mounted: $mounted, isSpinning: $_isSpinning, letter: $_letter',
        );
        timer.cancel();
        return;
      }

      _currentIndex = _random.nextInt(WheelHelper.getAlphabets().length);
      dev.log('[PlayerFortuneWheel] Adding to stream: $_currentIndex');
      _controller?.add(_currentIndex);
    });
  }

  /// Start a "smooth stop" when a letter arrives:
  /// - Let it spin a bit more (delay)
  /// - Then stop gracefully on that letter
  void _startSmoothStop(String letter) {
    // If already scheduled, don't schedule again
    if (_smoothStopTimer != null) {
      return;
    }

    dev.log('[PlayerFortuneWheel] _startSmoothStop scheduled for $letter');

    _smoothStopTimer = Timer(const Duration(milliseconds: 800), () {
      _smoothStopTimer = null;

      // If widget gone or letter changed, bail out
      if (!mounted || _letter != letter) {
        return;
      }

      _stopAtLetter(letter);
    });
  }

  void _stopAtLetter(String letter) {
    dev.log('[PlayerFortuneWheel] _stopAtLetter called for letter: $letter');

    // Stop any running timers
    _spinningTimer?.cancel();
    _spinningTimer = null;

    // Locally mark as not spinning
    _isSpinning = false;

    final alphabets = WheelHelper.getAlphabets();
    final targetIndex = alphabets.indexOf(letter);
    dev.log(
      '[PlayerFortuneWheel] Target index for letter $letter: $targetIndex',
    );

    if (targetIndex == -1 || !mounted) return;

    _currentIndex = targetIndex;

    // Close old controller so NO old random events can come through
    try {
      _controller?.close();
    } catch (_) {
      // ignore if already closed
    }

    // Create a brand new controller just for the final stop
    _controller = StreamController<int>.broadcast();

    // Push the final index once
    dev.log(
      '[PlayerFortuneWheel] Adding final target index to new stream: $_currentIndex',
    );
    _controller!.add(_currentIndex);

    // Rebuild so FortuneWheel listens to new stream
    if (mounted) {
      setState(() {});
    }
  }

  void _stopSpinning() {
    _spinningTimer?.cancel();
    _spinningTimer = null;
  }

  @override
  void dispose() {
    _spinningTimer?.cancel();
    _smoothStopTimer?.cancel();
    _controller?.close();
    _firebaseSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320.h,
      width: 320.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 320.h,
            width: 320.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.kWhite,
            ),
          ),
          Container(
            height: 320.h,
            width: 320.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.kGray300.withValues(alpha: 0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: FortuneWheel(
              selected: _controller!.stream,
              indicators: const <FortuneIndicator>[],
              animateFirst: false,
              physics: _letter != null
                  ? CircularPanPhysics(
                      // smoother, longer deceleration when stopping on letter
                      duration: Duration(milliseconds: 1500),
                      curve: Curves.decelerate,
                    )
                  : CircularPanPhysics(
                      duration: Duration(milliseconds: 2500),
                      curve: Curves.decelerate,
                    ),
              items: [
                for (int i = 0; i < WheelHelper.getAlphabets().length; i++)
                  FortuneItem(
                    style: FortuneItemStyle(
                      color:
                          _letter != null &&
                              WheelHelper.getAlphabets()[i] != _letter
                          ? WheelHelper.getColorForIndex(
                              i,
                            ).withValues(alpha: 0.1)
                          : WheelHelper.getColorForIndex(i),
                      borderWidth: 0,
                    ),
                    child: Container(
                      width: double.maxFinite,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 10.w),
                      color:
                          _letter != null &&
                              WheelHelper.getAlphabets()[i] != _letter
                          ? WheelHelper.getColorForIndex(
                              i,
                            ).withValues(alpha: 0.1)
                          : WheelHelper.getColorForIndex(i),
                      child: Text(
                        WheelHelper.getAlphabets()[i],
                        style: AppTypography.kRegular19.copyWith(
                          color:
                              _letter != null &&
                                  WheelHelper.getAlphabets()[i] != _letter
                              ? AppColors.kBlack.withValues(alpha: 0.1)
                              : AppColors.kBlack,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_letter != null) ...[
            ConfettiAnimation(
              key: ValueKey(_letter),
              enabled: _letter != null,
              duration: const Duration(seconds: 3),
            ),
            Container(
              width: 61.w,
              height: 61.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.kPrimary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _letter!,
                  style: AppTypography.kBold24.copyWith(
                    color: AppColors.kWhite,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class StaticPlayerFortuneWheelWidget extends StatelessWidget {
  final String letter;

  const StaticPlayerFortuneWheelWidget({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    final alphabets = WheelHelper.getAlphabets();
    final targetIndex = alphabets.indexOf(letter);

    // Fallback: agar letter list me na mile to index 0
    final safeIndex = targetIndex == -1 ? 0 : targetIndex;

    // Single-value stream taake FortuneWheel ko ek hi selected index mile
    final selectedStream = Stream<int>.value(safeIndex);

    return SizedBox(
      height: 320.h,
      width: 320.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 320.h,
            width: 320.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.kWhite,
            ),
          ),
          Container(
            height: 320.h,
            width: 320.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.kGray300.withValues(alpha: 0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: FortuneWheel(
              // No spinning: just one value with almost-zero duration
              selected: selectedStream,
              indicators: const <FortuneIndicator>[],
              animateFirst: false,
              physics: CircularPanPhysics(
                duration: Duration(
                  milliseconds: 1,
                ), // practically no animation, just render at position
                curve: Curves.linear,
              ),
              items: [
                for (int i = 0; i < alphabets.length; i++)
                  FortuneItem(
                    style: FortuneItemStyle(
                      color: alphabets[i] != letter
                          ? WheelHelper.getColorForIndex(
                              i,
                            ).withValues(alpha: 0.1)
                          : WheelHelper.getColorForIndex(i),
                      borderWidth: 0,
                    ),
                    child: Container(
                      width: double.maxFinite,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 10.w),
                      color: alphabets[i] != letter
                          ? WheelHelper.getColorForIndex(
                              i,
                            ).withValues(alpha: 0.1)
                          : WheelHelper.getColorForIndex(i),
                      child: Text(
                        alphabets[i],
                        style: AppTypography.kRegular19.copyWith(
                          color: alphabets[i] != letter
                              ? AppColors.kBlack.withValues(alpha: 0.1)
                              : AppColors.kBlack,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Center selected letter + confetti (optional)
          ConfettiAnimation(
            key: ValueKey(letter),
            enabled: true,
            duration: const Duration(seconds: 3),
          ),
          Container(
            width: 61.w,
            height: 61.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.kPrimary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                letter,
                style: AppTypography.kBold24.copyWith(color: AppColors.kWhite),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
