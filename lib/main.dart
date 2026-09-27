import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:wallet/app/router/app_router.dart';
import 'package:wallet/app/theme/app_theme.dart';

import 'package:wallet/app/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wallet/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    DevicePreview.enable(enabled: kDebugMode);
  } catch (e) {
    // Ignore binding assertion errors during hot restart on web
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const CryptoSimApp(),
  ));

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
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'CryptoSim',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return SkeletonizerConfig(
          data: SkeletonizerConfigData(
            effectResolver: (brightness) => switch (brightness) {
              Brightness.light => const ShimmerEffect(),
              Brightness.dark => const ShimmerEffect.dark(),
            },
            brightness: Theme.of(context).brightness,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
