import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insan_jamd_hawan/core/data/constants/constants.dart';
import 'package:insan_jamd_hawan/core/models/session/session_enums.dart';

class ScoringPlayingTile extends StatefulWidget {
  final int index;
  final String name;
  final String imagePath;
  final String answer;
  final int points;
  final AnswerEvaluationStatus? status;
  final bool usedDoublePoints;
  final VoidCallback? onReportTap;

  const ScoringPlayingTile({
    super.key,
    required this.index,
    required this.name,
    required this.imagePath,
    required this.answer,
    required this.points,
    this.status,
    this.usedDoublePoints = false,
    this.onReportTap,
  });

  @override
  State<ScoringPlayingTile> createState() => ScoringPlayerTileState();
}

class ScoringPlayerTileState extends State<ScoringPlayingTile>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Row(
          children: [
            SizedBox(
              width: 7.w,
              child: Center(
                child: Text(
                  widget.index.toString(),
                  style: AppTypography.kBold16,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            // Status icon based on evaluation status
            _buildStatusIcon(),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                widget.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.kRegular19.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.kBlue,
                ),
              ),
            ),
            if (widget.status == AnswerEvaluationStatus.unclear)
              InkWell(
                onTap: widget.onReportTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 2.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: AppColors.kPrimary, width: 1),
                  ),
                  child: Text(
                    'Report',
                    style: AppTypography.kRegular19.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.kPrimary,
                    ),
                  ),
                ),
              ),
            SizedBox(width: 5.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.5.h),
              decoration: BoxDecoration(
                color: _getAnswerColor(),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Text(
                widget.answer,
                style: AppTypography.kRegular19.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.kWhite,
                ),
              ),
            ),
            SizedBox(width: 5.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.usedDoublePoints &&
                    widget.status == AnswerEvaluationStatus.correct)
                  Container(
                    margin: EdgeInsets.only(right: 4.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: AppColors.kPrimary, width: 1),
                    ),
                    child: Text(
                      '2x',
                      style: AppTypography.kBold16.copyWith(
                        color: AppColors.kPrimary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                Text(
                  widget.points > 0 ? '+${widget.points}' : '${widget.points}',
                  style: AppTypography.kBold16.copyWith(
                    color: widget.points > 0
                        ? AppColors.kPrimary
                        : AppColors.kGray500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    final status = widget.status ?? AnswerEvaluationStatus.incorrect;

    Color iconColor;
    Widget icon;

    switch (status) {
      case AnswerEvaluationStatus.correct:
        iconColor = AppColors.kPrimary;
        icon = SvgPicture.asset(
          AppAssets.done,
          width: 24.w,
          height: 24.h,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        );
        break;
      case AnswerEvaluationStatus.duplicate:
        iconColor = AppColors.kLightYellow;
        icon = Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.kGray600, width: 1.5),
          ),
          child: Center(
            child: Text(
              'D',
              style: AppTypography.kBold16.copyWith(
                color: AppColors.kBlack,
                fontSize: 12.sp,
              ),
            ),
          ),
        );
        break;
      case AnswerEvaluationStatus.unclear:
        iconColor = AppColors.kGray300;
        icon = Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.kGray600, width: 1.5),
          ),
          child: Center(
            child: Text(
              '?',
              style: AppTypography.kBold16.copyWith(
                color: AppColors.kBlack,
                fontSize: 12.sp,
              ),
            ),
          ),
        );
        break;
      case AnswerEvaluationStatus.incorrect:
        iconColor = AppColors.kRed500;
        icon = Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
          child: Center(
            child: Icon(Icons.close, color: AppColors.kWhite, size: 16.sp),
          ),
        );
        break;
    }

    return Container(
      width: 32.h,
      height: 32.h,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Center(child: icon),
    );
  }

  Color _getAnswerColor() {
    final status = widget.status ?? AnswerEvaluationStatus.incorrect;

    switch (status) {
      case AnswerEvaluationStatus.correct:
        return AppColors.kGreen100;
      case AnswerEvaluationStatus.duplicate:
        return AppColors.kLightYellow;
      case AnswerEvaluationStatus.unclear:
        return AppColors.kGray300;
      case AnswerEvaluationStatus.incorrect:
        return AppColors.kGray300;
    }
  }
}
