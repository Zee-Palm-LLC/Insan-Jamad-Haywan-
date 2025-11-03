import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insan_jamd_hawan/services/audio_service.dart';

class CustomIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const CustomIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await AudioService.instance.playAudio(AudioType.click);
        onTap();
      },
      child: SvgPicture.asset(icon),
    );
  }
}
