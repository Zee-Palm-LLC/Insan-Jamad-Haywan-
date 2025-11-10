import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';

class PositionPodium extends StatelessWidget {
  final bool isFirst;
  final String position;
  final String? badge;
  final String image;
  final String name;
  final String points;
  final String totalPoints;
  const PositionPodium({
    super.key,
    this.isFirst = true,
    required this.position,
    this.badge,
    required this.image,
    required this.name,
    required this.points,
    required this.totalPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isFirst
          ? EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isFirst ? AppColors.kPrimary : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (badge != null) ...[Image.asset(badge!), SizedBox(width: 10.w)],
          Text(
            position,
            style: AppTypography.kBold16.copyWith(
              color: isFirst ? AppColors.kWhite : null,
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            height: isFirst ? 60.h : 50.h,
            width: isFirst ? 60.h : 50.h,
            decoration: BoxDecoration(
              color: AppColors.kGray300,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.kGray500),
            ),
            padding: EdgeInsets.all(2.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.kGray300,
                    child: Icon(
                      Icons.person,
                      size: 30.sp,
                      color: AppColors.kGray600,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.kBold16.copyWith(
                    height: 1.2,
                    color: isFirst ? AppColors.kWhite : AppColors.kRed500,
                  ),
                ),
                Text(
                  '$totalPoints pts',
                  style: AppTypography.kRegular19.copyWith(
                    fontSize: 16.sp,
                    color: isFirst ? AppColors.kWhite : null,
                  ),
                ),
              ],
            ),
          ),
          Text(
            points,
            style: AppTypography.kBold21.copyWith(
              color: isFirst ? AppColors.kGold : AppColors.kPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
