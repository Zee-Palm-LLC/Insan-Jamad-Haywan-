// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insan_jamd_hawan/app.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';

class NetworkCall<T> {
  static Future<void> networkCall<T>({
    required Future<T?> Function() future,
    Function(T?)? onComplete,
    bool isInternetCheckEnabled = false,
    bool isAutoCloseKeyboard = false,
    GlobalKey<FormState>? formKey,
    Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    late T? response;
    if (formKey != null && !formKey.currentState!.validate()) {
      return;
    }
    if (isAutoCloseKeyboard) {
      final FocusScopeNode currentFocus = FocusScope.of(
        navigatorKey.currentContext!,
      );
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    }
    if (isInternetCheckEnabled) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isEmpty || result[0].rawAddress.isEmpty) {
          AppToaster.showToast(
            'No internet connection',
            subTitle: 'Please check your internet connection and try again.',
            type: ToastificationType.error,
          );
          return;
        }
      } on SocketException catch (_) {
        AppToaster.showToast(
          'No internet connection',
          subTitle: 'Please check your internet connection and try again.',
          type: ToastificationType.error,
        );
        return;
      }
    }

    // Show loading indicator
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Execute the future function
      response = await future.call();

      if (Navigator.of(
        navigatorKey.currentContext!,
        rootNavigator: true,
      ).canPop()) {
        Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
      }

      // Hide loading indicator
      onComplete?.call(response);
    } catch (error, stacktrace) {
      if (error is Map) {
        onError?.call(error['message'], stacktrace);
      } else if (error is Exception) {
        final message = error.toString().replaceFirst('Exception: ', '');
        onError?.call(message, stacktrace);
      } else {
        onError?.call(error.toString(), stacktrace);
      }
      if (Navigator.of(
        navigatorKey.currentContext!,
        rootNavigator: true,
      ).canPop()) {
        Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
      }
    }
  }
}
