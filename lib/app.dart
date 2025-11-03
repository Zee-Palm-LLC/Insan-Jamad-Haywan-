import 'package:flutter/material.dart';
import 'package:insan_jamd_hawan/config/routes/router.dart';
import 'package:insan_jamd_hawan/core/utils/toastification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class InsanJamdHawan extends StatelessWidget {
  const InsanJamdHawan({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Insan Jamd Hawan',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
