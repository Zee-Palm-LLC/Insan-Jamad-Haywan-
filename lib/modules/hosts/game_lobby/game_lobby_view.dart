import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/app_assets.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/player_list_card.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/modules/hosts/letter_generator/letter_generator_view.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/primary_button.dart';

class GameLobbyView extends StatefulWidget {
  const GameLobbyView({super.key});

  @override
  State<GameLobbyView> createState() => _GameLobbyViewState();
}

class _GameLobbyViewState extends State<GameLobbyView> {
  int selectedRounds = 3;
  int selectedTime = 45;

  final List<Map<String, String>> players = [
    {'name': 'Sophia', 'avatar': ''},
    {'name': 'Ethan', 'avatar': ''},
    {'name': 'Carter', 'avatar': ''},
    {'name': 'Liam John', 'avatar': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(10.h),
          child: CustomIconButton(icon: AppAssets.backIcon, onTap: () {}),
        ),
        actions: [
          CustomIconButton(icon: AppAssets.shareIcon, onTap: () {}),
          SizedBox(width: 16.w),
        ],
      ),
      body: LobbyBg(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              SizedBox(height: 50.h),
              GameLogo(),
              SizedBox(height: 12.h),
              RoomCodeText(),
              SizedBox(height: 34.h),
              PlayerListCard(),
              SizedBox(height: 20.h),
              PrimaryButton(
                text: 'Start !',
                width: 209.w,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LetterGeneratorView(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
