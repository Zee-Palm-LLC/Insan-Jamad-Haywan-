import 'package:flutter/material.dart';
import 'package:insan_jamd_hawan/data/constants/app_assets.dart';

class GameLogo extends StatelessWidget {
  const GameLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppAssets.logo);
  }
}