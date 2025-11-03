import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/app_assets.dart';
import 'package:insan_jamd_hawan/data/constants/app_colors.dart';
import 'package:insan_jamd_hawan/data/constants/app_typography.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/custom_icon_button.dart';

class RoomCodeText extends StatelessWidget {
  const RoomCodeText({
    super.key,
    required this.lobbyId,
    this.inviteCode,
    this.iSend = false,
  });

  final String lobbyId;
  final String? inviteCode;
  final bool iSend;

  String _buildDisplayCode() {
    // If invite code exists, use it (short and user-friendly)
    if (inviteCode != null && inviteCode!.trim().isNotEmpty) {
      return inviteCode!.trim().toUpperCase();
    }
    // Otherwise, show shortened lobby ID for display
    final source = lobbyId.trim();
    if (source.isEmpty) return 'UNKNOWN';
    if (source.length > 8) {
      return source.substring(0, 8).toUpperCase();
    }
    return source.toUpperCase();
  }

  String _buildCopyCode() {
    // For copying, use invite code if available, otherwise use full lobby ID
    if (inviteCode != null && inviteCode!.trim().isNotEmpty) {
      return inviteCode!.trim().toUpperCase();
    }
    return lobbyId.trim();
  }

  @override
  Widget build(BuildContext context) {
    final displayCode = _buildDisplayCode();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Room Code: ',
                style: AppTypography.kRegular19.copyWith(
                  color: AppColors.kBlack,
                ),
              ),
              TextSpan(
                text: displayCode,
                style: AppTypography.kBold21.copyWith(
                  color: AppColors.kPrimary,
                ),
              ),
            ],
          ),
        ),
        if (iSend) ...[
          SizedBox(width: 5.w),
          CustomIconButton(
            onTap: () async {
              final codeToCopy = _buildCopyCode();
              await Clipboard.setData(ClipboardData(text: codeToCopy));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Room code copied')),
                );
              }
            },
            icon: AppAssets.sendIcon,
          ),
        ],
      ],
    );
  }
}
