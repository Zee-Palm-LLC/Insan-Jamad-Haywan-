import 'package:flutter/material.dart';
import 'package:insan_jamd_hawan/data/constants/app_colors.dart';
import 'package:insan_jamd_hawan/data/constants/app_typography.dart';

class RoomCodeText extends StatelessWidget {
  const RoomCodeText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Room Code: ',
            style: AppTypography.kRegular19.copyWith(color: AppColors.kBlack),
          ),
          TextSpan(
            text: 'XY21234',
            style: AppTypography.kBold21.copyWith(color: AppColors.kPrimary),
          ),
        ],
      ),
    );
  }
}
