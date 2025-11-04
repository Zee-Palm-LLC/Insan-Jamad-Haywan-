import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insan_jamd_hawan/core/services/cache/helper.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';
import 'package:insan_jamd_hawan/data/constants/constants.dart';
import 'package:insan_jamd_hawan/modules/widgets/buttons/primary_button.dart';
import 'package:insan_jamd_hawan/responsive.dart';

class UsernameInputDialog extends StatefulWidget {
  const UsernameInputDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const UsernameInputDialog(),
    );
  }

  @override
  State<UsernameInputDialog> createState() => _UsernameInputDialogState();
}

class _UsernameInputDialogState extends State<UsernameInputDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveUsername() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      AppToaster.showToast(
        'Please enter your name',
        type: ToastificationType.error,
      );
      return;
    }

    if (name.length < 2) {
      AppToaster.showToast(
        'Name must be at least 2 characters',
        type: ToastificationType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AppService.setPlayerId(name);

      if (mounted) {
        Navigator.of(context).pop(name);
      }
    } catch (e) {
      if (mounted) {
        AppToaster.showToast(
          'Failed to save name: $e',
          type: ToastificationType.error,
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return AlertDialog(
      backgroundColor: AppColors.kGreen100,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      content: SizedBox(
        width: isDesktop ? 350.w : double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter your name to continue', style: AppTypography.kBold21),
            const SizedBox(height: 24),

            // Name Input
            TextField(
              controller: _nameController,
              enabled: !_isLoading,
              autofocus: true,
              textAlign: TextAlign.center,
              style: AppTypography.kRegular19.copyWith(fontSize: 16.sp),
              decoration: InputDecoration(hintText: 'Your name'),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _saveUsername(),
            ),
            SizedBox(height: 16.h),

            // Info Text
            Text(
              'Your name will be used as your player ID',
              style: AppTypography.kRegular19.copyWith(fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),

            // Continue Button
            PrimaryButton(
              text: _isLoading ? 'Loading...' : 'Continue',
              onPressed: _isLoading ? () {} : _saveUsername,
            ),
          ],
        ),
      ),
    );
  }
}
