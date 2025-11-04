import 'package:flutter/material.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/modules/widgets/cards/animated_bg.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  static const String path = '/get-started';
  static const String name = 'GetStarted';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LobbyBg(child: AnimatedBg(
        child: Column(
          children: [
            
          ],
        ),
      )),
    );
  }
}