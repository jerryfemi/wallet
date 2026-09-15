import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  DevicePreview.enable(enabled: kDebugMode);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: CryptoSimApp()));

  if (kDebugMode) {
    Future.microtask(() async {
      try {
        final c = DevicePreview.controller;
        await c.applyPreset(DevicePresets.iPhone16Pro);
      } catch (e) {
        // DevicePreview might not be enabled or fully ready
      }
    });
  }
}

class CryptoSimApp extends ConsumerWidget {
  const CryptoSimApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effectResolver: (Brightness _) => const ShimmerEffect(
          baseColor: Color(0xFF1E2530),
          highlightColor: Color(0xFF2A2D3E),
          duration: Duration(seconds: 2),
        ),
      ),
      child: MaterialApp.router(
        title: 'CryptoSim',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // Enforce dark theme based on the prototype
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
