import 'package:flutter/material.dart';
import 'package:insan_jamd_hawan/data/constants/app_colors.dart';
import 'package:insan_jamd_hawan/data/constants/app_typography.dart';

class RoomCodeText extends StatelessWidget {
  const RoomCodeText({super.key, required this.lobbyId});

  final String lobbyId;

  @override
  Widget build(BuildContext context) {
    // Extract short code from UUID if it's a full UUID
    String displayCode = lobbyId;
    if (lobbyId.length > 8 && lobbyId.contains('-')) {
      // Take first 8 characters or use invite code if available
      displayCode = lobbyId.substring(0, 8).toUpperCase();
    } else if (lobbyId.length > 8) {
      displayCode = lobbyId.substring(0, 8).toUpperCase();
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Room Code: ',
            style: AppTypography.kRegular19.copyWith(color: AppColors.kBlack),
          ),
          TextSpan(
            text: displayCode,
            style: AppTypography.kBold21.copyWith(color: AppColors.kPrimary),
          ),
        ],
      ),
    );
  }
}
