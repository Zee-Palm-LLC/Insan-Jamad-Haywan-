import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

export 'package:toastification/toastification.dart';

class AppToaster {
  static void showToast(
    String message, {
    ToastificationType type = ToastificationType.success,
    String subTitle = '',
    Alignment alignment = Alignment.bottomRight,
  }) {
    toastification.show(
      type: type,
      style: ToastificationStyle.fillColored,
      alignment: alignment,
      autoCloseDuration: const Duration(seconds: 3, milliseconds: 500),
      dragToClose: true,
      title: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Poppins-Medium',
        ),
      ),
      description: subTitle != ''
          ? RichText(
              text: TextSpan(
                text: subTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
            )
          : null,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: _getIconByType(type),
      showIcon: true, // show or hide the icon
      primaryColor: _getColorByType(type),
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],

      showProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
      applyBlurEffect: false,
    );
  }

  static Icon _getIconByType(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.white,
        );
      case ToastificationType.error:
        return const Icon(Icons.error_outline_rounded, color: Colors.white);
      case ToastificationType.warning:
        return const Icon(Icons.warning_amber_rounded, color: Colors.white);
      case ToastificationType.info:
        return const Icon(Icons.info_outline_rounded, color: Colors.white);
      default:
        return const Icon(Icons.info_outline_rounded, color: Colors.white);
    }
  }

  static Color _getColorByType(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return Colors.green;
      case ToastificationType.error:
        return Colors.red;
      case ToastificationType.warning:
        return Colors.orange;
      case ToastificationType.info:
        return Colors.blue;
      default:
        return Colors.red;
    }
  }
}
