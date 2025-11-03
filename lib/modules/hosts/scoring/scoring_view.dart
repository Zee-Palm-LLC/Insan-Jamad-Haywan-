import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/game_logo.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/lobby_bg.dart';
import 'package:insan_jamd_hawan/modules/hosts/game_lobby/components/room_code_text.dart';
import 'package:insan_jamd_hawan/modules/hosts/scoring/components/scoring_playing_tile.dart';
import 'package:insan_jamd_hawan/modules/hosts/voting/voting_view.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/custom_icon_button.dart';

class ScoringView extends StatefulWidget {
  const ScoringView({super.key, required this.selectedAlphabet});

  final String selectedAlphabet;

  static const String path = '/scoring/:letter';
  static const String name = 'Scoring';

  @override
  State<ScoringView> createState() => _ScoringViewState();
}

class _ScoringViewState extends State<ScoringView>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _shownFruitAnswers = [];
  final List<Map<String, dynamic>> _shownAnimalAnswers = [];

  final List<Map<String, dynamic>> _fruitAnswers = [
    {
      'name': 'Sophia',
      'answer': 'Apple',
      'points': 5,
      'color': AppColors.kPrimary,
    },
    {
      'name': 'Ahmed',
      'answer': 'Apricot',
      'points': 10,
      'color': Colors.orange,
    },
    {
      'name': 'Aman',
      'answer': 'Mango',
      'points': 0,
      'color': AppColors.kRed500,
    },
  ];

  final List<Map<String, dynamic>> _animalAnswers = [
    {
      'name': 'Sophia',
      'answer': 'Ants',
      'points': 10,
      'color': AppColors.kPrimary,
    },
    {
      'name': 'Ahmed',
      'answer': 'Anaconda',
      'points': 5,
      'color': AppColors.kPrimary,
    },
  ];

  @override
  void initState() {
    super.initState();
    _simulateAppearing();
  }

  Future<void> _simulateAppearing() async {
    // Show fruit answers first
    for (final answer in _fruitAnswers) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) {
        setState(() => _shownFruitAnswers.add(answer));
      }
    }

    // Then show animal answers
    for (final answer in _animalAnswers) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) {
        setState(() => _shownAnimalAnswers.add(answer));
      }
    }
  }

  String _getPlayerAvatar(String name) {
    final hash = name.hashCode.abs();
    final index = hash % 4;
    final images = [
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
      'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
      'https://plus.unsplash.com/premium_photo-1678197937465-bdbc4ed95815?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=688',
    ];
    return images[index];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(10.h),
          child: CustomIconButton(
            icon: AppAssets.backIcon,
            onTap: () => context.pop(),
          ),
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
              RoomCodeText(lobbyId: 'XY21234'),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Letter', style: AppTypography.kRegular24),
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: (){
                      context.push(VotingView.path);
                    },
                    child: Container(
                      height: 50.h,
                      width: 74.w,
                      decoration: BoxDecoration(
                        color: AppColors.kPrimary,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(top: 6.h),
                      child: Text(
                        widget.selectedAlphabet,
                        style: AppTypography.kRegular41.copyWith(
                          color: AppColors.kWhite,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.kGreen100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.all(16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Answers',
                      style: AppTypography.kBold21.copyWith(height: 1),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Fruit',
                      style: AppTypography.kRegular24.copyWith(height: 1),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.all(16.h),
                      child: Column(
                        children: [
                          for (int i = 0; i < _shownFruitAnswers.length; i++) ...[
                            ScoringPlayingTile(
                              imagePath: _getPlayerAvatar(_shownFruitAnswers[i]['name'] as String),
                              name: _shownFruitAnswers[i]['name'] as String,
                              answer: _shownFruitAnswers[i]['answer'] as String,
                              points: _shownFruitAnswers[i]['points'] as int,
                              color: _shownFruitAnswers[i]['color'] as Color,
                              index: i + 1,
                            ),
                            if (i != _shownFruitAnswers.length - 1)
                              Divider(
                                color: AppColors.kGray300,
                                thickness: 1,
                                height: 16.h,
                              ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text('Animals', style: AppTypography.kRegular24),
                    SizedBox(height: 12.h),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.all(16.h),
                      child: Column(
                        children: [
                          for (int i = 0; i < _shownAnimalAnswers.length; i++) ...[
                            ScoringPlayingTile(
                              imagePath: _getPlayerAvatar(_shownAnimalAnswers[i]['name'] as String),
                              name: _shownAnimalAnswers[i]['name'] as String,
                              answer: _shownAnimalAnswers[i]['answer'] as String,
                              points: _shownAnimalAnswers[i]['points'] as int,
                              color: _shownAnimalAnswers[i]['color'] as Color,
                              index: i + 1,
                            ),
                            if (i != _shownAnimalAnswers.length - 1)
                              Divider(
                                color: AppColors.kGray300,
                                thickness: 1,
                                height: 16.h,
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}