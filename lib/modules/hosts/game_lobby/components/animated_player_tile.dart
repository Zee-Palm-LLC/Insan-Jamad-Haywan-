import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';

class AnimatedPlayerTile extends StatefulWidget {
  final int index;
  final String name;
  final String imagePath;
  final Color color;
  final bool isHost;
  final VoidCallback? onKick;

  const AnimatedPlayerTile({
    super.key,
    required this.index,
    required this.name,
    required this.imagePath,
    required this.color,
    this.isHost = false,
    this.onKick,
  });

  @override
  State<AnimatedPlayerTile> createState() => AnimatedPlayerTileState();
}

class AnimatedPlayerTileState extends State<AnimatedPlayerTile>
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

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
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
              width: 15.w,
              child: Center(
                child: Text(
                  widget.index.toString(),
                  style: AppTypography.kBold16,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              height: 32.h,
              width: 32.h,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: widget.color, width: 2),
              ),
              child: Center(
                child: Text(
                  _getInitials(widget.name),
                  style: AppTypography.kBold16.copyWith(
                    fontSize: 14.sp,
                    color: widget.color,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Row(
                children: [
                  Text(
                    widget.name,
                    style: AppTypography.kBold21.copyWith(
                      color: widget.color,
                      fontSize: 20.sp,
                    ),
                  ),
                  if (widget.isHost) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'Host',
                        style: AppTypography.kBold16.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kPrimary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.onKick != null) ...[
              IconButton(
                icon: Icon(Icons.person_remove_alt_1_outlined, size: 20.sp),
                onPressed: widget.onKick,
                color: AppColors.kRed500,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
