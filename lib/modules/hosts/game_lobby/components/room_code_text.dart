import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/custom_icon_button.dart';

class RoomCodeText extends StatelessWidget {
  final bool isSend;
  const RoomCodeText({super.key, required this.lobbyId, this.isSend = false});

  final String lobbyId;

  @override
  Widget build(BuildContext context) {
    String displayCode = lobbyId;
    if (lobbyId.length > 8 && lobbyId.contains('-')) {
      displayCode = lobbyId.substring(0, 8).toUpperCase();
    } else if (lobbyId.length > 8) {
      displayCode = lobbyId.substring(0, 8).toUpperCase();
    }

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
        if (isSend) ...[
          SizedBox(width: 10.w),
          CustomIconButton(icon: AppAssets.sendIcon, onTap: () {}),
        ],
      ],
    );
  }
}
