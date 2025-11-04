import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insan_jamd_hawan/data/constants/app_assets.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/custom_icon_button.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class GameLogo extends StatelessWidget {
  const GameLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Row(
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisAlignment: isDesktop
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      children: [
        if (isDesktop)
          CustomIconButton(
            icon: AppAssets.backIcon,
            onTap: () {
              context.pop();
            },
          ),
        Image.asset(AppAssets.logo),
        if (isDesktop)
          CustomIconButton(icon: AppAssets.shareIcon, onTap: () {}),
      ],
    );
  }
}
