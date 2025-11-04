import 'package:flutter/material.dart';
import 'package:insan_jamd_hawan/core/data/constants/app_assets.dart';

class LobbyBg extends StatelessWidget {
  final Widget child;
  const LobbyBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.liningBg),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
